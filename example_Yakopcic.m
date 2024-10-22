close all
clear all
[file, path] = uigetfile('*.txt')
file_path = strcat(path,file)
Rs = 4.7;
[U_m,I_m,t] = get_mean_values(file_path,false);
plot(U_m,I_m, "LineWidth",2);
legend('Wartości zmierzone','Wartości uśrednione')
Rs = 4.7;
figure(3)
U_mem_m = U_m-I_m*Rs;
plot(U_mem_m,I_m, '--');

hold('on');

Ap = 4000;
An = 4000;
Vp = 0.0635;
Vn = 0.1753;
xp = 0;
xn = 0.1593;
ap = 1.6721;
an = 6.7842;
Xinit = 0.00015 ;
a1 = 0.4506;
a2 = 0.1717;
b = 0.3496;  
parameter = [4000	4000	0.0797940961462372	0.179601337076835	0	0.163437027084673	2.11289011350819	6.79935966365579	0.000134002312109383	0.341392172972976	0.129905874132482	0.456801604375956];
lb = zeros([length(parameter),1]);
ub = [inf inf 1.5 1.5 1 1 inf inf 1 inf inf inf];
t_i = t;


options = optimset('Display','iter');
options.Algorithm = 'sqp';
options.MaxFunEvals = 1e5;
options.MaxIter = 1e4;
options.OptimalityTolerance = 1e-12;

options2 = optimset('Display','iter');
options2.MaxFunEvals = 1e5;
options2.MaxIter = 1e4;
options2.TolFun = 1e-12;
options2.TolX = 1e-4;


[end_parameters,r1] = fmincon(@(x) Optim2(U_m,I_m, t_i, x,false),parameter,[],[],[],[],lb,ub,[],options);
[end_parameters2,r2] = minimize(@(x) Optim2(U_m,I_m, t_i, x,false),parameter,[],[],[],[],lb,ub,[],options2);
if r2<r1
    b_end_parameters = end_parameters2
else
    b_end_parameters = end_parameters
end


[end_parameters,r1] = fmincon(@(x) Optim2(U_m,I_m, t_i, x,true),parameter,[],[],[],[],lb,ub,[],options);
[end_parameters2,r2] = minimize(@(x) Optim2(U_m,I_m, t_i, x,true),parameter,[],[],[],[],lb,ub,[],options2);

if r2<r1
    b_end_parameters = end_parameters2
else
    b_end_parameters = end_parameters
end

[X,G,Umem_i,I] = Yakopcic_Memristor(t_i,b_end_parameters,U_m);
plot(U_m,I_m,'--');
plot(U_m,I);
legend('Wartość referencyjna','Dopasowany model')
figure(2)
hold on
plot(t,I_m)
plot(t_i,I)
legend('Prąd uśredniony','Prąd modelu')
% I(length(I)+1) = I(1);
% V(length(V)+1) = V(1);
figure(4)
plot(U_m,X)

figure(5)
plot(t,U_mem_m)
hold on
plot(t_i,Umem_i)

figure(6)
plot(U_m,Umem_i./I)

