fs = 300; % Fréquence de bits 
Ts = 1/fs; % Durée d'un bit
fe = 48*10^(3); % Fréquence d'échantillonnage
Te = 1/fe; % Durée d'échantillonnage
ns = fe / fs; % Nombre d'échantillons par bit
np=16; % Nombre de bits à transmettre
phi0 = rand*2*pi; % Phase aléatoire
phi1 = rand*2*pi;   % Phase aléatoire

% Partie 3.1

%% Question 1

NRZ= 1:ns*np;
for n=0:np-1
      NRZ(n*ns +1:(n+1)*ns) = randi([0,1]); % génération des bits de manière aléatoire (les bits sont tous répétés ns fois)
end

%% Question 2

t=0:Te:(np)*Ts - Te; % temps
stairs(t,NRZ); % affichage de NRZ sous la forme d'une fonction en escalier
xlabel('Temps (s)')
ylabel('NRZ (V)')
title('Génération du signal NRZ')
ylim([-0.2 1.2])
xlim([0 np*Ts])

%% Question 3

p=(fe +1 )/(2*1024); 
f = 0 :2*p: fe;
f = f - fe/2;
DSP=pwelch(NRZ,[],[],[],fe,'twosided');
plot(f,DSP);
xlabel('Fréquence (Hz)');
ylabel('Densité spectrale de puissance (V^2.Hz^{-2})');
title('DSP tracée à l aide d un periodigramme de Welch');

% Question 4
DSPtheo = 0.25*Ts*sinc(pi*f*Ts).^2+0.25*dirac(f);
hold on
plot(f,DSPtheo);
legend('Tracé simulé','Tracé théorique');
xlim([-2500 50000])
hold off

%Partie 3.2

F0 = 1180 ;
F1 = 980 ;
t = 0 : Te : np*Ts-Te;
cos1 = cos(2*pi*F0*t + phi0);
cos2 = cos(2*pi*F1*t + phi1);

%Question 1
x = (1 - NRZ).*cos1 + NRZ.*cos2;

%% Question 2

figure()
plot(t,x);
xlabel('Temps (s)')
ylabel('x (V)')
title('Génération du signal modulé en fréquence')
ylim([-1.2 1.2])
xlim([0 np*Ts/3])

%% Question 4

DSP2=pwelch(x,[],[],[],fe,'twosided');
semilogy(f,fftshift(DSP2));
xlabel('Fréquence (Hz)');
ylabel('Densité spectrale de puissance de x(t) (V^2.Hz^{-2})');
title('DSP tracée avec un periodigramme de Welch');
hold on

% Partie 4

rapport = 10; % rapport signal sur bruit
Px = mean(abs(x).^2);
Pb = Px / (10^(rapport/10));
bruit = sqrt(Pb)*randn(1,ns*np);
x=x+bruit;
DSP2=pwelch(x,[],[],[],fe,'twosided');
semilogy(f,fftshift(DSP2));
legend('x(t) non bruité','x(t) bruité');
hold off



% Partie V
%% génération du signal aux nouvelles fréquences

F0 = 6000;
F1 = 2000;
t = 0 : Te : np*Ts-Te;
cos1 = cos(2*pi*F0*t + phi0);
cos2 = cos(2*pi*F1*t + phi1);
x = (1 - NRZ).*cos1 + NRZ.*cos2;
rapport = 10; % rapport signal sur bruit
Px = mean(abs(x).^2);
Pb = Px / (10^(rapport/10));
bruit = sqrt(Pb)*randn( 1 , ns*np );
x=x+bruit;

DSP2=pwelch(x,[],[],[],fe,'twosided');
semilogy(f,fftshift(DSP2));
xlabel('Fréquence (Hz)');
ylabel('Densité spectrale de puissance de x(t) bruité (V^2.Hz^{-2}) de x(t) avec F0 = 6000 Hz et F1 = 2000 Hz');
title('DSP de x bruité tracée avec un periodigramme de Welch');


%% 5.1 : filtre passe bas

ordre = 61;
fc = 3000; 
tp=((-(ordre-1)/2:1:(ordre-1)/2))*Te;
h=2*fc*sinc(2*fc*tp)/fe;
figure();
y_PB=filter(h,1,x);
plot(y_PB); 
xlabel('Temps (s)')
ylabel('y_{PB}(t)')
title('Signal x(t) en sortie du filtre passe-bas avec un ordre de 61')



%% DSP du signal filtré y_PB

figure();
DSP2=pwelch(y_PB,[],[],[],fe,'twosided');
semilogy(f,fftshift(DSP2));
xlabel('Fréquence (Hz)');
ylabel('Densité spectrale de puissance (V^2.Hz^{-2}) de y_{PB}(t)');
title('DSP de x bruité en sortie du filtre passe-bas y_{PB}');

%% 5.2 : filtre passe haut

ordre = 61;
fc = 5000;
tp=(-(ordre-1)/2:1:(ordre-1)/2)*Te;
h_PB=2*fc*sinc(2*fc*tp)/fe;
Dirac = zeros(1,length(tp));
Dirac((length(tp)+1)/2)=1;
h_PH = (Dirac-h_PB);
y_PH=filter(h_PH,1,x);
figure();
plot(y_PH); 
xlabel('Temps (s)')
ylabel('y_{PH}(t)')
title('Signal x(t) en sortie du filtre passe-haut avec un ordre de 61')

%% DSP du signal filtré y_PH

figure();
DSP3=pwelch(y_PH,[],[],[],fe,'twosided');
semilogy(f,fftshift(DSP3));
xlabel('Fréquence (Hz)');
ylabel('Densité spectrale de puissance (V^2.Hz^{-2}) de y_{PH}(t)');
title('DSP de x bruité en sortie du filtre passe-haut y_{PH}');

% 5.3 : Les ordre-1/2 = 30 premiers points sont faux car on a pas x sur 30 points avant 0


%% 5.5.1 Passe bas

K=60;
y = y_PB;
NRZ_estime = 1:ns*np;
for n =0:np-1
    somme= sum(y(n*ns +1:(n+1)*ns).^2);
    if somme > K 
      NRZ_estime(n*ns +1:(n+1)*ns) = 1;
    else 
      NRZ_estime(n*ns +1:(n+1)*ns) = 0;
    end
end
t=0:Te:(np)*Ts - Te;
figure();
NRZ= 1:ns*np;
for n =0:np-1
      NRZ(n*ns +1:(n+1)*ns) = randi([0,1]);
end
plot(t,NRZ)
hold on
plot(t,NRZ_estime)

% Taux passe-bas (PB)
compteurbit = 0;
compteurerrone = 0;
for n = 0:np-1
    if NRZ_estime(n*ns +1:(n+1)*ns) ~= NRZ(n*ns +1:(n+1)*ns)
      compteurerrone = compteurerrone + 1;
    end
    compteurbit = compteurbit+1;
end
taux_PB=compteurerrone/compteurbit;

title('Comparaison des NRZ(t) en sortie du filtre passe-bas')
subtitle(strcat('Taux de bits erronés :  ',sprintf('%.4f', taux_PB)))
legend("NRZ(t) réel","NRZ(t) estime")
xlabel('Temps (s)')
ylabel('NRZ(t) ')
ylim([-0.1 1.1])
xlim([0 0.05])
hold off


%% 5.5.1 Passe haut

K=50;
y = y_PH;
NRZ_estime2 = 1:ns*np;
for n = 0:np-1
    somme= sum(y(n*ns +1:(n+1)*ns).^2);
    if somme < K 
      NRZ_estime2(n*ns +1:(n+1)*ns) = 1;
    else 
      NRZ_estime2(n*ns +1:(n+1)*ns) = 0;
    end
end
t=0:Te:(np)*Ts - Te;
plot(t,NRZ)
hold on

% Taux passe-haut (PH)
compteurbit = 0;
compteurerrone = 0;
for n = 0:np-1
    if NRZ_estime(n*ns +1:(n+1)*ns) ~= NRZ(n*ns +1:(n+1)*ns)
      compteurerrone = compteurerrone + 1;
    end
    compteurbit = compteurbit+1;
end
taux_PH=compteurerrone/compteurbit;

plot(t,NRZ_estime)
title('Comparaison des NRZ(t) en sortie du filtre passe-haut')
subtitle(strcat('Taux de bits erronés :  ',sprintf('%.4f', taux_PH)))
legend("NRZ(t) réel","NRZ(t) estime")
xlabel('Temps (s)')
ylabel('NRZ(t) ')
ylim([-0.1 1.1])
xlim([0 0.05])
hold off



% NOUVEL ORDRE
%% 5.6.1 : Passe-bas

ordre = 201;
fc = 3000; 
tp=((-(ordre-1)/2:1:(ordre-1)/2))*Te;
h=2*fc*sinc(2*fc*tp)/fe;
figure();
%plot(tp,h);
y_PB=filter(h,1,x);
plot(y_PB);
xlabel('Temps (s)')
ylabel('y_{PB}(t)')
title('Signal x(t) en sortie du filtre passe-bas avec un ordre de 201')

%% 5.6.1 : Passe-haut

ordre = 201;
fc = 5000;
tp=(-(ordre-1)/2:1:(ordre-1)/2)*Te;
h_PB=2*fc*sinc(2*fc*tp)/fe;
% figure();
% plot(tp,h_PB);
Dirac = zeros(1,length(tp));
Dirac((length(tp)+1)/2)=1;
h_PH = (Dirac-h_PB);
y_PH=filter(h_PH,1,x);
figure();
plot(y_PH);
xlabel('Temps (s)')
ylabel('y_{PB}(t)')
title('Signal x(t) en sortie du filtre passe-haut avec un ordre de 201')

% 5.6.1.a : décalage de nouveau_ordre/2 = 70 entre les deux (à chaque fois)

%% 5.6.1.b : le 0 du filtré = le 0 de l'entrée+(ordre-1)/2

% on mets donc (ordre-1)/2 zéros à droite de l'entrée (zero-padding)
% et on tronque la sortie
ordre = 201;
tp=((-(ordre-1)/2:1:(ordre-1)/2))*Te;
h=2*fc*sinc(2*fc*tp)/fe;
figure();
x=[x zeros(1,(ordre-1)/2)];
y_PB=filter(h,1,x);
y_PB=y_PB(1,(ordre-1)/2:end);
plot(y_PB);
xlabel('Temps (s)')
ylabel('y_{PB}(t)')
title('Signal x(t) en sortie du filtre passe-bas avec un ordre de 201 après modification')

%%
ordre = 61;
tp=((-(ordre-1)/2:1:(ordre-1)/2))*Te;
h=2*fc*sinc(2*fc*tp)/fe;
figure();
x=[x zeros(1,(ordre-1)/2)];
y_PB=filter(h,1,x);
y_PB=y_PB(1,(ordre-1)/2:end);
plot(y_PB)
xlabel('Temps (s)')
ylabel('y_{PB}(t)')
title('Signal x(t) en sortie du filtre passe-bas avec un ordre de 61 après modification')



%%% FREQUENCES DE LA NORME V21
%% 5.6.2

F0 = 1180 ;
F1 = 980 ;
t = 0 : Te : np*Ts-Te;
cos1 = cos(2*pi*F0*t + phi0);
cos2 = cos(2*pi*F1*t + phi1);
x = (1 - NRZ).*cos1 + NRZ.*cos2;
fc=1080;

rapport = 100; % rapport signal sur bruit
Px = mean(abs(x).^2);
Pb = Px / (10^(rapport/10));
bruit = sqrt(Pb)*randn( 1 , ns*np );
x=x+bruit;

% filtrage PB
ordre = 61;
tp=((-(ordre-1)/2:1:(ordre-1)/2))*Te;
h=2*fc*sinc(2*fc*tp)/fe;
y_PB=filter(h,1,x);

% filtrage PH
ordre = 201;
tp=(-(ordre-1)/2:1:(ordre-1)/2)*Te;
h_PB=2*fc*sinc(2*fc*tp)/fe;
Dirac = zeros(1,length(tp));
Dirac((length(tp)+1)/2)=1;
h_PH = (Dirac-h_PB);
y_PH=filter(h_PH,1,x);


% taux passe-bas (PB)
K=30;
y = y_PB;
NRZ_estime = 1:ns*np;

for n = 0:np-1
    sommePH(n+1)= sum(y(n*ns +1:(n+1)*ns).^2);
    somme = sum(y(n*ns +1:(n+1)*ns).^2);
    if somme > K 
      NRZ_estime(n*ns +1:(n+1)*ns) = 1;
    else  
      NRZ_estime(n*ns +1:(n+1)*ns) = 0;
    end
end

t=0:Te:(np)*Ts - Te;
plot(t,NRZ)
hold on
plot(t,NRZ_estime)

compteurbit = 0;
compteurerrone = 0;
for n = 0:np-1
    if NRZ_estime(n*ns +1:(n+1)*ns) ~= NRZ(n*ns +1:(n+1)*ns)
      compteurerrone = compteurerrone + 1;
    end
    compteurbit = compteurbit+1;
end
taux_PB=compteurerrone/compteurbit;


plot(t,NRZ_estime)
title('Comparaison des NRZ(t) en sortie du filtre passe-bas')
subtitle(strcat('Taux de bits erronés :  ',sprintf('%.4f', taux_PB)))
legend("NRZ(t) réel","NRZ(t) estime")
xlabel('Temps (s)')
ylabel('NRZ(t) ')

ylim([-0.1 1.1])
xlim([0 0.05])
hold off

%% taux passe-haut

K=40;
y = y_PH;
NRZ_estime2 = 1:ns*np;
for n = 0:np-1
    sommePH(n+1)= sum(y(n*ns +1:(n+1)*ns).^2);
    somme = sum(y(n*ns +1:(n+1)*ns).^2);
    if somme < K 
      NRZ_estime2(n*ns +1:(n+1)*ns) = 1;
    else  
      NRZ_estime2(n*ns +1:(n+1)*ns) = 0;
    end
end
t=0:Te:(np)*Ts - Te;
plot(t,NRZ)
hold on


compteurbit = 0;
compteurerrone = 0;
for n = 0:np-1
    if NRZ_estime2(n*ns +1:(n+1)*ns) ~= NRZ(n*ns +1:(n+1)*ns)
      compteurerrone = compteurerrone + 1;
    end
    compteurbit = compteurbit+1;
end
taux_PH = compteurerrone/compteurbit;

plot(t,NRZ_estime)
title('Comparaison des NRZ(t) en sortie du filtre passe-haut')
subtitle(strcat('Taux de bits erronés :  ',sprintf('%.4f', taux_PH)))
legend("NRZ(t) réel","NRZ(t) estime")
xlabel('Temps (s)')
ylabel('NRZ(t) ')

ylim([-0.1 1.1])
xlim([0 0.05])
hold off









