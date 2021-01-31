; =============================================================================
; PLAYER MANAGEMENT
; =============================================================================

; -----------------------------------------------------------------------------
PLRINIT
; PLAYER SHIP INITIALIZATION
; INPUT:    NONE
; OUTPUT:   NONE
; MODIFIES: NONE
; -----------------------------------------------------------------------------
           
            MOVE.W  #0,(PLRSCOR)
            MOVE.W  #100,(PLRHEAL)
            MOVE.W  #SCRWIDTH/2,(PLRPOSX)
            MOVE.W  #SCRHEIGH-(60),(PLRPOSY)
            RTS

; -----------------------------------------------------------------------------
PLRUPDT
; PLAYER SHIP UPDATE
; INPUT:    NONE
; OUTPUT:   NONE
; MODIFIES: NONE
; -----------------------------------------------------------------------------
            
            MOVE.W  D1,-(A7)
            MOVE.B  (KBDVAL),D1             ; PERFORM MOTION AND CHECK BOUNDS
            ROR.B   #1,D1                   ; CHECK LEFT BOUNDARY
            BCC     .CHKUP
            SUB.W   #PLRSPEED,(PLRPOSX)
            CMP.W   #0,(PLRPOSX)
            BGE     .CHKUP
            MOVE.W  #0,(PLRPOSX)
.CHKUP      ROR.B   #1,D1                   ; CHECK TOP BOUNDARY
            BCC     .CHKRT
            SUB.W   #PLRSPEED,(PLRPOSY)
            CMP.W   #0,(PLRPOSY)
            BGE     .CHKRT
            MOVE.W  #0,(PLRPOSY)
.CHKRT      ROR.B   #1,D1                   ; CHECK RIGHT BOUNDARY
            BCC     .CHKDN
            ADD.W   #PLRSPEED,(PLRPOSX)
            CMP.W   #SCRWIDTH-PLRWIDTH,(PLRPOSX)
            BLE     .CHKDN
            MOVE.W  #SCRWIDTH-PLRWIDTH,(PLRPOSX)
.CHKDN      ROR.B   #1,D1                   ; CHECK BOTTOM BOUNDARY
            BCC     .MDONE
            ADD.W   #PLRSPEED,(PLRPOSY)
            CMP.W   #SCRHEIGH-PLRHEIGH,(PLRPOSY)
            BLE     .MDONE
            MOVE.W  #SCRHEIGH-PLRHEIGH,(PLRPOSY)
.MDONE      BTST.B  #KBDBITF1,(KBDEDGE)
            BEQ     .NOFIRE
            
            MOVEM.L A1-A3/D0-D2,-(A7)
            LEA     PLRSHOI,A1
            LEA     PLRSHOU,A2
            LEA     PLRSHOP,A3
            MOVE.W  #SHTTYPE,D0
            MOVE.W  (PLRPOSX),D1
            MOVE.W  (PLRPOSY),D2
            JSR     AGLADD
            
            MOVE.L  #3,D2
            MOVE.B  #76,D0
            TRAP    #15                     ; STOP ALL SOUNDS
            MOVE.B  #1,D1
            MOVE.B  #72,D0
            TRAP    #15
            MOVEM.L (A7)+,A1-A3/D0-D2
            BRA     .NOFIRE
            
.NOFIRE     MOVE.W  (A7)+,D1
            RTS
            
; -----------------------------------------------------------------------------    
PLRPLOT
; PLAYER'S SHIP PLOT
; INPUT:    NONE
; OUTPUT:   NONE
; MODIFIES: NONE
; -----------------------------------------------------------------------------  

            MOVEM.L  D0-D4,-(A7)
            
            UTLSPEN #PLRGREY1
            UTLSFIL #PLRGREY1
            CLR     D0
            MOVE.W  (PLRPOSX),D1          ; INTITIALIZE D1=PLRPOSX & D2=PLRPOSY
            MOVE.W  (PLRPOSY),D2
            MOVE.W  D1,D3                       
            MOVE.W  D2,D4
            
            ADD.W   #(PLRHEIGH/9),D3      ; LEFT WING          
            ADD.W   #(PLRHEIGH),D4  
            MOVE.B  #87,D0
            TRAP    #15
            
            ADD.W   #(12*(PLRHEIGH/9)),D1
            ADD.W   #(12*(PLRHEIGH/9)),D3
            MOVE.B  #87,D0
            TRAP    #15
            
            SUB.W   #(PLRHEIGH/9),D1
            ADD.W   #(4*(PLRHEIGH/9)),D2
            SUB.W   #(PLRHEIGH/9),D3
            SUB.W   #(4*(PLRHEIGH/9)),D4
            MOVE.B  #87,D0
            TRAP    #15
            
            SUB.W   #(10*(PLRHEIGH/9)),D1
            SUB.W   #(10*(PLRHEIGH/9)),D3
            MOVE.B  #87,D0
            TRAP    #15
            
            UTLSPEN #PLRGREY2
            UTLSFIL #PLRGREY2
            CLR     D0
            MOVE.W  (PLRPOSX),D1          ; INTITIALIZE D1=PLRPOSX & D2=PLRPOSY
            MOVE.W  (PLRPOSY),D2
            MOVE.W  D1,D3                       
            MOVE.W  D2,D4
            
            ADD.W   #(6*(PLRHEIGH/9)),D1  ; PAINT THE BODY
            ADD.W   #(7*(PLRHEIGH/9)),D3
            ADD.W   #(PLRHEIGH/9),D4
            MOVE.B  #87,D0
            TRAP    #15
            
            SUB.W   #(2*(PLRHEIGH/9)),D1
            ADD.W   #(PLRHEIGH/9),D2
            ADD.W   #(2*(PLRHEIGH/9)),D3
            ADD.W   #(7*(PLRHEIGH/9)),D4
            MOVE.B  #87,D0
            TRAP    #15
            
            SUB.W   #(PLRHEIGH/9),D1
            ADD.W   #(PLRHEIGH/9),D2
            ADD.W   #(PLRHEIGH/9),D3
            SUB.W   #(5*(PLRHEIGH/9)),D4
            MOVE.B  #87,D0
            TRAP    #15
            
            SUB.W   #(PLRHEIGH/9),D1
            ADD.W   #(PLRHEIGH/9),D2
            ADD.W   #(PLRHEIGH/9),D3
            ADD.W   #(3*(PLRHEIGH/9)),D4
            MOVE.B  #87,D0
            TRAP    #15
            
            ADD.W   #(3*(PLRHEIGH/9)),D1
            ADD.W   #(5*(PLRHEIGH/9)),D2
            SUB.W   #(3*(PLRHEIGH/9)),D3
            ADD.W   #(3*(PLRHEIGH/9)),D4
            MOVE.B  #87,D0
            TRAP    #15
            
            UTLSPEN #PLRBLUE
            UTLSFIL #PLRBLUE
            CLR     D0
            MOVE.W  (PLRPOSX),D1          ; INTITIALIZE D1=PLRPOSX & D2=PLRPOSY
            MOVE.W  (PLRPOSY),D2
            MOVE.W  D1,D3                       
            MOVE.W  D2,D4
            
            ADD.W   #(5*(PLRHEIGH/9)),D1  ; PAINT THE FIRST WINDOW
            ADD.W   #(2*(PLRHEIGH/9)),D2
            ADD.W   #(8*(PLRHEIGH/9)),D3
            ADD.W   #(3*(PLRHEIGH/9)),D4
            MOVE.B  #87,D0
            TRAP    #15
            
            SUB.W   #(2*(PLRHEIGH/9)),D1  ; PAINT THE SECOND WINDOW
            ADD.W   #(2*(PLRHEIGH/9)),D2
            ADD.W   #(2*(PLRHEIGH/9)),D3
            ADD.W   #(2*(PLRHEIGH/9)),D4
            MOVE.B  #87,D0
            TRAP    #15
            
            ADD.W   #(3*(PLRHEIGH/9)),D1  ; PAINT THE THIRD WINDOW
            ADD.W   #(2*(PLRHEIGH/9)),D2
            SUB.W   #(3*(PLRHEIGH/9)),D3
            ADD.W   #(3*(PLRHEIGH/9)),D4
            MOVE.B  #87,D0
            TRAP    #15
                  
            MOVEM.L (A7)+,D0-D4
            RTS

*~Font name~Fixedsys~
*~Font size~18~
*~Tab type~1~
*~Tab size~4~
