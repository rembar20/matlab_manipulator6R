%funkcja to kalka z DanePunktuGlownego, uzywana do tworzenia punktow
%pomocniczych

function [aux_Posit, aux_Orient, aux_time] = DanePunktuPomocniczego(oznaczenie_punktu, t0, tk) %Funkcja otwiera okno w ktorym mozna wpisac dane punktu
ListaNazwDanych = {['Wspolrzedne punktu przejsciowego ' oznaczenie_punktu ' [mm]'], ['Orientacja punktu przejsciowego ' oznaczenie_punktu ' [deg]'], ['t' oznaczenie_punktu ' [s] Musi znajdowac sie w zakresie od ' num2str(t0) ' do ' num2str(tk)]}; %Tablica zawierajace dane wyswietlane nad polem dialogowmy
dimension = [1 50]; % Wielkosc okna 
defaultValues = {'Dane nalezy oddzielac przecinkiem! x,y,z','alpha,beta,gamma',''}; %wartosci podstawowe w polu dialogowym
poprawneDane = false; % Flaga bitowa uzywana w funkcji while
title = "Parametry punktu przejsciowego numer " + oznaczenie_punktu; % Tytul okna


while ~poprawneDane %Petla, ktora powoduje ze funkcja niez akonczy sie dopoki nie zostana wpisane poprawne dane

    aux_Posit = []; %inicjalizacje zmiennych
    aux_Orient = []; % w kazdej petli po to zeby po anulowaniu wpisywania wyniku w 2 probie nie przeslalo zlych danych
    aux_time = [];

    InputValues = inputdlg(ListaNazwDanych, title, dimension, defaultValues); % Otworz okno dialogowe i wpisz odpowiedzi w tablice InputValues
    if(~isempty(InputValues)) % Sprawdz czy COKOLWIEK zostalo wpisane w tablice (jest pusta tylko gdy kliknie sie cancel)

        
        aux_Posit = str2num(InputValues{1}); %Zamien string na wartosc numeryczna
        aux_Orient = deg2rad(str2num(InputValues{2})); % Zamien string na wartosc w stopniach
        aux_time = str2num(InputValues{3}); %Zamien string na wartosc numeryczna

        if(isempty(aux_Posit)   || isempty(aux_Orient) || isempty(aux_time) || numel(aux_Posit) ~= 3 || numel(aux_Orient) ~= 3  || numel(aux_time) ~= 1 || ((aux_time <= t0) || (aux_time >= tk)))
            %Sprawdz nastepujace warunki
            %Isempty() czy wpisano cokolwiek w dana zmienną
            % numel() ~= 3 sprawdz czy ilosc elementow wektora jest inna niż 3,
            % Sprawdz czy wpisany czas miesci sie w zakresie t0 do tk 
            % jeżeli tak to:
            
            msgbox("Wprowadzone wartosci sa niepoprawne!", 'Ostrzezenie', 'warn') %wyswietl info w konsoli ze wartosci sa niepoprawne  
            pause(0.5);
            defaultValues = InputValues; %Ustaw podstawowe wartosci jako te aktualnie wpisane
        elseif(~PrzestrzenRobocza(aux_Posit)) % sprawdz czy punkt jest w obszarze roboczym
            msgbox("Wprowadzony punkt jest poza obszarem roboczym!", 'Ostrzezenie', 'warn')
            pause(0.5);
            defaultValues = InputValues; %Ustaw podstawowe wartosci jako te aktualnie wpisane
        else %jezeli powyzsze warunki sa niespelnione (wartosci sa dobre)
        
            disp("Pozycja punktu pomoczniczego " + oznaczenie_punktu) %wyswietl w konsoli informacje na temat punktow
            disp(aux_Posit)
            disp("Orientacja punktu pomocniczego [rad] " + oznaczenie_punktu)
            disp(aux_Orient)
            disp("t" + oznaczenie_punktu)
            disp(aux_time)
            poprawneDane = true; %ustaw flage na 1, zeby petla while przestala dzialac
        end
    else
        disp("Anulowano wprowadzanie danych.") % info w konsoli ze anulowano wprowadzanie danych
        return % wyjdz z funkcji dajac pusta zmienna jako wyjscie
    end
 end
