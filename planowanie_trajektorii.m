%planowania_trajektorii

%menu mo¿na utworzyæ korzystaj¹c z zadanie 9 (zestaw II)
%menu aktywne
%mo¿na wykorzystaæ, np. while, break, return

konfiguracja_A = optymP_A; %wybrana konfiguracje ustaw jako domyslna do wykonywania obliczen
konfiguracja_B = optymP_B;

q_A =  RealThetasP_A(:,konfiguracja_A)'; %przepisanie wybranego rozwiazania zadania odwrotnego kinematyki do zmiennej pomocniczej 
q_B = RealThetasP_B(:,konfiguracja_B)';

% zmienne potrzebne do poprawnego dzialania skryptu Trajektoria TCP bez
% uruchamiania wielomianu 7 stpnia
NazwyKonfiguracji_pR = "";
NazwyKonfiguracji_pW = "";
konfiguracja_R = 1;
konfiguracja_W = 1;
% kazda z tych zmiennych jest na nowo definiowana przy uzyciu skryptu w-nu 7 stopnia.

original_config = [konfiguracja_A,konfiguracja_B,konfiguracja_R,konfiguracja_W]; % zmienna potrzebna do powracania do domyslnej wartosci po zakonczeniu kreslenia toru TCP
while(1)
    user_input =  menu('Wybierz Opcje:', 'Wielomian 3 stopnia', 'Wielomian 5 stopnia', 'Wielomian 7 stopnia', '4 3 4', 'Wyjscie');
    if(user_input == 1) %w 3 stp
        num_okna = 1;
        wielomian_3stopien % figure 1,2
        
        rysuj_RW = false;
        ilosc_zadan_odwrotnych = 2; % 2 wszedize oprocz w7stp - tam = 4

        typ_wielomianu = 3; % typ wielomianu (pomocnicza dla wykresow TCP)
        num_okna_tcp = num_okna + 10; % ustaw okna, offset 10 zeby sie nie najechaly z niczym innym (dla kolejnych offset o 10 wiekszy)
        trajektoria_TCP %wywolaj rysowanie trajektorii TCP

    elseif(user_input == 2) %w 5 stp
        num_okna = 3;
        wielomian_5stopien % figure 3,4

        rysuj_RW = false;
        ilosc_zadan_odwrotnych = 2;

        typ_wielomianu = 5;
        num_okna_tcp = num_okna + 20;
        trajektoria_TCP

    elseif(user_input == 3) % w 7 stp
        num_okna = 5;
        q_R = []; %inicjalizacja pustych wektorów q_r i q_w  
        q_W = []; % potrzebne, zeby moc uruchamiac wielomian_7_stopein bez definiowania nowych punktow za kazdym razem
        wielomian_7stopien % figure 5,6
        
        rysuj_RW = true;

        ilosc_zadan_odwrotnych = 4;
        typ_wielomianu = 7;
        num_okna_tcp = num_okna + 30;
        trajektoria_TCP

    elseif(user_input == 4) % w 434
        num_okna = 7;
        cztery_trzy_cztery % figure 7,8
        
        rysuj_RW = true;

        ilosc_zadan_odwrotnych = 2;

        typ_wielomianu = 434;
        num_okna_tcp = num_okna + 40;
        trajektoria_TCP

    elseif(user_input == 5)
        close all
        break
    end
end