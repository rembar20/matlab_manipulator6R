%do wrzucenia 4-3-4 do q_tau_tcp => POPRAWIĆ 4-3-4

ilosc_punktow = size(q_tau_tcp, 1);
punkty_TCP = zeros(ilosc_punktow, 3);

for i = 1:ilosc_punktow
    
    tablica_pozycji = q_tau_tcp(i, :);
    [A60, pozycja, orientacja] = zadanie_proste(tablica_pozycji, dh_params);
    punkty_TCP(i, :) = pozycja;
    
end

figure;
plot3(punkty_TCP(:,1), punkty_TCP(:,2), punkty_TCP(:,3), 'b-', 'LineWidth', 2);
grid on; axis equal;
xlabel('X [m]'); ylabel('Y [m]'); zlabel('Z [m]');
title('Trajektoria TCP w Przestrzeni 3D');



