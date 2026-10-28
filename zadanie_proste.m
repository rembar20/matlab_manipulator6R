function [A60, position, orientation_ZYX] = zadanie_proste(Thetas, dh_parameters)
% ZADANIE_PROSTE Oblicza pozycję i orientację TCP na podstawie kątów przegubowych
% Wersja ze spójną korektą parametrów DH i odczytem orientacji ZYX

    if nargin < 2
        dh_parameters = evalin('base', 'dh_params');
    end

    % 1. KOREKTA DH: lambda4 musi wynosić 0, ponieważ przesunięcie 410 mm
    % jest już realizowane przez macierz A3e (lambda3e)
    dh_parameters.lambda4 = 0; %

    t1 = Thetas(1);
    t2 = Thetas(2);
    t3 = Thetas(3);
    t4 = Thetas(4);
    t5 = Thetas(5);
    t6 = Thetas(6);

    % Macierz transformacji DH
    function A = matrixA(theta, lambda, l, alpha)
        A = [ cos(theta),  -sin(theta)*cos(alpha),   sin(theta)*sin(alpha),  l*cos(theta);
              sin(theta),   cos(theta)*cos(alpha),  -cos(theta)*sin(alpha),  l*sin(theta);
              0,            sin(alpha),              cos(alpha),             lambda;
              0,            0,                       0,                      1];
    end

    % Transformacje ogniw
    A1  = matrixA(t1, dh_parameters.lambda1, dh_parameters.l1, dh_parameters.alpha1);
    A2  = matrixA(t2, dh_parameters.lambda2, dh_parameters.l2, dh_parameters.alpha2);
    A3  = matrixA(t3, dh_parameters.lambda3, dh_parameters.l3, dh_parameters.alpha3);
    
    % Przesunięcie dodatkowe w przegubie 3 (ramię offsetowe)
    A3e = matrixA(dh_parameters.theta3e, dh_parameters.lambda3e, dh_parameters.l3e, dh_parameters.alpha3e);
    
    A4  = matrixA(t4, dh_parameters.lambda4, dh_parameters.l4, dh_parameters.alpha4);
    A5  = matrixA(t5, dh_parameters.lambda5, dh_parameters.l5, dh_parameters.alpha5);
    A6  = matrixA(t6, dh_parameters.lambda6, dh_parameters.l6, dh_parameters.alpha6);

    % Główna macierz transformacji
    A60 = A1 * A2 * A3 * A3e * A4 * A5 * A6; %[cite: 2]

    % Wyznaczenie pozycji TCP [X; Y; Z]
    position = A60(1:3, 4); %[cite: 2]

    % Odczyt orientacji ZYX (spójny ze skryptem zadania odwrotnego)
    tool_fi  = atan2(A60(2,3), A60(1,3)); %
    tool_vi  = atan2(sqrt(A60(1,3)^2 + A60(2,3)^2), A60(3,3)); %
    tool_ksi = atan2(A60(3,2), -A60(3,1)); %[cite: 1]
    
    orientation_ZYX = [rad2deg(tool_fi); rad2deg(tool_vi); rad2deg(tool_ksi)];
end