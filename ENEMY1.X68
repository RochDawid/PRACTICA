; =============================================================================
; LEVEL 1 ENEMY MANAGEMENT. IT IS AN AGENT.
; LOCAL MEMORY IS:
;                  - +0 WORD X COORDINATE
;                  - +2 WORD Y COORDINATE
;                  - +4 WORD X SPEED
;                  - +6 WORD Y SPEED
; =============================================================================

; -----------------------------------------------------------------------------
EN1INIT
; INITALIZES AN ASTEROID
; INPUT    - A0 POINTER TO THE LOCAL MEMORY
; OUTPUT   - NONE
; MODIFIES - NONE
; NOTE     - ASSUMES SCRHEIGH IS GREATER THAN 255
; -----------------------------------------------------------------------------
            MOVE.W  D0,-(A7)
.OUT        JSR     UTLRAND   
            LSL     #2,D0  
            CMP.W   #SCRWIDTH,D0
            BGE     .OUT 
     
            MOVE.W  D0,(A0)                 ; X POSITION (PSEUDO-RANDOM)
            MOVE.W  #EN1HEIGH/2, 2(A0)      ; Y POSITION   
         
            JSR     UTLRAND
            AND.W   #$0001,D0               ; Y SPEED (PSEUDO-RANDOM)
            ADDQ.B  #2,D0
            MOVE.W  D0,6(A0)
            
            JSR     UTLRAND
            AND.W   #$0001,D0
            ADDQ.B  #1,D0
            CMP     #1,D0
            BEQ     .LEFT
            
            JSR     UTLRAND
            AND.W   #$0005,D0
            MOVE.W  D0,4(A0)                ; X SPEED (PSEUDO-RANDOM)
            BRA     .END
            
.LEFT       JSR     UTLRAND
            AND.W   #$0005,D0
            NEG     D0
            MOVE.W  D0,4(A0)
            
.END        MOVE.W  (A7)+,D0
            RTS

; -----------------------------------------------------------------------------
EN1UPDT
; UPDATES AN ASTEROID
; INPUT    - A0 POINTER TO THE LOCAL MEMORY
; OUTPUT   - NONE
; MODIFIES - A0
; -----------------------------------------------------------------------------
           
            MOVEM.L D0-D7,-(A7)
            MOVE.W  (A0),D0
            ADD.W   4(A0),D0
            MOVE.W  D0,(A0)                     ; X:=X+VX
            MOVE.W  2(A0),D0
            ADD.W   6(A0),D0
            MOVE.W  D0,2(A0)                    ; Y:=Y+VY
            
            CLR.W   D0
            MOVE.W  (A0),D0
            MOVE.W  2(A0),D1
            MOVE.W  (PLRPOSX),D2
            MOVE.W  (PLRPOSY),D3
            MOVE.W  #PLRWIDTH,D5
            MOVE.W  #PLRHEIGH,D7
            MOVE.W  #EN1WIDTH,D4
            MOVE.W  #EN1HEIGH,D6
            JSR     UTLCHCOL
            TST.B   D0
            BNE     .COL                        ; COLLISION?
            
            CMP.W   #1,(A0)                     ; CHECK LEFT BOUNDARY
            BLT     .BOUNCEL                    ; IF COLLISION -> BOUNCE
            CMP.W   #SCRWIDTH-1-EN1WIDTH,(A0)   ; CHECK RIGHT BOUNDARY
            BGT     .BOUNCER                    ; IF COLLISION -> BOUNCE
            CMP.W   #SCRHEIGH-1-EN1HEIGH,2(A0)  ; CHECK BOTTOM BOUNDARY
            BGT     .BOUNCEB                    ; IF COLLISION -> BOUNCE
            BRA     .END

.BOUNCEL    NEG 4(A0)                           ; BOUNCE
            BRA     .END   

.BOUNCER    MOVE.W  #SCRWIDTH-1-EN1WIDTH,(A0)   ; ADJUST X
            NEG     4(A0)                       ; BOUNCE
            BRA     .END

.BOUNCEB    JSR     AGLKILL
            BRA     .END

.COL        SUB.W   #EN1DMGPW,(PLRHEAL)         ; YES: MAKE DAMAGE TO PLAYER

.END        MOVEM.L (A7)+,D0-D7
            RTS

; -----------------------------------------------------------------------------
EN1PLOT
; PLOTS A LEVEL 1 ENEMY
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------

            MOVEM.L D0-D4,-(A7)
            UTLSPEN #EN1GREEN
            UTLSFIL #EN1GREEN            
            MOVE.W  (A0),D1          ; INTITIALIZE D1 AND D2 WITH XPOS AND YPOS

            MOVE.W  2(A0),D2          
            MOVE.W  D1,D3                       
            MOVE.W  D2,D4
                                           
            ADD.W   #(EN1WIDTH/4),D2                ; HEAD P11
            ADD.W   #(EN1WIDTH),D3            
            ADD.W   #(6*(EN1WIDTH)/8),D4           
            MOVE.B  #87,D0
            TRAP    #15
                        
            ADD.W   #(EN1WIDTH/8),D1                ; HEAD P2
            SUB.W   #(EN1WIDTH/8),D2
            SUB.W   #(EN1WIDTH/8),D3            
            ADD.W   #(EN1WIDTH/8),D4           
            MOVE.B  #87,D0
            TRAP    #15
            
            
            ADD.W   #(EN1WIDTH/8),D1                ; HEAD P3
            SUB.W   #(EN1WIDTH/8),D2
            SUB.W   #(EN1WIDTH/8),D3            
            ADD.W   #(EN1WIDTH/4),D4           
            MOVE.B  #87,D0
            TRAP    #15
            
            SUB.W   #(EN1WIDTH/8),D1                ; LEFT LEG
            ADD.W   #(EN1WIDTH),D2
            SUB.W   #(EN1WIDTH/2),D3            
            ADD.W   #(EN1WIDTH/8),D4           
            MOVE.B  #87,D0
            TRAP    #15

            SUB.W   #(EN1WIDTH/8),D1                ; LEFT FOOT
            ADD.W   #(EN1WIDTH/8),D2
            SUB.W   #(EN1WIDTH/8),D3            
            ADD.W   #(EN1WIDTH/8),D4           
            MOVE.B  #87,D0
            TRAP    #15
            
            ADD.W   #(EN1WIDTH-EN1WIDTH/8),D1        ; RIGHT FOOT
            ADD.W   #(EN1WIDTH-EN1WIDTH/8),D3            
            MOVE.B  #87,D0
            TRAP    #15
            
            SUB.W   #(EN1WIDTH/8),D1                ; RIGHT LEG
            SUB.W   #(EN1WIDTH/8),D2
            SUB.W   #(EN1WIDTH/8),D3            
            SUB.W   #(EN1WIDTH/8),D4           
            MOVE.B  #87,D0
            TRAP    #15
               
            UTLSPEN #$00FFFFFF              ; RESET PEN AND FILL COLOR TO WHITE
            UTLSFIL #$00FFFFFF             
            
            MOVE.W  (A0),D1          ; INTITIALIZE D1 AND D2 WITH XPOS AND YPOS
            MOVE.W  2(A0),D2 
            MOVE.W  D1,D3                   
            MOVE.W  D2,D4

            
            ADD.W   #(2*(EN1WIDTH/8)),D1        ; EYE
            ADD.W   #(2*(EN1WIDTH/8)),D2           
            ADD.W   #(6*(EN1WIDTH/8)),D3            
            ADD.W   #(7*(EN1WIDTH/8)),D4           
            MOVE.B  #88,D0
            TRAP    #15
            
            UTLSPEN #$00000000              ; RESET PEN AND FILL COLOR TO WHITE
            UTLSFIL #$00000000
            
            MOVE.W  (A0),D1          ; INTITIALIZE D1 AND D2 WITH XPOS AND YPOS
            MOVE.W  2(A0),D2 
            MOVE.W  D1,D3                   
            MOVE.W  D2,D4
            
            ADD.W   #(3*(EN1WIDTH/8)),D1         ; PUPIL
            ADD.W   #(3*(EN1WIDTH/8)),D2           
            ADD.W   #(4*(EN1WIDTH/8)),D3            
            ADD.W   #(5*(EN1WIDTH/8)),D4
            MOVE.B  #87,D0
            TRAP    #15

            ADD.W   #(3*(EN1WIDTH/8)),D1         ; EYEBROW
            SUB.W   #(EN1WIDTH/4),D2
            SUB.W   #(EN1WIDTH/4),D3             
            SUB.W   #(3*(EN1WIDTH/8)),D4      
            MOVE.B  #87,D0
            TRAP    #15
            MOVEM.L (A7)+,D0-D4
            RTS

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
