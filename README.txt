Escola Politècnica Superior
Grau en Enginyeria Informàtica
Estructura de Computadors II
Mars Invaders

Dawid Michal Roch Móll
Julián Wallis Medina

Estructura de Computadors II

INTRODUCCIÓ

En aquesta pràctica se’ns ha demanat que programem un videojoc
emprant el llenguatge assemblador del procesador Motorola 68000.
Nosaltres hem decidit crear una versió del conegut “Space Invaders” que
hem anomenat Mars Invaders. El protagonista del nostre joc és una nau espacial
que vol arribar a Mart per a poder aconseguir un llenguatge de programació de
més alt nivell, però uns ovnis intentarán impedir que arribi…

ESTRUCTURA DEL JOC

El joc consta de 3 nivells, cada un més difícil que l’anterior, on el jugador (la
nau espacial) haurà de sobreviure l’atac dels enemics.
Al primer nivell apareixen els enemics de dificultat 1, que han de menester
un tir per morir; al segon nivell tornen a aparèixer els enemics de nivell 1 i
s’introdueixen el enemics de dificultat 2, que han de menester dos tirs per morir.
Al darrer nivell surten els dos anteriors enemics però, a més, introduïm l’enemic
final, que ha de menester 8 tirs per morir i a més també pot disparar.

ESTRUCTURA DEL CODI

El codi està estructurat en diferents fitxers que cridam desde el Main. Aquests
fitxers son:
-

AGENTLIST: conté les funcionalitats necessàries pels agents
CONST: fitxer de les constants del joc
EN3SHOT: fitxer que conté les funcionalitats necessàries pels dispars dels
enemics del nivell 3
ENEMY1: conté les funcionalitats dels enemics del nivell 1
ENEMY2: conté les funcionalitats dels enemics del nivell 2
ENEMY3: conté les funcionalitats dels enemics del nivell 3
PLAYER: conté les funcionalitats del jugador principal del joc
PLAYERSHOT: fitxer que conté les funcionalitats necessàries pels dispars
del jugador
SPAWNER: conté les funcionalitats necessàries per a l’aparició dels
enemics
STAR: conté les funcionalitats de les estrelles del fons
STATES: fitxer que implementa el disseny dels estats del joc
SYSCONST: fitxer de constants del sistema del joc
SYSTEM: fitxer que implementa tot els mecanismes relacionats amb el
sistema necessaris per la funcionalitat del joc
SYSVAR: fitxer de variables del sistema del joc
UTIL: fitxer amb subrutines d’utilitat que es fan servir a diferents parts del
codi
VAR: fitxer amb les variables del joc

COM JUGAR I CARACTERÍSTIQUES DEL JOC

Per jugar s’ha de menester el teclat i el ratolí. El teclat s’empra en el propi
joc en sí mentre que el ratolí s’ha d’emprar als estats no jugables, és a dir: a l’inici,
als estats intermitjos entre nivells, a la pantalla de Game Over i a la pantalla de
victòria. Del ratolí només emprarem el click esquerra mentre que del teclat
haurem d’emprar les fletxes de direcció (per moure al jugador per la pantalla) i
l’espai per disparar.
El joc conté diferents àudios que es reprodueixen al llarg de la partida, per
exemple quan el jugador dispara o perd la partida.
Per poder guanyar al joc, el jugador haurà de sobreviure als dos primers
nivells i eliminar a tots els enemics finals del darrer nivell. Una vegada aconseguit,
la seva puntuació i la seva vida restant es guardaran en un fitxer i es mostrarà per
pantalla la puntuació de l’anterior victòria. De no aconseguir guanyar botarà a
una pantalla de Game Over i haurà de tornar a començar de bell nou.