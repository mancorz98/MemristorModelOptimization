function [X,G,V,I] = MMS_Memristor_RK4 (t, parameter, V_in,Rs)
delta_t = t(2)-t(1);
l_t = length(t);
f = zeros (4, l_t);
Ron = parameter (1);
Roff = parameter (2);
Von = parameter (3);
Voff = parameter (4);
Xinit = parameter (5);
f(1,1) = Xinit;
f(2,1) = f(1,1)/Ron + (1-f(1,1))/Roff;
f(3,1) = V_in(1)/(1 + Rs * f(2,1));
f(4,1) = f(2,1) * f(3,1);
for i = 2:l_t
    v1 = delta_t * MMS_prime(f(:,i-1), parameter);
    v2 = delta_t * MMS_prime((f(:,i-1) + v1/2), parameter);
    v3 = delta_t * MMS_prime((f(:,i-1) + v2/2), parameter);
    v4 = delta_t * MMS_prime((f(:,i-1) + v3), parameter);
    f(1,i) = f(1,i-1) + 1/6 * (v1 + 2 * v2 + 2 * v3 + v4);
    f(2,i) = f(1,i)/Ron + (1-f(1,i))/Roff;
    f(3,i) = V_in(i)/(1 + Rs * f(2,i));
    f(4,i) = f(2,i) * f(3,i);
end
X = f(1,:); % State variable
G = f(2,:); % Conductivity
V = f(3,:); % Voltage of the memristor
I = f(4,:); % Current through the memristorend.
end
