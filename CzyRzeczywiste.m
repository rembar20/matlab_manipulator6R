%Funkcja sprawdza czy wynik zadania odwrotnego jest rzeczywisty

function wynik = CzyRzeczywiste(InvResult)

allReal = 0;
while(allReal == 0) % mało wydajne rozwiązanie na sprawdzanie czy wszystko jest rzeczywiste
    if(size(InvResult,2) ~= 0) %sprawdz czy tablica nie jest pusta
        for j = 1:size(InvResult,2) %j = 1 do ilosci kolumn tablicy wejsciowej
           if(~isreal(InvResult(:,j))) % jezeli AKTUALNA KOLUMNA MA JAKĄKOLWIEK WARTOŚĆ UROJONĄ
              InvResult(:,j) = [];         % usuń kolumne
              break; %wyjdź z pętli for (pętla while dalej jest aktywna)
           end 
           if(j == size(InvResult,2) && isreal(InvResult(:,j))) %jeżeli wszystko jest rzeczywiste (j= ilosc kolumn macierzy wejsciowej)
               allReal = 1; % ustaw warunek na wyjscie z petli for
           end 
       end %end for
    wynik = InvResult;
    else  %jak macierz wejsciowa  została zredukowana do macierzy 0x0
    msgbox("Zadne z rozwiązań zadania odwrotnego nie jest rzeczywiste!"); %wyswietl okienko, ze zadne z rozwiazan nie jest rzeczywiste
    wynik = NaN; %wynik jako nan (uzywane do podania uzytkownikowi informacji o tym, ze musi ponownie wprowadzic dane wejsciowe)
    break;
    end
end %end while
end %end fun