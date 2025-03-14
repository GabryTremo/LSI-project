function m = mean_prec_glob(term_document_matrix,query_matrix,truth_matrix)
%calcola la precisione media al variare di livelli di recall
%sufficientemente diversi (distanti di almeno 0.05) per ogni query, e poi
%media su tutte le query
m = 0;
q = size(query_matrix,2);
for j = 1:q
    mean_prec_loc = 0;
    truth_vec = truth_matrix(:,j); %vettore che ha 1 in corrispondenza dei documenti effettivamente rilevanti per la j-esima query
    k=0;
    recall_old=2; %inizializza livello di recall ad ogni query, in modo tale da rendere vera la condizione recall>=recall_old-0.05 appena found>0
    relevant=sum(truth_vec ~= 0);
    for i = -100:100
        %bool_vec è un vettore che ha 1 in corrispondenza dei documenti
        %considerati rilevanti dalla cosine similarity con threshold 
        %i*(0.01), per la j-esima query 
        bool_vec = cosine_similarity(term_document_matrix,query_matrix(:,j),i*(0.01));  
        found = sum(bool_vec ~= 0);    %numero di documenti considerati rilevanti dalla analisi con cosine similarity
        relevant_found = sum(bool_vec+truth_vec == 2);  %tra questi ultimi, numero di documenti effettivamente rilevanti
        recall = relevant_found/relevant;
        if found==0
            mean_prec_loc = mean_prec_loc/(100+i-k);    %ottiene la media sui livelli di recall non esclusi
            break
        else
            if recall>=recall_old-0.05
                k=k+1;
            else
                mean_prec_loc = mean_prec_loc + relevant_found/found;
                recall_old=recall;
            end
        end        
        
        %se l'analisi ha dato almeno una corrispondenza (found>0), calcola
        %la precisione e la aggiunge a quella che sarà la media;
        %se invece found==0, la precisione non è ben definita e escludiamo
        %questo valore dalla media. Per come è impostata la cosine
        %similarity, se found==0 per qualche i, allora found==0 per ogni
        %k>i e possiamo quindi concludere.
    end
    m = m + mean_prec_loc;
end
m = m/q;  %ottiene la media sulle query

