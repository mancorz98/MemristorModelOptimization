function [X,G,V,I] = VTEAM_model(t_i, parameter, V_in,a,Rs)

w_off = 1;

R_off = parameter(1);
R_on = parameter(2);
v_on = parameter(3);
v_off = parameter(4);
k_on = parameter(5);

k_off = parameter(6);
a_on = a(1);
a_off = a(2);
x_init = parameter(7);
l_t = length(V_in) ;


f = zeros (4, l_t);


ts = t_i(2:end) - t_i(1:end-1);
dt= mean(ts);

f(1,1) = x_init;
f(2,1) = 1 / (R_on+(R_off-R_on)/w_off*f(1,1));
f(3,1) = V_in(1)/(1 + Rs * f(2,1));
f(4,1) = f(2,1) * f(3,1);


for i = 2:l_t

    v1 = dt * VTEAM_Prime(f(:,i-1), parameter,a);
    v2 = dt * VTEAM_Prime((f(:,i-1) + v1/2), parameter,a);
    v3 = dt * VTEAM_Prime((f(:,i-1) + v2/2), parameter,a);
    v4 = dt * VTEAM_Prime((f(:,i-1) + v3), parameter,a);


    f(1,i) = f(1,i-1) + 1/6 * (v1 + 2 * v2 + 2 * v3 + v4);
    f(2,i) = 1 / (R_on+(R_off-R_on)/w_off*f(1,i));
    f(3,i) = V_in(i)/(1 + Rs * f(2,i));
    f(4,i) = f(2,i) * f(3,i);

end
X = f(1,:); % State variable
G = f(2,:); % Conductivity
V = f(3,:); % Voltage of the memristor
I = f(4,:); % Current through the memristorend.
end