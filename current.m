function [I] = current(parameter,x,V)
a1 = parameter(10);
a2 = parameter(11);
b = parameter(12);

if V>=0
    I = a1*x*sinh(b*V);
else
    I = a2*x*sin(b*V);
end

end

