function dx = MMS_prime(init, parameter)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
tau = parameter(6);
beta = 38.4615;
%beta = parameter(6);
Ron = parameter (1);
Roff = parameter (2);
Von = parameter (3);
Voff = parameter (4);
Xinit = parameter (5);
X = init (1);
G = init (2);
V = init (3);
I = init (4);
dx = 1/tau * ((1/(1 + exp(-beta * (V-Von)))) * (1-X)-(1-1/(1 + exp(-beta * (V +Voff)))) * X);
end

