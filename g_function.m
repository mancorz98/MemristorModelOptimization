function g = g_function(parameter,V)
Vp = parameter(3);
Vn = parameter(4);
Ap = parameter(1);
An = parameter(2);
if V>Vp
    g = Ap*(exp(V)-exp(Vp));
elseif V<-Vn
    g = -An*(exp(-V)-exp(Vn));
else
    g = 0;
end

end

