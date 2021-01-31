; =============================================================================
; LEVEL 3 ENEMY SHOT MANAGEMENT. IT IS AN AGENT.
; LOCAL MEMORY IS:
;                  - +0 WORD X COORDINATE
;                  - +2 WORD Y COORDINATE
;                  - +4 WORD Y SPEED
; =============================================================================

; -----------------------------------------------------------------------------
EN3SHOI
; PLAYER SHOT INITIALIZATION
; INPUT: A0 POINTER TO THE LOCAL MEMORY
; OUTPUT: NONE
; MODIFIES: NONE
; -----------------------------------------------------------------------------
        MOVEM.L D1-D2,-(A7)
        MOVE.W  D1,(A0)                 ; SET X POSITION
        ADD.W   #(EN3WIDTH/2),(A0)
        MOVE.W  D2,2(A0)                ; SET Y POSITION
        ADD.W   #EN3HEIGH,2(A0)
        MOVE.W  #EN3SHSP,4(A0)          ; SET Y SPEED
        MOVEM.L (A7)+,D1-D2
        RTS
    
; -----------------------------------------------------------------------------
EN3SHOU
; PLAYER SHOT UPDATE
; INPUT: A0 POINTER TO THE LOCAL MEMORY
; OUTPUT: NONE
; MODIFIES: NONE
; -----------------------------------------------------------------------------

            ADD.W   #EN3SHSP,2(A0)             ; MOVE
            CMP.W   #SCRHEIGH-1-EN3SHHE,2(A0)  ; CHECK BOTTOM BOUNDARY
            BGT     AGLKILL                    ; IF COLLISION -> KILL
            
            MOVEM.L A0-A1/D0-D7,-(A7)
            MOVE.W  (A0),D2                    ; PREPARE SHOT COORDINATES FOR
            MOVE.W  2(A0),D3                   ; COLLISION CHECK
            MOVE.W  #PLRSHWI,D5
            MOVE.W  #PLRHEIGH,D7
            MOVE.L  A0,A1
                         
            CLR.W   D0
            MOVE.W  (A0),D0
            MOVE.W  2(A0),D1
            MOVE.W  (PLRPOSX),D2
            MOVE.W  (PLRPOSY),D3
            MOVE.W  #PLRWIDTH,D5
            MOVE.W  #PLRHEIGH,D7
            MOVE.W  #EN3SHWI,D4
            MOVE.W  #EN3SHHE,D6
            JSR     UTLCHCOL
            TST.B   D0
            BNE     .COL                       ; COLLISION?            
            BRA     .END
            
.COL        SUB.W   #EN3SHDM,(PLRHEAL)         ; YES: MAKE DAMAGE TO PLAYER
            MOVE.L  #3,D2
            MOVE.B  #76,D0
            TRAP    #15                        ; STOP ALL SOUNDS
            MOVE.B  #10,D1
            MOVE.B  #72,D0
            TRAP    #15                        ; PLAY PLAYER HIT SOUND
            
.END2       MOVE.L  A1,A0
            JSR     AGLKILL                    ; DESTROY SHOT
.END        MOVEM.L (A7)+,A0-A1/D0-D7
            RTS


; -----------------------------------------------------------------------------
EN3SHOP
; PLAYER SHOT PLOT
; INPUT: A0 POINTER TO THE LOCAL MEMORY
; OUTPUT: NONE
; MODIFIES: NONE
; -----------------------------------------------------------------------------
        
        MOVEM.L     A0/D0-D4,-(A7)
        UTLSPEN     #$00FFFFFF
        UTLSFIL     #$000000FF
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
