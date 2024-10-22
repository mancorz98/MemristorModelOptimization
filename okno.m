function f = okno(parameter,x,V)
xp = parameter(5);
xn = parameter(6);
ap = parameter(7);
an = parameter(8);
if V>0
    if x >= xp
        f = exp(-ap*(x-xp))*(((xp-x)/(1-xp))+1);
    else 
        f=1;
    end
else
    if x <= 1-xn
        f = exp(an*(x+xn-1))*((x)/(1-xn));
    else
        f=1;
    end
end
end

