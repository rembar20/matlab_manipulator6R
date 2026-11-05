
t=t0:0.01:tk;
tau=t./tk;
%theta1 theta2 theta3
k=size(q_A);
n=k(2);
q_tau_w3 = zeros(length(t),n);
%macierz
A=[1 0 0 0;
    0 1/tk 0 0;
    1 1 1 1;
    0 1/tk 2/tk 3/tk];

for i=1:n
%wektor warunkow brzegowych (q0,dq0,qk,dqk)
B=[q_A(i) 0 q_B(i) 0]';
%macierz wspolczynnikow wielomianu
X=inv(A)*B;
a0=X(1);
a1=X(2);
a2=X(3);
a3=X(4);
% Pozycja, przyspieszenie, predkosc
q_tau=a0+a1*tau+a2*tau.^2+a3*tau.^3;
dq_tau = (a1+2*a2*tau+3*a3*tau.^2)/tk;
ddq_tau = (2*a2+6*a3*tau)/tk^2;

q_tau_w3(:,i) = q_tau(:); %inicjalizacja tablicy w której zawarte są wszystkie przejściowe wartości kątów przegubów  

%Rysowanie wykresow
rys_wykresy(tau,q_tau,dq_tau,ddq_tau,i,1,3) %  WektorCzasu, WektorQ, Wektor_dQ, Wektor_ddQ, i, num_okna, st_wielomianu
end