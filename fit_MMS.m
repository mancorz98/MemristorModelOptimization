function [b_end_parameters,r2_best] = fit_MMS(U_m,I_m,t,Rs)
parameter = [3	60	0.25	-0.001	1e-6	0.001];

lb = [0,0,0,-1.5,0,0];
ub = [1e3,1e4,1.5,0,1,0.1];

options = optimset('Display','off');
options.Algorithm = 'sqp';
options.MaxFunEvals = 1e5;
options.MaxIter = 2e4;
options.OptimalityTolerance = 1e-4;

options2 = optimset('Display','off');
%options2.Algorithm = 'fminlbfgs';
options2.MaxFunEvals = 1e5;
options2.MaxIter = 2e4;
options2.TolFun = 1e-4;
options2.TolX = 1e-4;
%options2.Algorithm = 'fminlbfgs';
weight = 2;

[end_parameters,r1] = fmincon(@(x) Optim_MMS(U_m,I_m, t, x,false,Rs,weight),parameter,[],[],[],[],lb,ub,[],options);
[end_parameters2,r2] = minimize(@(x) Optim_MMS(U_m,I_m, t, x,false,Rs,weight),parameter,[],[],[],[],lb,ub,[],options2);

if r2<r1
    b_end_parameters = end_parameters2;
else
    b_end_parameters = end_parameters;
end
while true
    try
    [end_parameters,r1] = fmincon(@(x) Optim_MMS(U_m,I_m, t, x,true,Rs,weight),b_end_parameters,[],[],[],[],lb,ub,[],options);
    catch ME
    disp('problem using fmicon')
    end
    
    [end_parameters2,r2] = minimize(@(x) Optim_MMS(U_m,I_m, t, x,true,Rs,weight),b_end_parameters,[],[],[],[],lb,ub,[],options2);
    
    if r2<r1
        b_end_parameters = end_parameters2;
        r2_best = r2;
    else
        b_end_parameters = end_parameters;
        r2_best = r1;
    end
    [X,~] = MMS_Memristor_RK4(t,b_end_parameters,U_m,Rs);
    if abs((X(1)-X(end))/X(1)) <= 1e-3 || weight >= 8
        break;
    else 
        weight = weight+1;
    end
end


end