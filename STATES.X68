; =============================================================================
; TITLE    : GAME STATE MANAGEMENT
; AUTHOR   : ANTONI BURGUERA, DAWID ROCH AND JULIÁN WALLIS
; HISTORY  : XX-XXX-201X - CREATION
;            11-OCT-2020 - MINOR CHANGES
; =============================================================================

; -----------------------------------------------------------------------------
STAINIT
; INITALIZES THE STATE MANAGER
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVE.B  D0,-(A7)
            MOVE.B  #50,D0
            TRAP    #15                     ; CLOSE ALL FILES AS RECOMMENDED
            MOVE.W  #STANONE,(STACUR)
            MOVE.W  #STAINTR,(STANEXT)
            MOVE.B  (A7)+,D0
            RTS

; -----------------------------------------------------------------------------
STAUPD
; PERFORMS STATE UPDATE AND INIT IF NECESSARY
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------

            MOVEM.L D0/A0,-(A7)
            CLR.L   D0
            MOVE.W  (STANEXT),D0
            CMP.W   (STACUR),D0
            BEQ     .DOUPD
            MOVE.W  D0,(STACUR)             ; IF STATE CHANGED, DO INIT
            LSL.L   #2,D0
            MOVE.L  D0,A0
            MOVE.L  .INITBL(A0),A0
            JSR     (A0)
.DOUPD      CLR.L   D0                      ; IN ANY CASE, DO UPDATE
            MOVE.W  (STACUR),D0
            LSL.L   #2,D0
            MOVE.L  D0,A0
            MOVE.L  .UPDTBL(A0),A0
            JSR     (A0)
            MOVEM.L (A7)+,D0/A0
            RTS
            
.INITBL     DC.L    STAINTRI,STAPLN1I,STA1TO2I,STAPLN2I,STA2TO3I,STAPLN3I,STAWONI,STAGAOVI
.UPDTBL     DC.L    STAINTRU,STAPLN1U,STA1TO2U,STAPLN2U,STA2TO3U,STAPLN3U,STAWONU,STAGAOVU

; -----------------------------------------------------------------------------
STAPLOT
; PERFORMS STATE PLOT
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------

            MOVEM.L D0/A0,-(A7)
            CLR.L   D0
            MOVE.W  (STACUR),D0
            LSL.L   #2,D0
            MOVE.L  D0,A0
            MOVE.L  .PLTTBL(A0),A0
            JSR     (A0)
            MOVEM.L (A7)+,D0/A0
            RTS
            
.PLTTBL     DC.L    STAINTRP,STAPLN1P,STA1TO2P,STAPLN2P,STA2TO3P,STAPLN3P,STAWONP,STAGAOVP

; -----------------------------------------------------------------------------
STAEMPTY
; EMPTY SUBROUTINE FOR CASES WITH NOTHING TO DO
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; NOTE     - JUST A PLACEHOLDER. NOTHING TO DO.
; -----------------------------------------------------------------------------

            RTS

; =============================================================================
; INITIALITZATION, UPDATE AND PLOT OF GAME INTRODUCTION STATE
; =============================================================================

; -----------------------------------------------------------------------------
STAINTRI
; GAME INTRODUCTION STATE INITIALIZATION
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.L D0-D2/A1,-(A7)
            MOVE.L  #3,D2
            MOVE.B  #76,D0
            TRAP    #15                     ; STOP ALL SOUNDS
            LEA     .SNDP,A1
            MOVE.B  #71,D0
            CLR.B   D1
            TRAP    #15                     ; ADD INTRO SOUND TO MEMORY
            MOVE.B  #72,D0
            TRAP    #15                     ; PLAY INTRO MUSIC
            MOVEM.L (A7)+,D0-D2/A1
            BRA     DMMINIT
            
.SNDP       DC.B    'SND/introSound.wav',0
            DS.W    0
            
; -----------------------------------------------------------------------------
STAINTRU
; GAME INTRODUCTION STATE UPDATE
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------

            MOVEM.L D0-D1,-(A7)
            BTST    #0,(MOUSSTAT)                ; MOUSE LEFT BUTTON PRESSED?
            BEQ     .END                         ; NO: GO TO END
            MOVE.W  (MOUSPOSX),D0                ; X COORDINATES
            CMP.W   #SCRWIDTH/2-50,D0
            BLE     .END
            CMP.W   #SCRWIDTH/2+45,D0
            BGE     .END
            MOVE.W  (MOUSPOSY),D1                ; Y COORDINATES
            CMP.W   #3*SCRHEIGH/4-10,D1
            BLE     .END
            CMP.W   #3*SCRHEIGH/4+25,D1
            BGE     .END
            MOVE.W  #STAPLN1,(STANEXT)
            CLR.W   (MOUSPOSX)
            CLR.W   (MOUSPOSY)
            CLR.B   (MOUSSTAT)
.END        MOVEM.L (A7)+,D0-D1
            RTS

; -----------------------------------------------------------------------------
STAINTRP
; GAME INTRODUCTION STATE PLOT
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------

            MOVEM.L D0-D4/A1,-(A7)
            MOVE.W  #((80-13)/2)<<8|10,D1
            MOVE.B  #11,D0
            TRAP    #15                     ; LOCATE TEXT CURSOR
            LEA     .STR0,A1
            MOVE.B  #13,D0
            TRAP    #15                     ; PRINT THE STRING
            
            MOVE.W  #((80-65)/2)<<8|12,D1
            MOVE.B  #11,D0
            TRAP    #15                     ; LOCATE TEXT CURSOR
            LEA     .STR1,A1
            MOVE.B  #13,D0
            TRAP    #15                     ; PRINT THE STRING
            
            CLR.W   D1
            CLR.L   D2
            MOVE.W  #SCRWIDTH/2-50,D1
            MOVE.W  #3*SCRHEIGH/4-10,D2
            MOVE.W  #SCRWIDTH/2+45,D3
            MOVE.W  #3*SCRHEIGH/4+25,D4
            MOVE.B  #87,D0
            TRAP    #15                     ; PRINT RECTANGLE OF BUTTON
            
            BTST.B  #4,(SCRCYCCT)           ; MAKE THE START STRING FLICK
            BEQ     .END
            
            MOVE.W  #((80-5)/2)<<8|24,D1
            MOVE.B  #11,D0
            TRAP    #15                     ; LOCATE TEXT CURSOR
            LEA     .STR2,A1
            MOVE.B  #13,D0
            TRAP    #15                     ; PRINT THE STRING
.END        MOVEM.L (A7)+,D0-D4/A1
            RTS

.STR0       DC.B    'MARS INVADERS',0
.STR1       DC.B    'INVADE MARS TO DEVELOP A BETTER CODING LANGUAGE TO MAKE THIS GAME',0
.STR2       DC.B    'START',0
            DS.W    0

; =============================================================================
; INITIALIZATION, UPDATE AND PLOT OF GAME OVER STATE
; =============================================================================

; -----------------------------------------------------------------------------
STAGAOVI
; GAME OVER STATE INITIALIZATION
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------

            MOVEM.L D0-D2/A1,-(A7)
            MOVE.L  #3,D2
            MOVE.B  #76,D0
            TRAP    #15                     ; STOP ALL SOUNDS
            LEA     .SNDP,A1
            MOVE.B  #71,D0
            MOVE.B  #255,D1
            TRAP    #15                     ; ADD GAME OVER SOUND TO MEMORY
            MOVEM.L (A7)+,D0-D2/A1
            RTS

.SNDP       DC.B    'SND/gameOverSound.wav',0
            DS.W    0

; -----------------------------------------------------------------------------
STAGAOVU
; GAME OVER STATE UPDATE
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------

            MOVEM.L D0-D1,-(A7)
            BTST.B  #0,(MOUSSTAT)                ; MOUSE LEFT BUTTON PRESSED?
            BEQ     .END                         ; NO: GO TO END
            MOVE.W  (MOUSPOSX),D0                ; X COORDINATES
            CMP.W   #SCRWIDTH/2-50,D0
            BLE     .END
            CMP.W   #SCRWIDTH/2+45,D0
            BGE     .END
            MOVE.W  (MOUSPOSY),D1                ; Y COORDINATES
            CMP.W   #3*SCRHEIGH/4-10,D1
            BLE     .END
            CMP.W   #3*SCRHEIGH/4+25,D1
            BGE     .END
            MOVE.W  #STAINTR,(STANEXT)
            CLR.W   (MOUSPOSX)
            CLR.W   (MOUSPOSY)
            CLR.B   (MOUSSTAT)
.END        MOVEM.L (A7)+,D0-D1
            RTS

; -----------------------------------------------------------------------------
STAGAOVP
; GAME OVER STATE PLOT
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------

            MOVEM.L D0-D4/A1,-(A7)
            UTLSPEN #$00FFFFFF
            UTLSFIL #$00000000
            
            MOVE.B  #255,D1
            MOVE.B  #72,D0
            TRAP    #15                     ; PLAY GAME OVER SOUND
            MOVE.W  #((80-9)/2)<<8|10,D1
            MOVE.B  #11,D0
            TRAP    #15                     ; LOCATE TEXT CURSOR
            LEA     .STR0,A1
            MOVE.B  #13,D0
            TRAP    #15                     ; PRINT THE STRING
            
            MOVE.W  #((80-60)/2)<<8|12,D1
            MOVE.B  #11,D0
            TRAP    #15                     ; LOCATE TEXT CURSOR
            LEA     .STR1,A1
            MOVE.B  #13,D0
            TRAP    #15                     ; PRINT THE STRING

            MOVE.W  #SCRWIDTH/2-55,D1
            MOVE.W  #3*SCRHEIGH/4-10,D2
            MOVE.W  #SCRWIDTH/2+45,D3
            MOVE.W  #3*SCRHEIGH/4+25,D4
            MOVE.B  #87,D0
            TRAP    #15                     ; PRINT RECTANGLE OF BUTTON
            
            BTST.B  #4,(SCRCYCCT)           ; MAKE THE TRY AGAIN STRING FLICK
            BEQ     .END
            
            MOVE.W  #((80-9)/2)<<8|24,D1
            MOVE.B  #11,D0
            TRAP    #15                     ; LOCATE TEXT CURSOR
            LEA     .STR2,A1
            MOVE.B  #13,D0
            TRAP    #15                     ; PRINT THE STRING
.END        MOVEM.L (A7)+,D0-D4/A1
            RTS
            
.STR0       DC.B    'GAME OVER',0
.STR1       DC.B    'YOU COULD NOT REACH MARS, YOU WILL HAVE TO STICK TO ASSEMBLY',0
.STR2       DC.B    'TRY AGAIN',0
            DS.W    0

; =============================================================================
; INITIALITZATION, UPDATE AND PLOT OF SCREEN BETWEEN LEVEL 1 AND LEVEL 2 
; =============================================================================

; -----------------------------------------------------------------------------
STA1TO2I
; GAME INTRODUCTION STATE INITIALIZATION
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.L D0-D2/A1,-(A7)
            MOVE.L  #3,D2
            MOVE.B  #76,D0
            TRAP    #15                     ; STOP ALL SOUNDS
            LEA     .SNDP,A1
            MOVE.B  #71,D0
            MOVE.B  #5,D1
            TRAP    #15                     ; ADD INTRO SOUND TO MEMORY
            MOVE.B  #72,D0
            MOVE.B  #5,D1
            TRAP    #15                     ; PLAY INTRO MUSIC
            MOVEM.L (A7)+,D0-D2/A1
            BRA     DMMINIT
            
.SNDP       DC.B    'SND/toLevel2Sound.wav',0
            DS.W    0
            
; -----------------------------------------------------------------------------
STA1TO2U
; GAME INTRODUCTION STATE UPDATE
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------

            MOVEM.L D0-D1,-(A7)
            BTST    #0,(MOUSSTAT)                ; MOUSE LEFT BUTTON PRESSED?
            BEQ     .END                         ; NO: GO TO END
            MOVE.W  (MOUSPOSX),D0                ; X COORDINATES
            CMP.W   #SCRWIDTH/2-50,D0
            BLE     .END
            CMP.W   #SCRWIDTH/2+45,D0
            BGE     .END
            MOVE.W  (MOUSPOSY),D1                ; Y COORDINATES
            CMP.W   #3*SCRHEIGH/4-10,D1
            BLE     .END
            CMP.W   #3*SCRHEIGH/4+25,D1
            BGE     .END
            MOVE.W  #STAPLN2,(STANEXT)
            CLR.W   (MOUSPOSX)
            CLR.W   (MOUSPOSY)
            CLR.B   (MOUSSTAT)
.END        MOVEM.L (A7)+,D0-D1
            RTS

; -----------------------------------------------------------------------------
STA1TO2P
; GAME INTRODUCTION STATE PLOT
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------

            MOVEM.L D0-D4/A1,-(A7)
            MOVE.W  #((80-12)/2)<<8|10,D1
            MOVE.B  #11,D0
            TRAP    #15                     ; LOCATE TEXT CURSOR
            LEA     .STR0,A1
            MOVE.B  #13,D0
            TRAP    #15                     ; PRINT THE STRING
            MOVE.W  #((80-60)/2)<<8|12,D1
            MOVE.B  #11,D0
            TRAP    #15                     ; LOCATE TEXT CURSOR
            LEA     .STR1,A1
            MOVE.B  #13,D0
            TRAP    #15                     ; PRINT THE STRING

            MOVE.W  #((80-30)/2)<<8|15,D1
            MOVE.B  #11,D0
            TRAP    #15                     ; LOCATE TEXT CURSOR
            LEA     .STR2,A1
            MOVE.B  #13,D0
            TRAP    #15                     ; PRINT THE STRING

            MOVE.W  #((80+12)/2)<<8|15,D1
            MOVE.B  #11,D0
            TRAP    #15                     ; LOCATE TEXT CURSOR
            CLR.L   D1
            MOVE.W  (PLRSCOR),D1
            MOVE.B  #1,D2
            MOVE.B  #20,D0
            TRAP    #15                     ; PRINT PLAYER'S SCORE

            MOVE.W  #((80-31)/2)<<8|17,D1
            MOVE.B  #11,D0
            TRAP    #15                     ; LOCATE TEXT CURSOR
            LEA     .STR3,A1
            MOVE.B  #13,D0
            TRAP    #15                     ; PRINT THE STRING

            MOVE.W  #((80+12)/2)<<8|17,D1
            MOVE.B  #11,D0
            TRAP    #15                     ; LOCATE TEXT CURSOR
            CLR.L   D1
            MOVE.W  (PLRHEAL),D1
            MOVE.B  #1,D2
            MOVE.B  #20,D0
            TRAP    #15                     ; PRINT PLAYER'S HEALTH
      
            CLR.W   D1
            CLR.L   D2
            MOVE.W  #SCRWIDTH/2-50,D1
            MOVE.W  #3*SCRHEIGH/4-10,D2
            MOVE.W  #SCRWIDTH/2+45,D3
            MOVE.W  #3*SCRHEIGH/4+25,D4
            MOVE.B  #87,D0
            TRAP    #15                     ; PRINT RECTANGLE OF BUTTON
            
            BTST.B  #4,(SCRCYCCT)           ; MAKE THE START STRING FLICK
            BEQ     .END
            
            MOVE.W  #((80-5)/2)<<8|24,D1
            MOVE.B  #11,D0
            TRAP    #15                     ; LOCATE TEXT CURSOR
            LEA     .STR4,A1
            MOVE.B  #13,D0
            TRAP    #15                     ; PRINT THE STRING
.END        MOVEM.L (A7)+,D0-D4/A1
            RTS

.STR0       DC.B    'GET READY...',0
.STR1       DC.B    'YOU BARELY PASSED LEVEL 1... NEXT LEVEL WONT BE THAT EASY...',0
.STR2       DC.B    'YOUR CURRENT SCORE: ',0
.STR3       DC.B    'YOUR CURRENT HEALTH: ',0
.STR4       DC.B    'START',0
            DS.W    0

; =============================================================================
; INITIALITZATION, UPDATE AND PLOT OF SCREEN BETWEEN LEVEL 2 AND LEVEL 3 
; =============================================================================

; -----------------------------------------------------------------------------
STA2TO3I
; GAME INTRODUCTION STATE INITIALIZATION
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.L D0-D2/A1,-(A7)
            MOVE.L  #3,D2
            MOVE.B  #76,D0
            TRAP    #15                     ; STOP ALL SOUNDS
            LEA     .SNDP,A1
            MOVE.B  #71,D0
            MOVE.B  #6,D1
            TRAP    #15                     ; ADD INTRO SOUND TO MEMORY
            MOVE.B  #72,D0
            MOVE.B  #6,D1
            TRAP    #15                     ; PLAY INTRO MUSIC
            MOVEM.L (A7)+,D0-D2/A1
            BRA     DMMINIT
            
.SNDP       DC.B    'SND/toLevel3Sound.wav',0
            DS.W    0
            
; -----------------------------------------------------------------------------
STA2TO3U
; GAME INTRODUCTION STATE UPDATE
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------

            MOVEM.L D0-D1,-(A7)
            BTST    #0,(MOUSSTAT)                ; MOUSE LEFT BUTTON PRESSED?
            BEQ     .END                         ; NO: GO TO END
            MOVE.W  (MOUSPOSX),D0                ; X COORDINATES
            CMP.W   #SCRWIDTH/2-50,D0
            BLE     .END
            CMP.W   #SCRWIDTH/2+45,D0
            BGE     .END
            MOVE.W  (MOUSPOSY),D1                ; Y COORDINATES
            CMP.W   #3*SCRHEIGH/4-10,D1
            BLE     .END
            CMP.W   #3*SCRHEIGH/4+25,D1
            BGE     .END
            MOVE.W  #STAPLN3,(STANEXT)
            CLR.W   (MOUSPOSX)
            CLR.W   (MOUSPOSY)
            CLR.B   (MOUSSTAT)
.END        MOVEM.L (A7)+,D0-D1
            RTS

; -----------------------------------------------------------------------------
STA2TO3P
; GAME INTRODUCTION STATE PLOT
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------

            MOVEM.L D0-D4/A1,-(A7)
            MOVE.W  #((80-26)/2)<<8|10,D1
            MOVE.B  #11,D0
            TRAP    #15                     ; LOCATE TEXT CURSOR
            LEA     .STR0,A1
            MOVE.B  #13,D0
            TRAP    #15                     ; PRINT THE STRING
            
            MOVE.W  #((80-62)/2)<<8|12,D1
            MOVE.B  #11,D0
            TRAP    #15                     ; LOCATE TEXT CURSOR
            LEA     .STR1,A1
            MOVE.B  #13,D0
            TRAP    #15                     ; PRINT THE STRING
            
            MOVE.W  #((80-30)/2)<<8|15,D1
            MOVE.B  #11,D0
            TRAP    #15                     ; LOCATE TEXT CURSOR
            LEA     .STR2,A1
            MOVE.B  #13,D0
            TRAP    #15                     ; PRINT THE STRING
            
            MOVE.W  #((80+12)/2)<<8|15,D1
            MOVE.B  #11,D0
            TRAP    #15                     ; LOCATE TEXT CURSOR
            CLR.L   D1
            MOVE.W  (PLRSCOR),D1
            MOVE.B  #1,D2
            MOVE.B  #20,D0
            TRAP    #15                     ; PRINT PLAYER'S SCORE
                                              
            MOVE.W  #((80-31)/2)<<8|17,D1
            MOVE.B  #11,D0
            TRAP    #15                     ; LOCATE TEXT CURSOR
            LEA     .STR3,A1
            MOVE.B  #13,D0
            TRAP    #15                     ; PRINT THE STRING
            
            MOVE.W  #((80+12)/2)<<8|17,D1
            MOVE.B  #11,D0
            TRAP    #15                     ; LOCATE TEXT CURSOR
            CLR.L   D1
            MOVE.W  (PLRHEAL),D1
            MOVE.B  #1,D2
            MOVE.B  #20,D0
            TRAP    #15                     ; PRINT PLAYER'S HEALTH
                                  
                       
            CLR.W   D1
            CLR.L   D2
            MOVE.W  #SCRWIDTH/2-50,D1
            MOVE.W  #3*SCRHEIGH/4-10,D2
            MOVE.W  #SCRWIDTH/2+45,D3
            MOVE.W  #3*SCRHEIGH/4+25,D4
            MOVE.B  #87,D0
            TRAP    #15                     ; PRINT RECTANGLE OF BUTTON
            
            BTST.B  #4,(SCRCYCCT)           ; MAKE THE START STRING FLICK
            BEQ     .END
            
            MOVE.W  #((80-5)/2)<<8|24,D1
            MOVE.B  #11,D0
            TRAP    #15                     ; LOCATE TEXT CURSOR
            LEA     .STR4,A1
            MOVE.B  #13,D0
            TRAP    #15                     ; PRINT THE STRING
.END        MOVEM.L (A7)+,D0-D4/A1
            RTS

.STR0       DC.B    'LEVEL 2 WAS TOO EASY, HUH?',0
.STR1       DC.B    'GET READY... BECAUSE YOU WONT LAST A MINUTE WITH THE FINAL BOSS',0
.STR2       DC.B    'YOUR CURRENT SCORE: ',0
.STR3       DC.B    'YOUR CURRENT HEALTH: ',0
.STR4       DC.B    'START',0
            DS.W    0

; =============================================================================
; INITIALITZATION, UPDATE AND PLOT OF LEVEL 1 STATE
; =============================================================================       

; -----------------------------------------------------------------------------
STAPLN1I
; LEVEL 1 GAME STATE INITIALIZATION
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - 68K SOUND MEMORY
; -----------------------------------------------------------------------------
            CLR.B   (NENMLVL)          ; RESET ENEMY COUNTER
            MOVEM.L D0-D2/A1-A3,-(A7)
            MOVE.L  #3,D2
            MOVE.B  #76,D0
            TRAP    #15                ; STOP ALL SOUNDS
            LEA     .SNDP1,A1
            MOVE.B  #71,D0
            MOVE.B  #1,D1
            TRAP    #15                ; ADD SHOT SOUND TO MEMORY
            LEA     .SNDP2,A1
            MOVE.B  #71,D0
            MOVE.B  #2,D1
            TRAP    #15                ; ADD LEVEL 1 EXPLOSION SOUND TO MEMORY
            LEA     .SNDP3,A1
            MOVE.B  #71,D0
            MOVE.B  #3,D1
            TRAP    #15                ; ADD LEVEL 2 EXPLOSION SOUND TO MEMORY
            LEA     .SNDP4,A1
            MOVE.B  #71,D0
            MOVE.B  #4,D1
            TRAP    #15                ; ADD LEVEL 3 EXPLOSION SOUND TO MEMORY
            LEA     .SNDP5,A1
            MOVE.B  #71,D0
            MOVE.B  #9,D1
            TRAP    #15                ; ADD ENEMY HIT SOUND TO MEMORY
            LEA     .SNDP6,A1
            MOVE.B  #71,D0
            MOVE.B  #10,D1
            TRAP    #15                ; ADD PLAYER HIT SOUND TO MEMORY
            
            MOVE.L  #20,D1
            MOVE.W  #STARTYPE,D0
            LEA     STARIN2,A1
            LEA     STARUPDT,A2
            LEA     STARPLOT,A3
.LOOP       JSR     AGLADD
            DBRA    D1,.LOOP
            
            MOVEM.L (A7)+,D0-D2/A1-A3
            BRA     PLRINIT
            
.SNDP1      DC.B    'SND/shotSound.wav',0
.SNDP2      DC.B    'SND/explosionSound.wav',0
.SNDP3      DC.B    'SND/explosion2Sound.wav',0
.SNDP4      DC.B    'SND/explosion3Sound.wav',0
.SNDP5      DC.B    'SND/enemyHitSound.wav',0
.SNDP6      DC.B    'SND/playerHitSound.wav',0
            DS.W    0

; -----------------------------------------------------------------------------
STAPLN1U
; LEVEL 1 GAME STATE UPDATE
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            JSR     SPWNLV1                         
            JSR     PLRUPDT  
            JSR     AGLUPD
            
            BTST    #$0F,(PLRHEAL)      ; IF PLAYER'S HEALTH IS ZERO OR LOWER
            BNE     .CHGSTA             ; CHANGE STATE
            RTS
.CHGSTA     MOVE.W  #STAGAOV,(STANEXT)
            RTS            
 
; -----------------------------------------------------------------------------
STAPLN1P
; LEVEL 1 GAME STATE PLOT
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------

            MOVEM.L D0-D4/A1,-(A7)
            JSR     PLRPLOT
            JSR     AGLPLOT
            UTLSPEN #$00FFFFFF
            UTLSFIL #$00000000
            CLR.W   D1
            MOVE.B  #11,D0
            TRAP    #15                     ; LOCATE SCORE TEXT CURSOR
            LEA     .STR0,A1
            MOVE.B  #13,D0
            TRAP    #15                     ; PRINT SCORE STRING
            MOVE.W  #7<<8|0,D1
            MOVE.B  #11,D0
            TRAP    #15                     ; LOCATE SCORE NUMBER CURSOR
            MOVE.W  (PLRSCOR),D1
            MOVE.B  #1,D2
            MOVE.B  #20,D0
            TRAP    #15                     ; PRINT PLAYERS SCORE
            CLR.B   D2
            MOVE.W  #73<<8|0,D1
            MOVE.B  #11,D0
            TRAP    #15                     ; LOCATE LEVEL TEXT CURSOR
            LEA     .STR1,A1
            MOVE.B  #13,D0
            TRAP    #15                     ; PRINT LEVEL STRING
            UTLSFIL #$000000FF
            MOVE.W  #SCRWIDTH-110,D1
            MOVE.W  D1,D3
            ADD.W   #100,D3
            MOVE.W  #SCRHEIGH-20-10,D2
            MOVE.W  D2,D4
            ADD.W   #20,D4
            MOVE.B  #87,D0
            TRAP    #15                     ; PRINT HEALTH BAR IN RED
            UTLSFIL #$0000FF00
            MOVE.W  #SCRWIDTH-110,D1
            MOVE.W  D1,D3
            ADD.W   (PLRHEAL),D3
            MOVE.B  #87,D0
            TRAP    #15                     ; PRINT ACTUAL HEALTH IN GREEN
            UTLSFIL #$00000000
            LEA     .STR2,A1
            MOVE.W  #SCRWIDTH-140,D1
            ADDQ.W  #2,D2
            MOVE.B  #95,D0
            TRAP    #15                     ; PRINT HEALTH STRING
            MOVEM.L (A7)+,D0-D4/A1
            RTS

.STR0       DC.B    'SCORE: ',0
.STR1       DC.B    'LEVEL 1',0
.STR2       DC.B    'HP',0
            DS.W    0

; =============================================================================
; INITIALITZATION, UPDATE AND PLOT OF LEVEL 2 STATE
; =============================================================================

; -----------------------------------------------------------------------------
STAPLN2I
; LEVEL 2 GAME STATE INITIALIZATION
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            CLR.B   (NENMLVL)               ; RESET ENEMY COUNTER
            MOVE.W  #SCRWIDTH/2,(PLRPOSX)   ; SET PLAYER'S POSITION TO DEFAULT
            MOVE.W  #SCRHEIGH-PLRHEIGH,(PLRPOSY)            
            
            MOVEM.L D0-D2/A1-A3,-(A7)
            MOVE.L  #3,D2
            MOVE.B  #76,D0
            TRAP    #15                     ; STOP ALL SOUNDS
            
            MOVE.L  #20,D1
            MOVE.W  #STARTYPE,D0
            LEA     STARIN2,A1
            LEA     STARUPDT,A2
            LEA     STARPLOT,A3
.LOOP       JSR     AGLADD
            DBRA    D1,.LOOP
            MOVEM.L (A7)+,D0-D2/A1-A3
            RTS

; -----------------------------------------------------------------------------
STAPLN2U
; LEVEL 2 GAME STATE UPDATE
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            JSR     SPWNLV2                         
            JSR     PLRUPDT     
            JSR     AGLUPD
            
            BTST    #$0F,(PLRHEAL)      ; IF PLAYER'S HEALTH IS ZERO OR LOWER
            BNE     .CHGSTA             ; CHANGE STATE
            RTS
.CHGSTA     MOVE.W  #STAGAOV,(STANEXT)
            RTS
          
; -----------------------------------------------------------------------------
STAPLN2P
; LEVEL 2 GAME STATE PLOT
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            
            MOVEM.L D0-D4/A1,-(A7)
            JSR     PLRPLOT
            JSR     AGLPLOT
            UTLSPEN #$00FFFFFF
            UTLSFIL #$00000000
            CLR.W   D1
            MOVE.B  #11,D0
            TRAP    #15                     ; LOCATE SCORE TEXT CURSOR
            LEA     .STR0,A1
            MOVE.B  #13,D0
            TRAP    #15                     ; PRINT SCORE STRING
            MOVE.W  #7<<8|0,D1
            MOVE.B  #11,D0
            TRAP    #15                     ; LOCATE SCORE NUMBER CURSOR
            MOVE.W  (PLRSCOR),D1
            MOVE.B  #1,D2
            MOVE.B  #20,D0
            TRAP    #15                     ; PRINT PLAYERS SCORE
            CLR.B   D2
            MOVE.W  #73<<8|0,D1
            MOVE.B  #11,D0
            TRAP    #15                     ; LOCATE LEVEL TEXT CURSOR
            LEA     .STR1,A1
            MOVE.B  #13,D0
            TRAP    #15                     ; PRINT LEVEL STRING
            UTLSFIL #$000000FF
            MOVE.W  #SCRWIDTH-110,D1
            MOVE.W  D1,D3
            ADD.W   #100,D3
            MOVE.W  #SCRHEIGH-20-10,D2
            MOVE.W  D2,D4
            ADD.W   #20,D4
            MOVE.B  #87,D0
            TRAP    #15                     ; PRINT HEALTH BAR IN RED
            UTLSFIL #$0000FF00
            MOVE.W  #SCRWIDTH-110,D1
            MOVE.W  D1,D3
            ADD.W   (PLRHEAL),D3
            MOVE.B  #87,D0
            TRAP    #15                     ; PRINT ACTUAL HEALTH IN GREEN
            UTLSFIL #$00000000
            LEA     .STR2,A1
            MOVE.W  #SCRWIDTH-140,D1
            ADDQ.W  #2,D2
            MOVE.B  #95,D0
            TRAP    #15                     ; PRINT HEALTH STRING
            MOVEM.L (A7)+,D0-D4/A1
            RTS

.STR0       DC.B    'SCORE: ',0
.STR1       DC.B    'LEVEL 2',0
.STR2       DC.B    'HP',0
            DS.W    0

; =============================================================================
; INITIALITZATION, UPDATE AND PLOT OF LEVEL 3 STATE
; =============================================================================

; -----------------------------------------------------------------------------
STAPLN3I
; LEVEL 3 GAME STATE INITIALIZATION
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            CLR.B   (NENMLVL)               ; RESET ENEMY COUNTER
            CLR.B   (BOSKILL)               ; RESET BOSSES KILLED COUNTER
            MOVE.W  #SCRWIDTH/2,(PLRPOSX)   ; SET PLAYER'S POSITION TO DEFAULT
            MOVE.W  #SCRHEIGH-PLRHEIGH,(PLRPOSY)
            
            MOVEM.L D0-D2/A1-A3,-(A7)
            MOVE.L  #3,D2
            MOVE.B  #76,D0
            TRAP    #15                     ; STOP ALL SOUNDS
            
            MOVE.L  #20,D1
            MOVE.W  #STARTYPE,D0
            LEA     STARIN2,A1
            LEA     STARUPDT,A2
            LEA     STARPLOT,A3
.LOOP       JSR     AGLADD
            DBRA    D1,.LOOP
            
            MOVEM.L (A7)+,D0-D2/A1-A3
            RTS


; -----------------------------------------------------------------------------
STAPLN3U
; LEVEL 3 GAME STATE UPDATE
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            JSR     SPWNLV3
            JSR     PLRUPDT
            JSR     AGLUPD
            
            BTST    #$0F,(PLRHEAL)      ; IF PLAYER'S HEALTH IS ZERO OR LOWER
            BNE     .CHGSTA             ; CHANGE STATE
            RTS
.CHGSTA     MOVE.W  #STAGAOV,(STANEXT)
            RTS
          
; -----------------------------------------------------------------------------
STAPLN3P
; LEVEL 3 GAME STATE PLOT
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            
            MOVEM.L D0-D4/A1,-(A7)
            JSR     PLRPLOT
            JSR     AGLPLOT
            UTLSPEN #$00FFFFFF
            UTLSFIL #$00000000
            CLR.W   D1
            MOVE.B  #11,D0
            TRAP    #15                     ; LOCATE SCORE TEXT CURSOR
            LEA     .STR0,A1
            MOVE.B  #13,D0
            TRAP    #15                     ; PRINT SCORE STRING
            MOVE.W  #7<<8|0,D1
            MOVE.B  #11,D0
            TRAP    #15                     ; LOCATE SCORE NUMBER CURSOR
            MOVE.W  (PLRSCOR),D1
            MOVE.B  #1,D2
            MOVE.B  #20,D0
            TRAP    #15                     ; PRINT PLAYERS SCORE
            CLR.B   D2
            MOVE.W  #73<<8|0,D1
            MOVE.B  #11,D0
            TRAP    #15                     ; LOCATE LEVEL TEXT CURSOR
            LEA     .STR1,A1
            MOVE.B  #13,D0
            TRAP    #15                     ; PRINT LEVEL STRING
            UTLSFIL #$000000FF
            MOVE.W  #SCRWIDTH-110,D1
            MOVE.W  D1,D3
            ADD.W   #100,D3
            MOVE.W  #SCRHEIGH-20-10,D2
            MOVE.W  D2,D4
            ADD.W   #20,D4
            MOVE.B  #87,D0
            TRAP    #15                     ; PRINT HEALTH BAR IN RED
            UTLSFIL #$0000FF00
            MOVE.W  #SCRWIDTH-110,D1
            MOVE.W  D1,D3
            ADD.W   (PLRHEAL),D3
            MOVE.B  #87,D0
            TRAP    #15                     ; PRINT ACTUAL HEALTH IN GREEN
            UTLSFIL #$00000000
            LEA     .STR2,A1
            MOVE.W  #SCRWIDTH-140,D1
            ADDQ.W  #2,D2
            MOVE.B  #95,D0
            TRAP    #15                     ; PRINT HEALTH STRING
            MOVEM.L (A7)+,D0-D4/A1
            RTS

.STR0       DC.B    'SCORE: ',0
.STR1       DC.B    'LEVEL 3',0
.STR2       DC.B    'HP',0
            DS.W    0


; =============================================================================
; INITIALITZATION, UPDATE AND PLOT OF WINNING SCREEN STATE
; =============================================================================

; -----------------------------------------------------------------------------
STAWONI
; WINNING SCREEN STATE INITIALIZATION
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------   

            MOVEM.L D0-D4/A1,-(A7)
            MOVE.L  #3,D2
            MOVE.B  #76,D0
            TRAP    #15                     ; STOP ALL SOUNDS
            CLR.L   D2
            LEA     .SNDP,A1
            MOVE.B  #71,D0
            MOVE.B  #66,D1
            TRAP    #15                     ; ADD WINNING SOUND TO MEMORY
            ADDQ.B  #1,D0
            TRAP    #15                     ; PLAY MUSIC
            CLR.B   D1
            CLR.L   D2
            JSR     UTLFILI
            LEA     .FILE,A1
            LEA     .BUFFER,A2
            MOVE.L  #4,D2
            JSR     UTLFILR                 ; READ LAST SCORE
            MOVE.L  (.BUFFER),D3
            MOVE.W  D3,(LASHEAL)
            MOVE.B  #16,D4
            LSR.L   D4,D3
            MOVE.W  D3,(LASSCOR)
            BTST    #15,(LASSCOR)
            BEQ     .NOT0
            MOVE.W  #0,(LASSCOR)
.NOT0       BTST    #15,(LASHEAL)
            BEQ     .END
            MOVE.W  #0,(LASHEAL)
.END        CLR.L   (.BUFFER)
            CLR.L   D3
            MOVE.W  (PLRSCOR),D3
            LSL.L   D4,D3
            MOVE.W  (PLRHEAL),D3
            MOVE.L  D3,(.BUFFER)
            JSR     UTLFILW                 ; WRITE ACTUAL HEALTH IN FILE
            CLR.L   (.BUFFER)
            MOVEM.L (A7)+,D0-D4/A1
            RTS

.SNDP       DC.B    'SND/winSound.wav',0
.FILE       DC.B    'SAVE/scores.bin',0
            DS.W    0
.BUFFER     DS.L    1
            
; -----------------------------------------------------------------------------
STAWONU
; WINNING SCREEN STATE UPDATE
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------

            MOVEM.L D0-D1,-(A7)
            BTST.B  #0,(MOUSSTAT)                ; MOUSE LEFT BUTTON PRESSED?
            BEQ     .END                         ; NO: GO TO END
            MOVE.W  (MOUSPOSX),D0                ; X COORDINATES
            CMP.W   #SCRWIDTH/2-50,D0
            BLE     .END
            CMP.W   #SCRWIDTH/2+45,D0
            BGE     .END
            MOVE.W  (MOUSPOSY),D1                ; Y COORDINATES
            CMP.W   #3*SCRHEIGH/4-10,D1
            BLE     .END
            CMP.W   #3*SCRHEIGH/4+25,D1
            BGE     .END
            MOVE.W  #STAINTR,(STANEXT)
            CLR.W   (MOUSPOSX)
            CLR.W   (MOUSPOSY)
            CLR.B   (MOUSSTAT)
.END        MOVEM.L (A7)+,D0-D1
            RTS

; -----------------------------------------------------------------------------
STAWONP
; WINNING SCREEN STATE PLOT
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------

            MOVEM.L D0-D4/A1,-(A7)
            MOVE.W  #((80-16)/2)<<8|10,D1
            MOVE.B  #11,D0
            TRAP    #15                     ; LOCATE TEXT CURSOR
            LEA     .STR0,A1
            MOVE.B  #13,D0
            TRAP    #15                     ; PRINT THE STRING
            MOVE.W  #((80-53)/2)<<8|12,D1
            MOVE.B  #11,D0
            TRAP    #15                     ; LOCATE TEXT CURSOR
            LEA     .STR1,A1
            MOVE.B  #13,D0
            TRAP    #15                     ; PRINT THE STRING
            
            MOVE.W  #((80-15)/2)<<8|15,D1
            MOVE.B  #11,D0
            TRAP    #15                     ; LOCATE TEXT CURSOR
            LEA     .STR3,A1
            MOVE.B  #13,D0
            TRAP    #15                     ; PRINT THE STRING

            MOVE.W  #46<<8|15,D1
            MOVE.B  #11,D0
            TRAP    #15                     ; LOCATE TEXT CURSOR
            CLR.L   D1
            MOVE.W  (LASSCOR),D1
            MOVE.B  #3,D2
            MOVE.B  #20,D0
            TRAP    #15                     ; PRINT PLAYERS SCORE
            
            MOVE.W  #((80-16)/2)<<8|16,D1
            MOVE.B  #11,D0
            TRAP    #15                     ; LOCATE TEXT CURSOR
            LEA     .STR4,A1
            MOVE.B  #13,D0
            TRAP    #15                     ; PRINT THE STRING

            MOVE.W  #46<<8|16,D1
            MOVE.B  #11,D0
            TRAP    #15                     ; LOCATE TEXT CURSOR
            CLR.L   D1
            MOVE.W  (LASHEAL),D1
            MOVE.B  #3,D2
            MOVE.B  #20,D0
            TRAP    #15                     ; PRINT PLAYERS SCORE
            
            
            MOVE.W  #((80-15)/2)<<8|18,D1
            MOVE.B  #11,D0
            TRAP    #15                     ; LOCATE TEXT CURSOR
            LEA     .STR5,A1
            MOVE.B  #13,D0
            TRAP    #15                     ; PRINT THE STRING

            MOVE.W  #46<<8|18,D1
            MOVE.B  #11,D0
            TRAP    #15                     ; LOCATE TEXT CURSOR
            CLR.L   D1
            MOVE.W  (PLRSCOR),D1
            MOVE.B  #3,D2
            MOVE.B  #20,D0
            TRAP    #15                     ; PRINT PLAYERS SCORE
            
            MOVE.W  #((80-16)/2)<<8|19,D1
            MOVE.B  #11,D0
            TRAP    #15                     ; LOCATE TEXT CURSOR
            LEA     .STR6,A1
            MOVE.B  #13,D0
            TRAP    #15                     ; PRINT THE STRING

            MOVE.W  #46<<8|19,D1
            MOVE.B  #11,D0
            TRAP    #15                     ; LOCATE TEXT CURSOR
            CLR.L   D1
            MOVE.W  (PLRHEAL),D1
            MOVE.B  #3,D2
            MOVE.B  #20,D0
            TRAP    #15                     ; PRINT PLAYERS SCORE

            
            CLR.W   D1
            MOVE.W  #SCRWIDTH/2-50,D1
            MOVE.W  #3*SCRHEIGH/4-10,D2
            MOVE.W  #SCRWIDTH/2+50,D3
            MOVE.W  #3*SCRHEIGH/4+25,D4
            MOVE.B  #87,D0
            TRAP    #15                     ; PRINT RECTANGLE OF BUTTON
            
            BTST.B  #4,(SCRCYCCT)           ; MAKE THE PLAY AGAIN STRING FLICK
            BEQ     .END
            
            MOVE.W  #((80-10)/2)<<8|24,D1
            MOVE.B  #11,D0
            TRAP    #15                     ; LOCATE TEXT CURSOR
            LEA     .STR2,A1
            MOVE.B  #13,D0
            TRAP    #15                     ; PRINT THE STRING
.END        MOVEM.L (A7)+,D0-D4/A1
            RTS

.STR0       DC.B    'YOU REACHED MARS',0
.STR1       DC.B    'NOW YOU CAN CODE THIS GAME AGAIN WITH BETTER GRAPHICS',0
.STR2       DC.B    'PLAY AGAIN',0
.STR3       DC.B    'LAST SCORE: ',0
.STR4       DC.B    'LAST HEALTH: ',0
.STR5       DC.B    'YOUR SCORE: ',0
.STR6       DC.B    'YOUR HEALTH: ',0
            DS.W    0


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
