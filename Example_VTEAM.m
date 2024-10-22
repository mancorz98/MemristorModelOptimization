close all
clear all
[file, path] = uigetfile('*.txt')
file_path = strcat(path,file)
[U_m,I_m,t] = get_mean_values(file_path,false);
plot(U_m,I_m, "LineWidth",2);
legend('Wartości zmierzone','Wartości uśrednione')
figure(3)
plot(U_m,I_m, '--');
hold('on');


parameter = [1.4701, 203.5152, -0.0531, 0.0071,-1.3954,1.5698, 0.0416];
%ME = Optim(U_m,I_m, t, parameter);
options = optimset('Display','off');
%options.Algorithm = 'interior-point'; 
options.MaxFunEvals = 1e6;
options.MaxIter = 1000;
options.TolFun = 1e-6;
options.TolX = 1e-3;
%options.OptimalityTolerance = 1e-6;

options2 = optimset('Display','off');
options2.MaxFunEvals = 1e6;
options2.MaxIter = 1000;
options2.TolFun = 1e-6;
options2.TolX = 1e-3;

t_i = t;


lb = [0,0, -inf,0,-inf,0,0];
ub = [1e3,1e3,0,inf,0,inf,10];
%nonlcon = @unitdisk;
r_best = 1;
best_parameters = zeros([9,9,length(parameter)]);
r_table = zeros([9,9]);

parfor i = 1:9
    for j = 1:3
        try
        [end_parameters,r1] = minimize(@(x) Optim_VTEAM(U_m,I_m, t_i, x, false,[i,j]), parameter,[],[],[],[],lb,ub,[],options);
        %[end_parameters,r1] = fminunc(@(x) Optim_VTEAM(U_m,I_m, t, x,false),parameter,options2);
        catch ME
                warning('Problem using fmincon');
                r1 = 1;
                end_parameters = parameter;
        end
        %r1 = 1;
        [end_parameters2,r2] = fminsearch(@(x) Optim_VTEAM(U_m,I_m, t_i, x, false,[i,j]),parameter,options2);
        if r2<r1
            b_end_parameters = end_parameters2;
        else
            b_end_parameters = end_parameters;
        end

        [end_parameters,r1] = minimize(@(x) Optim_VTEAM(U_m,I_m, t_i, x, true,[i,j]), b_end_parameters,[],[],[],[],lb,ub,[],options);
        [end_parameters2,r2] = fminsearch(@(x) Optim_VTEAM(U_m,I_m, t_i, x, true,[i,j]),b_end_parameters,options2);

        if r2<r1
            b_end_parameters = end_parameters2
            r_table(i,j) = r2;
            s = sprintf("Obliczenia dla a_on=%d, a_off=%d, r2=%f, wygrywa fminsearch",[i,j,r2]);
            disp(s)
        else
            b_end_parameters = end_parameters
            r_table(i,j) = r1;
            s = sprintf("Obliczenia dla a_on=%d, a_off=%d, r2=%f, wygrywa minimize",[i,j,r1]);
            disp(s)
        end

        %b_end_parameters(7:8) = abs(b_end_parameters(7:8));
        best_parameters(i,j,:) = b_end_parameters;
    end
end

min_r = min(min(r_table));
[a_on, a_off] = find(r_table==min_r);
best_parameter = best_parameters(a_on,a_off,:) ;



[I,X,V,G] = VTEAM_model(t_i,best_parameter,U_m,[a_on, a_off]);
plot(U_m,I)
legend('Wartość referencyjna','Dopasowany model')
figure(2)
hold on
plot(t_i,I_m)
plot(t_i,I)
legend('Prąd uśredniony','Prąd modelu')
% I(length(I)+1) = I(1);
% V(length(V)+1) = V(1);
figure(4)
plot(U_m-I_m*4.7,I_m)
hold on
plot(V,I)
legend('Prąd uśredniony','Prąd modelu')

figure(5)
plot(V,X)

function [c,ceq] = unitdisk(x)
    c = [];
    ceq = zeros([2,1]);
    ceq(1) = mod(x(7),1);
    ceq(2) = mod(x(8),1);


end



