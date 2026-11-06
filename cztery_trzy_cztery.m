

t1 = (1/3)*tk; % ustaw tr jako 1/3 czasu koncowego
t2 = (2/3)*tk; % ustaw tw jako 2/3 czasu koncowego
%t3 = tk
tr = t1-t0;
tb = t2-t1;
tw = tk-t2;
k = size(q_A);
n = k(2);
tvec_1 = t0:0.01:tr;
tau_t1 = (tvec_1-t0)/(t1-t0);
tvec_2 = t1:0.01:t2;
tau_t2 = (tvec_2-t1)/(t2-t1);
tvec_3 = t2:0.01:tk;
tau_t3 = (tvec_3-t2)/(tk-t2);

q_R = (1/4)*(q_B+3*q_A);
q_W = (1/4)*(3*q_B+q_A);
%Macierz 14x14 
A = [1, 0,    0,       0,      0,       0, 0,     0,      0,      0, 0,     0,      0,      0;  %w1
     0, 0,    0,       0,      0,       0, 0,     0,      0,      0, 1,     1,      1,      1;  %w2
     0 1/tr   0,       0,      0,       0, 0,     0,      0,      0, 0,     0,      0,      0;  %w3
     0, 0     0,       0,      0,       0, 0,     0,      0,      0, 1/tw,  2/tw,   3/tw,   4/tw; %w4
     0, 0,    2/tr^2,  0,      0,       0, 0,     0,      0,      0, 0,     0,      0,      0;  %w5
     0, 0,    0,       0,      0,       0, 0,     0,      0,      0, 0,     2/tw^2, 6/tw^2, 12/tw^2; %w6
     1, 1,    1,       1,      1,       0, 0,     0,      0,      0, 0,     0,      0,      0;  %w7
     0, 0,    0,       0,      0,       1, 1,     1,      1,      0, 0,     0,      0,      0;  %w8
     0, 1/tr, 2/tr,    3/tr,   4/tr,    0, -1/tb, 0,      0,      0, 0,     0,      0,      0;  %w9
     0, 0,    0,       0,      0,       0, 1/tb,  2/tb,   3/tb,   0, -1/tw, 0,      0,      0;  %w10
     0, 0,    2/tr^2,  6/tr^2, 12/tr^2, 0,  0,   -2/tb^2, 0,      0, 0,     0,      0,      0;  %w11
     0, 0,    0,       0,      0,       0,  0,    2/tb^2, 6/tb^2, 0, 0,    -2/tw^2, 0,      0;  %w12
     0, 0,    0,       0,      0,       1,  0,    0,       0,     0, 0,     0,      0,      0;  %w13
     0, 0,    0,       0,      0,       0,  0,    0,       0,     1, 0,     0,      0,      0]; %w14

for i = 1:n
B = [q_A(i); q_B(i); 0; 0; 0; 0; q_R(i); q_W(i); 0; 0; 0; 0; q_R(i); q_W(i)];
X = inv(A)*B;

a10 = X(1);
a11 = X(2);
a12 = X(3);
a13 = X(4);
a14 = X(5);
a20 = X(6);
a21 = X(7);
a22 = X(8);
a23 = X(9);
a30 = X(10);
a31 = X(11);
a32 = X(12);
a33 = X(13);
a34 = X(14);

%pozycja
q_w4_1 = a10+a11*tau_t1+a12*tau_t1.^2+a13*tau_t1.^3+a14*tau_t1.^4;
q_w3   = a20+a21*tau_t2+a22*tau_t2.^2+a23*tau_t2.^3;
q_w4_2 = a30+a31*tau_t3+a32*tau_t3.^2+a33*tau_t3.^3+a34*tau_t3.^4;
%predkosc
dq_w4_1 = (a11+2*a12*tau_t1+3*a13*tau_t1.^2+4*a14*tau_t1.^3)/tr;
dq_w3  = (a21+2*a22*tau_t2+3*a23*tau_t2.^2)/tb;
dq_w4_2 = (a31+2*a32*tau_t3+3*a33*tau_t3.^2+4*a34*tau_t3.^3)/tw;
%przyspieszenie
ddq_w4_1 = (2*a12+6*a13*tau_t1+12*a14*tau_t1.^2)/tr^2;
ddq_w3 = (2*a22+6*a23*tau_t2)/tb^2;
ddq_w4_2 = (2*a32+6*a33*tau_t3+12*a34*tau_t3.^2)/tw^2;

%sklejenie wielomianu

index_R = size(tau_t1,2); %indeksy uzywane do wziecia danych z tablicy calkowitej by zaznaczyc punkty zmiany wielomianow
index_W = size(tau_t1,2)+size(tau_t2,2); % jako ze wielomiany sa sklejane to punktem przegeicia bedzie ostatni punkt w tablicy

tau_calk = [tvec_1,tvec_2,tvec_3]; %zakres 
q_calk = [q_w4_1, q_w3, q_w4_2];
dq_calk = [dq_w4_1, dq_w3, dq_w4_2];
ddq_calk = [ddq_w4_1, ddq_w3, ddq_w4_2];

q_tau_w434 = q_calk(:,i);
rys_wykresy(tau_calk,q_calk,dq_calk,ddq_calk,i,7,434)
 %Rysowanie wykresow
    if i <= 3
        figure(7)
        plot_index = i;
    else
        figure(8)
        plot_index = i - 3;
    end

    % Punkty R i W na wykresach przemieszczenia

    subplot(3,3,plot_index)
    hold on
    plot(tau_calk(index_R), q_calk(index_R), 'go', MarkerSize=6, MarkerFaceColor='g'); % stworz punkt 'go' g -green o - punkt, MarkerSize - wielkosc punktu , MarkerFaceColor = 'g' - kolor wypelnienia na  g (green)
    plot(tau_calk(index_W), q_calk(index_W), 'bo', MarkerSize=6, MarkerFaceColor='b'); % b- blue i tak dalej
    % Dodanie opisów tekstowych nad/obok punktów
    text(tau_calk(index_R), q_calk(index_R), '  R', 'VerticalAlignment', 'bottom', 'FontSize', 9, 'Color', 'g', 'FontWeight', 'bold');
    text(tau_calk(index_W), q_calk(index_W), '  W', 'VerticalAlignment', 'bottom', 'FontSize', 9, 'Color', 'b', 'FontWeight', 'bold');
    % Maksymalne i minimalne wartosci
    hold off

    % Punkty R i W na wykresach predkosci

    subplot(3,3,plot_index+3)
    hold on
    plot(tau_calk(index_R), dq_calk(index_R), 'go', MarkerSize=6, MarkerFaceColor='g'); % stworz punkt 'go' g -green o - punkt, MarkerSize - wielkosc punktu , MarkerFaceColor = 'g' - kolor wypelnienia na  g (green)
    plot(tau_calk(index_W), dq_calk(index_W), 'bo', MarkerSize=6, MarkerFaceColor='b'); % b- blue i tak dalej
    hold off
    % Dodanie opisów tekstowych nad/obok punktów
    text(tau_calk(index_R), dq_calk(index_R), '  R', 'VerticalAlignment', 'bottom', 'FontSize', 9, 'Color', 'g', 'FontWeight', 'bold');
    text(tau_calk(index_W), dq_calk(index_W), '  W', 'VerticalAlignment', 'bottom', 'FontSize', 9, 'Color', 'b', 'FontWeight', 'bold');
    hold off
       
    % Punkty R i W na wykresach przyspieszenia

    subplot(3,3,plot_index+6)
    hold on
    plot(tau_calk(index_R), ddq_calk(index_R), 'go', MarkerSize=6, MarkerFaceColor='g'); % stworz punkt 'go' g -green o - punkt, MarkerSize - wielkosc punktu , MarkerFaceColor = 'g' - kolor wypelnienia na  g (green)
    plot(tau_calk(index_W), ddq_calk(index_W), 'bo', MarkerSize=6, MarkerFaceColor='b'); % b- blue i tak dalej
    % Dodanie opisów tekstowych nad/obok punktów
    text(tau_calk(index_R), ddq_calk(index_R), '  R', 'VerticalAlignment', 'bottom', 'FontSize', 9, 'Color', 'g', 'FontWeight', 'bold');
    text(tau_calk(index_W), ddq_calk(index_W), '  W', 'VerticalAlignment', 'bottom', 'FontSize', 9, 'Color', 'b', 'FontWeight', 'bold');
    hold off

end
