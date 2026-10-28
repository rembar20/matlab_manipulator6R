function w_7stp = wielomian_7stopien(t0,tk,q_A,q_B)
t = t0:0.01:tk;
tau = t ./ tk;

n = length(q_A);

% Macierz A (8x8) dla wielomianu 7. stopnia
A = [1 0 0 0 0 0 0 0;
     0 1/tk 0 0 0 0 0 0;
     0 0 2/tk^2 0 0 0 0 0;
     0 0 0 6/tk^3 0 0 0 0;
     1 1 1 1 1 1 1 1;
     0 1/tk 2/tk 3/tk 4/tk 5/tk 6/tk 7/tk;
     0 0 2/tk^2 6/tk^2 12/tk^2 20/tk^2 30/tk^2 42/tk^2;
     0 0 0 6/tk^3 24/tk^3 60/tk^3 120/tk^3 210/tk^3];

for i = 1:n
    
    %wektor warunkow brzegowych (q0,dq0,ddq0, dddq0,qk,dqk,ddq0, dddqk)
    B = [q_A(i); 0; 0; 0; q_B(i); 0; 0; 0];
    X = inv(A)*B;
    
    a0 = X(1); 
    a1 = X(2); 
    a2 = X(3); 
    a3 = X(4);
    a4 = X(5); 
    a5 = X(6); 
    a6 = X(7); 
    a7 = X(8);
    
    % Pozycja, prędkość i przyspieszenie
    q_tau = a0 + a1*tau + a2*tau.^2 + a3*tau.^3 + a4*tau.^4 + a5*tau.^5 + a6*tau.^6 + a7*tau.^7;
    dq_tau = (a1 + 2*a2*tau + 3*a3*tau.^2 + 4*a4*tau.^3 + 5*a5*tau.^4 + 6*a6*tau.^5 + 7*a7*tau.^6)/(tk);
    ddq_tau = (2*a2 + 6*a3*tau + 12*a4*tau.^2 + 20*a5*tau.^3 + 30*a6*tau.^4 + 42*a7*tau.^5)/(tk^2);
    %Rysowanie wykresow
    if i <= 3
        figure(5)
        plot_index = i;
    else
        figure(6)
        plot_index = i - 3;
    end
    
    subplot(3,3,plot_index)
    plot(tau, q_tau, 'r')
    xlabel('\it\tau')
    nazwa = ['\it\theta_' num2str(i)];
    title(nazwa)
    ylabel(nazwa)
    grid on
    
    subplot(3,3,plot_index+3)
    plot(tau, dq_tau, 'r')
    xlabel('\it\tau')
    nazwa = ['d\it\theta_' num2str(i)];
    ylabel(nazwa)
    grid on
    
    subplot(3,3,plot_index+6)
    plot(tau, ddq_tau, 'r')
    xlabel('\it\tau')
    nazwa = ['dd\it\theta_' num2str(i)];
    ylabel(nazwa)
    grid on
end


figure(5)
set(gcf,"Name", "W7Stp - Ramie","NumberTitle", "off")
sgtitle('Trajektorie ramienia (1-3) - Wielomian 7 stopnia')

figure(6)
set(gcf,"Name", "W7Stp - Nadgarstek","NumberTitle", "off")
sgtitle('Trajektorie nadgarstka (4-6) - Wielomian 7 stopnia')

end