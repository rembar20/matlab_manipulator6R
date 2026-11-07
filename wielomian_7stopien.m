% --- TWORZENIE PUNKTOW POMOCNICZYCH ---

if(isempty(q_R) || isempty(q_W)) % tworz punkty tylko gdy uruchamiane z menu planowania trajektorii
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
end %jezeli nie anulowano danych to wykonuj program dalej
%wykonaj zadanie odwrotne
q_R = zadanie_odwrotne(pos_R(1),pos_R(2),pos_R(3),orient_R(1),orient_R(2),orient_R(3),dh_params);
q_W = zadanie_odwrotne(pos_W(1),pos_W(2),pos_W(3),orient_W(1),orient_W(2),orient_W(3),dh_params);
% sprawdz czy zadanie odwrotne nie ma wynikow zespolonych
[Realq_R, NazwyKonfiguracji_pR] = CzyRzeczywiste(q_R);
[Realq_W, NazwyKonfiguracji_pW] = CzyRzeczywiste(q_W);

if(isempty(Realq_W) || isempty(Realq_R)) % jak ma wszystkie wyniki zespolone zatrzymaj skrypt
error("Wszystkie wyniki zadania odwrotnego dla jednego z zadanych punktow są liczbami zespolonymi, przerwano dzialanie programu!")
end

TablicaPrzemieszczen = zeros(size(Realq_R,2),size(Realq_W,2)); % znajdz najbardziej optymalna konfiguracje (przejscie A-R-W-B)
        for i = 1:size(Realq_R,2) % i - punkt R
            for j = 1:size(Realq_W,2) % j - punkt W
            Przemieszczenie_AR = sum(abs(RealThetasP_A(:,konfiguracja_A) - Realq_R(:,i)));
            Przemieszczenie_RW = sum(abs(Realq_R(:,i) - Realq_W(:,j)));
            Przemieszczenie_WB = sum(abs(Realq_W(:,j) - RealThetasP_B(:,konfiguracja_B)));
            TablicaPrzemieszczen(i,j) = Przemieszczenie_AR + Przemieszczenie_RW + Przemieszczenie_WB; % i - rozwiazania punktu R, j - rozwiazania punktu W
            end
        end
        [MinKolumn, wekWierszy] = min(TablicaPrzemieszczen); %Zwraca wektor najmniejszych wartosci w kolumnach (MinKolumn) i wektor ich wierszy
        [MinWartosc, optymP_W] =   min(MinKolumn); % Zwraca Minimalna wartosc z calej tablicy oraz indeks kolumny w ktorej ta wartosc sie znajduje
        optymP_R = wekWierszy(optymP_W);
        konfiguracja_R = optymP_R;
        konfiguracja_W = optymP_W;
end
% --- INTERPOLACJA ---

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
    B = [q_A(i); q_B(i); 0; 0; 0; 0; Realq_R(i,konfiguracja_R); Realq_W(i,konfiguracja_W)];
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

    wzor_dq =  @(tau) (a1 + 2*a2*tau + 3*a3*tau.^2 + 4*a4*tau.^3 + 5*a5*tau.^4 + 6*a6*tau.^5 + 7*a7*tau.^6)/tk; %stworz wzor funkcji na dq
    wzor_ddq = @(tau) (2*a2 + 6*a3*tau + 12*a4*tau.^2 + 20*a5*tau.^3 + 30*a6*tau.^4 + 42*a7*tau.^5)/tk^2; %stworz wzor funkcji na ddq
    %@(argument) (funkcja(argument))- szkielet definicji funkcji w matlabie
    dq_tau = wzor_dq(tau); %uzyj wzoru funkcji wzor_dq i jako argument uzyj tablicy tau
    ddq_tau = wzor_ddq(tau); % uzyj wzoru funkmcji wozr_ddq i jako argument uzyj tablicy tau
    dq_r = wzor_dq(tr/tk); % podobnie jak wyzej tylko tym razem uzywa sie jako argument pojedynczej liczby (znormalizowane tr)
    dq_w = wzor_dq(tw/tk);
    ddq_r = wzor_ddq(tr/tk);
    ddq_w = wzor_ddq(tw/tk);
    %te zmienne są po to, zeby na wykresach moc zaznaczyc PUNKTY tr, tw i
    %jakie wartosci sa dla tr i tw
    q_tau_w7(:,i) = q_tau(:);

    % --- WYKRESY ---

    rys_wykresy(tau,q_tau,dq_tau,ddq_tau,i,5,7) %  WektorCzasu, WektorQ, Wektor_dQ, Wektor_ddQ, i, num_okna, st_wielomianu
    if i <= 3
        figure(5)
        plot_index = i;
    else
        figure(6)
        plot_index = i - 3;
    end
        
    % Punkty R i W na wykresach przemieszczenia

    subplot(3,3,plot_index)
    hold on
    plot(tr/tk, Realq_R(i,konfiguracja_R), 'go', MarkerSize=6, MarkerFaceColor='g'); % stworz punkt 'go' g -green o - punkt, MarkerSize - wielkosc punktu , MarkerFaceColor = 'g' - kolor wypelnienia na  g (green)
    plot(tw/tk, Realq_W(i,konfiguracja_W), 'bo', MarkerSize=6, MarkerFaceColor='b'); % b- blue i tak dalej
    % Dodanie opisów tekstowych nad/obok punktów
    text(tr/tk, Realq_R(i,konfiguracja_R), '  R', 'VerticalAlignment', 'bottom', 'FontSize', 9, 'Color', 'g', 'FontWeight', 'bold');
    text(tw/tk, Realq_W(i,konfiguracja_W), '  W', 'VerticalAlignment', 'bottom', 'FontSize', 9, 'Color', 'b', 'FontWeight', 'bold');
    hold off
        
    % Punkty R i W na wykresach predkosci

    subplot(3,3,plot_index+3)
    hold on
    plot(tr/tk, dq_r, 'go', MarkerSize=6, MarkerFaceColor='g');
    plot(tw/tk, dq_w, 'bo', MarkerSize=6, MarkerFaceColor='b');
    % Dodanie opisów tekstowych nad/obok punktów
    text(tr/tk, dq_r, '  R', 'VerticalAlignment', 'bottom', 'FontSize', 9, 'Color', 'g', 'FontWeight', 'bold');
    text(tw/tk, dq_w, '  W', 'VerticalAlignment', 'bottom', 'FontSize', 9, 'Color', 'b', 'FontWeight', 'bold');
    hold off
        
    % Punkty R i W na wykresach przyspieszenia

  
    subplot(3,3,plot_index+6)
    hold on
    plot(tr/tk, ddq_r, 'go', MarkerSize=6, MarkerFaceColor='g');
    plot(tw/tk, ddq_w, 'bo', MarkerSize=6, MarkerFaceColor='b');
    % Dodanie opisów tekstowych nad/obok punktów
    text(tr/tk, ddq_r, '  R', 'VerticalAlignment', 'bottom', 'FontSize', 9, 'Color', 'g', 'FontWeight', 'bold');
    text(tw/tk, ddq_w, '  W', 'VerticalAlignment', 'bottom', 'FontSize', 9, 'Color', 'b', 'FontWeight', 'bold');
    hold off


end


figure(5)
set(gcf,"Name", "W7Stp - Ramie","NumberTitle", "off")
sgtitle('Trajektorie ramienia (1-3) - Wielomian 7 stopnia')

figure(6)
set(gcf,"Name", "W7Stp - Nadgarstek","NumberTitle", "off")
sgtitle('Trajektorie nadgarstka (4-6) - Wielomian 7 stopnia')
