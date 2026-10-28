function [aux_Posit, aux_Orient, aux_time] = DanePunktuPomocniczego(oznaczenie_punktu)
ListaNazwDanych = {['Wspolrzedne punktu przejsciowego ' oznaczenie_punktu ' [mm]'], ['Orientacja punktu przejsciowego ' oznaczenie_punktu ' [deg]'], 'Czas przejsciowy [s]'};
dimension = [1 50];
defaultValues = {'','',''};
poprawneDane = false;
title = "Parametry punktu przejsciowego numer " + oznaczenie_punktu
aux_Posit = [];
aux_Orient = [];
aux_time = [];

while ~poprawneDane
    InputValues = inputdlg(ListaNazwDanych, title, dimension, defaultValues);
    if(~isempty(InputValues))

        
        aux_Posit = str2num(InputValues{1});
        aux_Orient = str2num(InputValues{2});
        aux_time = str2num(InputValues{3});

        if(isempty(aux_Posit)   || isempty(aux_Orient) || isempty(aux_time) || numel(aux_Posit) ~= 3 || numel(aux_Orient) ~= 3  || numel(aux_time) ~= 1)
            disp("Wprowadzone wartości są niepoprawne!")
            defaultValues = InputValues;
        else
            disp("Pozycja punktu pomoczniczego")
            disp(aux_Posit)
            disp("Orientacja punktu pomocniczego")
            disp(aux_Orient)
            disp("Czas przejscia do punktu pomocniczego")
            disp(aux_time)
            poprawneDane = true;
        end
    else
        disp("Anulowano wprowadzanie danych.")
        return
    end
 end
