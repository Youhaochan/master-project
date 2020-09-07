function [X_SVG,index_matrix] = highlight_detection_set2(alpha,I,tau)
   
    HSV=rgb2hsv(I);
    H=HSV(:,:,1);
    S=HSV(:,:,2);
    V=HSV(:,:,3);
    X_SVG=0;
% compute X_sv and X_g
    a = S<alpha & V>1-alpha;
    index_matrix = a;
% X_SVG = X_sv;




end
% no error
function G = compute_G(I)
    [x_max,y_max,z_max] = size(I);
%     sprintf('max x is %d, max y is %d',x_max,y_max);
    G = zeros(x_max,y_max);
    for x = 1:x_max
        for y = 1:y_max
            if x==x_max
                x_plus=x;
            else
                x_plus=x+1;
            end
            if x<=1
                x_minus = x;
            else 
                x_minus = x-1;
            end
            
            if y==y_max
                y_plus=y;
            else
                y_plus=y+1;
            end
               
            if y<=1
                y_minus = y;
            else 
                y_minus = y-1;
            end
           %  sprintf('max x is %d, max y is %d',x,y)
            a = find_min(I,x_plus,y)- find_min(I,x_minus,y);
            b = find_min(I,x,y_plus)- find_min(I,x,y_minus);
            a = double(a);
            b = double(b);
            G(x,y) = sqrt((a^2+b^2))/2;       
        end
    end

end

% no error
function min_I_c = find_min(I,x,y)
    
     list = I(x,y,:);
     min_I_c = min(list);

end








