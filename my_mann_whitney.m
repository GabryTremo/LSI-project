function p = my_mann_whitney(x,y)
% p = my_mann_whitney(x,y) restitusce il p-value dato dal test statistico
% di Mann-Whitney (ranksum in matlab) tra i vettori colonna x ed y,
% che possono essere anche di dimensioni diverse. In realtà, una volta
% valutata la statistica U, viene calcolato il p-value usando il fatto che
% (U-m)/sigma è approssimativamente normale standard (teorema del limite
% centrale), che è una approssimazione valida perchè nel caso in cui è
% stato usato nel progetto si hanno vettori di 225 componenti.

% Costruisce il vettore di tutti i valori, ordinati in ordine crescente
z = [x; y];
z = sort(z);

n1 = length(x);
n2 = length(y);
n = n1 + n2;

% ranks è una matrice che avrà sulla prima colonna i valori ordinati in modo
% crescente e sulla seconda i ranghi associati ai valori sulla riga
% corrispondente (la prima è semplicemente z, ed è qui solo a scopi di
% debugging)
ranks = zeros(n,2);

loc_cont = 0;   % Contatore per il numero di ripetizioni di un singolo valore (si intende 1 ripetizione se compare 2 volte)
rip_cont = 0;   % Contatore per il numero di valori diversi che hanno ripetizioni
rip_prop = zeros(2,ceil(n/2));  % Matrice che conterrà sulla prima riga l'indice di z da cui parte la ripetizione di un valore,
                                % e sulla seconda il numero di ripetizioni corrispondenti (cioè loc_cont)
                                                                                                                                                       
j = 1;  % Itera sul numero di componenti del vettore z

while j < n
    
    % Ottiene il numero di ripetizioni, se ce ne sono, e manda avanti il
    % loop della quantità corrispondente. L'ultimo elemento da fastidio con
    % gli indici, ma in qualche modo va tenuto conto di esso.
    while z(j) == z(j+1)  
        loc_cont = loc_cont + 1;
        j = j + 1;
        if j == n
            break
        end
    end    

    % Se c'è stata almeno una ripetizione, salva le quantità giuste nei
    % vari vettori e nei vari contatori. Altrimenti, fa lo stesso ma senza
    % aggiornare le quantità non necessarie. Se siamo all'ultimo elemento
    % ed esso non è stato ripetuto, il suo rango è necessariamente n.
    if loc_cont > 0
        rip_prop(1,rip_cont + 1) = j-loc_cont;
        rip_prop(2,rip_cont + 1) = loc_cont;
        ranks(j -loc_cont : j,2) = mean( j - loc_cont : j)*ones(loc_cont+1,1);
        ranks(j -loc_cont : j,1) = z(j);
        rip_cont = rip_cont + 1;
        loc_cont = 0;
        j = j + 1;
    else
        ranks(j,1) = z(j);
        ranks(j,2) = j;
        if j == n-1
            ranks(n,:) = [z(n),n];
        end
        j = j+1;
    end

end

R=0;    % Inizializza la somma dei ranghi corrispondenti alle componenti del primo vettore

% La somma sopra è ottenuta cercando, per ogni elemento del vettore x, la
% sua posizione corrispondente nella prima colonna di ranks (cioè la sua
% posizione in ordine crescente), e osservando che per costruzione il rango
% corrispondente ad esso è il valore nella stessa riga di ranks
for j = 1:n1
    index_vec = find(ranks(:,1)==x(j));
    R = R + ranks(index_vec(1), 2); 
end

% Calcola il valore della statistica U del test sul nostro campione
U = R - (n1*(n1+1))/2;

% Vettore ausiliario, serve per calcolare la deviazione standard
corr_vec = rip_prop(2,:).^3 - rip_prop(2,:); 

% Calcola media e deviazione standard
m = n1*n2/2;
sigma = sqrt((n1*n2/12)*(n+1-(sum(corr_vec))/(n*(n-1))));

% Calcola il valore della statistica Z, approssimativamente normale per il
% teorema del limite centrale
z = (U - m)/sigma;

% Il p-value è allora (approssimativamente) la probabilità che |N(0,1)|>=z,
% cioè la seguente, per le proprietà dell'integrale
p = 1 - integral(@(x) ((exp((-(x.^2))/2))/sqrt(2*pi)), -abs(z), abs(z));


