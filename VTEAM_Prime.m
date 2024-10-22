function dx = VTEAM_Prime(init ,parameters,a)
    
R_off = parameters(1);
R_on = parameters(2);
v_on = parameters(3);
v_off = parameters(4);
k_on = parameters(5);
k_off = parameters(6);
a_on = a(1);
a_off = a(2);

X = init (1);
V = init (3);
I = init (4);


if  V <= v_on
        dx = k_on * (V/v_on - 1)^ a_on  * biolek_window(4,X,I);
        %dx = k_on * (U(i)/v_on - 1)^ a_on  * 1;
    elseif V >= v_off
        dx = k_off *(V/v_off - 1)^a_off * biolek_window(1,X,I);
        %dx = k_off *(U(i)/v_off - 1)^a_off * 1;
    else
        dx = 0;
end

end