%% 
danemanipulatora
    function A = matrixA(theta, lambda, l, alpha)
        A = [ cos(theta),  -sin(theta)*cos(alpha),   sin(theta)*sin(alpha),  l*cos(theta);
              sin(theta),   cos(theta)*cos(alpha),  -cos(theta)*sin(alpha),  l*sin(theta);
              0,            sin(alpha),              cos(alpha),             lambda;
              0,            0,                       0,                      1];
    end
    A3e = matrixA(dh_params.theta3e, dh_params.lambda3e, dh_params.l3e, dh_params.alpha3e); %wyrzucona wczesniej i wpisana jako argument, poniewaz ta macierz jest stala
function position = zad_proste_pozycja(Thetas, dh_parameters, A3e) % kalka funkcji z zadania prostego, usuniecie wyliczania orientacji dla szybszego liczenia
    t1 = Thetas(1);
    t2 = Thetas(2);
    t3 = Thetas(3);
    t4 = Thetas(4);
    t5 = Thetas(5);
    t6 = Thetas(6);

    A1  = matrixA(t1, dh_parameters.lambda1, dh_parameters.l1, dh_parameters.alpha1);
    A2  = matrixA(t2, dh_parameters.lambda2, dh_parameters.l2, dh_parameters.alpha2);
    A3  = matrixA(t3, dh_parameters.lambda3, dh_parameters.l3, dh_parameters.alpha3);

    
    A4  = matrixA(t4, 0, dh_parameters.l4, dh_parameters.alpha4);
    A5  = matrixA(t5, dh_parameters.lambda5, dh_parameters.l5, dh_parameters.alpha5);
    A6  = matrixA(t6, dh_parameters.lambda6, dh_parameters.l6, dh_parameters.alpha6);

    % Macierz transformacji końcówki (TCP)
    A60 = A1 * A2 * A3 * A3e * A4 * A5 * A6; 

    % Wyznaczenie pozycji TCP [X; Y; Z]
    position = A60(1:3, 4); 
end



% Ilosc punktow do wygenerowania
N = 1000000;
ruchliwosc_robota = 6;
% Limity katowe 6 osi w stopniach (zrodlo Karta Katalogowa RS-005L)
limits = [
    -180, 180;  % Os 1
    -80,  135;  % Os 2
    -172, 118;  % Os 3
    -360, 360;  % Os 4
    -145, 145;  % Os 5
    -360, 360   % Os 6
];
limits = deg2rad(limits); %zamiana calej tablicy na radiany

%Utworzenie pustej macierzy pozycji (Nx3) (3 bo x,y,z)
chmuraXYZ = zeros(N,3);

%Utworzenie pustej macierzy losowych pozycji
q_random = zeros(ruchliwosc_robota,N);
for i = 1:6
    q_random(i,:) = limits(i,1) + (limits(i,2) -limits(i,1))*rand(N, 1); %wzor na losowa wartosc z przedzialu (random = A+(B-A)*losowa_liczba)
end

%Zadanie proste utworzone z kazdego z punktow
for i = 1:N
    chmuraXYZ(i, :) = zad_proste_pozycja(q_random(:, i), dh_params, A3e).';
end
%Przygotowanie danych do eksportu
chmuraXYZ = round(chmuraXYZ,2); %zaokraglenie do 2 miejsc po przecinku (setne czesci mm)
save('ChmuraPunktow.mat', 'chmuraXYZ'); % Zapisz zmienna do pliku mat.