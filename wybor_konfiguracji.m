function [OptymalnaKonfiguracja_p1, OptymalnaKonfiguracja_p2, TablicaNazw_p1, TablicaNazw_p2, RealThetas_p1, RealThetas_p2] = wybor_konfiguracji(Thetas_1,Thetas_2)
%wybór konfiguracji

%min przemieszczeñ w parach kinematycznych
[RealThetas_p1, TablicaNazw_p1] = CzyRzeczywiste(Thetas_1);
[RealThetas_p2, TablicaNazw_p2] = CzyRzeczywiste(Thetas_2);

if(isempty(RealThetas_p2) || isempty(RealThetas_p1))
error("Wszystkie wyniki zadania odwrotnego dla jednego z zadanych punktow s¹ liczbami zespolonymi, przerwano dzialanie programu!")
end


TablicaPrzemieszczen = zeros(size(RealThetas_p1,2),size(RealThetas_p2,2));

for i  = 1:size(RealThetas_p1,2) % iteracja po wynikach
    for j = 1:size(RealThetas_p2,2)
        PrzemieszczeniePrzegubow  = RealThetas_p1(:,i)-RealThetas_p2(:,j); %policz przemieszczenie kazdego przegubu
        TablicaPrzemieszczen(i,j) = sum(abs(PrzemieszczeniePrzegubow)); %dodaj wartosci bezwzgledne przemieszczenia kazdego przegubu
    end
end

[MinKolumn, wekWierszy] = min(TablicaPrzemieszczen); %Zwraca wektor najmniejszych wartosci w kolumnach (MinKolumn) i wektor ich wierszy
[MinWartosc, idKolumny] =   min(MinKolumn); % Zwraca Minimalna wartosc z calej tablicy oraz indeks kolumny w ktorej ta wartosc sie znajduje
idWiersza = wekWierszy(idKolumny);
OptymalnaKonfiguracja_p1 = idWiersza;
OptymalnaKonfiguracja_p2 = idKolumny;
end