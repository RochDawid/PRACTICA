; =============================================================================
; GAME CONSTANTS
;
; COMMENTS:
;       - THE WIDTH AND HEIGTH OF EVERY ENEMY HAS TO BE MULTIPLIED BY THE SAME
;         CONSTANT (P.EX: EN1HEIGH IS 33 AND EN1WIDTH IS 24 -> 33=11*3, 24=8*3
;
; =============================================================================

; --- PLAYER'S SHIP RELATED CONSTANTS -----------------------------------------

PLRWIDTH    EQU     52          ; PLAYER WIDTH (PIXELS) ONLY MULTIPLES OF 13!
PLRHEIGH    EQU     36          ; PLAYER HEIGHT (PIXELS) ONLY MULTIPLES OF 9!
PLRGREY1    EQU     $009E9E9E   ; PLAYER GREY 1 COLOR (PEN & FILL)
PLRGREY2    EQU     $00616161   ; PLAYER GREY 2 COLOR (PEN & FILL)
PLRBLUE     EQU     $00FFAE00   ; PLAYER BLUE COLOR (PEN & FILL)
PLRSPEED    EQU     8           ; PLAYER SPEED (PIXELS PER INT)
PLRINIHE    EQU     100         ; PLAYER INITIAL HEALTH

; --- ENEMY 1 RELATED CONSTANTS -----------------------------------------------

EN1SCORE    EQU     5           ; SCORE GIVEN BY EVERY LEVEL 1 ENEMY KILLED
NENMLVL1    EQU     50          ; NUMBER OF LEVEL 1 ENEMIES
EN1HEIGH    EQU     33          ; ENEMY 1 HEIGHT (PIXELS) ONLY MULTIPLES OF 11!
EN1WIDTH    EQU     24          ; ENEMY 1 WIDTH (PIXELS) ONLY MULTIPLES OF 8!
EN1GREEN    EQU     $004FAF4C   ; ENEMY 1 GREEN COLOR (PEN & FILL)
EN1DMGPW    EQU     1           ; ENEMY 1 DAMAGE POWER

; --- ENEMY 2 RELATED CONSTANTS -----------------------------------------------

EN2SCORE    EQU     10          ; SCORE GIVEN BY EVERY LEVEL 2 ENEMY KILLED
NENMLVL2    EQU     25          ; NUMBER OF LEVEL 2 ENEMIES 
EN2HEIGH    EQU     42          ; ENEMY 2 HEIGHT (PIXELS) ONLY MULTIPLES OF 14!
EN2WIDTH    EQU     48          ; ENEMY 2 WIDTH  (PIXELS) ONLY MULTIPLES OF 16!
EN2PURPL    EQU     $009A1B6A   ; ENEMY 2 PURPLE COLOR (PEN & FILL)
EN2YELLO    EQU     $003BEBFF   ; ENEMY 2 YELLOW COLOR (PEN & FILL)
NSHOTEN2    EQU     2           ; ENEMY 2 HITS NEEDED TO DIE
EN2DMGPW    EQU     2           ; ENEMY 2 DAMAGE POWER

; --- ENEMY 3 RELATED CONSTANTS -----------------------------------------------

EN3SCORE    EQU     25          ; SCORE GIVEN BY EVERY LEVEL 3 ENEMY KILLED
NENMLVL3    EQU     5           ; NUMBER OF LEVEL 3 ENEMIES 
EN3HEIGH    EQU     52          ; ENEMY 3 HEIGHT (PIXELS) ONLY MULTIPLES OF 13!
EN3WIDTH    EQU     116         ; ENEMY 3 WIDTH  (PIXELS) ONLY MULTIPLES OF 29!
EN3GREY1    EQU     $00808080   ; ENEMY 3 GREY 1 COLOR (PEN & FILL)
EN3GREY2    EQU     $00C0C0C0   ; ENEMY 3 GREY 2 COLOR (PEN & FILL)
EN3YELLO    EQU     $0025C5FF   ; ENEMY 3 YELLOW COLOR (PEN & FILL)
NSHOTEN3    EQU     8           ; ENEMY 3 HITS NEEDED TO DIE
EN3DMGPW    EQU     4           ; ENEMY 3 DAMAGE POWER

; --- GAME STATES CONSTANTS ---------------------------------------------------

STANONE     EQU     -1                      ; PLACEHOLDER TO FORCE CHANGE
STAINTR     EQU     0                       ; INTRODUCTION STATE
STAPLN1     EQU     1                       ; LEVEL 1 GAME STATE
STA1TO2     EQU     2                       ; SCREEN BETWEEN LVL1 AND LVL2
STAPLN2     EQU     3                       ; LEVEL 2 GAME STATE
STA2TO3     EQU     4                       ; SCREEN BETWEEN LVL2 AND LVL3
STAPLN3     EQU     5                       ; LEVEL 3 GAME STATE
STAWON      EQU     6                       ; WINNING SCREEN STATE
STAGAOV     EQU     7                       ; GAME OVER STATE

; --- PLAYER SHOT RELATED CONSTANTS -------------------------------------------

PLRSHWI    EQU     5                       ; PLAYER SHOT WIDTH IN PIXELS
PLRSHHE    EQU     13                      ; PLAYER SHOT HEIGHT IN PIXELS
PLRSHSP    EQU     8                       ; PLAYER SHOT SPEED

; --- ENEMY 3 SHOT RELATED CONSTANTS -------------------------------------------

EN3SHWI    EQU     3                       ; ENEMY SHOT WIDTH IN PIXELS
EN3SHHE    EQU     10                      ; ENEMY SHOT HEIGHT IN PIXELS
EN3SHSP    EQU     6                       ; ENEMY SHOT SPEED
EN3SHDM    EQU     10                      ; ENEMY SHOT 3 DAMAGE POWER


; --- AGENT TYPES CONSTANTS ---------------------------------------------------

SHTTYPE     EQU     1                       ; SHOTS AGENT ID
EN1TYPE     EQU     2                       ; LEVEL 1 ENEMIES AGENT ID
EN2TYPE     EQU     3                       ; LEVEL 2 ENEMIES AGENT ID
EN3TYPE     EQU     4                       ; LEVEL 3 ENEMIES AGENT ID
SHT3TYPE    EQU     5                       ; LEVEL 3 ENEMIY SHOT AGENT ID
STARTYPE    EQU     6                       ; STARS AGENT ID






*~Font name~Fixedsys~
*~Font size~18~
*~Tab type~1~
*~Tab size~4~
