function w_5stp = wielomian_5stopien(t0,tk,q_A,q_B)
t = [t0:0.01:tk];
tau = t./tk;

k = size(q_A);
n = k(2);
%macierz A 
A = [1 0 0 0 0 0;
    0 1/tk 0 0 0 0;
    0 0 2/tk^2 0 0 0;
    1 1 1 1 1 1;
    0 1/tk 2/tk 3/tk 4/tk 5/tk;
    0 0 2/tk^2 6/tk^2 12/tk^2 20/tk^2];

for i = 1:n
    % Wektor warunkow brzegowych: [q0, dq0, ddq0, qk, dqk, ddqk]'
    B = [q_A(i); 0; 0; q_B(i); 0; 0];
    %macierz wspl wielomianu
    X = inv(A)*B;

    a0 = X(1);
    a1 = X(2);
    a2 = X(3);
    a3 = X(4);
    a4 = X(5);
    a5 = X(6);

    % Pozycja, prędkość i przyspieszenie
    q_tau   = a0 + a1*tau + a2*tau.^2 + a3*tau.^3 + a4*tau.^4 + a5*tau.^5;
    dq_tau  = (a1 + 2*a2*tau + 3*a3*tau.^2 + 4*a4*tau.^3 + 5*a5*tau.^4)/tk;
    ddq_tau = (2*a2 + 6*a3*tau + 12*a4*tau.^2 + 20*a5*tau.^3)/(tk^2);

    if(i <= 3)
        figure(3)
        plot_index = i;
    elseif i >= 4 
        figure(4)
        plot_index = i-3;
    end

    subplot(3,3,plot_index)
    plot(tau,q_tau,'r')
    xlabel('\it\tau')
    nazwa = ['\it\theta_' num2str(i)];
    title(nazwa)
    ylabel(nazwa)
    grid on

    subplot(3,3,plot_index+3)
    plot(tau,dq_tau,'r')
    xlabel('\it\tau')
    nazwa = ['d\it\theta_' num2str(i)];
    ylabel(nazwa)
    grid on

    subplot(3,3,plot_index+6)
    plot(tau,ddq_tau,'r')
    xlabel('\it\tau')
    nazwa = ['dd\it\theta_' num2str(i)];
    ylabel(nazwa)
    grid on
end

figure(3)
set(gcf,"Name", "W5Stp - Ramie","NumberTitle", "off")
sgtitle('Trajektorie ramienia (1-3) - Wielomian 5 stopnia')
figure(4)
set(gcf,"Name", "W5Stp - Nadgarstek","NumberTitle", "off")
sgtitle('Trajektorie nadgarstka (4-6) - Wielomian 5 stopnia')
end