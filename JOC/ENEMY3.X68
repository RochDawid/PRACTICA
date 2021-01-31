; =============================================================================
; LEVEL 3 ENEMY MANAGEMENT. IT IS AN AGENT.
; LOCAL MEMORY IS:
;                  - +0 WORD X COORDINATE
;                  - +2 WORD Y COORDINATE
;                  - +4 WORD X SPEED
;                  - +6 WORD Y SPEED
;                  - +8 BYTE HITS NEEDED TO DIE
; =============================================================================

; -----------------------------------------------------------------------------
EN3INIT
; INITALIZES A LEVEL 3 ENEMY
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
            AND.W   #$0001,D0               ; Y SPEED (PSEUDO-RANDOM)
            ADDQ.B  #$0001,D0           
            MOVE.W  D0,6(A0) 
           
            JSR     UTLRAND
            AND.W   #$0001,D0
            ADDQ.B  #1,D0
            CMP     #1,D0
            BEQ     .LEFT
            
            JSR     UTLRAND
            AND.W   #$0007,D0
            ADDQ.B  #$0001,D0
            MOVE.W  D0,4(A0)                ; X SPEED (PSEUDO-RANDOM)
            BRA     .END

.LEFT       JSR     UTLRAND
            AND.W   #$000A,D0
            NEG     D0
            MOVE.W  D0,4(A0)

.END        MOVE.W  (A7)+,D0
            RTS

; -----------------------------------------------------------------------------
EN3UPDT
; UPDATES A LEVEL 3 ENEMY
; INPUT    - A0 POINTER TO THE LOCAL MEMORY
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
           
            MOVEM.L D0-D7/A1-A3,-(A7)    
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
            MOVE.W  #EN3WIDTH,D4
            MOVE.W  #EN3HEIGH,D6
            JSR     UTLCHCOL
            TST.B   D0
            BNE     .COL                        ; COLLISION?

            CMP.W   #1,(A0)                     ; CHECK LEFT BOUNDARY
            BLT     .BOUNCEL                    ; IF COLLISION -> BOUNCE
            
            CMP.W   #SCRWIDTH-1-EN3WIDTH,(A0)   ; CHECK RIGHT BOUNDARY
            BGT     .BOUNCER                    ; IF COLLISION -> BOUNCE
            
            CMP.W   #SCRHEIGH-1-EN3HEIGH,2(A0)  ; CHECK BOTTOM BOUNDARY
            BGT     .BOUNCEB                    ; IF COLLISION -> BOUNCE
                        
            CMP.W   #1,2(A0)                    ;CHECK TOP BOUNDARY
            BLT     .BOUNCET                    ; IF COLLISION -> BOUNCE
            BRA     .END

.BOUNCEL    NEG     4(A0)                       ; BOUNCE
            BRA     .END   

.BOUNCER    MOVE.W  #SCRWIDTH-1-EN3WIDTH,(A0)   ; ADJUST X
            NEG     4(A0)                       ; BOUNCE
            BRA     .END

.BOUNCEB    MOVE.W  #SCRHEIGH-1-EN3HEIGH,2(A0)
            NEG     6(A0)
            BRA     .END
            
.BOUNCET    NEG     6(A0)
            BRA     .END
            
.COL        SUB.W   #EN3DMGPW,(PLRHEAL)     ; YES: MAKE DAMAGE TO PLAYER

           

.END        JSR     UTLRAND6
            CMP.B   #2,D0
            BLE     .FAST                   ; SPAWN A SMALL STAR 1/2 TIMES

            CMP.B   #4,D0
            BLE     .MEDIUM                 ; SPAWN A MEDIUM STAR 1/3 TIMES     
        
            MOVE.W  #$5F,D4
            BRA .END2
            
.FAST       MOVE.W  #$1F,D4
            BRA     .END2
.MEDIUM     MOVE.W  #$3F,D4

   
            
.END2       MOVE.B  (SCRCYCCT),D0
            AND     D4,D0                   ; EVERY 32 CYCLES
            BNE     .ENDF                   ; CREATE A NEW SHOT
            
            LEA     EN3SHOI,A1
            LEA     EN3SHOU,A2
            LEA     EN3SHOP,A3
            MOVE.W  #SHT3TYPE,D0
            MOVE.W  (A0),D1
            MOVE.W  2(A0),D2
            JSR     AGLADD
            
            MOVE.L  #3,D2
            MOVE.B  #76,D0
            TRAP    #15                     ; STOP ALL SOUNDS
            MOVE.B  #1,D1
            MOVE.B  #72,D0
            TRAP    #15
           
.ENDF       MOVEM.L (A7)+,D0-D7/A1-A3
            RTS

; -----------------------------------------------------------------------------
EN3PLOT
; PLOTS A LEVEL 3 ENEMY
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; WE MUST PLOT THE ENEMY FROM THE WIDEST POINT SO THE HITBOXES WORK CORRECTLY
; -----------------------------------------------------------------------------

            MOVEM.L D0-D4,-(A7)
            UTLSPEN #EN3GREY1
            UTLSFIL #EN3GREY1
            
            CLR     D0
            MOVE.W  (A0),D1          ; INTITIALIZE D1 AND D2 WITH XPOS AND YPOS
            MOVE.W  2(A0),D2           
            MOVE.W  D1,D3                       
            MOVE.W  D2,D4
            
            ADD.W   #(8*(EN3WIDTH/29)),D1       ; TOP SPIKE P1
            ADD.W   #(9*(EN3WIDTH)/29),D3              
            ADD.W   #(EN3WIDTH/29),D4           
            MOVE.B  #87,D0
            TRAP    #15
            
            ADD.W   #(6*(EN3WIDTH/29)),D1       ; TOP SPIKE P2
            ADD.W   #(6*(EN3WIDTH/29)),D3            
            MOVE.B  #87,D0
            TRAP    #15
            
            ADD.W   #(6*(EN3WIDTH/29)),D1       ; TOP SPIKE P3
            ADD.W   #(6*(EN3WIDTH/29)),D3            
            MOVE.B  #87,D0
            TRAP    #15
            
            
            SUB.W   #(EN3WIDTH/29),D1           ; TOP BASE P3
            ADD.W   #(EN3WIDTH/29),D2
            ADD.W   #(EN3WIDTH/29),D3            
            ADD.W   #(EN3WIDTH/29),D4  
            MOVE.B  #87,D0
            TRAP    #15
            
            SUB.W   #(6*(EN3WIDTH/29)),D1       ; TOP BASE P2   
            SUB.W   #(6*(EN3WIDTH/29)),D3            
            MOVE.B  #87,D0
            TRAP    #15
            
            SUB.W   #(6*(EN3WIDTH/29)),D1       ; TOP BASE P1   
            SUB.W   #(6*(EN3WIDTH/29)),D3            
            MOVE.B  #87,D0
            TRAP    #15
            
            SUB.W   #(2*(EN3WIDTH)/29),D1       ; BODY P1
            ADD.W   #(EN3WIDTH/29),D2
            ADD.W   #(14*(EN3WIDTH)/29),D3            
            ADD.W   #(EN3WIDTH/29),D4  
            MOVE.B  #87,D0
            TRAP    #15
            
            SUB.W   #(EN3WIDTH/29),D1           ; BODY P2
            ADD.W   #(EN3WIDTH/29),D2
            ADD.W   #(EN3WIDTH/29),D3            
            ADD.W   #(EN3WIDTH/29),D4  
            MOVE.B  #87,D0
            TRAP    #15
            
            SUB.W   #(EN3WIDTH/29),D1           ; BODY P3
            ADD.W   #(EN3WIDTH/29),D2
            ADD.W   #(EN3WIDTH/29),D3            
            ADD.W   #(EN3WIDTH/29),D4  
            MOVE.B  #87,D0
            TRAP    #15
            
            SUB.W   #(2*(EN3WIDTH)/29),D1       ; BODY P4
            ADD.W   #(EN3WIDTH/29),D2
            ADD.W   #(2*(EN3WIDTH)/29),D3            
            ADD.W   #(EN3WIDTH/29),D4  
            MOVE.B  #87,D0
            TRAP    #15
            
            SUB.W   #(EN3WIDTH/29),D1           ; BODY P5
            ADD.W   #(EN3WIDTH/29),D2
            ADD.W   #(EN3WIDTH/29),D3            
            ADD.W   #(EN3WIDTH/29),D4  
            MOVE.B  #87,D0
            TRAP    #15
            
            ADD.W   #(4*(EN3WIDTH)/29),D1       ; LEG 1 P1
            ADD.W   #(EN3WIDTH/29),D2
            SUB.W   #(18*(EN3WIDTH)/29),D3            
            ADD.W   #(EN3WIDTH/29),D4  
            MOVE.B  #87,D0
            TRAP    #15
            
            ADD.W   #(EN3WIDTH/29),D1           ; LEG 1 P2
            ADD.W   #(EN3WIDTH/29),D2
            SUB.W   #(EN3WIDTH/29),D3            
            ADD.W   #(EN3WIDTH/29),D4  
            MOVE.B  #87,D0
            TRAP    #15
            
            ADD.W   #(EN3WIDTH/29),D1           ; LEG 1 P3
            ADD.W   #(EN3WIDTH/29),D2
            SUB.W   #(EN3WIDTH/29),D3            
            ADD.W   #(EN3WIDTH/29),D4  
            MOVE.B  #87,D0
            TRAP    #15
            
            ADD.W   #(12*(EN3WIDTH)/29),D1       ; LEG 2 P1
            SUB.W   #(2*(EN3WIDTH)/29),D2
            ADD.W   #(16*(EN3WIDTH)/29),D3            
            SUB.W   #(2*(EN3WIDTH)/29),D4  
            MOVE.B  #87,D0
            TRAP    #15
            
            ADD.W   #(EN3WIDTH/29),D1           ; LEG 2 P2
            ADD.W   #(EN3WIDTH/29),D2
            SUB.W   #(EN3WIDTH/29),D3            
            ADD.W   #(EN3WIDTH/29),D4  
            MOVE.B  #87,D0
            TRAP    #15
            
            ADD.W   #(EN3WIDTH/29),D1           ; LEG 2 P3
            ADD.W   #(EN3WIDTH/29),D2
            SUB.W   #(EN3WIDTH/29),D3            
            ADD.W   #(EN3WIDTH/29),D4  
            MOVE.B  #87,D0
            TRAP    #15
           
            UTLSPEN #EN3GREY2
            UTLSFIL #EN3GREY2
            CLR     D0
            MOVE.W  (A0),D1       ; INTITIALIZE D1 AND D2 WITH XPOS AND YPOS
            MOVE.W  2(A0),D2
            MOVE.W  D1,D3                       
            MOVE.W  D2,D4
            
            ADD.W   #(7*(EN3WIDTH)/29),D1           ; LANDING LEG 1 P1
            ADD.W   #(10*(EN3WIDTH)/29),D2
            ADD.W   #(8*(EN3WIDTH)/29),D3            
            ADD.W   #(12*(EN3WIDTH)/29),D4  
            MOVE.B  #87,D0
            TRAP    #15
            
            SUB.W   #(EN3WIDTH/29),D1               ; LANDING LEG 1 P2
            ADD.W   #(2*(EN3WIDTH)/29),D2
            ADD.W   #(EN3WIDTH/29),D3            
            ADD.W   #(EN3WIDTH/29),D4  
            MOVE.B  #87,D0
            TRAP    #15
            
            ADD.W   #(14*(EN3WIDTH/29)),D1          ; LANDING LEG 2 P2   
            ADD.W   #(14*(EN3WIDTH/29)),D3            
            MOVE.B  #87,D0
            TRAP    #15
            
            ADD.W   #(EN3WIDTH/29),D1               ; LANDING LEG 2 P1
            SUB.W   #(2*(EN3WIDTH)/29),D2
            SUB.W   #(EN3WIDTH/29),D3            
            SUB.W   #(EN3WIDTH/29),D4  
            MOVE.B  #87,D0
            TRAP    #15
    
            
            UTLSPEN #EN3YELLO
            UTLSFIL #EN3YELLO
            CLR     D0
            MOVE.W  (A0),D1       ; INTITIALIZE D1 AND D2 WITH XPOS AND YPOS
            MOVE.W  2(A0),D2
            MOVE.W  D1,D3                       
            MOVE.W  D2,D4
            
            ADD.W   #(6*(EN3WIDTH)/29),D1           ; LIGHT TOP 1
            ADD.W   #(3*(EN3WIDTH)/29),D2
            ADD.W   #(7*(EN3WIDTH)/29),D3            
            ADD.W   #(4*(EN3WIDTH)/29),D4  
            MOVE.B  #87,D0
            TRAP    #15
            
            ADD.W   #(4*(EN3WIDTH/29)),D1           ; LIGHT TOP 2
            ADD.W   #(4*(EN3WIDTH/29)),D3            
            MOVE.B  #87,D0
            TRAP    #15
            
            ADD.W   #(4*(EN3WIDTH/29)),D1           ; LIGHT TOP 3
            ADD.W   #(4*(EN3WIDTH/29)),D3            
            MOVE.B  #87,D0
            TRAP    #15
            
            ADD.W   #(4*(EN3WIDTH/29)),D1           ; LIGHT TOP 4
            ADD.W   #(4*(EN3WIDTH/29)),D3         
            MOVE.B  #87,D0
            TRAP    #15
            
            ADD.W   #(4*(EN3WIDTH/29)),D1           ; LIGHT TOP 5
            ADD.W   #(4*(EN3WIDTH/29)),D3            
            MOVE.B  #87,D0
            TRAP    #15
            
            ADD.W   #(2*(EN3WIDTH)/29),D1           ; LIGHT BOTTOM 6
            ADD.W   #(2*(EN3WIDTH)/29),D2
            ADD.W   #(2*(EN3WIDTH)/29),D3            
            ADD.W   #(2*(EN3WIDTH)/29),D4  
            MOVE.B  #87,D0
            TRAP    #15
            
            SUB.W   #(4*(EN3WIDTH)/29),D1           ; LIGHT BOTTOM 5
            SUB.W   #(4*(EN3WIDTH)/29),D3
            MOVE.B  #87,D0
            TRAP    #15
            
            SUB.W   #(4*(EN3WIDTH)/29),D1           ; LIGHT BOTTOM 4
            SUB.W   #(4*(EN3WIDTH)/29),D3
            MOVE.B  #87,D0
            TRAP    #15

            SUB.W   #(4*(EN3WIDTH)/29),D1           ; LIGHT BOTTOM 3
            SUB.W   #(4*(EN3WIDTH)/29),D3
            MOVE.B  #87,D0
            TRAP    #15

            SUB.W   #(4*(EN3WIDTH)/29),D1           ; LIGHT BOTTOM 2
            SUB.W   #(4*(EN3WIDTH)/29),D3
            MOVE.B  #87,D0
            TRAP    #15
            
            SUB.W   #(4*(EN3WIDTH)/29),D1           ; LIGHT BOTTOM 1
            SUB.W   #(4*(EN3WIDTH)/29),D3
            MOVE.B  #87,D0
            TRAP    #15
                                                
            MOVEM.L (A7)+,D0-D4
            RTS


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
