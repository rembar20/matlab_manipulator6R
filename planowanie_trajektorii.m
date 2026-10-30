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
        wielomian_3stopien
    elseif(user_input == 2)
        wielomian_5stopien
    elseif(user_input == 3)
        wielomian_7stopien
    elseif(user_input == 4)
        cztery_trzy_cztery(t0,tk,ThetasP_A(:,1)',ThetasP_B(:,1)',1, dh_params)
    elseif(user_input == 5)
        close all
        break
    end
end