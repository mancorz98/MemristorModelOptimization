function [f] = biolek_window(p,x,cur)
f = 1 - ( x - heaviside(-1*cur))^(2*p);
end