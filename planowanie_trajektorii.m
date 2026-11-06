%planowania_trajektorii

%menu mo¿na utworzyæ korzystaj¹c z zadanie 9 (zestaw II)
%menu aktywne
%mo¿na wykorzystaæ, np. while, break, return
konfiguracja = 1;
q_A =  ThetasP_A(:,konfiguracja)'; %przepisanie wybranego rozwiazania zadania odwrotnego kinematyki do zmiennej pomocniczej 
q_B = ThetasP_B(:,konfiguracja)';

while(1)
    user_input =  menu('Wybierz Opcje:', 'Wielomian 3 stopnia', 'Wielomian 5 stopnia', 'Wielomian 7 stopnia', '4 3 4', 'Wyjscie');
    if(user_input == 1)
        num_okna = 1;
        wielomian_3stopien % figure 1,2

        q_tau_tcp = q_tau_w3
        nazwa_wielomianu = "wielomian 3 stopnia"
        num_okna_tcp = num_okna + 10;
        trajektoria_TCP

    elseif(user_input == 2)
        num_okna = 3;
        wielomian_5stopien % figure 3,4
        
        q_tau_tcp = q_tau_w5
        nazwa_wielomianu = "wielomian 5 stopnia"
        num_okna_tcp = num_okna + 10;
        trajektoria_TCP.m

    elseif(user_input == 3)
        num_okna = 5;
        wielomian_7stopien % figure 5,6

        q_tau_tcp = q_tau_w7
        nazwa_wielomianu = "wielomian 7 stopnia"
        num_okna_tcp = num_okna + 10;
        trajektoria_TCP.m

    elseif(user_input == 4)
        num_okna = 7;
        cztery_trzy_cztery % figure 7,8

        q_tau_tcp = q_tau_w434
        nazwa_wielomianu = "4-3-4"
        num_okna_tcp = num_okna + 10;
        trajektoria_TCP.m

    elseif(user_input == 5)
        close all
        break
    end
end