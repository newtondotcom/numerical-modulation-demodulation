%% 6.2.2 gestion d'une erreur de synchronisation de phase porteuse : modification du démodulateur

% Constantes
F0 = 1180 ;
F1 = 980 ;
np=16;
fs = 300;
Ts = 1/fs;
fe = 48*10^(3);
Te = 1/fe;
ns = fe / fs;
Ts = ns*Te;
t = 0 : Te : np*Ts-Te;

% Génération du signal NRZ
NRZ= 1:ns*np;
for n=0:np-1 
      NRZ(n*ns +1:(n+1)*ns) = randi([0,1]);
end

% génération des cosinus en émission
phi0 = rand*2*pi;
phi1 = rand*2*pi;
cos0_NRZ = cos(2*pi*F0*t + phi0);   % génération du premier cosinus
cos1_NRZ = cos(2*pi*F1*t + phi1);   % génération du second cosinus

x = (1 - NRZ).*cos0_NRZ + NRZ.*cos1_NRZ; % signal non bruité

% % Ajout de bruit au signal x
% rapport = 100; % rapport signal sur bruit
% Px = mean(abs(x).^2);
% Pb = Px / (10^(rapport/10));
% bruit = sqrt(Pb)*randn( 1 , ns*np );
% x=x+bruit;

% génération des cosinus/sinus en réception
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

% Calcul des intégrales de x01, x02, x11 et x12 entre (n-1)*Ts et n*Ts pour n de 1 à np
% par la méthode des rectangles, et mise au carré des intégrales
for n=1:np
    integrale_xcos0(n)= sum(xcos0((n-1)*ns+1:n*ns)*Te)^2;   % integrale_xcos0(n) = integrale de x01 entre (n-1)*Ts et n*Ts
    integrale_xsin0(n)= sum(xsin0((n-1)*ns+1:n*ns)*Te)^2;   % integrale_xsin0(n) = integrale de x02 entre (n-1)*Ts et n*Ts
    integrale_xcos1(n)= sum(xcos1((n-1)*ns+1:n*ns)*Te)^2;   % integrale_xcos1(n) = integrale de x11 entre (n-1)*Ts et n*Ts
    integrale_xsin1(n)= sum(xsin1((n-1)*ns+1:n*ns)*Te)^2;   % integrale_xsin1(n) = integrale de x12 entre (n-1)*Ts et n*Ts
end

delta_integrales = (integrale_xcos1 + integrale_xsin1) - (integrale_xcos0 + integrale_xsin0);     % différence des deux sommes d'intégrales   

NRZ_estime = delta_integrales > 0;


% génération d'un vecteur erreurs tel que erreurs(n) = 1 ssi le n-ième bit
% de NRZ_estime est différent du n-ième bit transmis (bit erroné)
for n=1:np
    erreurs(n) = NRZ_estime(n) ~= NRZ((n-1)*ns + 1); % le même bit est répété ns fois dans NRZ mais pas dans NRZ_estime
end
taux = sum(erreurs)/np;
