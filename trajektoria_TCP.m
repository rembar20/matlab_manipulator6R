%do wrzucenia 4-3-4 do q_tau_tcp => POPRAWIĆ 4-3-4

ilosc_punktow = size(q_tau_tcp, 1);
punkty_TCP = zeros(ilosc_punktow, 3);

for i = 1:ilosc_punktow
    
    tablica_pozycji = q_tau_tcp(i, :);
    [A60, pozycja, orientacja] = zadanie_proste(tablica_pozycji, dh_params);
    punkty_TCP(i, :) = pozycja;
    
end

figure(num_okna_tcp); %wykres 3d
set(gcf,"Name", "Trajektora TCP - 3D","NumberTitle", "off")
%sgtitle("Trajektorie ramienia \it\theta_{1-3} - " + tytul_wykresu)

plot3(punkty_TCP(:,1), punkty_TCP(:,2), punkty_TCP(:,3), 'r-', 'LineWidth', 2);
grid on; axis equal;
xlabel('X [mm]'); ylabel('Y [mm]'); zlabel('Z [mm]');
title('Trajektoria TCP w Przestrzeni 3D');

figure(num_okna_tcp+1);
set(gcf,"Name", "Trajektoria TCP - 2D","NumberTitle", "off")
%sgtitle("Trajektorie ramienia \it\theta_{1-3} - " + tytul_wykresu)

subplot(1,3,1) %wykres 2d x-y
plot(punkty_TCP(:,1), punkty_TCP(:,2), 'r-', 'LineWidth', 2)
grid on; axis equal;
xlabel('X [mm]'); ylabel('Y [mm]');
title('Trajektoria TCP x-y');


subplot(1,3,2) %wykres 2d x-z
plot(punkty_TCP(:,1), punkty_TCP(:,3), 'r-', 'LineWidth', 2)
grid on; axis equal;
xlabel('X [mm]'); ylabel('Z [mm]');
title('Trajektoria TCP x-z');

subplot(1,3,3) %wykres 2d y-z
plot(punkty_TCP(:,2), punkty_TCP(:,3), 'r-', 'LineWidth', 2)
grid on; axis equal;
xlabel('Y [mm]'); ylabel('Z [mm]');
title('Trajektoria TCP y-z');

