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

clear poprawneDane czas defVal; % usun zmienne z workspace (zmienne czysto  pomocnicze)





function val = input_liczba(prompt_text)
    % Sprawdza czy wpisane dane są liczbą
    val = str2double(input(prompt_text, 's'));
    
    while isnan(val)
        disp('  [!] Błąd: Wprowadzona wartość nie jest liczbą. Spróbuj ponownie.');
        val = str2double(input(prompt_text, 's'));
    end
end

function matrixZYX = matrixZYX(alpha, beta, gamma) 
matrixZYX = [
    cos(alpha)*cos(beta),  cos(alpha)*sin(beta)*sin(gamma) - sin(alpha)*cos(gamma),  cos(alpha)*sin(beta)*cos(gamma) + sin(alpha)*sin(gamma);
    sin(alpha)*cos(beta),  sin(alpha)*sin(beta)*sin(gamma) + cos(alpha)*cos(gamma),  sin(alpha)*sin(beta)*cos(gamma) - cos(alpha)*sin(gamma);
   -sin(beta),          cos(beta)*sin(gamma),                             cos(beta)*cos(gamma)];
end
%% 
%dane planowania
%z klawiatury
%czas
t0= 0;
%położenie 
%wpisac z klawiatury odpowiednie wartosci
manual_input = input("Czy chcesz wpisac wlasne dane planowania? [Y/N]: ", 's');
manual_input = upper(manual_input);
if strcmp(manual_input, "Y")
    % Sekcja wpisywania danych
    disp("Dane Punktu A")
    p_A_x = input_liczba("Podaj wspolrzedna X punktu poczatkowego p_A_x = ");
    p_A_y = input_liczba("Podaj wspolrzedna Y punktu poczatkowego p_A_y = ");
    p_A_z = input_liczba("Podaj wspolrzedna Z punktu poczatkowego p_A_z = ");
    fprintf('\n') % nowa linia
    
    disp("Dane Punktu B")
    p_B_x = input_liczba("Podaj wspolrzedna X punktu koncowego p_B_x = ");
    p_B_y = input_liczba("Podaj wspolrzedna Y punktu koncowego p_B_y = ");
    p_B_z = input_liczba("Podaj wspolrzedna Z punktu koncowego p_B_z = ");   
    fprintf('\n') % nowa linia
    
    disp("Orientacja początkowa (A)")
    deg_A_alpha = input_liczba("Podaj kąt alpha orientacji początkowej (A) deg_A_alpha = ");
    deg_A_beta  = input_liczba("Podaj kąt beta orientacji początkowej (A) deg_A_beta = ");
    deg_A_gamma = input_liczba("Podaj kąt gamma orientacji początkowej (A) deg_A_gamma = ");
    fprintf('\n') % nowa linia
    
    disp("Orientacja końcowa (B)")
    deg_B_alpha = input_liczba("Podaj kąt alpha orientacji końcowej (B) deg_B_alpha = ");
    deg_B_beta  = input_liczba("Podaj kąt beta orientacji końcowej (B) deg_B_beta = ");
    deg_B_gamma = input_liczba("Podaj kąt gamma orientacji końcowej (B) deg_B_gamma = ");
    fprintf('\n') % nowa linia

    disp("Czas ruchu")
    tk = input_liczba("Podaj czas ruchu tk = ");

    %Sekcja podstawiania podstawowych danych
else
     if(~strcmp(manual_input,"N"))
     disp("[!] Odpowiedz rozna od Y lub N, przyjmuje podstawowe dane [!]")
     manual_input = "N";
     pause(1);
     end
    
    %WARTOSCI PODSTAWOWE
    %---------------------------------------------------------------
    p_A_x = 100; p_A_y = 200; p_A_z = 300;
    p_B_x = 200; p_B_y = 200; p_B_z = 200;
    deg_A_alpha = 0 ; deg_A_beta  = 0  ;deg_A_gamma = 0;
    deg_B_alpha = 15 ; deg_B_beta  = 45  ;deg_B_gamma = 60;
    tk = 1;
    %----------------------------------------------------------------   
end

p_A= [
    p_A_x; %x
    p_A_y; %y
    p_A_z]; %z
p_B= [
    p_B_x; %x
    p_B_y; %y
    p_B_z]; %z
%wpisac wartosci w stopniach, w zmiennych odpowiednich za alpha,beta, gamma
%wartosc bedzie w radianach!
A_DegArray  = [deg_A_alpha; %alpha
               deg_A_beta; %beta
               deg_A_gamma]; %gamma];

B_DegArray  = [deg_B_alpha; %alpha
               deg_B_beta; %beta
               deg_B_gamma]; %gamma];
alpha_A = deg2rad(A_DegArray(1)) ; beta_A = deg2rad(A_DegArray(2)); gamma_A = deg2rad(A_DegArray(3));
alpha_B = deg2rad(B_DegArray(1)) ; beta_B = deg2rad(B_DegArray(2)); gamma_B = deg2rad(B_DegArray(3));


orientation_matrix_A = matrixZYX(A_DegArray(1),A_DegArray(2),A_DegArray(3));
orientation_matrix_B = matrixZYX(B_DegArray(1),B_DegArray(2),B_DegArray(3));


% Wypisanie wartosci jezeli ustawiono wartosci domyslne
string_array = ["alpha","beta","gamma";
               "X","Y","Z"];
disp("Przyjete podstawowe dane:")
if(~strcmp(manual_input, "Y"))
    for i = 1:3
        disp("Wspolrzedna " + string_array(2,i) + " punktu poczatkowego p_A_" + lower(string_array(2,i)) + " = " + num2str(p_A(i)));
    end
     fprintf('\n') % nowa linia
    for i = 1:3
        disp("Wspolrzedna " + string_array(2,i) + " punktu koncowego p_B_" + lower(string_array(2,i)) + " = " + num2str(p_B(i)));
    end
     fprintf('\n') % nowa linia
    for i = 1:3
        disp("Kat " + string_array(1,i) + " orientacji poczatkowej p_A_" + lower(string_array(1,i)) + " = " + num2str(A_DegArray(i)));
    end
     fprintf('\n') % nowa linia
    for i = 1:3
        disp("Kat " + string_array(1,i) + " orientacji koncowej p_B_" + lower(string_array(1,i)) + " = " + num2str(B_DegArray(i)));
    end
     fprintf('\n') % nowa linia
    disp("Czas ruchu tk = " + num2str(tk));
    %pause(1); %pauza na 3 sekundy, zeby mozna bylo zobaczyc ze cos sie stalo w konsoli
end

%wyznaczenie macierzy orientacji w położeniu A i B
disp("Macierz orientacji A:")
disp(num2str(orientation_matrix_A))
disp("Macierz orientacji B:")
disp(num2str(orientation_matrix_B))

