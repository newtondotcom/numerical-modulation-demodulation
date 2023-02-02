# numerical-modulation-demodulation
This is a Matlab project which consists of modulating a signal and then demodulate it using using 3 differents methods.
The first one consists of an energy detection applied to respectively a high-pass filter and a low-pass filter (implemented [here](https://github.com/newtondotcom/numerical-modulation-demodulation/blob/main/Codes/mod_demod_filtrage.m) )
The second one consists of a FSK demodulation (Frequence Shift Keying) accordingly to the french norm V21 (implemented [here](https://github.com/newtondotcom/numerical-modulation-demodulation/blob/main/Codes/mod_demod_v21.m))
The third one consists of a FSK demodulation with carrier phase error management (implemented [here](https://github.com/newtondotcom/numerical-modulation-demodulation/blob/main/Codes/mod_demod_v21gestion.m))

This project was realized during my engineering studies in Digital Sciences at ENSEEIHT.


# French notice : 
+---------------------------Comment utiliser les 4 fichiers fournis ? ----------------------------------+

(:_:_:) - mod_demod_filtrage.m
But : Modulation et démodulation par filtrage passe-haut et passe-bas
Paramètres : Les constantes f_s, f_e et np peuvent être modifiées.
Dépendances : Ce fichier peut être executé indépendamment. 

(:_:_:) - mod_demod_v21.m
But : Démodulateur de fréquence (FSK) adapté à la norme V21
Paramètres : Les constantes f_s, f_e et np peuvent être modifiées.
Dépendances : Ce fichier peut être executé indépendamment. 

(:_:_:) - mod_demod_v21gestion.m
But : Démodulateur de fréquence adapté à la norme V21 avec gestion d'erreur de phase porteuse
Dépendances : Ce fichier peut être executé indépendamment. 

(:_:_:) - gen_image.m
But : Démoduler les fichiers contenant les images afin de reconstituer l'image entière. On propose ensuite à l'utilisateur d l'enregistrer.
Dépendances :  Nécéssite la présence de reconstitution_image.m et des fichiersi.m pour i de 1 à 6 dans son répertoire.


