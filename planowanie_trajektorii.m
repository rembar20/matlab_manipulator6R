%planowania_trajektorii

%menu mo¿na utworzyæ korzystaj¹c z zadanie 9 (zestaw II)
%menu aktywne
%mo¿na wykorzystaæ, np. while, break, return

while(1)
    user_input =  menu('Wybierz Opcje:', 'Wielomian 3 stopnia', 'Wielomian 5 stopnia', 'Wielomian 7 stopnia', '4 3 4', 'Wyjscie');
    if(user_input == 1)
        disp(user_input) %disp s¹ dla debugu, mozna usuanc potem
        wielomian_3stopien(t0,tk,ThetasP_A(:,1)',ThetasP_B(:,1)')
    elseif(user_input == 2)
        disp(user_input)
        wielomian_5stopien
    elseif(user_input == 3)
        disp(user_input)
        wielomian_7stopien
    elseif(user_input == 4)
        disp(user_input)
        cztery_trzy_cztery
    elseif(user_input == 5)
        close all
        break
    end
end