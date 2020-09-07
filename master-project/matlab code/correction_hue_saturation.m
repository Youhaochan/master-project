%% correction of hue and saturation 
function [H_new,S_new] = correction_hue_saturation(H,S,I,alpha,X_svg)
% input
% H, S - dim  mxn
[x_max,y_max,~] = size(I);
% H_new = H;
% S_new = S;
H_sum1=0;
H_sum2=0;
S_sum1=0;
S_sum2=0;
H_new = H;
S_new = S;

[row,col] = size(X_svg) ;
for i = 1:row
    x = X_svg(i,1);
    y = X_svg(i,2);
    index = [x,y];
    omega = get_omega(index,I);
    [r,c] = size(omega);
    for i = 1:r
        for j= 1 :c
        a = W_svg(X_svg,omega{i,j},alpha);
        H_sum1 = H_sum1 +a;
        H_sum2 = H_sum2+H(omega{i,j}(1),omega{i,j}(2)) * a;
        b = W_HS(index,omega{i,j},H,S);
        S_sum1 = S_sum1 + b ;
        S_sum2 = S_sum2 + S(omega{i,j}(1),omega{i,j}(2))*b;
        end
    end
    H(x,y) = (1/H_sum1) * H_sum2;  
    S(x,y) = (1/S_sum1) * S_sum2;

end
    
H_new = H;
S_new = S;

end


% no error
function w = W_svg(X_svg,x,alpha)
    % determine whether x is inside X_svg
    b = (x==X_svg);
    b = b(:,1)&b(:,2);
    c = any(b);
    % if c==1 means x is in the list of X_svg
    if c==1
        w=alpha;
    else 
        w=1;
    end

end

% no error
function w_hs = W_HS(x,u,H,S)
delta=1;
exp1 = exp(-(H(x(1),x(2))- H(u(1),u(2)))^2/delta^2 );
exp2 = exp(-(1-S(u(1),u(2)))^2 );

w_hs = exp1*exp2;
end


function omega = get_omega(x,I)
% input x dim [row,col]
dim =7;% window size
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
