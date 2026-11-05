function rys_wykresy(WektorCzasu, WektorQ, Wektor_dQ, Wektor_ddQ, i, num_okna, st_wielomianu )
[q_max, q_max_index] = max(WektorQ);
[dq_max, dq_max_index] = max(Wektor_dQ);
[ddq_max, ddq_max_index] = max(Wektor_ddQ);

[q_min, q_min_index] = min(WektorQ);
[dq_min, dq_min_index] = min(Wektor_dQ);
[ddq_min, ddq_min_index] = min(Wektor_ddQ);
 %Rysowanie wykresow
    if i <= 3
        figure(num_okna)
        plot_index = i;
    else
        figure(num_okna+1)
        plot_index = i - 3;
    end
    % --- Wykresy Przemieszczenia ---
    subplot(3,3,plot_index)
    plot(WektorCzasu, WektorQ, 'r')
    xlabel('\it\tau')
    nazwa = ['\it\theta_' num2str(i)];
    title(nazwa)
    ylabel(nazwa)
    grid on
    hold on
        %Punkt Max
        plot(WektorCzasu(q_max_index), WektorQ(q_max_index), 'mo', MarkerSize=6, MarkerFaceColor='m'); % stworz punkt 'po' m - magenta o - punkt, MarkerSize - wielkosc punktu , MarkerFaceColor = 'm' - kolor wypelnienia na  m (magenta)
        text(WektorCzasu(q_max_index), WektorQ(q_max_index), ['  q_{max} = ',num2str(q_max, '%.3f')], 'VerticalAlignment', 'bottom', 'FontSize', 8, 'Color', 'm', 'FontWeight', 'bold'); % uzycie '%.3f zaokrągla zmienną do 3 miejsc po przecinku (jak w c)
    %Punkt Min
        plot(WektorCzasu(q_min_index), WektorQ(q_min_index), 'mo', MarkerSize=6, MarkerFaceColor='m'); 
        text(WektorCzasu(q_min_index), WektorQ(q_min_index), ['  q_{min} = ',num2str(q_min, '%.3f')], 'VerticalAlignment', 'bottom', 'FontSize', 8, 'Color', 'm', 'FontWeight', 'bold');
    hold off
    
    % --- Wykresy Predkosci ---
    subplot(3,3,plot_index+3)
    plot(WektorCzasu, Wektor_dQ, 'r')
    xlabel('\it\tau')
    nazwa = ['d\it\theta_' num2str(i)];
    ylabel(nazwa)
    grid on
    hold on
    %Rysowanie punktow
        plot(WektorCzasu(dq_max_index), Wektor_dQ(dq_max_index), 'mo', MarkerSize=6, MarkerFaceColor='m'); % stworz punkt 'po' m - magenta o - punkt, MarkerSize - wielkosc punktu , MarkerFaceColor = 'm' - kolor wypelnienia na  m (magenta)
        text(WektorCzasu(dq_max_index), Wektor_dQ(dq_max_index), ['  dq_{max} = ',num2str(dq_max, '%.3f')], 'VerticalAlignment', 'bottom', 'FontSize', 8, 'Color', 'm', 'FontWeight', 'bold'); % uzycie '%.3f zaokrągla zmienną do 3 miejsc po przecinku (jak w c)
    %Punkt Min
        plot(WektorCzasu(dq_min_index), Wektor_dQ(dq_min_index), 'mo', MarkerSize=6, MarkerFaceColor='m'); 
        text(WektorCzasu(dq_min_index), Wektor_dQ(dq_min_index), ['  dq_{min} = ',num2str(dq_min, '%.3f')], 'VerticalAlignment', 'bottom', 'FontSize', 8, 'Color', 'm', 'FontWeight', 'bold');

    hold off

    % --- Wykresy przyspieszenia ---
    subplot(3,3,plot_index+6)
    plot(WektorCzasu, Wektor_ddQ, 'r')
    xlabel('\it\tau')
    nazwa = ['dd\it\theta_' num2str(i)];
    ylabel(nazwa)
    grid on
    hold on
        plot(WektorCzasu(ddq_max_index), Wektor_ddQ(ddq_max_index), 'mo', MarkerSize=6, MarkerFaceColor='m'); % stworz punkt 'po' m - magenta o - punkt, MarkerSize - wielkosc punktu , MarkerFaceColor = 'm' - kolor wypelnienia na  m (magenta)
        text(WektorCzasu(ddq_max_index), Wektor_ddQ(ddq_max_index), ['  ddq_{max} = ',num2str(ddq_max, '%.3f')], 'VerticalAlignment', 'bottom', 'FontSize', 8, 'Color', 'm', 'FontWeight', 'bold'); % uzycie '%.3f zaokrągla zmienną do 3 miejsc po przecinku (jak w c)
    %Punkt Min
        plot(WektorCzasu(ddq_min_index), Wektor_ddQ(ddq_min_index), 'mo', MarkerSize=6, MarkerFaceColor='m'); 
        text(WektorCzasu(ddq_min_index), Wektor_ddQ(ddq_min_index), ['  ddq_{min} = ',num2str(ddq_min, '%.3f')], 'VerticalAlignment', 'bottom', 'FontSize', 8, 'Color', 'm', 'FontWeight', 'bold');
    hold off


    switch st_wielomianu
        case 3
            tytul_okna_ramie = "W3Stp - Ramie";
            tytul_okna_nadgarstek = "W3Stp - Nadgarstek";
            tytul_wykresu = "Wielomian 3 stopnia";
        case 5
            tytul_okna_ramie = "W5Stp - Ramie";
            tytul_okna_nadgarstek = "W5Stp - Nadgarstek";
            tytul_wykresu = "Wielomian 5 stopnia";
        case 7
            tytul_okna_ramie = "W7Stp - Ramie";
            tytul_okna_nadgarstek = "W7Stp - Nadgarstek";
            tytul_wykresu = "Wielomian 7 stopnia";
        case 434
            tytul_okna_ramie = "W434 - Ramie";
            tytul_okna_nadgarstek = "W434 - Nadgarstek";
            tytul_wykresu = "Wielomiany 4-3-4";
    end

figure(num_okna)
set(gcf,"Name", tytul_okna_ramie,"NumberTitle", "off")
sgtitle("Trajektorie ramienia \it\theta_{1-3} - " + tytul_wykresu)

figure(num_okna+1)
set(gcf,"Name", tytul_okna_nadgarstek,"NumberTitle", "off")
sgtitle("Trajektorie nadgarstka \it\theta_{4-6} - " + tytul_wykresu)