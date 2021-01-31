; =============================================================================
; LEVEL 2 ENEMY MANAGEMENT. IT IS AN AGENT.
; LOCAL MEMORY IS:
;                  - +0 WORD X COORDINATE
;                  - +2 WORD Y COORDINATE
;                  - +4 WORD X SPEED
;                  - +6 WORD Y SPEED
;                  - +8 BYTE HITS NEEDED TO DIE
; =============================================================================

; -----------------------------------------------------------------------------
EN2INIT
; INITALIZES A LEVEL 2 ENEMY
; INPUT    - A0 POINTER TO THE LOCAL MEMORY
; OUTPUT   - NONE
; MODIFIES - NONE
; NOTE     - ASSUMES SCRHEIGH IS GREATER THAN 255
; -----------------------------------------------------------------------------

            MOVE.W  D0,-(A7)
            JSR     UTLRAND
            LSL     #1,D0
            MOVE.W  D0,(A0)                 ; X POSITION (PSEUDO-RANDOM)
            MOVE.W  #EN2HEIGH/2,2(A0)       ; Y POSITION
            MOVE.B  D1,8(A0)                ; NUMBER OF SHOTS TO KILL
         
            JSR     UTLRAND
            AND.W   #$0004,D0               ; Y SPEED (PSEUDO-RANDOM)
            ADDQ.B  #2,D0            
            MOVE.W  D0,6(A0)
            
            JSR     UTLRAND
            AND.W   #$0001,D0
            ADDQ.B  #1,D0
            CMP     #1,D0
            BEQ     .LEFT
            
            JSR     UTLRAND
            AND.W   #$0008,D0
            MOVE.W  D0,4(A0)                ; X SPEED (PSEUDO-RANDOM)
            BRA     .END

.LEFT       JSR     UTLRAND
            AND.W   #$000A,D0
            NEG     D0
            MOVE.W  D0,4(A0)

.END        MOVE.W  (A7)+,D0
            RTS

; -----------------------------------------------------------------------------
EN2UPDT
; UPDATES A LEVEL 2 ENEMY
; INPUT    - A0 POINTER TO THE LOCAL MEMORY
; OUTPUT   - NONE
; MODIFIES - NONE
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
            MOVE.W  #EN2WIDTH,D4
            MOVE.W  #EN2HEIGH,D6
            JSR     UTLCHCOL
            TST.B   D0
            BNE     .COL                        ; COLLISION?

            CMP.W   #1,(A0)                     ; CHECK LEFT BOUNDARY
            BLT     .BOUNCEL                    ; IF COLLISION -> BOUNCE
            
            CMP.W   #SCRWIDTH-1-EN2WIDTH,(A0)   ; CHECK RIGHT BOUNDARY
            BGT     .BOUNCER                    ; IF COLLISION -> BOUNCE
            
            CMP.W   #SCRHEIGH-1-EN2HEIGH,2(A0)  ; CHECK BOTTOM BOUNDARY
            BGT     .BOUNCEB                    ; IF COLLISION -> BOUNCE
            BRA     .END

.BOUNCEL    NEG     4(A0)                       ; BOUNCE
            BRA     .END   

.BOUNCER    MOVE.W  #SCRWIDTH-1-EN2WIDTH,(A0)   ; ADJUST X
            NEG     4(A0)                       ; BOUNCE
            BRA     .END

.BOUNCEB    JSR     AGLKILL
            BRA     .END
            
.COL        SUB.W   #EN2DMGPW,(PLRHEAL)         ; YES: MAKE DAMAGE TO PLAYER

.END        MOVEM.L (A7)+,D0-D7
            RTS

; -----------------------------------------------------------------------------
EN2PLOT
; PLOTS A LEVEL 2 ENEMY
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------

            MOVEM.L D0-D4,-(A7)
            UTLSPEN #EN2PURPL
            UTLSFIL #EN2PURPL
            CLR     D0
            MOVE.W  (A0),D1          ; INTITIALIZE D1 AND D2 WITH XPOS AND YPOS
            MOVE.W  2(A0),D2           
            MOVE.W  D1,D3                       
            MOVE.W  D2,D4
            
            ADD.W   #(5*(EN2WIDTH/16)),D1
            ADD.W   #(11*(EN2WIDTH/16)),D3          ; WE PAINT THE ENEMIES HEAD    
            ADD.W   #(6*(EN2WIDTH/16)),D4           
            MOVE.B  #87,D0
            TRAP    #15
            
            SUB.W   #(2*(EN2WIDTH/16)),D1           ; LEFT SHOULDER PART 1
            ADD.W   #(2*(EN2WIDTH/16)),D2
            SUB.W   #(6*(EN2WIDTH/16)),D3            
            SUB.W   #(2*(EN2WIDTH/16)),D4  
            MOVE.B  #87,D0
            TRAP    #15
            
            ADD.W   #(8*(EN2WIDTH/16)),D1           ; RIGHT SHOULDER PART 1  
            ADD.W   #(8*(EN2WIDTH/16)),D3            
            MOVE.B  #87,D0
            TRAP    #15
            
            ADD.W   #(EN2WIDTH/16),D1               ; RIGHT SHOULDER PART 2
            ADD.W   #(EN2WIDTH/16),D2
            ADD.W   #(2*(EN2WIDTH/16)),D3            
            ADD.W   #(EN2WIDTH/16),D4  
            MOVE.B  #87,D0
            TRAP    #15
            
            SUB.W   #(11*(EN2WIDTH/16)),D1          ; LEFT SHOULDER PART 2   
            SUB.W   #(11*(EN2WIDTH/16)),D3            
            MOVE.B  #87,D0
            TRAP    #15
            
            SUB.W   #(EN2WIDTH/16),D1               ; LEFT ARM   
            ADD.W   #(EN2WIDTH/16),D2
            SUB.W   #(2*(EN2WIDTH/16)),D3            
            ADD.W   #(7*(EN2WIDTH/16)),D4  
            MOVE.B  #87,D0
            TRAP    #15
            
            ADD.W   #(14*(EN2WIDTH/16)),D1          ; RIGHT ARM   
            ADD.W   #(14*(EN2WIDTH/16)),D3            
            MOVE.B  #87,D0
            TRAP    #15
            
            SUB.W   #(EN2WIDTH/16),D1               ; RIGHT HAND PART 1  
            ADD.W   #(7*(EN2WIDTH/16)),D2
            SUB.W   #(EN2WIDTH/16),D3            
            ADD.W   #(EN2WIDTH/16),D4  
            MOVE.B  #87,D0
            TRAP    #15
            
            SUB.W   #(12*(EN2WIDTH/16)),D1          ; LEFT HAND PART 1
            SUB.W   #(12*(EN2WIDTH/16)),D3            
            MOVE.B  #87,D0
            TRAP    #15
            
            ADD.W   #(EN2WIDTH/16),D1               ; LEFT HAND PART 2
            ADD.W   #(EN2WIDTH/16),D2
            ADD.W   #(EN2WIDTH/16),D3            
            ADD.W   #(EN2WIDTH/16),D4  
            MOVE.B  #87,D0
            TRAP    #15
            
            ADD.W   #(10*(EN2WIDTH/16)),D1          ; RIGHT HAND PART 2   
            ADD.W   #(10*(EN2WIDTH/16)),D3            
            MOVE.B  #87,D0
            TRAP    #15
            
            UTLSPEN #EN2YELLO
            UTLSFIL #EN2YELLO
            CLR     D0
            MOVE.W  (A0),D1       ; INTITIALIZE D1 AND D2 WITH XPOS AND YPOS
            MOVE.W  2(A0),D2
            MOVE.W  D1,D3                       
            MOVE.W  D2,D4
            
            ADD.W   #(6*(EN2WIDTH)/16),D1               ; TOP LEFT EYE
            ADD.W   #(EN2WIDTH/16),D2
            ADD.W   #(7*(EN2WIDTH/16)),D3            
            ADD.W   #(2*(EN2WIDTH/16)),D4  
            MOVE.B  #87,D0
            TRAP    #15
            
            ADD.W   #(3*(EN2WIDTH/16)),D1           ; TOP RIGHT EYE
            ADD.W   #(3*(EN2WIDTH/16)),D3            
            MOVE.B  #87,D0
            TRAP    #15
            
            ADD.W   #(3*(EN2WIDTH/16)),D2           ; BOTTOM RIGHT EYE
            ADD.W   #(3*(EN2WIDTH/16)),D4           
            MOVE.B  #87,D0
            TRAP    #15
            
            SUB.W   #(3*(EN2WIDTH/16)),D1           ; BOTTOM LEFT EYE
            SUB.W   #(3*(EN2WIDTH/16)),D3            
            MOVE.B  #87,D0
            TRAP    #15
            
            ADD.W   #(EN2WIDTH/16),D1               ; MIDDLE EYE
            SUB.W   #(2*(EN2WIDTH/16)),D2        
            ADD.W   #(2*(EN2WIDTH/16)),D3
            SUB.W   #(EN2WIDTH/16),D4            
            MOVE.B  #87,D0
            TRAP    #15
            MOVEM.L (A7)+,D0-D4
            RTS

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
