
switch typ_wielomianu
        case 3
            tytul_okna = "W3";
            tytul_wykresu = "Wielomian 3 stopnia";
        case 5
            tytul_okna = "W5";
            tytul_wykresu = "Wielomian 5 stopnia";
        case 7
            tytul_okna = "W7";
            tytul_wykresu = "Wielomian 7 stopnia";
        case 434
            tytul_okna = "W434";
            tytul_wykresu = "Wielomiany 4-3-4";
    end

ilosc_punktow = size(q_tau_tcp, 1);
punkty_TCP = zeros(ilosc_punktow, 3);

for i = 1:ilosc_punktow
    
    tablica_pozycji = q_tau_tcp(i, :);
    [A60, pozycja, orientacja] = zadanie_proste(tablica_pozycji, dh_params);
    punkty_TCP(i, :) = pozycja;
    
end


while(1)
    user_input_trajektorie = menu("Wybierz trajektorie TCP do wyswietlenia","Trajektoria TCP - XYZ (3D)", "Trajektoria TCP - Rzuty X-Y, X-Z, Y-Z", "Trajektoria TCP - X(t), Y(t), Z(t) ", "Wybor konfiguracji", "Powrot do wyboru wielomianu");

    switch user_input_trajektorie
        case 1 % 3D

        figure(num_okna_tcp); %wykres 3d
        set(gcf,"Name", tytul_okna + "_Trajektora TCP - 3D","NumberTitle", "off")
        sgtitle("Trajektorie TCP - 3D -  " + tytul_wykresu + " - Konfiguracja A: Set  " + num2str(konfiguracja_A) + " B: Set  " + num2str(konfiguracja_B)  )
        plot3(punkty_TCP(:,1), punkty_TCP(:,2), punkty_TCP(:,3), 'r-', 'LineWidth', 2);
        grid on;
        xlabel('X [mm]'); ylabel('Y [mm]'); zlabel('Z [mm]');
        hold on
        plot3(p_A(1),p_A(2),p_A(3),'bo', MarkerSize=6, MarkerFaceColor='b');
        text(p_A(1),p_A(2),p_A(3),"  P_A", 'VerticalAlignment', 'bottom', 'FontSize', 8, 'Color', 'b', 'FontWeight', 'bold')

        plot3(p_B(1),p_B(2),p_B(3),'go', MarkerSize=6, MarkerFaceColor='g');
        text(p_B(1),p_B(2),p_B(3),"  P_B", 'VerticalAlignment', 'bottom', 'FontSize', 8, 'Color', 'g', 'FontWeight', 'bold')
        hold off

        case 2 % Rzuty X-Y, X-Z, Y-Z

        figure(num_okna_tcp+1);
        set(gcf,"Name", tytul_okna + "_Trajektora TCP - 2D","NumberTitle", "off")
        sgtitle(tytul_wykresu);
        subplot(1,3,1) %wykres 2d x-y
        plot(punkty_TCP(:,1), punkty_TCP(:,2), 'r-', 'LineWidth', 2)
        grid on; 
        xlabel('X [mm]'); ylabel('Y [mm]');
        title('Trajektoria TCP x-y');

        subplot(1,3,2) %wykres 2d x-z
        plot(punkty_TCP(:,1), punkty_TCP(:,3), 'r-', 'LineWidth', 2)
        grid on; 
        xlabel('X [mm]'); ylabel('Z [mm]');
        title('Trajektoria TCP x-z');

        subplot(1,3,3) %wykres 2d y-z
        plot(punkty_TCP(:,2), punkty_TCP(:,3), 'r-', 'LineWidth', 2)
        grid on; 
        xlabel('Y [mm]'); ylabel('Z [mm]');
        title('Trajektoria TCP y-z');

            

        case 3 % od czasu  

        figure(num_okna_tcp+2);
        set(gcf,"Name", tytul_okna + "_Trajektora TCP - q(t)","NumberTitle", "off")
        sgtitle(tytul_wykresu);
        subplot(1,3,1) %wykres 2d x(t)
        plot(t_tcp, punkty_TCP(:,1), 'r-', 'LineWidth', 2)
        grid on; 
        xlabel('t  [s]'); ylabel('Y [mm]');
        title('Trajektoria TCP x(t)');

        subplot(1,3,2) %wykres 2d y(t)
        plot(t_tcp, punkty_TCP(:,2),  'r-', 'LineWidth', 2)
        grid on; 
        xlabel('t [s]'); ylabel('Z [mm]');
        title('Trajektoria TCP y(t)');

        subplot(1,3,3) %wykres 2d z(t)
        plot(t_tcp,  punkty_TCP(:,3), 'r-', 'LineWidth', 2)
        grid on; 
        xlabel('t [s]'); ylabel('Z [mm]');
        title('Trajektoria TCP z(t)');

        case 5 % Powrot do wyboru wielomianu
        break;
    end
end


