% 6.2.2.c : Démodulation les fichiers contenant les images afin de reconstituer l'image entière
% Constantes
F0 = 1180 ;
F1 = 980 ;
fe = 48*10^(3);
Te = 1/fe;
fs = 300;
ns = fe / fs;
Ts = ns*Te;

%% Fichier 1

load('fichier1.mat');
x=signal;
t = (0 : length(x)-1)*Te;

theta0 = rand*2*pi; % phase aléatoire
theta1 = rand*2*pi; % phase aléatoire
cos0 = cos(2*pi*F0*t + theta0);   % génération du premier cosinus avec une phase aléatoire
sin0 = sin(2*pi*F0*t + theta0);   % génération du premier sinus avec la même phase aléatoire
cos1 = cos(2*pi*F1*t + theta1);   % génération du second cosinus avec une phase aléatoire
sin1 = sin(2*pi*F1*t + theta1);   % génération du second sinus avec la même phase aléatoire

xcos0 = x.*cos0;   % génération du produit de x (phases phi0 et phi1) par le premier cosinus (phase theta0) 
xsin0 = x.*sin0;   % génération du produit de x (phases phi0 et phi1) par le premier sinus (phase theta0)
xcos1 = x.*cos1;   % génération du produit de x (phases phi0 et phi1) par le second cosinus (phase theta1)
xsin1 = x.*sin1;   % génération du produit de x (phases phi0 et phi1) par le second sinus (phase theta1)

% Calcul des intégrales de x01, x02, x11 et x12 entre (n-1)*Ts et n*Ts pour
% n de 1 à length(x)/ns par la méthode des rectangles, et mise au carré des intégrales
for n=1:length(x)/ns
    integrale_xcos0(n)= sum(xcos0((n-1)*ns+1:n*ns)*Te)^2;   % integrale_xcos0(n) = integrale de x01 entre (n-1)*Ts et n*Ts
    integrale_xsin0(n)= sum(xsin0((n-1)*ns+1:n*ns)*Te)^2;   % integrale_xsin0(n) = integrale de x02 entre (n-1)*Ts et n*Ts
    integrale_xcos1(n)= sum(xcos1((n-1)*ns+1:n*ns)*Te)^2;   % integrale_xcos1(n) = integrale de x11 entre (n-1)*Ts et n*Ts
    integrale_xsin1(n)= sum(xsin1((n-1)*ns+1:n*ns)*Te)^2;   % integrale_xsin1(n) = integrale de x12 entre (n-1)*Ts et n*Ts
end

delta_integrales = (integrale_xcos1 + integrale_xsin1) - (integrale_xcos0 + integrale_xsin0);     % différence des deux sommes d'intégrales 

NRZ_estime = delta_integrales > 0; % NRZ_estime(n) = 0 ssi delta_integrales(n) plus proche de H0 que de H1; 1 sinon

z1 = NRZ_estime;


%% Fichier 2

load('fichier2.mat');
x=signal;
t = (0 : length(x)-1)*Te;

theta0 = rand*2*pi; % phase aléatoire
theta1 = rand*2*pi; % phase aléatoire
cos0 = cos(2*pi*F0*t + theta0);   % génération du premier cosinus avec une phase aléatoire
sin0 = sin(2*pi*F0*t + theta0);   % génération du premier sinus avec la même phase aléatoire
cos1 = cos(2*pi*F1*t + theta1);   % génération du second cosinus avec une phase aléatoire
sin1 = sin(2*pi*F1*t + theta1);   % génération du second sinus avec la même phase aléatoire

xcos0 = x.*cos0;   % génération du produit de x (phases phi0 et phi1) par le premier cosinus (phase theta0) 
xsin0 = x.*sin0;   % génération du produit de x (phases phi0 et phi1) par le premier sinus (phase theta0)
xcos1 = x.*cos1;   % génération du produit de x (phases phi0 et phi1) par le second cosinus (phase theta1)
xsin1 = x.*sin1;   % génération du produit de x (phases phi0 et phi1) par le second sinus (phase theta1)

% Calcul des intégrales de x01, x02, x11 et x12 entre (n-1)*Ts et n*Ts pour
% n de 1 à length(x)/ns par la méthode des rectangles, et mise au carré des intégrales
for n=1:length(x)/ns
    integrale_xcos0(n)= sum(xcos0((n-1)*ns+1:n*ns)*Te)^2;   % integrale_xcos0(n) = integrale de x01 entre (n-1)*Ts et n*Ts
    integrale_xsin0(n)= sum(xsin0((n-1)*ns+1:n*ns)*Te)^2;   % integrale_xsin0(n) = integrale de x02 entre (n-1)*Ts et n*Ts
    integrale_xcos1(n)= sum(xcos1((n-1)*ns+1:n*ns)*Te)^2;   % integrale_xcos1(n) = integrale de x11 entre (n-1)*Ts et n*Ts
    integrale_xsin1(n)= sum(xsin1((n-1)*ns+1:n*ns)*Te)^2;   % integrale_xsin1(n) = integrale de x12 entre (n-1)*Ts et n*Ts
end

delta_integrales = (integrale_xcos1 + integrale_xsin1) - (integrale_xcos0 + integrale_xsin0);     % différence des deux sommes d'intégrales 

NRZ_estime = delta_integrales > 0; % NRZ_estime(n) = 0 ssi delta_integrales(n) plus proche de H0 que de H1; 1 sinon

z2 = NRZ_estime;

%% Fichier 3

load('fichier3.mat');
x=signal;
t = (0 : length(x)-1)*Te;

theta0 = rand*2*pi; % phase aléatoire
theta1 = rand*2*pi; % phase aléatoire
cos0 = cos(2*pi*F0*t + theta0);   % génération du premier cosinus avec une phase aléatoire
sin0 = sin(2*pi*F0*t + theta0);   % génération du premier sinus avec la même phase aléatoire
cos1 = cos(2*pi*F1*t + theta1);   % génération du second cosinus avec une phase aléatoire
sin1 = sin(2*pi*F1*t + theta1);   % génération du second sinus avec la même phase aléatoire

xcos0 = x.*cos0;   % génération du produit de x (phases phi0 et phi1) par le premier cosinus (phase theta0) 
xsin0 = x.*sin0;   % génération du produit de x (phases phi0 et phi1) par le premier sinus (phase theta0)
xcos1 = x.*cos1;   % génération du produit de x (phases phi0 et phi1) par le second cosinus (phase theta1)
xsin1 = x.*sin1;   % génération du produit de x (phases phi0 et phi1) par le second sinus (phase theta1)

% Calcul des intégrales de x01, x02, x11 et x12 entre (n-1)*Ts et n*Ts pour
% n de 1 à length(x)/ns par la méthode des rectangles, et mise au carré des intégrales
for n=1:length(x)/ns
    integrale_xcos0(n)= sum(xcos0((n-1)*ns+1:n*ns)*Te)^2;   % integrale_xcos0(n) = integrale de x01 entre (n-1)*Ts et n*Ts
    integrale_xsin0(n)= sum(xsin0((n-1)*ns+1:n*ns)*Te)^2;   % integrale_xsin0(n) = integrale de x02 entre (n-1)*Ts et n*Ts
    integrale_xcos1(n)= sum(xcos1((n-1)*ns+1:n*ns)*Te)^2;   % integrale_xcos1(n) = integrale de x11 entre (n-1)*Ts et n*Ts
    integrale_xsin1(n)= sum(xsin1((n-1)*ns+1:n*ns)*Te)^2;   % integrale_xsin1(n) = integrale de x12 entre (n-1)*Ts et n*Ts
end

delta_integrales = (integrale_xcos1 + integrale_xsin1) - (integrale_xcos0 + integrale_xsin0);     % différence des deux sommes d'intégrales 

NRZ_estime = delta_integrales > 0; % NRZ_estime(n) = 0 ssi delta_integrales(n) plus proche de H0 que de H1; 1 sinon

z3 = NRZ_estime;

%% Fichier 4

load('fichier4.mat');
x=signal;
t = (0 : length(x)-1)*Te;

theta0 = rand*2*pi; % phase aléatoire
theta1 = rand*2*pi; % phase aléatoire
cos0 = cos(2*pi*F0*t + theta0);   % génération du premier cosinus avec une phase aléatoire
sin0 = sin(2*pi*F0*t + theta0);   % génération du premier sinus avec la même phase aléatoire
cos1 = cos(2*pi*F1*t + theta1);   % génération du second cosinus avec une phase aléatoire
sin1 = sin(2*pi*F1*t + theta1);   % génération du second sinus avec la même phase aléatoire

xcos0 = x.*cos0;   % génération du produit de x (phases phi0 et phi1) par le premier cosinus (phase theta0) 
xsin0 = x.*sin0;   % génération du produit de x (phases phi0 et phi1) par le premier sinus (phase theta0)
xcos1 = x.*cos1;   % génération du produit de x (phases phi0 et phi1) par le second cosinus (phase theta1)
xsin1 = x.*sin1;   % génération du produit de x (phases phi0 et phi1) par le second sinus (phase theta1)

% Calcul des intégrales de x01, x02, x11 et x12 entre (n-1)*Ts et n*Ts pour
% n de 1 à length(x)/ns par la méthode des rectangles, et mise au carré des intégrales
for n=1:length(x)/ns
    integrale_xcos0(n)= sum(xcos0((n-1)*ns+1:n*ns)*Te)^2;   % integrale_xcos0(n) = integrale de x01 entre (n-1)*Ts et n*Ts
    integrale_xsin0(n)= sum(xsin0((n-1)*ns+1:n*ns)*Te)^2;   % integrale_xsin0(n) = integrale de x02 entre (n-1)*Ts et n*Ts
    integrale_xcos1(n)= sum(xcos1((n-1)*ns+1:n*ns)*Te)^2;   % integrale_xcos1(n) = integrale de x11 entre (n-1)*Ts et n*Ts
    integrale_xsin1(n)= sum(xsin1((n-1)*ns+1:n*ns)*Te)^2;   % integrale_xsin1(n) = integrale de x12 entre (n-1)*Ts et n*Ts
end

delta_integrales = (integrale_xcos1 + integrale_xsin1) - (integrale_xcos0 + integrale_xsin0);     % différence des deux sommes d'intégrales 

NRZ_estime = delta_integrales > 0; % NRZ_estime(n) = 0 ssi delta_integrales(n) plus proche de H0 que de H1; 1 sinon

z4 = NRZ_estime;

%% Fichier 5

load('fichier5.mat');
x=signal;
t = (0 : length(x)-1)*Te;

theta0 = rand*2*pi; % phase aléatoire
theta1 = rand*2*pi; % phase aléatoire
cos0 = cos(2*pi*F0*t + theta0);   % génération du premier cosinus avec une phase aléatoire
sin0 = sin(2*pi*F0*t + theta0);   % génération du premier sinus avec la même phase aléatoire
cos1 = cos(2*pi*F1*t + theta1);   % génération du second cosinus avec une phase aléatoire
sin1 = sin(2*pi*F1*t + theta1);   % génération du second sinus avec la même phase aléatoire

xcos0 = x.*cos0;   % génération du produit de x (phases phi0 et phi1) par le premier cosinus (phase theta0) 
xsin0 = x.*sin0;   % génération du produit de x (phases phi0 et phi1) par le premier sinus (phase theta0)
xcos1 = x.*cos1;   % génération du produit de x (phases phi0 et phi1) par le second cosinus (phase theta1)
xsin1 = x.*sin1;   % génération du produit de x (phases phi0 et phi1) par le second sinus (phase theta1)

% Calcul des intégrales de x01, x02, x11 et x12 entre (n-1)*Ts et n*Ts pour
% n de 1 à length(x)/ns par la méthode des rectangles, et mise au carré des intégrales
for n=1:length(x)/ns
    integrale_xcos0(n)= sum(xcos0((n-1)*ns+1:n*ns)*Te)^2;   % integrale_xcos0(n) = integrale de x01 entre (n-1)*Ts et n*Ts
    integrale_xsin0(n)= sum(xsin0((n-1)*ns+1:n*ns)*Te)^2;   % integrale_xsin0(n) = integrale de x02 entre (n-1)*Ts et n*Ts
    integrale_xcos1(n)= sum(xcos1((n-1)*ns+1:n*ns)*Te)^2;   % integrale_xcos1(n) = integrale de x11 entre (n-1)*Ts et n*Ts
    integrale_xsin1(n)= sum(xsin1((n-1)*ns+1:n*ns)*Te)^2;   % integrale_xsin1(n) = integrale de x12 entre (n-1)*Ts et n*Ts
end

delta_integrales = (integrale_xcos1 + integrale_xsin1) - (integrale_xcos0 + integrale_xsin0);     % différence des deux sommes d'intégrales 

NRZ_estime = delta_integrales > 0; % NRZ_estime(n) = 0 ssi delta_integrales(n) plus proche de H0 que de H1; 1 sinon

z5 = NRZ_estime;

%% Fichier 6

load('fichier6.mat');
x=signal;
t = (0 : length(x)-1)*Te;

theta0 = rand*2*pi; % phase aléatoire
theta1 = rand*2*pi; % phase aléatoire
cos0 = cos(2*pi*F0*t + theta0);   % génération du premier cosinus avec une phase aléatoire
sin0 = sin(2*pi*F0*t + theta0);   % génération du premier sinus avec la même phase aléatoire
cos1 = cos(2*pi*F1*t + theta1);   % génération du second cosinus avec une phase aléatoire
sin1 = sin(2*pi*F1*t + theta1);   % génération du second sinus avec la même phase aléatoire

xcos0 = x.*cos0;   % génération du produit de x (phases phi0 et phi1) par le premier cosinus (phase theta0) 
xsin0 = x.*sin0;   % génération du produit de x (phases phi0 et phi1) par le premier sinus (phase theta0)
xcos1 = x.*cos1;   % génération du produit de x (phases phi0 et phi1) par le second cosinus (phase theta1)
xsin1 = x.*sin1;   % génération du produit de x (phases phi0 et phi1) par le second sinus (phase theta1)

% Calcul des intégrales de x01, x02, x11 et x12 entre (n-1)*Ts et n*Ts pour
% n de 1 à length(x)/ns par la méthode des rectangles, et mise au carré des intégrales
for n=1:length(x)/ns
    integrale_xcos0(n)= sum(xcos0((n-1)*ns+1:n*ns)*Te)^2;   % integrale_xcos0(n) = integrale de x01 entre (n-1)*Ts et n*Ts
    integrale_xsin0(n)= sum(xsin0((n-1)*ns+1:n*ns)*Te)^2;   % integrale_xsin0(n) = integrale de x02 entre (n-1)*Ts et n*Ts
    integrale_xcos1(n)= sum(xcos1((n-1)*ns+1:n*ns)*Te)^2;   % integrale_xcos1(n) = integrale de x11 entre (n-1)*Ts et n*Ts
    integrale_xsin1(n)= sum(xsin1((n-1)*ns+1:n*ns)*Te)^2;   % integrale_xsin1(n) = integrale de x12 entre (n-1)*Ts et n*Ts
end

delta_integrales = (integrale_xcos1 + integrale_xsin1) - (integrale_xcos0 + integrale_xsin0);     % différence des deux sommes d'intégrales 

NRZ_estime = delta_integrales > 0; % NRZ_estime(n) = 0 ssi delta_integrales(n) plus proche de H0 que de H1; 1 sinon

z6 = NRZ_estime;

%% Rassembler les images
image_retrouvee1 = reconstitution_image(z1);
image_retrouvee2 = reconstitution_image(z2);
image_retrouvee3 = reconstitution_image(z3);
image_retrouvee4 = reconstitution_image(z4);
image_retrouvee5 = reconstitution_image(z5);
image_retrouvee6 = reconstitution_image(z6);
final = [image_retrouvee6 image_retrouvee1 image_retrouvee5;image_retrouvee2 image_retrouvee4 image_retrouvee3];
image(final);
imsave;
