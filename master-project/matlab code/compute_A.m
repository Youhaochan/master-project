%% compute illumination chromaticity
function A = compute_A(I,X_svg,dim)

[row,col,~] = size(I);
A(:,:,1) = ones(row,col);
A(:,:,2) = ones(row,col);
A(:,:,3) = ones(row,col);
[row,~] = size(X_svg);
disp(size(X_svg))
for i = 1:row
    x = X_svg(i,1);
    y = X_svg(i,2);
    index = [x,y];
    omega = get_omega(index,I,dim);
    [r,c] = size(omega);
    e = zeros(7,7,3);
    for i = 1:r
        for j= 1 :c          
        e(i,j,:) = I(omega{i,j}(1),omega{i,j}(2),:);
        end
    end
    A(x,y,1) = 1-mean2(e);
end




end


function omega = get_omega(x,I,dim)
% input x dim [row,col]
mid = (dim+1)/2;
iter = dim -mid;
omega = cell(dim,dim);
omega{mid,mid} = x;
[x_max,y_max,~] = size(I);
for i = -iter:iter
    for j =-iter:iter
        index_x = x(1)+i;% index of matrix omega
        index_y = x(2)+j;
        if index_x<=1
            index_x=1;
        end
        if index_y<=1
            index_y=1;
        end
        if index_x>=x_max
            index_x=x_max;
        end
        if index_y>=y_max
            index_y=y_max;
        end      
      omega{mid+i,mid+j} = [index_x,index_y];
      
    end

end



end