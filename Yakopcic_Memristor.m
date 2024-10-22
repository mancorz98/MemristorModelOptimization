function [X,G,V,I] = Yakopcic_Memristor(t, parameter, V_in,Rs)
delta_t = t(2)-t(1);
l_t = length(t);
f = zeros (2, l_t);
Ap = parameter(1);
An = parameter(2);
Vp = parameter(3);
Vn = parameter(4);
xp = parameter(5);
xn = parameter(6);
ap = parameter(7);
an = parameter(8);
Xinit = parameter (9);
a1 = parameter(10);
a2 = parameter(11);
b = parameter(12);

f(1,1) = Xinit;
f(2,1) = current(parameter,Xinit,V_in(1));
f(3,1) = V_in(1) - f(2,1)*Rs;



for i = 2:l_t
    
    v1 = delta_t * Yakopcic_Prime([f(1,i-1), V_in(i), f(2,i)], parameter);
    v2 = delta_t * Yakopcic_Prime(([f(1,i-1), V_in(i), f(2,i)] + v1/2), parameter);
    v3 = delta_t * Yakopcic_Prime(([f(1,i-1), V_in(i), f(2,i)] + v2/2), parameter);
    v4 = delta_t * Yakopcic_Prime(([f(1,i-1), V_in(i), f(2,i)] + v3), parameter);
    f(1,i) = f(1,i-1) + 1/6 * (v1 + 2 * v2 + 2 * v3 + v4);
 
    f(2,i) = current(parameter,f(1,i),V_in(i));
    f(3,i) = V_in(i) - f(2,i)*Rs;
end
I = f(2,:);% Current through the memristor.
X = f(1,:);
V = f(3,:);
G = I./V;
end
