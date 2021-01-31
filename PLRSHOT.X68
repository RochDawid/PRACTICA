; =============================================================================
; PLAYER SHOT MANAGEMENT. IT IS AN AGENT.
; LOCAL MEMORY IS:
;                  - +0 WORD X COORDINATE
;                  - +2 WORD Y COORDINATE
; =============================================================================

; -----------------------------------------------------------------------------
PLRSHOI
; PLAYER SHOT INITIALIZATION
; INPUT: A0 POINTER TO THE LOCAL MEMORY
; OUTPUT: NONE
; MODIFIES: NONE
; -----------------------------------------------------------------------------
    
        MOVE.W  (PLRPOSX),(A0)
        ADD.W   #(6*(PLRWIDTH/13)),(A0)
        MOVE.W  (PLRPOSY),2(A0)
        SUB.W   #(2*(PLRWIDTH/13)),2(A0)
        RTS
        
        
    
; -----------------------------------------------------------------------------
PLRSHOU
; PLAYER SHOT UPDATE
; INPUT: A0 POINTER TO THE LOCAL MEMORY
; OUTPUT: NONE
; MODIFIES: NONE
; -----------------------------------------------------------------------------

            SUB.W   #PLRSHSP,2(A0)          ; MOVE
            TST.W   2(A0)                   ; KILL IF OUT OF SCREEN
            BLT     AGLKILL
            
            MOVEM.L A0-A1/D0-D7,-(A7)
            MOVE.W  (A0),D2                 ; PREPARE SHOT COORDINATES FOR
            MOVE.W  2(A0),D3                ; COLLISION CHECK
            MOVE.W  #PLRSHWI,D5
            MOVE.W  #PLRHEIGH,D7
            MOVE.L  A0,A1
            
            MOVE.W  #EN1TYPE,D0             ; LOOP THROUGH ALL ENEMIES
            JSR     DMMFRSTO
.LOOP       CMP.L   #0,A0
            BEQ     .LOOP2
            MOVE.W  8(A0),D0
            MOVE.W  10(A0),D1
            MOVE.W  #EN1WIDTH,D4
            MOVE.W  #EN1HEIGH,D6
            JSR     UTLCHCOL
            TST.B   D0
            BNE     .HIT                    ; IF COLLISION, HIT IT
            MOVE.W  #EN1TYPE,D0
            JSR     DMMNEXTO
            BRA     .LOOP
            
.LOOP2      MOVE.W  #EN2TYPE,D0             ; LOOP THROUGH ALL ENEMIES
            JSR     DMMFRSTO
.LOOP3      CMP.L   #0,A0
            BEQ     .LOOP4
            MOVE.W  8(A0),D0
            MOVE.W  10(A0),D1
            MOVE.W  #EN2WIDTH,D4
            MOVE.W  #EN2HEIGH,D6
            JSR     UTLCHCOL
            TST.B   D0
            BNE     .HIT2                   ; IF COLLISION, HIT IT
            MOVE.W  #EN2TYPE,D0
            JSR     DMMNEXTO
            BRA     .LOOP3

.LOOP4      MOVE.W  #EN3TYPE,D0             ; LOOP THROUGH ALL ENEMIES
            JSR     DMMFRSTO
.LOOP5      CMP.L   #0,A0
            BEQ     .END
            MOVE.W  8(A0),D0
            MOVE.W  10(A0),D1
            MOVE.W  #EN3WIDTH,D4
            MOVE.W  #EN3HEIGH,D6
            JSR     UTLCHCOL
            TST.B   D0
            BNE     .HIT3                   ; IF COLLISION, HIT IT
            MOVE.W  #EN3TYPE,D0
            JSR     DMMNEXTO
            BRA     .LOOP5
                   

.END2       MOVE.L  A1,A0
            JSR     AGLKILL                 ; DESTROY SHOT
.END        MOVEM.L (A7)+,A0-A1/D0-D7
            RTS

.HIT        ADD.L   #8,A0
            JSR     AGLKILL                 ; DELETE LEVEL 1 ENEMY
            MOVE.L  #3,D2
            MOVE.B  #76,D0
            TRAP    #15                     ; STOP ALL SOUNDS
            MOVE.B  #2,D1
            MOVE.B  #72,D0
            TRAP    #15                     ; PLAY EXPLOSION SOUND
            ADD.W   #EN1SCORE,(PLRSCOR)     ; INCREASE SCORE
            BRA     .END2
            
.HIT2       ADD.L   #8,A0
            SUBQ.B  #1,8(A0)
            BNE     .NBOOM
            JSR     AGLKILL                 ; DELETE LEVEL 2 ENEMY
            MOVE.L  #3,D2
            MOVE.B  #76,D0
            TRAP    #15                     ; STOP ALL SOUNDS
            MOVE.B  #3,D1
            MOVE.B  #72,D0
            TRAP    #15                     ; PLAY EXPLOSION SOUND
            ADD.W   #EN2SCORE,(PLRSCOR)     ; INCREASE SCORE
            BRA     .END2
            
.NBOOM      MOVE.L  #3,D2
            MOVE.B  #76,D0
            TRAP    #15                     ; STOP ALL SOUNDS
            MOVE.B  #9,D1
            MOVE.B  #72,D0
            TRAP    #15                     ; PLAY HIT SOUND
            BRA     .END2

.HIT3       ADD.L   #8,A0
            SUBQ.B  #1,8(A0)
            BNE     .NBOOM
            JSR     AGLKILL                 ; DELETE LEVEL 3 ENEMY
            MOVE.L  #3,D2
            MOVE.B  #76,D0
            TRAP    #15                     ; STOP ALL SOUNDS
            MOVE.B  #4,D1
            MOVE.B  #72,D0
            TRAP    #15                     ; PLAY EXPLOSION SOUND
            ADD.W   #EN3SCORE,(PLRSCOR)     ; INCREASE SCORE
            ADDQ.B  #1,(BOSKILL)            ; INCREASE NUMBER OF BOSSES KILLED
            BRA     .END2

; -----------------------------------------------------------------------------
PLRSHOP
; PLAYER SHOT PLOT
; INPUT: A0 POINTER TO THE LOCAL MEMORY
; OUTPUT: NONE
; MODIFIES: NONE
; -----------------------------------------------------------------------------
        
        MOVEM.L     A0/D0-D4,-(A7)
        UTLSPEN     #$00FFFFFF
        UTLSFIL     #$0000FFFF
        MOVE.W      (A0)+,D1
        MOVE.W      (A0),D2
        MOVE.W      D1,D3
        MOVE.W      D2,D4
        ADD.W       #PLRSHWI,D3
        ADD.W       #PLRSHHE,D4
        MOVE.B      #87,D0
        TRAP        #15
        MOVEM.L     (A7)+,A0/D0-D4
        RTS




*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
