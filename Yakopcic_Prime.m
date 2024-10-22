 function dx = Yakopcic_Prime(init, parameter)
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

X = init (1);

V = init (2);
I = init (3);

g = g_function(parameter,V);
f_s = okno(parameter,X,V);
dx = g*f_s;

end