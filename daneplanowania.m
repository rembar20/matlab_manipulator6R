
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
defA = [100,200,300,0,0,0]; %x,y,z, alpha,beta,gamma
defB = [200,250,230,15,45,60]; %uzywane by zadeklarowac stale na gorze programu i nie musiec ich zmieniac w akzdym jego punkcie
def_tk = 1;
%po³o¿enie 
%wpisac z klawiatury odpowiednie wartosci
% ------------------ WPISYWANIE DANYCH Z KLAWIATURY ------------------------
    odp = questdlg('Czy chcesz uzyc podstawowych wartosci punktów A i B oraz tk?', ... %otworz okno dialogowe z zapytaniem o wartosci podstawowe
        'Zapytanie', ...
        "Tak","Nie", ... %2 odpowiedzi
        'Tak'); % Podstawowa wartosc (zaznaczona przy otwarciu okna
%--- WPISYWANIE WLASNYCH DANYCH ---
    if(odp == "Nie") %jezeli wybrano manualne wpisywanie wartosci
        [pozycja, orientacja] = DanePunktuGlownego('A'); %wywolaj funkcje dla punktu A
        if(~isempty(pozycja) && ~isempty(orientacja)) %jezeli dane nie sa puste (nie zamknieto okna) to przypisz odebrane dane odpowiednim wartosciom
        p_A_x = pozycja(1);
        p_A_y = pozycja(2);
        p_A_z = pozycja(3);
        deg_A_alpha = orientacja(1);
        deg_A_beta = orientacja(2);
        deg_A_gamma = orientacja(3);
        else
        msgbox("Anulowano wprowadzanie wartosci, przyjmuje wartosci podstawowe punktu A") %jezeli zamknieto okno/wcisnieto przycisk anuluj to uzyj podstawowych wartosci

            p_A_x = defA(1); p_A_y = defA(2); p_A_z = defA(3);
            deg_A_alpha = defA(4) ; deg_A_beta  = defA(5)  ;deg_A_gamma = defA(6);
        end

        [pozycja, orientacja] = DanePunktuGlownego('B'); %jak wyzej, jak nie puste to przypisz w innym rpzypadku podstawowe wartosci
        if(~isempty(pozycja) && ~isempty(orientacja))
        p_B_x = pozycja(1);
        p_B_y = pozycja(2);
        p_B_z = pozycja(3);
        deg_B_alpha = orientacja(1);
        deg_B_beta = orientacja(2);
        deg_B_gamma = orientacja(3);
        else
        msgbox("Anulowano wprowadzanie wartosci, przyjmuje wartosci podstawowe punktu B")

            p_B_x = defB(1); p_B_y = defB(2); p_B_z = defB(3);
            deg_B_alpha = defB(4) ; deg_B_beta  = defB(5)  ;deg_B_gamma = defB(6);
        end
        
        tk = tk_input; %jako ze tk_input zwraca tylko jedna liczbe najpierw przypisz do finalnej zmiennej
        if(isnan(tk)) %potem sprawdz czy ta zmienna nie jest pusta
            tk = def_tk; %jak jest pusta to przypisz default wartosc
            msgbox("Anulowano wprowadzanie wartosci, przyjmuje wartosci podstawowe czasu tk")
        end 
    % --- UZYWANIE WARTOSCI PODSTAWOWYCH ---

    else %jezeli wybrano wartosci podstawowe/zamknieto okno
        if(odp ~= "Tak") %jezeli zamknieto okno
        msgbox("Zamknieto okno, uzywanie wartosci podstawowych")
        end
    %ustaw wartosci podstawowe:
    %WARTOSCI PODSTAWOWE DEKLARACJA NA GORZE PLIKU
    %---------------------------------------------------------------
    p_A_x = defA(1); p_A_y = defA(2); p_A_z = defA(3);
    p_B_x = defB(1); p_B_y = defB(2); p_B_z = defB(3);
    deg_A_alpha = defA(4) ; deg_A_beta  = defA(5)  ;deg_A_gamma = defA(6);
    deg_B_alpha = defB(4) ; deg_B_beta  = defB(5)  ;deg_B_gamma = defB(6);
    tk = def_tk;
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


orientation_matrix_A = matrixZYX(alpha_A,beta_A,gamma_A);
orientation_matrix_B = matrixZYX(alpha_B,beta_B,gamma_B);


% Wypisanie wartosci 
string_array = ["alpha","beta","gamma";
               "X","Y","Z"];
disp("Przyjete dane:")
    for i = 1:3
        disp("Wspolrzedna " + string_array(2,i) + " punktu poczatkowego p_A_" + lower(string_array(2,i)) + " = " + num2str(p_A(i)) + " [mm]");
    end
     fprintf('\n') % nowa linia
    for i = 1:3
        disp("Wspolrzedna " + string_array(2,i) + " punktu koncowego p_B_" + lower(string_array(2,i)) + " = " + num2str(p_B(i)) + " [mm]");
    end
     fprintf('\n') % nowa linia
    for i = 1:3
        disp("Kat " + string_array(1,i) + " orientacji poczatkowej p_A_" + lower(string_array(1,i)) + " = " + num2str(A_DegArray(i)) + " [deg]");
    end
     fprintf('\n') % nowa linia
    for i = 1:3
        disp("Kat " + string_array(1,i) + " orientacji koncowej p_B_" + lower(string_array(1,i)) + " = " + num2str(B_DegArray(i)) + " [deg]");
    end
     fprintf('\n') % nowa linia
    disp("Czas ruchu tk = " + num2str(tk));
    %pause(1); %pauza na 3 sekundy, zeby mozna bylo zobaczyc ze cos sie stalo w konsoli

%wyznaczenie macierzy orientacji w po³o¿eniu A i B
disp("Macierz orientacji A:")
disp(num2str(orientation_matrix_A))
disp("Macierz orientacji B:")
disp(num2str(orientation_matrix_B))
%czyszczenie zmiennych pomocniczych z tej funkcji (kazda jest albo zawarta
%w innej zmiennej lub nie jest juz potrzebna
%zmienne sa czyszczone w dwoch celach:
% ograniczenia zuzycia pamieci RAM oraz zwiekszenia czytelnosci workspace  
% i jako zmienna do petli for zostaje, zeby nie zuzywac zasobow (i czasu) na ponowna
% inicjalizacje zmiennej
clear p_A_x p_A_y p_A_z p_B_x p_B_y p_B_z deg_A_alpha deg_B_alpha deg_A_beta deg_B_beta deg_A_gamma deg_B_gamma pozycja orientacja odp string_array defA defB def_tk
