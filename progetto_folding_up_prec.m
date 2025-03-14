function folding_up_vec = progetto_folding_up_prec(term_document_matrix,query_matrix,truth_matrix,incr,percent)
%fornisce il vettore delle precisioni medie ad ogni incremento del numero
%di documenti, aggiornando la PSVD tramite folding-up.
%incr : quanti documenti vogliamo aggiungere ad ogni passo; 
%percent : dopo quale percentuale del numero dei documenti attuali vogliamo applicare update.
frac = percent/100;  
m = 700/incr;     %numero di passi del test
folding_up_vec = zeros(m+1,1);    %vettore su cui verranno salvate le precisioni medie ad ogni passo
cont = 0;     %contatore per sapere quando fare update
A = term_document_matrix(:,1:700);       %parte iniziale della matrice term-document, contenente metà dei documenti               
T = truth_matrix(1:700,:);  %parte iniziale della matrice delle verità, contenente metà dei documenti  
N = 700;
[U,S,V] = svds(A,300);    %psvd di A con k=300
S_inv = diag(1./diag(S));     %costruisce l'inversa di S sfruttando che essa è diagonale
Q = query_matrix'*U*S_inv;    %proietta la matrice delle query sullo spazio k-dimensionale
folding_up_vec(1) = mean_prec_glob(V',Q',T);    %calcola la precisione media al primo passo
V_temp = V;   %matrice che verrà usata per fare folding-in, mentre V verrà modificata solo per gli update
for j = 1:m    
    if cont < ceil(frac*N/incr)    %ceil(frac*N/incr) è il numero di applicazioni di folding-in da fare prima di applicare update
        D = term_document_matrix(:,701+(j-1)*incr:700+j*incr);   %documenti da aggiungere al passo j
        %----------folding_in------------
        S_inv = diag(1./diag(S));     
        D_proj = D'*U*S_inv; 
        V_temp = [V_temp;D_proj];
        %--------------------------------
        Q = query_matrix'*U*S_inv;
        T = truth_matrix(1:700+j*incr,:);
        folding_up_vec(j+1) = mean_prec_glob(V_temp',Q',T);
        cont = cont + 1;
    else
        D = term_document_matrix(:,N+1:700+j*incr);  %quando facciamo update, ripartiamo dai documenti dell'update precedente
        [U,S,V] = psvd_update(U,S,V,D);   
        S_inv = diag(1./diag(S));     
        Q = query_matrix'*U*S_inv;
        T = truth_matrix(1:700+j*incr,:);
        folding_up_vec(j+1) = mean_prec_glob(V',Q',T);
        V_temp = V;   
        N = 700+j*incr;   %aggiorna l'indice del documento corrispondente al più recente update
        cont = 0;     
    end
end