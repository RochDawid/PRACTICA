; =============================================================================
; TITLE    : GAME VARIABLES
; AUTHOR   : DAWID MICHAL ROCH MÓLL & JULIÁN WALLIS MEDINA
; HISTORY  :
; =============================================================================

; --- GAME STATE RELATED VARIABLES --------------------------------------------

STACUR      DS.W    1                       ; CURRENT GAME STATE
STANEXT     DS.W    1                       ; NEXT GAME STATE

; --- GAME ENEMIES RELATED VARIABLES ------------------------------------------

NENMLVL     DS.B    1                       ; NUMBER OF THIS LEVEL ENEMIES
BOSKILL     DS.B    1                       ; NUMBER OF BOSSES KILLED
            DS.W    0

; --- GAME PLAYER RELATED VARIABLES -------------------------------------------

PLRPOSX     DS.W    1                       ; PLAYER'S X POSITION (PIXELS)
PLRPOSY     DS.W    1                       ; PLAYER'S Y POSITION (PIXELS)
PLRSCOR     DS.W    1                       ; PLAYER'S SCORE
PLRHEAL     DS.W    1                       ; PLAYER'S HEALTH
LASSCOR     DS.W    1                       ; LAST PLAYER'S SCORE
LASHEAL     DS.W    1                       ; LAST PLAYER'S HEALTH

; --- UTILITY VARIABLES -------------------------------------------------------

UTLRNDIX    DS.B    1                       ; NEXT INDEX TO RANDOM NUMBER
            DS.W    0





*~Font name~Fixedsys~
*~Font size~18~
*~Tab type~1~
*~Tab size~4~
