%% 6. Démodulateur de fréquence adapté à la norme V21

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

% On commence par implanter un modulateur adapté à la fréquence V21

% Génération du signal NRZ
NRZ= 1:ns*np;
for n=0:np-1 
      NRZ(n*ns +1:(n+1)*ns) = randi([0,1]);
end

% Génération du signal x non-bruité
F0 = 1180 ;
F1 = 980 ;
phi0 = rand*2*pi;
phi1 = rand*2*pi;
t = 0 : Te : np*Ts-Te;
cos0 = cos(2*pi*F0*t + phi0);
cos1 = cos(2*pi*F1*t + phi1);
x = (1 - NRZ).*cos0 + NRZ.*cos1;

% Ajout de bruit au signal x
rapport = 100; % rapport signal sur bruit
Px = mean(abs(x).^2);
Pb = Px / (10^(rapport/10));
bruit = sqrt(Pb)*randn( 1 , ns*np );
x=x+bruit;

%% 6.1 Contexte de synchronisation idéale

cos0 = cos(2*pi*F0*t + phi0);   % génération du premier cosinus
cos1 = cos(2*pi*F1*t + phi1);   % génération du second cosinus
x0 = x.*cos0;   % génération du produit de x par le premier cosinus
x1 = x.*cos1;   % génération du produit de x par le second cosinus

%% 6.1.1 Evaluation des trois intégrales en utilisant les valeurs numériques des paramètres de la recommandation V21

int0 = Ts/2 + (sin(4*pi*F0*Ts+2*phi0) - sin(2*phi0))/(8*pi*F0);
int1 = Ts/2 + (sin(4*pi*F1*Ts+2*phi1) - sin(2*phi1))/(8*pi*F1);
int10 = (sin(2*pi*(F1+F0)*Ts+phi1+phi0) - sin(phi1+phi0))/(4*pi*(F1+F0)) + (sin(2*pi*(F1-F0)*Ts+phi1-phi0) - sin(phi1-phi0))/(4*pi*(F1-F0));


%% 6.1.2 Implantation du démodulateur proposé

% Calcul des intégrales de x0 et x1 entre (n-1)*Ts et n*Ts pour n de 1 à np
% par la méthode des rectangles 
for n=1:np
    integrale_x0(n)= sum(x0((n-1)*ns+1:n*ns))*Te;   % integrale_x0(n) = integrale de x0 entre (n-1)*Ts et n*Ts
    integrale_x1(n)= sum(x1((n-1)*ns+1:n*ns))*Te;   % integrale_x1(n) = integrale de x1 entre (n-1)*Ts et n*Ts
end
delta_integrales = integrale_x1 - integrale_x0;     % différence des deux intégrales

NRZ_estime = delta_integrales > 0; % NRZ_estime(n) = 0 ssi delta_integrales(n) plus proche de H0 que de H1; 1 sinon

% génération d'un vecteur erreurs tel que erreurs(n) = 1 ssi le n-ième bit
% de NRZ_estime est différent du n-ième bit transmis (bit erroné)
for n=1:np
        erreurs(n) = (NRZ_estime(n) ~= NRZ((n-1)*ns + 1)); % le même bit est répété ns fois dans NRZ mais pas dans NRZ_estime
end
taux = sum(erreurs)/np;

%% 6.2.1 Introduction d'une erreur de phase porteuse

% modification des phases des cosinus en émission
phi2 = rand*2*pi;
phi3 = rand*2*pi;
cos2 = cos(2*pi*F0*t + phi2);
cos3 = cos(2*pi*F1*t + phi3);
x = (1 - NRZ).*cos2 + NRZ.*cos3;

% Ajout de bruit au signal x
rapport = 100; % rapport signal sur bruit
Px = mean(abs(x).^2);
Pb = Px / (10^(rapport/10));
bruit = sqrt(Pb)*randn( 1 , ns*np );
x=x+bruit;

x0 = x.*cos0;   % génération du produit de x (phases phi2 et phi3) par le premier cosinus (phase phi0)
x1 = x.*cos1;   % génération du produit de x (phases phi2 et phi3) par le second cosinus (phase phi1)

% Calcul des intégrales de x0 et x1 entre (n-1)*Ts et n*Ts pour n de 1 à np
% par la méthode des rectangles 
for n=1:np
    integrale_x0(n)= sum(x0((n-1)*ns+1:n*ns))*Te;   % integrale_x0(n) = integrale de x0 entre (n-1)*Ts et n*Ts
    integrale_x1(n)= sum(x1((n-1)*ns+1:n*ns))*Te;   % integrale_x1(n) = integrale de x1 entre (n-1)*Ts et n*Ts
end

delta_integrales = integrale_x1 - integrale_x0;     % différence des deux intégrales

NRZ_estime = delta_integrales > 0; % NRZ_estime(n) = 0 ssi delta_integrales(n) plus proche de H0 que de H1; 1 sinon

% génération d'un vecteur erreurs tel que erreurs(n) = 1 ssi le n-ième bit
% de NRZ_estime est différent du n-ième bit transmis (bit erroné)
for n=1:np
        erreurs(n) = NRZ_estime(n) ~= NRZ((n-1)*ns + 1); % le même bit est répété ns fois dans NRZ mais pas dans NRZ_estime
end
taux = sum(erreurs)/np;


