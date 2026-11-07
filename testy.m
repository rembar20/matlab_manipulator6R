[Realq_R,~] = CzyRzeczywiste(q_R);
[Realq_W,~] = CzyRzeczywiste(q_W);
TablicaPrzemieszczen = zeros(size(Realq_R,2),size(Realq_W,2));
        for i = 1:size(Realq_R,2)
            for j = 1:size(Realq_W,2)
            Przemieszczenie_AR = sum(abs(RealThetasP_A(:,konfiguracja_A) - Realq_R(:,i)));
            Przemieszczenie_RW = sum(abs(Realq_R(:,i) - Realq_W(:,j)));
            Przemieszczenie_WB = sum(abs(Realq_W(:,j) - RealThetasP_B(:,konfiguracja_B)));
            TablicaPrzemieszczen(i,j) = Przemieszczenie_AR + Przemieszczenie_RW + Przemieszczenie_WB;
            end
        end
        [MinKolumn, wekWierszy] = min(TablicaPrzemieszczen); %Zwraca wektor najmniejszych wartosci w kolumnach (MinKolumn) i wektor ich wierszy
        [MinWartosc, optymP_W] =   min(MinKolumn); % Zwraca Minimalna wartosc z calej tablicy oraz indeks kolumny w ktorej ta wartosc sie znajduje
        optymP_R = wekWierszy(optymP_W);