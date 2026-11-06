%wybór konfiguracji

%min przemieszczeñ w parach kinematycznych
%zaczynaj¹æ od pary kinematycznej znajduj¹cej siê najbli¿ej podstawy 
% wyznaczenie min(theta1_B-theta1_A)
%wyznaczenie min(theta2_B-theta2_A)
%itd.

RealThetas_pA = CzyRzeczywiste(ThetasP_A);
RealThetas_pB = CzyRzeczywiste(ThetasP_B); 

if(isempty(RealThetas_pB) || isempty(RealThetas_pA))
error("Wszystkie wyniki zadania odwrotnego dla jednego z zadanych punktow s¹ liczbami zespolonymi, przerwano dzialanie programu!")
end


TablicaPrzemieszczen = zeros(size(RealThetas_pA,2),size(RealThetas_pB,2));

for i  = 1:size(RealThetas_pA,2) % iteracja po wynikach
    for j = 1:size(RealThetas_pB,2)
        PrzemieszczeniePrzegubow  = RealThetas_pA(:,i)-RealThetas_pB(:,j); %policz przemieszczenie kazdego przegubu
        TablicaPrzemieszczen(i,j) = sum(abs(PrzemieszczeniePrzegubow)); %dodaj wartosci bezwzgledne przemieszczenia kazdego przegubu
    end
end

[MinKolumn, wekWierszy] = min(TablicaPrzemieszczen); %Zwraca wektor najmniejszych wartosci w kolumnach (MinKolumn) i wektor ich wierszy
[MinWartosc, idKolumny] =   min(MinKolumn); % Zwraca Minimalna wartosc z calej tablicy oraz indeks kolumny w ktorej ta wartosc sie znajduje
idWiersza = wekWierszy(idKolumny);
OptymalnaKonfiguracja_pA = idWiersza;
OptymalnaKonfiguracja_pB = idKolumny;