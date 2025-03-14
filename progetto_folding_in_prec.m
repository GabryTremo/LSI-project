function folding_in_vec = progetto_folding_in_prec(term_document_matrix,query_matrix,truth_matrix,incr)
%fornisce il vettore delle precisioni medie ad ogni incremento del numero
%di documenti, aggiornando la PSVD tramite folding-in.
%incr : quanti documenti vogliamo aggiungere ad ogni passo.
m = 700/incr;     %numero di passi del test
A = term_document_matrix(:,1:700);
folding_in_vec = zeros(m+1,1);      %vettore su cui verranno salvate le precisioni medie ad ogni passo
[U,S,V] = svds(A,300);              %psvd di A con k=300
S_inv = diag(1./diag(S));           %costruisce l'inversa di S sfruttando che essa è diagonale
Q = query_matrix'*U*S_inv;          %proietta la matrice delle query sullo spazio k-dimensionale
T = truth_matrix(1:700,:);
folding_in_vec(1) = mean_prec_glob(V',Q',T);
for j = 1:m
    
    D = term_document_matrix(:,701+(j-1)*incr:700+j*incr);      %documenti da aggiungere al passo j
    %----------folding_in------------
    S_inv = diag(1./diag(S));     
    D_proj = D'*U*S_inv; 
    V = [V;D_proj];
    %--------------------------------
    Q = query_matrix'*U*S_inv;
    T = truth_matrix(1:700+j*incr,:);
    folding_in_vec(j+1) = mean_prec_glob(V',Q',T);
end
