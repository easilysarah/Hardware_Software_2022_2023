# Hardware_Software_2022_2023
Groupe 3.1 UART Sender 115200
Les membres du groupe sont : GILLES Sarah, LEBAILLY Emeline et TIROU Sam

Ce projet est réalisé dans le cadre de Hardware/Software. Ce cours se retrouve dans le programme de cours de première master en ingénierie électrique à la Faculté Polytechnique de Mons. Le but de notre projet est d'envoyer des informations via un UART  à l'aide du kit de développement DE0-Nano-SoC. Ce dernier présente une plateforme de conception matérielle robuste architecturée sur le FPGA SoC Altera. Les informations à lire seront de deux types : un compteur et un lecteur de fréquence.
L'outil utilisé pour créer ce programme est 'Quartus'.

Ce tuto est divisé en 2 parties principales : Software & Hardware.

La membre Hardware gère les I/O choisies et implémentées via 'Platform Designer' dans 'Quartus'. Il doit doit également compléter le 'ghrd' du programme afin d'y ajouter le bloc relatif à notre projet (contenant les I/O, clk, rst... utilisés).L'une de ses  missions est également de créer un programme (Driver dans le cas de notre projet) dont le but est d'établir un compteur et un lecteur de fréquence. Le compteur représente le nombre de battements d'horloge entre deux états S1.Il serivera également à la détermination de la fréquence.Finalement, le membre Hardware crée un TestBench dont l'objectif est de simuler le comportement du programme Drive avant de le lier à la partie Software et au processeur.

La partie Software a pour mission de modifier le fichier Main.c, qui est le code envoyé sur le processeur, et donc de  permettre l'encodage du caractère à envoyer, son affichage en caractère et en binaire, et l'envoi des données binaires vers le Hardware. Le membre Software gère également la connection du processeur à l'ordinateur,l'envoi des programmes nécessaires et assure le bon fonctionnement de tout cela.


Une vidéo explicative complète se trouve à l'aresse suivante : 
Bon visionnage ! 
