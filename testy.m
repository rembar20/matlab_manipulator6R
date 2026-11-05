defVal = "";
tk = str2num(inputdlg('tk', 'Dane czasu koncowego',[1 50], defVal));
poprawneDane = false; % Flaga bitowa uzywana w funkcji while
while(~poprawneDane)
if(~isempty(tk))
    if(tk <= 0 || numel(tk) ~= 1) %sprawdz czy tk jest mniejsze od 0 i nie zostala wpisana tylko jedna liczba, jezeli tak to:
    disp("Wprowadzone wartości są niepoprawne!") %wyswietl info w konsoli ze wartosci sa niepoprawne  
            defVal = InputValues; %Ustaw podstawowe wartosci jako te aktualnie wpisane
    else % jezeli zostaly wprowadzone poprawne wartosci
    disp("tk")
    end
else
    disp("Anulowano wprowadzanie danych")
    tk = NaN;
end
    while ~poprawneDane %Petla, ktora powoduje ze funkcja niez akonczy sie dopoki nie zostana wpisane poprawne dane
    InputValues = inputdlg(ListaNazwDanych, title, dimension, defaultValues);  % Otworz okno dialogowe i wpisz odpowiedzi w tablice InputValues
 
    if(~isempty(InputValues)) % Sprawdz czy COKOLWIEK zostalo wpisane w tablice (jest pusta tylko gdy kliknie sie cancel)
        
        aux_Posit = str2num(InputValues{1}); %Zamien string na wartosc numeryczna
        aux_Orient = deg2rad(str2num(InputValues{2})); % Zamien string na wartosc w stopniach

        if(isempty(aux_Posit)   || isempty(aux_Orient) || numel(aux_Posit) ~= 3 || numel(aux_Orient) ~= 3) %Sprawdz nastepujace warunki
            %Isempty() czy wpisano cokolwiek w dana zmienną
            % numel() ~= 3 sprawdz czy ilosc elementow wektora jest inna
            % niż 3, jeżeli tak to:
            disp("Wprowadzone wartości są niepoprawne!") %wyswietl info w konsoli ze wartosci sa niepoprawne  
            defaultValues = InputValues; %Ustaw podstawowe wartosci jako te aktualnie wpisane
        else %jezeli powyzsze warunki sa niespelnione (wartosci sa dobre)
        
            disp("Pozycja punktu pomoczniczego " + oznaczenie_punktu) %wyswietl w konsoli informacje na temat punktow
            disp(aux_Posit)
            disp("Orientacja punktu pomocniczego [rad] " + oznaczenie_punktu)
            disp(aux_Orient)
            poprawneDane = true; %ustaw flage na 1, zeby petla while przestala dzialac
        end
    else
        disp("Anulowano wprowadzanie danych.") % info w konsoli ze anulowano wprowadzanie danych
        return % wyjdz z funkcji dajac pusta zmienna jako wyjscie
    end
 end
