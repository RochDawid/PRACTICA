; =============================================================================
; STAR MANAGEMENT. IT IS AN AGENT.
; LOCAL MEMORY IS:
;                  - +0 WORD X POSITION
;                  - +2 WORD Y POSITION
;                  - +4 WORD Y SPEED (ALSO AFFECTS SIZE)
; =============================================================================

; -----------------------------------------------------------------------------
STARINIT
; INITALIZES A STAR 
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
            
            MOVE.W  D0,(A0)                  ; X POSITION (PSEUDO-RANDOM)
            MOVE.W  #1,2(A0)                 ; Y POSITION
            
            JSR     UTLRAND6
            CMP.B   #4,D0
            BLE     .STAR1                   ; SPAWN A SMALL STAR 1/2 TIMES

            CMP.B   #5,D0
            BLE     .STAR2                   ; SPAWN A MEDIUM STAR 1/3 TIMES
            
            MOVE.W  #3,4(A0)
            BRA     .END
            
.STAR1      MOVE.W  #1,4(A0)
            BRA     .END
.STAR2      MOVE.W  #2,4(A0)
              
.END        MOVE.W  (A7)+,D0
            RTS
            
; -----------------------------------------------------------------------------
STARIN2
; INITALIZES A LEVEL 2 ENEMY
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
            MOVE.W  D0,(A0)                  ; X POSITION (PSEUDO-RANDOM)
            
.OUT2       JSR     UTLRAND   
            LSL     #2,D0  
            CMP.W   #SCRWIDTH,D0
            BGE     .OUT2            
            MOVE.W  D0,2(A0)                 ; Y POSITION (PSEUDO-RANDOM)
            
            JSR     UTLRAND6
            CMP.B   #4,D0
            BLE     .STAR1                   ; SPAWN A SMALL STAR 1/2 TIMES

            CMP.B   #5,D0
            BLE     .STAR2                   ; SPAWN A MEDIUM STAR 1/3 TIMES
            
            MOVE.W  #3,4(A0)
            BRA     .END
            
.STAR1      MOVE.W  #1,4(A0)
            BRA     .END
.STAR2      MOVE.W  #2,4(A0)
              
.END        MOVE.W  (A7)+,D0
            RTS

; -----------------------------------------------------------------------------
STARUPDT
; UPDATES A LEVEL 2 ENEMY
; INPUT    - A0 POINTER TO THE LOCAL MEMORY
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
           
            MOVE.W D0,-(A7)    
            
            MOVE.W  2(A0),D0
            ADD.W   4(A0),D0
            MOVE.W  D0,2(A0)                    ; Y:=Y+VY
                       
          
            CMP.W   #SCRHEIGH-1,2(A0)           ; CHECK BOTTOM BOUNDARY
            BGT     .BOUNCEB                    ; IF COLLISION -> BOUNCE
            BRA     .END

.BOUNCEB    JSR     AGLKILL            
.END        MOVE.W (A7)+,D0
            RTS

; -----------------------------------------------------------------------------
STARPLOT
; PLOTS A LEVEL 2 ENEMY
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------

            MOVEM.L D0-D5,-(A7)
            UTLSPEN #$00FFFFFF
            UTLSFIL #$00FFFFFF
            CLR     D0
            MOVE.W  (A0),D1          ; INTITIALIZE D1 AND D2 WITH XPOS AND YPOS
            MOVE.W  2(A0),D2           
            MOVE.W  D1,D3                       
            MOVE.W  D2,D4            
            MOVE.W  4(A0),D5
            
            LSL     #1,D5
            ADD.W   D5,D3            ; WE PAINT THE STAR  
            ADD.W   D5,D4           
            MOVE.B  #87,D0
            TRAP    #15
            
            MOVEM.L (A7)+,D0-D5
            RTS

     



*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
