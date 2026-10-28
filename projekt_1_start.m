%to do:
% zrobic punkty - wybor macierzy, spr_macierzy, planowanie_trajektorii ale
% to po zajeciach/wykladzie

% uzyc pliku z zajec zeby zrobic planowanie trajektorii

clear
close all
clc
disp('Projekt 1')
disp('Planowanie trajektorii manipulatora o strukturze szeregowej 6R')
disp('Wykonany przez studentów grupy 13A4 P02')
disp('Bartosz Remin, Szymon Grela, Bartłomiej Sasin, Maciej Pitala')
disp('Wcisnij enter')
pause
daneplanowania
danemanipulatora
%Zadanie odwrotne zostało zaimplementowane za pomoca zmodyfikowanej funkcji utworzonej w ramach zajec Fundamentals of Robotics w roku akadmickim 2025/2026, 
% jako wynik daje tablice 6x8 gdzie wiersz 1 odpowiada theta1, 2 theta 2 itd,
%kolumny sa podzielone w ten sposob, że Kolumna 1,2 odpowiada temu samemu rozwiązaniu dla thet 1:3 ale różnym rozwiązaniom thet 4:6
% wycinek komentarza z kodu:
% kolumny 1-2 Set 1, nadgarstek 1,2
% kolumny 3-4 Set 2, nadgarstek 1,2
% kolumny 5-6 Set 3, nadgarstek 1,2
% kolumny 7-8 Set 4, nadgarstek 1,2
%wszystkie wartosci kątów są w RADIANACH!!!!
ThetasP_A = zadanie_odwrotne(p_A(1),p_A(2),p_A(3),alpha_A,beta_A,gamma_A,dh_params);
ThetasP_B = zadanie_odwrotne(p_B(1),p_B(2),p_B(3),alpha_B,beta_B,gamma_B,dh_params);

wybor_konfiguracji
spr_macierzy
planowanie_trajektorii
