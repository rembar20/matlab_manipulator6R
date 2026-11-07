clear
close all
clc
disp('Projekt 1')
disp('Planowanie trajektorii manipulatora o strukturze szeregowej 6R')
disp('Wykonany przez studentów grupy 13A4 P02')
%disp('Bartosz Remin, Szymon Grela, Bartłomiej Sasin, Maciej Pitala')
disp('Wcisnij enter')
pause

daneplanowania % Wprowadzanie danych punktow z klawiatury lub uzycie wartosci domyslnych (Punkty sa sprawdzane pod kątem obecnosci w przestrzeni roboczej)

danemanipulatora % Przypisanie parametrow DH

ThetasP_A = zadanie_odwrotne(p_A(1),p_A(2),p_A(3),alpha_A,beta_A,gamma_A,dh_params); % Zadanie odwrotne dla Punktu A
ThetasP_B = zadanie_odwrotne(p_B(1),p_B(2),p_B(3),alpha_B,beta_B,gamma_B,dh_params); % Zadanie odwrotne dla Pujnktu B

%Wybor optymalnej konfiguracji, tej o najmniejszym przemieszczeniu przegubow 
[optymP_A, optymP_B, NazwyKonfiguracji_pA, NazwyKonfiguracji_pB, RealThetasP_A, RealThetasP_B] = wybor_konfiguracji(ThetasP_A,ThetasP_B);

%{ 
W funkcji wybor konfiguracji dodatkowo sprawdza sie czy wszystkie
rozwiazania sa rzeczywiste, jezeli ktores nie jest to usuwa sie je i zmniejsza ilosc dostepnych  rozwiazan
%}

disp("Wybrane rozwiązanie zadania odwrotnego (najmniejsze przemieszczenie) dla punktu A: Set"  + num2str(optymP_A) + " B: Set" + num2str(optymP_B) ) % informacja do konsoli
%spr_macierzy % Dane o orientacji sa zawarte w rozwiazaniu zadania odwrotnego, poniewaz jest to robot o ruchliwosci = 6, stad sprawdzanie macierzy nie jest potrzebne. 
planowanie_trajektorii
