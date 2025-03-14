function bool_vec=cosine_similarity(term_document_matrix,query,tol)
%data una matrice term-document, un vettore corrispondente ad una query e
%una tolleranza, restituisce un vettore che ha 1 in corrispondenza dei
%documenti considerati rilevanti dalla cosine similarity con tale
%tolleranza, e 0 altrimenti.
k=size(term_document_matrix,2);     %numero di documenti
bool_vec=zeros(k,1);
for j=1:k
cosine=dot(term_document_matrix(:,j),query)/(norm(term_document_matrix(:,j),2)*norm(query,2));
if cosine>=tol
    bool_vec(j)=1;
else
    bool_vec(j)=0;
end
end
end