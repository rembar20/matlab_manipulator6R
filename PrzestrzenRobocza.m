function Inside = PrzestrzenRobocza(Punkt)

load('ChmuraPunktow.mat', 'chmuraXYZ') % zaladuj zmienna chmura punktow do workspace (wymiar: [10^6,3], (:,1) - x, (:,2) - y, (:,3) - z)
% ^ zmienna jest generowana w skrypcie  ChmuraPunktow.m, z powodu duzej ilosci iteracji (10^6)
% w skrypcie zmienna zostala zapisana do pliku, ktory jest wczytywany na poczatku kazdego wykonywania skryptu 

tolerancja = 15; % tolerancja odleglosci do najblizszego punktu to 15 mm

dx = chmuraXYZ(:,1) - Punkt(1); 
dy = chmuraXYZ(:,2) - Punkt(2);
dz = chmuraXYZ(:,3) - Punkt(3);
%Policz odleglosc pomiedzy kazdym punktem w chmurze a wspolrzednymi badanego punktu

odleglosc = sqrt(dx.^2+dy.^2 +dz.^2); % dlugosci wektora odleglosci od Punktu do kazdego elementu chmury

if(min(odleglosc)<=tolerancja)
    disp("Punkt jest w obszarze roboczym")
    Inside = true;
else
    disp("Punkt jest poza obszarem roboczym")
    Inside = false;
end
end