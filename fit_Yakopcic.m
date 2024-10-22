function [b_end_parameters,r2_best] = fit_Yakopcic(U_m,I_m,t,Rs)

%parameter = [4000	4000	0.0797940961462372	0.179601337076835	0.1	0.9	2.11289011350819	6.79935966365579	1e-3	0.341392172972976	0.129905874132482	0.456801604375956];
%parameter = [298.144276518999	14806.8395763799	0.0543994905656497	0.237489981310999	0.453428336444115	0.674867477442484	3.97694638959827	44.9225098118077	0	0.439547490134639	0.307515596540527	0.332696689894238];
%parameter = [310.471327889630	14807.8487420178	0.696448885989638	0.128686697415129	0	1	329.726786409863	589.312611173305	1e-3	63.0794895011012	62.7705190282585	0.0282682022342371];
parameter = [4000	4000	0.0797940961462372	0.179601337076835	0	0.163437027084673	2.11289011350819	6.79935966365579	0.000134002312109383	0.341392172972976	0.129905874132482	0.456801604375956];;
lb = zeros([length(parameter),1]);
ub = [1e6 1e6 1.5 1.5 1 1 1e3 1e3 1 1e3 1e3 1e3];

options = optimset('Display','off');
options.Algorithm = 'sqp';
options.MaxFunEvals = 1e6;
options.MaxIter = 4e4;
options.OptimalityTolerance = 1e-6;
options.TolFun = 1e-6;
options.TolX = 1e-6;
options.OptimalityTolerance = 1e-6;
options.UseParallel = false;




options2 = optimset('Display','off');
options2.MaxFunEvals = 1e6;
options2.MaxIter = 4e4;
options2.TolFun = 1e-6;
options2.TolX = 1e-6;
%options2.Algorithm = 'fminlbfgs';
weight = 2;

try
    [end_parameters,r1] = fmincon(@(x) Optim_Yakopcic(U_m,I_m, t, x,false,Rs, weight),parameter,[],[],[],[],lb,ub,[],options);
catch ME
        warning('Problem using fmincon');
        r1 = 2;
        end_parameters = parameter;
end


[end_parameters2,r2] = minimize(@(x) Optim_Yakopcic(U_m,I_m, t, x,false,Rs, weight),parameter,[],[],[],[],lb,ub,[],options2);


if r2<r1
    b_end_parameters = end_parameters2;
else
    b_end_parameters = end_parameters;
end


while true
    try
    [end_parameters,r1] = fmincon(@(x) Optim_Yakopcic(U_m,I_m, t, x,true, Rs, weight),parameter,[],[],[],[],lb,ub,[],options);
    catch ME
        warning('Problem using fmincon');
        r1 = 2;
        end_parameters = parameter;
    end

    
    [end_parameters2,r2] = minimize(@(x) Optim_Yakopcic(U_m,I_m, t, x,true, Rs, weight),parameter,[],[],[],[],lb,ub,[],options2);
    
    if r2<r1
        b_end_parameters = end_parameters2;
        r2_best = r2;
    else
        b_end_parameters = end_parameters;
        r2_best = r1;
    end

    [X,~] = Yakopcic_Memristor(t,b_end_parameters,U_m,Rs);
    if abs((X(1)-X(end))/X(1)) <= 1e-3 || weight >= 8
        break;
    else 
        weight = weight+1;
    end
end




end