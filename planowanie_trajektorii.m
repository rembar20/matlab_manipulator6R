%planowania_trajektorii

%menu mo¿na utworzyæ korzystaj¹c z zadanie 9 (zestaw II)
%menu aktywne
%mo¿na wykorzystaæ, np. while, break, return

while(1)
    user_input =  menu('Wybierz Opcje:', 'Wielomian 3 stopnia', 'Wielomian 5 stopnia', 'Wielomian 7 stopnia', '4 3 4', 'Wyjscie');
    if(user_input == 1)
        wielomian_3stopien(t0,tk,ThetasP_A(:,1)',ThetasP_B(:,1)')
    elseif(user_input == 2)
        wielomian_5stopien(t0,tk,ThetasP_A(:,1)',ThetasP_B(:,1)')
    elseif(user_input == 3)
        wielomian_7stopien(t0,tk,ThetasP_A(:,1)',ThetasP_B(:,1)')
    elseif(user_input == 4)
        cztery_trzy_cztery(t0,tk,ThetasP_A(:,1)',ThetasP_B(:,1)',1, dh_params)
    elseif(user_input == 5)
        close all
        break
    end
end