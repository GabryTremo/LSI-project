function recomputing_vec = progetto_recomputing_prec(term_document_matrix,query_matrix,truth_matrix,incr)
%fornisce il vettore delle precisioni medie ad ogni incremento del numero
%di documenti, ottenute ricalcolando la PSVD ad ogni passo.
%incr : quanti documenti vogliamo aggiungere ad ogni passo.
m = 700/incr;     %numero di passi del test
recomputing_vec = zeros(m+1,1);   %vettore su cui verranno salvate le precisioni medie ad ogni passo
for j = 0:m
    A = term_document_matrix(:,1:700+j*incr);     
    [U,S,V] = svds(A,300);          %psvd di A con k=300
    S_inv = diag(1./diag(S));       %costruisce l'inversa di S sfruttando che essa è diagonale 
    Q = query_matrix'*U*S_inv;      %proietta la matrice delle query sullo spazio k-dimensionale
    T = truth_matrix(1:700+j*incr,:);
    recomputing_vec(j+1) = mean_prec_glob(V',Q',T);
end