close all
incr=14;
v=700:incr:1400;
p=plot(v,recomputing_vec,"k",v,folding_in_vec,"r",v,updating_vec,"b",v,folding_up_vec,"g");
ylim([0.09 0.2])
p(1).LineWidth = 2; p(2).LineWidth = 2; p(3).LineWidth = 2; p(4).LineWidth = 2;
legend("Recomputing","Folding-in","Updating","Folding-up",Location="southeast")
xlabel("Numero di documenti")
ylabel("Precisione media")
figure 
incr=28;
v=700:incr:1400;
p=plot(v,recomputing_vec_28,"k",v,folding_in_vec_28,"r",v,updating_vec_28,"b",v,folding_up_vec_28,"g");
ylim([0.09 0.2])
p(1).LineWidth = 2; p(2).LineWidth = 2; p(3).LineWidth = 2; p(4).LineWidth = 2;
legend("Recomputing","Folding-in","Updating","Folding-up",Location="southeast")
xlabel("Numero di documenti")
ylabel("Precisione media")
