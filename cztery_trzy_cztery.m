function ftf = cztery_trzy_cztery(t0, tk, q_A, q_D,wybrana_konfiguracja, dh_params)
%RAMIE IDZIE Z PUNKTU A (Punkt A definiowany w danych planowania) do punktu
%D (punktu koncowego) przez 2 punkty pomocnicze (B i C)

%Definiowanie punktu B
[pozycja_pomocnicza_B, orientacja_pomocnicza_B, czas_przejsciowy_B] = DanePunktuPomocniczego(1);
AuxPoint_B = zadanie_odwrotne(pozycja_pomocnicza_B(1),pozycja_pomocnicza_B(2),pozycja_pomocnicza_B(3),orientacja_pomocnicza_B(1),orientacja_pomocnicza_B(2),orientacja_pomocnicza_B(3),dh_params);
aux_qB = AuxPoint_B(:,wybrana_konfiguracja);

%Definiowanie punktu C

[pozycja_pomocnicza_C, orientacja_pomocnicza_C, czas_przejsciowy_C] = DanePunktuPomocniczego(2);
AuxPoint_C = zadanie_odwrotne(pozycja_pomocnicza_C(1),pozycja_pomocnicza_C(2),pozycja_pomocnicza_C(3),orientacja_pomocnicza_C(1),orientacja_pomocnicza_C(2),orientacja_pomocnicza_C(3),dh_params);
aux_qC = AuxPoint_C(:,wybrana_konfiguracja);

%Definicja czasow przejsciowych

T_AdoB = czas_przejsciowy_B - t0;
T_BdoC = czas_przejsciowy_C - czas_przejsciowy_B;
T_CdoD = tk - czas_przejsciowy_C;

% Ilosc przegubow
n = length(q_A);

% Wektory czasu (znormalizowane [0,1])
dt = 0.01;
tau1 = 0:dt:1;
tau2 = 0:dt:1;
tau3 = 0:dt:1;


% Macierz A (14x14)
A = [
    1, 0, 0, 0, 0,                      0, 0, 0, 0,                      0, 0, 0, 0, 0;                                     % 1.  q1(0) = qA
    0, 1/T_AdoB, 0, 0, 0,               0, 0, 0, 0,                      0, 0, 0, 0, 0;                                     % 2.  dq1(0) = 0
    0, 0, 2/T_AdoB^2, 0, 0,             0, 0, 0, 0,                      0, 0, 0, 0, 0;                                     % 3.  ddq1(0) = 0
    1, 1, 1, 1, 1,                      0, 0, 0, 0,                      0, 0, 0, 0, 0;                                     % 4.  q1(1) = qB
    0, 0, 0, 0, 0,                      1, 0, 0, 0,                      0, 0, 0, 0, 0;                                     % 5.  q2(0) = qB
    0, 0, 0, 0, 0,                      1, 1, 1, 1,                      0, 0, 0, 0, 0;                                     % 6.  q2(1) = qC
    0, 0, 0, 0, 0,                      0, 0, 0, 0,                      1, 0, 0, 0, 0;                                     % 7.  q3(0) = qC
    0, 0, 0, 0, 0,                      0, 0, 0, 0,                      1, 1, 1, 1, 1;                                     % 8.  q3(1) = qD
    0, 0, 0, 0, 0,                      0, 0, 0, 0,                      0, 1/T_CdoD, 2/T_CdoD, 3/T_CdoD, 4/T_CdoD;         % 9.  dq3(1) = 0
    0, 0, 0, 0, 0,                      0, 0, 0, 0,                      0, 0, 2/T_CdoD^2, 6/T_CdoD^2, 12/T_CdoD^2;         % 10. ddq3(1) = 0
    0, 1/T_AdoB, 2/T_AdoB, 3/T_AdoB, 4/T_AdoB,      0, -1/T_BdoC, 0, 0,                  0, 0, 0, 0, 0;                     % 11. dq1(1) - dq2(0) = 0
    0, 0, 2/T_AdoB^2, 6/T_AdoB^2, 12/T_AdoB^2,      0, 0, -2/T_BdoC^2, 0,                0, 0, 0, 0, 0;                     % 12. ddq1(1) - ddq2(0) = 0
    0, 0, 0, 0, 0,                      0, 1/T_BdoC, 2/T_BdoC, 3/T_BdoC,             0, -1/T_CdoD, 0, 0, 0;                 % 13. dq2(1) - dq3(0) = 0
    0, 0, 0, 0, 0,                      0, 0, 2/T_BdoC^2, 6/T_BdoC^2,            0, 0, -2/T_CdoD^2, 0, 0;                   % 14. ddq2(1) - ddq3(0) = 0
];

end