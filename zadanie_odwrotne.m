%Skrypt przygotowany poprzez zmodyfikowanie skryptu powstałego w ramach przedmiotu Fundamentals of  Robotics w semestrze zimowym roku akademickiego 2025/2026
function InverseKinematics = zadanie_odwrotne(x,y,z,tool_fi,tool_vi,tool_ksi,dh_parameters)

%Deklaracje Funkcji wewnetrznych
function A=matrixA(theta,lambda,l,alpha)

A=[ cos(theta)   -sin(theta)*cos(alpha)    sin(theta)*sin(alpha)   l*cos(theta);
    sin(theta)    cos(theta)*cos(alpha)   -cos(theta)*sin(alpha)   l*sin(theta);
    0             sin(alpha)               cos(alpha)              lambda;
    0             0                        0                       1];
    
end

function A_RPY=matrixA_RPY(fi, vi, ksi, x, y, z)

A_RPY=[cos(fi)*cos(vi)   cos(fi)*sin(vi)*sin(ksi)-sin(fi)*cos(ksi)   cos(fi)*sin(vi)*cos(ksi)+sin(fi)*sin(ksi)   x;
       sin(fi)*cos(vi)   sin(fi)*sin(vi)*sin(ksi)+cos(fi)*cos(ksi)   sin(fi)*sin(vi)*cos(ksi)-cos(fi)*sin(ksi)   y;
      -sin(vi)           cos(vi)*sin(ksi)                            cos(vi)*cos(ksi)                            z;
       0                 0                                           0                                           1];
       
end

function A_ZYZ=matrixA_ZYZ(fi, vi, ksi, x, y, z)

A_ZYZ=[cos(fi)*cos(vi)*cos(ksi)-sin(fi)*sin(ksi)   -cos(fi)*cos(vi)*sin(ksi)-sin(fi)*cos(ksi)   cos(fi)*sin(vi)   x;
       sin(fi)*cos(vi)*cos(ksi)+cos(fi)*sin(ksi)   -sin(fi)*cos(vi)*sin(ksi)+cos(fi)*cos(ksi)   sin(fi)*sin(vi)   y;
      -sin(vi)*cos(ksi)                             sin(vi)*sin(ksi)                             cos(vi)          z;
       0                                            0                                            0                1];
       
end

function [fi1,vi1,ksi1,fi2,vi2,ksi2]=orientation_angles(A)

%The first solution
fi1=atan2(A(2,3),A(1,3)); %around Z axis
vi1=atan2(sqrt(A(1,3)*A(1,3)+A(2,3)*A(2,3)),A(3,3)); %around Y' axis
ksi1=atan2(A(3,2),-A(3,1)); %around z" axis

%The second solution for assumed combination of theta ( 4 possible)
fi2=atan2(-A(2,3),-A(1,3)); %around Z axis
vi2=atan2(-sqrt(A(1,3)*A(1,3)+A(2,3)*A(2,3)), A(3,3)) ; %around Y' axis
ksi2=atan2(-A(3,2),-A(3,1)); %around Z" axis

end


InverseResult = zeros(6,8); % Stworzenie macierzy wynikowej
% kolumny 1-2 Set 1, nadgarstek 1,2
% kolumny 3-4 Set 2, nadgarstek 1,2
% kolumny 5-6 Set 3, nadgarstek 1,2
% kolumny 7-8 Set 4, nadgarstek 1,2


A60=matrixA_RPY(tool_fi, tool_vi, tool_ksi, x, y, z); % Wyznacz macierz A60 obracajac wokół RPY
%Wyliczanie pozycji środka nadgarstka (CoW - Center of Wirst)
TCP_position=[x y z 1];
CoW_position=TCP_position - dh_parameters.lambda6*[A60(1,3) A60(2,3) A60(3,3) A60(4,3)] ;% vector of position of the wirst center
X_CoW=CoW_position(1); Y_CoW=CoW_position(2); Z_CoW=CoW_position(3);

%Obliczenia dla Theta 1
theta1_1=atan2(Y_CoW,X_CoW);
theta1_2=atan2(-Y_CoW,-X_CoW);

%Obliczenia dla Theta 3
OXY=sqrt(X_CoW*X_CoW + Y_CoW*Y_CoW);
r3=sqrt(dh_parameters.l3*dh_parameters.l3+dh_parameters.lambda3e*dh_parameters.lambda3e);
alpha=atan(dh_parameters.lambda3e/dh_parameters.l3);
c_alpha_theta3=((OXY-dh_parameters.l1)*(OXY-dh_parameters.l1)+(Z_CoW-dh_parameters.lambda1)*(Z_CoW-dh_parameters.lambda1)-dh_parameters.l2*dh_parameters.l2-r3*r3)/(2*dh_parameters.l2*r3);
s1_alpha_theta3=sqrt(1-c_alpha_theta3*c_alpha_theta3);
s2_alpha_theta3=-sqrt(1-c_alpha_theta3*c_alpha_theta3);
theta3_1=alpha-atan2(s1_alpha_theta3,c_alpha_theta3);
theta3_2=alpha-atan2(s2_alpha_theta3,c_alpha_theta3);

%Obliczenia dla Theta 2

%Dla Theta 3_1
k1=OXY-dh_parameters.l1;
k2=Z_CoW-dh_parameters.lambda1;
k3=r3*sin(alpha-theta3_1);
t1=(-2*k1+2*sqrt(k1*k1+k2*k2-k3*k3))/(2*(k2-k3));
t2=(-2*k1-2*sqrt(k1*k1+k2*k2-k3*k3))/(2*(k2-k3));
theta2_1=2*atan(t1) ;
theta2_2=2*atan(t2);

%Dla Theta 3_2
k3=r3*sin(alpha-theta3_2); %Tylko k3 się zmieniło;
t1=(-2*k1+2*sqrt(k1*k1+k2*k2-k3*k3))/(2*(k2-k3));
t2=(-2*k1-2*sqrt(k1*k1+k2*k2-k3*k3))/(2*(k2-k3));
theta2_3=2*atan(t1);
theta2_4=2*atan(t2);

%Wyznaczenie Setów kątów

Sets = [theta1_1, theta2_1,theta3_1;
        theta1_1, theta2_3,theta3_2;
        theta1_2, theta2_2,theta3_1;
        theta1_2, theta2_4,theta3_2];

for i = 1:4
column_even = 2*i; % 4 = 8
column_odd = 2*i-1; % 4 = 7, 3 = 5 etc
InverseResult(1:3,column_even) = Sets(i,:)';
InverseResult(1:3,column_odd) = Sets(i,:)';
end

%set1 (LLEFT UP): theta1_1, theta2_1, theta3_1
A1=matrixA(theta1_1, dh_parameters.lambda1, dh_parameters.l1, dh_parameters.alpha1);
A2=matrixA(theta2_1,dh_parameters.lambda2, dh_parameters.l2, dh_parameters.alpha2);
A3=matrixA(theta3_1,dh_parameters.lambda3, dh_parameters.l3, dh_parameters.alpha3);
A3e=matrixA(dh_parameters.theta3e,dh_parameters.lambda3e, dh_parameters.l3e, dh_parameters.alpha3e);
A30_1=A1*A2*A3*A3e;
A63_1=inv(A30_1)*A60;

[fi1, vi1, ksi1, fi2, vi2, ksi2]=orientation_angles(A63_1);
InverseResult(4,1) = fi1;
InverseResult(4,2)= fi2;
InverseResult(5,1)= vi1;
InverseResult(5,2) = vi2;
InverseResult(6,1) = ksi1;
InverseResult(6,2)= ksi2;


%set2 (LEFT DOWN): theta1_1, theta2_3, theta3_2
A1=matrixA(theta1_1, dh_parameters.lambda1, dh_parameters.l1, dh_parameters.alpha1);
A2=matrixA(theta2_3,dh_parameters.lambda2, dh_parameters.l2, dh_parameters.alpha2);
A3=matrixA(theta3_2,dh_parameters.lambda3, dh_parameters.l3, dh_parameters.alpha3);
A3e=matrixA(dh_parameters.theta3e,dh_parameters.lambda3e, dh_parameters.l3e, dh_parameters.alpha3e);
A30_2=A1*A2*A3*A3e;
A63_2=inv(A30_2)*A60;

[fi1, vi1, ksi1, fi2, vi2, ksi2]=orientation_angles(A63_2);
InverseResult(4,3) = fi1;
InverseResult(4,4)= fi2;
InverseResult(5,3)= vi1;
InverseResult(5,4) = vi2;
InverseResult(6,3) = ksi1;
InverseResult(6,4)= ksi2;


%set3 (RIGHT UP): theta1_2, theta2_2, theta3_1
A1=matrixA(theta1_2, dh_parameters.lambda1, dh_parameters.l1, dh_parameters.alpha1);
A2=matrixA(theta2_2,dh_parameters.lambda2, dh_parameters.l2, dh_parameters.alpha2);
A3=matrixA(theta3_1,dh_parameters.lambda3, dh_parameters.l3, dh_parameters.alpha3);
A3e=matrixA(dh_parameters.theta3e,dh_parameters.lambda3e, dh_parameters.l3e, dh_parameters.alpha3e);
A30_3=A1*A2*A3*A3e;
A63_3=inv(A30_3)*A60;

[fi1, vi1, ksi1, fi2, vi2, ksi2]=orientation_angles(A63_3);
InverseResult(4,5) = fi1;
InverseResult(4,6)= fi2;
InverseResult(5,5)= vi1;
InverseResult(5,6) = vi2;
InverseResult(6,5) = ksi1;
InverseResult(6,6)= ksi2;



%set4 (RIGHT DOWN): theta1_2, theta2_4, theta3_2
A1=matrixA(theta1_2, dh_parameters.lambda1, dh_parameters.l1, dh_parameters.alpha1);
A2=matrixA(theta2_4,dh_parameters.lambda2, dh_parameters.l2, dh_parameters.alpha2);
A3=matrixA(theta3_2,dh_parameters.lambda3, dh_parameters.l3, dh_parameters.alpha3);
A3e=matrixA(dh_parameters.theta3e,dh_parameters.lambda3e, dh_parameters.l3e, dh_parameters.alpha3e);
A30_4=A1*A2*A3*A3e;
A63_4=inv(A30_4)*A60;

[fi1, vi1, ksi1, fi2, vi2, ksi2]=orientation_angles(A63_4);
InverseResult(4,7) = fi1;
InverseResult(4,8)= fi2;
InverseResult(5,7)= vi1;
InverseResult(5,8) = vi2;
InverseResult(6,7) = ksi1;
InverseResult(6,8)= ksi2;


InverseKinematics = InverseResult;

end