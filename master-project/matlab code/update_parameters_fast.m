%% update parameters
function [m_d_new,m_s_new,p,q] = update_parameters_fast(m_d, m_s, h_k,p,q,I,Lambda,Gamma,beta1,beta2)
% input 
% m_d, m_s,  - dim  m*n matrix
% p, q    -  dim  m*n*2 
% h_k  -  step length
% I  - image data
% A  -  Gamma
% 
% output: 
% m_d and m_s are the diffuse and specular reflection coefficients
% 
    max_iter = 0;
    error = 100;
    last_error=10000;
    while(max_iter<500 &&error>0.0002)
       div_p1 = divergence(p(:,:,1),p(:,:,2));
       div_q1 = divergence(q(:,:,1),q(:,:,2));
        [delta_md_x,delta_md_y] = gradient(m_d);
        [delta_ms_x,delta_ms_y] = gradient(m_s);
        [row,col] = size(delta_md_x);
        delta_m_d = zeros(row,col,2);
        delta_m_s = zeros(row,col,2);
        delta_m_d(:,:,1) = delta_md_x;
        delta_m_d(:,:,2) = delta_md_y;
        delta_m_s(:,:,1) = delta_ms_x;
        delta_m_s(:,:,2) = delta_ms_y;    
        max_iter=max_iter+1;
        sprintf('error is %f, maximum iteration times is %d',error,max_iter)
        derivative_md_left = m_d.*Lambda + m_s.*Gamma - I;
        derivative_md = derivative_md_left(:,:,1).*Lambda(:,:,1) + ...
            derivative_md_left(:,:,2).*Lambda(:,:,2)...
            +derivative_md_left(:,:,3).*Lambda(:,:,3) -beta1.*div_q1;
        derivative_ms = derivative_md_left(:,:,1).*Gamma(:,:,1) + ...
            derivative_md_left(:,:,2).*Gamma(:,:,2)...
            +derivative_md_left(:,:,3).*Gamma(:,:,3) -beta2.*div_p1;
        z1 = m_d - h_k.*derivative_md;
        z2 = m_s - h_k.*derivative_ms;
        z3 = p-h_k*beta2.*delta_m_s;
        z4 = q-h_k*beta1.*(delta_m_d - q);
       
        m_d_k_plus = p_omega_1(z1);
        m_s_k_plus = p_omega_2(z2);       
        p_plus = p_omega_3(z3);
        q_plus = z4;

        m_d_old = m_d;
        m_d = m_d_k_plus;
        m_s = m_s_k_plus;
        p = p_plus;
        q = q_plus;
        I_d2 = m_d_k_plus.*Lambda + m_s_k_plus.*Gamma;   
        err = I_d2-I;
        error = norm(err(:));
        Error(max_iter) = error; 
        if((last_error-error)<0)
            break;
        end
        last_error = error;
        
    end 
    
    m_d_new = m_d;
    m_s_new = m_s;
    sprintf('error is %f, maximum iteration times is %d',error,max_iter)
    plot(Error)







end

 %% projection operator
function md = p_omega_1(z)

    z(z>1) = 1;
    z(z<0) = 0;
    md= z;
  
end


function ms = p_omega_2(z)
    z(z>1) = 1;
    z(z<0) = 0;
    ms= z;
end
% no error
function p = p_omega_3(z)
       z(z>1) = 1;
    z(z<-1) = -1;
    p= z;
    
end

function a = derivative_md(m_d, m_s,Gamma, T, beta1,div_qx,Ix)

    a= (m_d.*Gamma +m_s.*T -double(Ix)).'*Gamma -beta1*div_qx;
%     sprintf('derivative_mddd qian is %f, hou div_qxis %f, and a is %f',(m_d*Gamma +m_s*T -double(Ix)).'*Gamma,div_qx,a)

end

function a = derivative_ms(m_d, m_s,Gamma, T, beta2,div_px,Ix)
 
    a = (m_d.*Gamma + m_s.*T - double(Ix)).'*T - beta2 *div_px;
%     sprintf('derivative_msss qian is %f, houdiv_px is %f, and a is %f',(m_d*Gamma +m_s*T -double(Ix)).'*Gamma,div_px,a)
end


