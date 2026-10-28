function ctc = cztery_trzy_cztery(t0, tk, q_A, q_B)

% Planowanie trajektorii wielomianami 4-3-4 (stopnie 4, 3, 4) w przestrzeni przegubow.
% Odcinek 1 (stopien 4): A -> P1,  odcinek 2 (stopien 3): P1 -> P2,  odcinek 3 (stopien 4): P2 -> B.
% Kazdy odcinek ma wlasny czas znormalizowany tau_i = (t - t_i)/T_i in [0,1].
% 14 niewiadomych na przegub (5+4+5) i 14 warunkow:
%  q1(0)=q_A, dq1(0)=0, ddq1(0)=0;  q1(1)=P1, q2(0)=P1, ciaglosc dq i ddq w P1;
%  q2(1)=P2, q3(0)=P2, ciaglosc dq i ddq w P2;  q3(1)=q_B, dq3(1)=0, ddq3(1)=0.
% Punkty posrednie P1, P2 = q_A + ulamek*(q_B - q_A) (kazdy przegub), w chwilach t1, t2.

q_A = q_A(:)'; q_B = q_B(:)';
n = numel(q_A);
T = tk - t0;

% --- parametry (z klawiatury; Enter = domyslne) ---

dom_czas = [0.25 0.50 0.25];   % podzial czasu T na 3 odcinki (ulamki)
dom_poz  = [0.15 0.85];        % polozenie punktow posrednich jako ulamek przemieszczenia
disp('Wielomiany 4-3-4: parametry (Enter = wartosci domyslne)')
odp = strtrim(input(sprintf('Podzial czasu na 3 odcinki [%g %g %g] (ulamki, np. 0.25 0.5 0.25): ', dom_czas), 's'));
frakcje = str2num(odp); %#ok<ST2NM>

if numel(frakcje) ~= 3 || any(frakcje <= 0) || any(~isfinite(frakcje))
    if ~isempty(odp)
        disp('[!] Niepoprawne dane, przyjmuje wartosci domyslne.');
    end
    frakcje = dom_czas;
end

frakcje = frakcje / sum(frakcje);
odp = strtrim(input(sprintf('Polozenia posrednie P1 P2 jako ulamek przemieszczenia [%g %g]: ', dom_poz), 's'));
pozycje = str2num(odp); %#ok<ST2NM>

if numel(pozycje) ~= 2 || any(~isfinite(pozycje))
    if ~isempty(odp)
        disp('[!] Niepoprawne dane, przyjmuje wartosci domyslne.'); 
    end
    pozycje = dom_poz;
end

T1 = frakcje(1)*T; T2 = frakcje(2)*T; T3 = frakcje(3)*T;
tb1 = t0 + T1; tb2 = tb1 + T2;
P1 = q_A + pozycje(1)*(q_B - q_A);
P2 = q_A + pozycje(2)*(q_B - q_A);

fprintf('Czasy odcinkow: T1=%.3f s, T2=%.3f s, T3=%.3f s (punkty posrednie w t=%.3f s i t=%.3f s)\n', T1, T2, T3, tb1, tb2);

% --- macierz warunkow (taka sama dla kazdego przegubu) ---
M = zeros(14,14);
z = @(n_, tau_, d_) wiersz_potegowy(n_, tau_, d_);   % wiersz pochodnej d-tej wielomianu stopnia n_ w tau_
c1 = 1:5; c2 = 6:9; c3 = 10:14;                     % kolumny niewiadomych odcinkow 1,2,3
M(1,c1)  = z(4,0,0);                                % q1(0)
M(2,c1)  = z(4,0,1)/T1;                             % dq1(0)
M(3,c1)  = z(4,0,2)/T1^2;                           % ddq1(0)
M(4,c1)  = z(4,1,0);                                % q1(1) = P1
M(5,c2)  = z(3,0,0);                                % q2(0) = P1
M(6,c1)  = z(4,1,1)/T1;   M(6,c2)  = -z(3,0,1)/T2;     % ciaglosc predkosci w P1
M(7,c1)  = z(4,1,2)/T1^2; M(7,c2)  = -z(3,0,2)/T2^2;   % ciaglosc przyspieszenia w P1
M(8,c2)  = z(3,1,0);                                % q2(1) = P2
M(9,c3)  = z(4,0,0);                                % q3(0) = P2
M(10,c2) = z(3,1,1)/T2;   M(10,c3) = -z(4,0,1)/T3;     % ciaglosc predkosci w P2
M(11,c2) = z(3,1,2)/T2^2; M(11,c3) = -z(4,0,2)/T3^2;   % ciaglosc przyspieszenia w P2
M(12,c3) = z(4,1,0);                                % q3(1) = q_B
M(13,c3) = z(4,1,1)/T3;                             % dq3(1) = 0
M(14,c3) = z(4,1,2)/T3^2;                           % ddq3(1) = 0

t = linspace(t0, tk, round(T/0.01) + 1);
s1 = t <= tb1; s2 = t > tb1 & t <= tb2; s3 = t > tb2;
a1 = zeros(n,5); a2 = zeros(n,4); a3 = zeros(n,5);
Q = zeros(n, numel(t)); dQ = Q; ddQ = Q;

for i = 1:n
    b = [q_A(i); 0; 0; P1(i); P1(i); 0; 0; P2(i); P2(i); 0; 0; q_B(i); 0; 0];
    x = M \ b;
    a1(i,:) = x(c1)'; a2(i,:) = x(c2)'; a3(i,:) = x(c3)';
    [Q(i,s1), dQ(i,s1), ddQ(i,s1)] = oblicz_wielomian(a1(i,:), (t(s1)-t0)/T1, T1);
    [Q(i,s2), dQ(i,s2), ddQ(i,s2)] = oblicz_wielomian(a2(i,:), (t(s2)-tb1)/T2, T2);
    [Q(i,s3), dQ(i,s3), ddQ(i,s3)] = oblicz_wielomian(a3(i,:), (t(s3)-tb2)/T3, T3);
end

wypisz_wspolczynniki(a1, sprintf('Wielomian 4 stopnia - odcinek 1 (tau = (t-t0)/T1, T1=%.3f s):', T1));
wypisz_wspolczynniki(a2, sprintf('Wielomian 3 stopnia - odcinek 2 (tau = (t-t1)/T2, T2=%.3f s):', T2));
wypisz_wspolczynniki(a3, sprintf('Wielomian 4 stopnia - odcinek 3 (tau = (t-t2)/T3, T3=%.3f s):', T3));
rysuj_charakterystyki(t, Q, dQ, ddQ, 'Wielomiany 4-3-4', 7);

end

function w = wiersz_potegowy(n, tau, d)
% wiersz [d-ta pochodna tau^k po tau], k = 0..n, obliczona w tau
w = zeros(1, n+1)
for k = d:n
    w(k+1) = factorial(k)/factorial(k-d) * tau^(k-d);
end
end

function [q, dq, ddq] = oblicz_wielomian(a, tau, Ti)
% Oblicza pozycje, predkosc i przyspieszenie dla danych wspolczynnikow a w czasie tau w [0,1]
deg = numel(a) - 1;
q = zeros(size(tau));
dq = zeros(size(tau));
ddq = zeros(size(tau));

for k = 0:deg
    q = q + a(k+1) * tau.^k;
    if k >= 1
        dq = dq + k * a(k+1) * tau.^(k-1);
    end
    if k >= 2
        ddq = ddq + k * (k-1) * a(k+1) * tau.^(k-2);
    end
end
dq = dq / Ti;
ddq = ddq / (Ti^2);
end

function wypisz_wspolczynniki(a, naglowek)
disp(naglowek);
[n, deg_plus_1] = size(a);
for i = 1:n
    fprintf('Przegub %d: ', i);
    for k = 1:deg_plus_1
        fprintf('a%d=%.4f ', k-1, a(i,k));
    end
    fprintf('\n');
end
end

function rysuj_charakterystyki(t, Q, dQ, ddQ, tytul_glowny, fig_offset)
n = size(Q, 1);
for i = 1:n
    if i <= 3
        figure(fig_offset);
        plot_idx = i;
    else
        figure(fig_offset + 1);
        plot_idx = i - 3;
    end

    subplot(3, 3, plot_idx)
    plot(t, Q(i,:), 'r', 'LineWidth', 1.5)
    xlabel('t [s]')
    ylabel(['\it\theta_' num2str(i)])
    title(['\it\theta_' num2str(i)])
    grid on

    subplot(3, 3, plot_idx + 3)
    plot(t, dQ(i,:), 'r', 'LineWidth', 1.5)
    xlabel('t [s]')
    ylabel(['d\it\theta_' num2str(i)])
    grid on

    subplot(3, 3, plot_idx + 6)
    plot(t, ddQ(i,:), 'r', 'LineWidth', 1.5)
    xlabel('t [s]')
    ylabel(['dd\it\theta_' num2str(i)])
    grid on
end

figure(fig_offset)
sgtitle([tytul_glowny ' - Ramie (1-3)'])
figure(fig_offset + 1)
sgtitle([tytul_glowny ' - Nadgarstek (4-6)'])
end
