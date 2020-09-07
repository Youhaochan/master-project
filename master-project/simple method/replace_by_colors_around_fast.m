function A = replace_by_colors_around_fast(I,X_svg,num,alpha,tau,method)

[row,col,~] = size(I);
A(:,:,1) = ones(row,col);
A(:,:,2) = ones(row,col);
A(:,:,3) = ones(row,col);
[row,~] = size(X_svg);
A = I;
for i = 1:row
    e = [0 0 0];
    x = X_svg(i,1);
    y = X_svg(i,2);
    index = [x,y];   
%     tic
    [x_left,y_left,x_right,y_right]= get_index(index,I,num);
    I_small = I(x_left:x_right,y_left:y_right,:);
    if(method == 'fast')
    [~,index_matrix] = highlight_detection_set2(alpha,I_small,tau); % index_matrix =1  when it is highlight pixel
    elseif(method == 'slow')
    [~,index_matrix] = highlight_detection_set(alpha,I_small,tau);%very slow method with bit better result
    end;
    neighbours = I_small.*(~index_matrix);  % only extract non highlights
   
    [r,~] = find(~index_matrix>0);
    n = length(r);
    e(1) = sum(sum(neighbours(:,:,1)))/n;
    e(2) = sum(sum(neighbours(:,:,2)))/n;
    e(3) = sum(sum(neighbours(:,:,3)))/n;
   if n<2
    disp('please enlarge the window size');
    [e,~]= enlarge_window(index,I,num*3,alpha,tau);
    A(x,y,1)= e(1);  
    A(x,y,2)= e(2);  
    A(x,y,3)= e(3);  
    continue;    
   end
    A(x,y,1)= e(1)  ;
    A(x,y,2)= e(2) ;
    A(x,y,3)= e(3) ;
end
end
function [e,a] = enlarge_window(index,I,num,alpha,tau)
    p = 6;
    a=0;
    while (1)
    e = [0 0 0];  
    [x_left,y_left,x_right,y_right]= get_index(index,I,num);
    I_small = I(x_left:x_right,y_left:y_right,:);
    [~,index_matrix] = highlight_detection_set2(alpha,I_small,tau); % index_matrix =1  when it is highlight pixel
    neighbours = I_small.*(~index_matrix);  % only extract non highlights
    save('11.mat','neighbours')
    [r,~] = find(~index_matrix>0); % find the number of nonhighlights 
    n = length(r);
    e(1) = sum(sum(neighbours(:,:,1)))/n;
    e(2) = sum(sum(neighbours(:,:,2)))/n;
    e(3) = sum(sum(neighbours(:,:,3)))/n;
        if n<=2
            disp('warning!!!!!!the neighbour is all highlights, we need a large window size');
            num = num+p;
            sprintf('window size increase to %d\n',p)
            
            p = p+6;
            
        else                     
            break;
        end
    end

end



function bool_ = detect(x,X_svg)
    b = (x==X_svg);
    b = b(:,1)&b(:,2);
    bool_ = any(b);

end

function [x_left,y_left,x_right,y_right]= get_index(x,I,num)
mid = (num+1)/2;
dist = num -mid;
[x_max,y_max,~] = size(I);
x_left = x(1)-dist ;

y_left = x(2) - dist;
x_right = x(1)+dist ;
y_right = x(2) + dist;
if x_left<=1
    x_left=1;
end
if y_left<=1
    y_left=1;
end

if x_right>=x_max
    x_right=x_max;
end
if y_right>=y_max
    y_right=y_max;
end


end