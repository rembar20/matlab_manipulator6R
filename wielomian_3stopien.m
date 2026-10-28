function w_3stp = wielomian_3stopien(t0,tk,q_A,q_B)
t=[t0:0.01:tk];
tau=t./tk;
%theta1 theta2 theta3
k=size(q_A);
n=k(2);

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

%Rysowanie wykresow
if(i <=3)
    figure(1)
    plot_index = i;
elseif i>=4 
    figure(2)
    plot_index = i-3;
end

subplot(3,3,plot_index)
plot(tau,q_tau,'r')
xlabel('\it\tau')
nazwa=['\it\theta_' num2str(i)];
title(nazwa)
ylabel(nazwa)
grid on
subplot(3,3,plot_index+3)
plot(tau,dq_tau,'r')
xlabel('\it\tau')
nazwa=['d\it\theta_' num2str(i)];
ylabel(nazwa)
subplot(3,3,plot_index+6)
plot(tau,ddq_tau,'r')
xlabel('\it\tau')
nazwa=['dd\it\theta_' num2str(i)];
ylabel(nazwa)
grid on
%eval(['C' num2str(i) '=C'])
end
figure(1)
set(gcf,"Name", "W3Stp - Ramie","NumberTitle", "off")
sgtitle('Trajektorie ramienia (1-3) - Wielomian 3 stopnia')
figure(2)
set(gcf,"Name", "W3Stp - Nadgarstek","NumberTitle", "off")
sgtitle('Trajektorie nadgarstka (4-6) - Wielomian 3 stopnia')
end