function [best_parameter,a,min_r] = fit_VTEAM(U_m,I_m,t,Rs)


parameter = [513.6430582003035 589.438190710945 -3.39153632977762e-06 0.166832062114045 -0.239573183740504 9975.09057640145 0];
%ME = Optim(U_m,I_m, t, parameter);
options = optimset('Display','off');
options.Algorithm = 'sqp'; 
options.MaxFunEvals = 1e5;
options.MaxIter =  2e3;
options.TolFun = 1e-4;
options.TolX = 1e-4;
options.OptimalityTolerance = 1e-4;
options.UseParallel = false;
 
options2 = optimset('Display','off');
options2.MaxFunEvals = 1e5;
options2.MaxIter = 2e3;
options2.TolFun = 1e-4;
options2.TolX = 1e-4;
%options2.Algorithm = 'fminlbfgs';

lb = [0,    0,      -1.5, 0,  -1e5,0,0];
ub = [100,  1e6,    0,  1.5,    0,1e5,0.1];
%nonlcon = @unitdisk;
best_parameters = zeros([9,9,length(parameter)]);
r_table = ones([9,9]);
weight = 1;

parfor i = 1:9
    for j = 1:9
        try
            [end_parameters,r1] = fmincon(@(x) Optim_VTEAM(U_m,I_m, t, x, false,[i,j],Rs,weight),parameter,[],[],[],[],lb,ub,[],options);
        catch ME
                warning('Problem using fmincon');
                r1 = 2;
                end_parameters = parameter;
        end
        try
            [end_parameters2,r2] = minimize(@(x) Optim_VTEAM(U_m,I_m, t, x, false,[i,j],Rs,weight), parameter,[],[],[],[],lb,ub,[],options2);
        catch ME
                warning('Problem using minimize');
                r2 = 2;
                end_parameters2 = parameter;
        end
        %r1 = 1;
        
        if r2<r1
            b_end_parameters = end_parameters2;
            r_best = r2;
        else
            b_end_parameters = end_parameters;
            r_best = r1;
        end
        
        if r_best >= 0.1
            disp('Porzucono rozwiązanie')
            continue;
        end
            try
            [end_parameters,r1] = fmincon(@(x) Optim_VTEAM(U_m,I_m, t, x, true,[i,j],Rs,weight),b_end_parameters,[],[],[],[],lb,ub,[],options);
            catch ME
                warning('Problem using fmincon');
                r1 = 2;
                end_parameters = parameter;
            end

        try
            [end_parameters2,r2] = minimize(@(x) Optim_VTEAM(U_m,I_m, t, x, true,[i,j],Rs,weight), b_end_parameters,[],[],[],[],lb,ub,[],options2);
        catch ME
                warning('Problem using minimize');
                r2 = 2;
                end_parameters2 = parameter;
        end
            if r2<r1
                b_end_parameters = end_parameters2
                r_table(i,j) = r2;
                s = sprintf("Obliczenia dla a_on=%d, a_off=%d, r2=%f, wygrywa minimize",[i,j,r2]);
                disp(s)
            else
                b_end_parameters = end_parameters
                r_table(i,j) = r1;
                s = sprintf("Obliczenia dla a_on=%d, a_off=%d, r2=%f, wygrywa fmincon",[i,j,r1]);
                disp(s)
            end
            
        %b_end_parameters(7:8) = abs(b_end_parameters(7:8));
        best_parameters(i,j,:) = b_end_parameters;
    end
end
min_r = min(min(r_table));
[a_on, a_off] = find(r_table==min_r);
best_parameter = best_parameters(a_on,a_off,:);
a = [a_on, a_off];
best_parameter = reshape(best_parameter, 7,[]);



options = optimset('Display','off');
options.Algorithm = 'sqp'; 
options.MaxFunEvals = 1e6;
options.MaxIter = 2e4;
options.TolFun = 1e-4;
options.TolX = 1e-4;
options.OptimalityTolerance = 1e-4;
 
options2 = optimset('Display','off');
options2.MaxFunEvals = 1e6;
options2.MaxIter = 2e4;
options2.TolFun = 1e-4;
options2.TolX = 1e-4;
%options2.Algorithm = 'fminlbfgs';

%nonlcon = @unitdisk;



try
    [end_parameters,r1] = fmincon(@(x) Optim_VTEAM(U_m,I_m, t, x, false,a,Rs,weight),best_parameter,[],[],[],[],lb,ub,[],options);
catch ME
        warning('Problem using fmincon');
        r1 = 1;
        end_parameters = parameter;
end
try
    [end_parameters2,r2] = minimize(@(x) Optim_VTEAM(U_m,I_m, t, x, false,a,Rs,weight), best_parameter,[],[],[],[],lb,ub,[],options2);
catch ME
        warning('Problem using minimize');
        r2 = 1;
        end_parameters2 = parameter;
end
%r1 = 1;

if r2<r1
    b_end_parameters = end_parameters2;
    r_best = r2;
else
    b_end_parameters = end_parameters;
    r_best = r1;

while true

    try
    [end_parameters,r1] = fmincon(@(x) Optim_VTEAM(U_m,I_m, t, x, true,a,Rs,weight),b_end_parameters,[],[],[],[],lb,ub,[],options);
    catch ME
        warning('Problem using fmincon');
        r1 = 1;
        end_parameters = parameter;
    end
    
    try
    [end_parameters2,r2] = minimize(@(x) Optim_VTEAM(U_m,I_m, t, x, true,a,Rs,weight), b_end_parameters,[],[],[],[],lb,ub,[],options2);
    catch ME
        warning('Problem using minimize');
        r2 = 1;
        end_parameters2 = parameter;
    end
    if r2<r1
        best_parameter = end_parameters2;
        min_r = r2;
        s = sprintf("Obliczenia dla a_on=%d, a_off=%d, r2=%f, wygrywa minimize",[a(1),a(2),r2]);
        disp(s)
    else
        best_parameter = end_parameters;
        min_r = r1;
        s = sprintf("Obliczenia dla a_on=%d, a_off=%d, r2=%f, wygrywa fmincon",[a(1),a(2),r1]);
        disp(s)
    end
    
    [X,~] = VTEAM_model(t,best_parameter,U_m,a,Rs);
    if abs((X(1)-X(end))/X(1)) <= 1e-2 || weight >= 8
        break;
    else 
        weight = weight+1;
    end



end
end