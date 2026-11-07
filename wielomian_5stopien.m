
t = t0:0.01:tk;
tau = t./tk;

k = size(q_A);
n = k(2);
q_tau_w5 = zeros(length(t),n);

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
    ddq_tau = (2*a2 + 6*a3*tau + 12*a4*tau.^2 + 20*a5*tau.^3)/tk^2;
    
    q_tau_w5(:,i) = q_tau(:);

%Rysowanie wykresow
rys_wykresy(tau,q_tau,dq_tau,ddq_tau,i,3,5) %  WektorCzasu, WektorQ, Wektor_dQ, Wektor_ddQ, i, num_okna, st_wielomianu
end

        t_tcp = t;  % czas na os X wykresu TCP
        q_tau_tcp = q_tau_w5;   % wartosci theta1:6 dla wykresow TCP