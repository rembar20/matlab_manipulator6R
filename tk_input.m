function tk = tk_input()
defVal = {''}; % zainicjalizuj wartosc podstawowa jako puste pole
poprawneDane = false; % Flaga bitowa uzywana w funkcji while
while(~poprawneDane) % petla while
    czas = inputdlg('tk', 'Dane czasu koncowego',[1 50], defVal); % otworz okno dialogowe
if(~isempty(czas))
    tk = str2num(czas{1}); %zmien string na wartosc numeryczna
    if(isempty(tk) || tk <= 0 || numel(tk) ~= 1) %sprawdz czy tk jest puste oraz czy jest mniejsze od 0 i nie zostala wpisana tylko jedna liczba, jezeli tak to:
    disp("Wprowadzone wartości są niepoprawne!") %wyswietl info w konsoli ze wartosci sa niepoprawne  
    defVal = czas; %Ustaw podstawowe wartosci jako te aktualnie wpisane
    else % jezeli zostaly wprowadzone poprawne wartosci
    disp("tk = " + num2str(tk));
    poprawneDane = 1;
    end
else
    disp("Anulowano wprowadzanie danych") %
    tk = NaN; %ustaw czas koncowy jako NaN (uzywane do anulowania wykonywania programu)
    break;
end
end

end