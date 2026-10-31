
[pos_R, orient_R, tr] = DanePunktuPomocniczego('R',t0,tk);

if( isempty(pos_R)|| isempty(orient_R) || isempty(tr)) %sprawdzenie czy anulowano wpisanie danych punktu R
    msgbox("Anulowano rysowanie wykresów", 'Operacja anulowana', 'warn');
    return
else

[pos_W, orient_W, tw] = DanePunktuPomocniczego('W',t0+tr,tk);
end %endif dla powyzszego
if(isempty(pos_W) || isempty(orient_W) || isempty(tw)) %sprawdzenie czy anulowano wpisanie danych punktu W
    %rozbite na dwa ify, poniewaz przy jednym i tak otwierałoby się drugie
    %okno nawet jezeli anulowano w pierwszym
    msgbox("Anulowano rysowanie wykresów", 'Operacja anulowana', 'warn');
    return
else %jezeli nie anulowano danych to wykonuj program dalej

q_R = zadanie_odwrotne(pos_R(1),pos_R(2),pos_R(3),orient_R(1),orient_R(2),orient_R(3),dh_params);
q_W = zadanie_odwrotne(pos_W(1),pos_W(2),pos_W(3),orient_W(1),orient_W(2),orient_W(3),dh_params);

t = t0:0.01:tk;
tau = t ./ tk;
n = length(q_A);
q_tau_w7 = zeros(length(t),n);

% Macierz A (8x8) dla wielomianu 7. stopnia
A = [1 0 0 0 0 0 0 0; %qA
     1 1 1 1 1 1 1 1; %qB
     0 1/tk 0 0 0 0 0 0; %dqA
     0 1/tk 2/tk 3/tk 4/tk 5/tk 6/tk 7/tk;    %dQB 
     0 0 2/tk^2 0 0 0 0 0;     %ddQa
     0 0 2/tk^2 6/tk^2 12/tk^2 20/tk^2 30/tk^2 42/tk^2; %ddQb
     1 tr/tk (tr/tk)^2 (tr/tk)^3 (tr/tk)^4 (tr/tk)^5 (tr/tk)^6 (tr/tk)^7; %qR
     1 tw/tk (tw/tk)^2 (tw/tk)^3 (tw/tk)^4 (tw/tk)^5 (tw/tk)^6 (tw/tk)^7];%qW

for i = 1:n
    
    %wektor warunkow brzegowych (q0,dq0,ddq0, dddq0,qk,dqk,ddq0, dddqk)
    B = [q_A(i); q_B(i); 0; 0; 0; 0; q_R(i); q_W(i)];
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
    dq_tau = (a1 + 2*a2*tau + 3*a3*tau.^2 + 4*a4*tau.^3 + 5*a5*tau.^4 + 6*a6*tau.^5 + 7*a7*tau.^6);
    ddq_tau = (2*a2 + 6*a3*tau + 12*a4*tau.^2 + 20*a5*tau.^3 + 30*a6*tau.^4 + 42*a7*tau.^5);

   q_tau_w7(:,i) = q_tau(:);
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