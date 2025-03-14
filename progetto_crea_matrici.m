%-----------costruzione matrice term-document-----------
filename = "Documents.txt";
str = extractFileText(filename);    %prende l'intero file degli abstract come stringa
textData = split(str,newline);      %costruisce un array di stringhe, tagliando il testo intero ogni volta che si va a capo (cambia documento)
documents = tokenizedDocument(textData);    %rappresenta ogni abstract come collezione delle sue parole
bag = bagOfWords(documents);        %costruisce la collezione dei termini distinti che appaiono nei vari documenti, e conta quante volte appaiono  
term_document_matrix = tfidf(bag)';          %costruisce la matrice term-document relativa alla collezione sopra, con il sistema di peso tf-idf
%--------------costruzione matrice query----------------
filename2 = "Queries.txt";
str2 = extractFileText(filename2);
textData2 = split(str2,newline);
t = bag.NumWords;         %numero di termini nei documenti
q = size(textData2,1);    %numero di query
query_matrix = zeros(t,q);
%usando la proprietà Counts della classe bagOfWords, crea un vettore in cui
%la j-esima componente è il peso globale (con il sistema idf) del termine j
idf_vec = zeros(t,1);
df = sum(bag.Counts > 0, 1);
for j = 1:t
    idf_vec(j) = log(t / df(j));
end

for i=1:q
    words_in_str = split(textData2(i));     %spezza la i-esima query in un array di stringhe contenenti le parole di tale query
    %la i-esima colonna della matrice è un vettore in cui la j-esima
    %componente è 1 se il j-esimo termine compare nella i-esima query
    for j = 1:t         
        if any(strcmp(bag.Vocabulary(j), words_in_str))     
            query_matrix(j,i) = 1;
        end
    end
    %per ottenere un risultato coerente, i termini nelle query vanno moltiplicati per il peso globale idf
    query_matrix(:,i) = query_matrix(:,i).*idf_vec;     
end
%la matrice delle verità è stata creata direttamente usando le funzioni di
%importazione dei dati di matlab