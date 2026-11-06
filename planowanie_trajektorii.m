%planowania_trajektorii

%menu mo¿na utworzyæ korzystaj¹c z zadanie 9 (zestaw II)
%menu aktywne
%mo¿na wykorzystaæ, np. while, break, return
konfiguracja = 1; % ROBOCZO!!!
q_A =  ThetasP_A(:,konfiguracja)'; %przepisanie wybranego rozwiazania zadania odwrotnego kinematyki do zmiennej pomocniczej 
q_B = ThetasP_B(:,konfiguracja)';

while(1)
    user_input =  menu('Wybierz Opcje:', 'Wielomian 3 stopnia', 'Wielomian 5 stopnia', 'Wielomian 7 stopnia', '4 3 4', 'Wyjscie');
    if(user_input == 1)
        wielomian_3stopien % figure 1,2
    elseif(user_input == 2)
        wielomian_5stopien % figure 3,4
    elseif(user_input == 3)
        wielomian_7stopien % figure 5,6
    elseif(user_input == 4)
        cztery_trzy_cztery % figure 7,8
    elseif(user_input == 5)
        close all
        break
    end
end