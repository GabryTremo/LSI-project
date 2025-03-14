function [U_new,S_new,V_new] = psvd_update(U,S,V,D)
%fornisce i tre nuovi componenti della PSVD, aggiornati tramite il metodo
%di updating descritto nell'articolo
    k = size(S,1); t = size(D,1); p = size(D,2); d = size(V,1);
    D_cap = (eye(t)-U*U')*D;
    [Q,R] = qr(D_cap,"econ"); 
    A_cap = zeros(k+p);
    A_cap(1:k,1:k) = S; A_cap(1:k,k+1:end) = U'*D; A_cap(k+1:end,k+1:end) = R;
    [U_cap,S_cap,V_cap] = svd(A_cap);
    U_k_cap = U_cap(:,1:k); S_new = S_cap(1:k,1:k); V_k_cap = V_cap(:,1:k);
    U_new = [U,Q]*U_k_cap; V_new = [V,zeros(d,p);zeros(p,k),eye(p)]*V_k_cap;
end