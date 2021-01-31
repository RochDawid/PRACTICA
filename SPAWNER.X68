; =============================================================================
; SPAWNER MANAGEMENT.
; =============================================================================

; -----------------------------------------------------------------------------
SPWNLV1
; SPAWNER FOR LEVEL ONE
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------

            MOVEM.L D0/A1-A3,-(A7)
                    
            CLR.L   D1
            MOVE.B  (SCRCYCCT),D0          
            AND     #$0F,D0                 ; EVERY 16 CYCLES
            BNE     .END                    ; CREATE A NEW EN1
            
            CMP.B   #NENMLVL1, (NENMLVL)    ; CHECK IF WE WON LEVEL
            BEQ     .CHGSTA
            
            LEA     STARINIT,A1
            LEA     STARUPDT,A2
            LEA     STARPLOT,A3
            MOVE.W  #STARTYPE,D0
            JSR     AGLADD
            
            LEA     EN1INIT,A1
            LEA     EN1UPDT,A2
            LEA     EN1PLOT,A3
            MOVE.W  #EN1TYPE,D0
            JSR     AGLADD
            ADDQ.B  #1,(NENMLVL)

.END        MOVEM.L (A7)+,D0/A1-A3            
            RTS
          
            
.CHGSTA     MOVE.W  #STA1TO2,(STANEXT)
            BRA     .END
            
; -----------------------------------------------------------------------------
SPWNLV2
; SPAWNER FOR LEVEL TWO
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------

            MOVEM.L D0-D1/A1-A3,-(A7)
            CLR.L   D1
            MOVE.B  (SCRCYCCT),D0
            AND     #$0F,D0                 ; EVERY 16 CYCLES
            BNE     .END                    ; CREATE A NEW ENEMY
            
            CMP.B   #NENMLVL2, (NENMLVL)           ; CHECK IF WE WON LEVEL
            BEQ     .CHGSTA
            
            LEA     STARINIT,A1
            LEA     STARUPDT,A2
            LEA     STARPLOT,A3
            MOVE.W  #STARTYPE,D0
            JSR     AGLADD
            
            JSR     UTLRAND6
            CMP.B   #4,D0
            BLE     .SPWEN1                 ; SPAWN A LVL1 ENEMY 2/3 TIMES
            
            LEA     EN2INIT,A1
            LEA     EN2UPDT,A2
            LEA     EN2PLOT,A3
            MOVE.W  #EN2TYPE,D0
            MOVE.B  #NSHOTEN2,D1
            JSR     AGLADD
            ADDQ.B  #1,(NENMLVL)
            BRA     .END
            
.SPWEN1     LEA     EN1INIT,A1
            LEA     EN1UPDT,A2
            LEA     EN1PLOT,A3
            MOVE.W  #EN1TYPE,D0
            JSR     AGLADD
            
.END        MOVEM.L (A7)+,D0-D1/A1-A3
            RTS

.CHGSTA     MOVE.W  #STA2TO3,(STANEXT)
            BRA     .END

; -----------------------------------------------------------------------------
SPWNLV3
; SPAWNER FOR LEVEL THREE
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
 
            MOVEM.L D0-D1/A1-A3,-(A7)
            CLR.L   D1
            MOVE.B  (SCRCYCCT),D0
            AND     #$0F,D0                 ; EVERY 16 CYCLES
            BNE     .END                    ; CREATE A NEW ENEMY

            LEA     STARINIT,A1
            LEA     STARUPDT,A2
            LEA     STARPLOT,A3
            MOVE.W  #STARTYPE,D0
            JSR     AGLADD
                
            BRA     .WON
             
.RETURN     JSR     UTLRAND6
            CMP.B   #3,D0
            BLE     .SPWEN1                 ; SPAWN A LVL1 ENEMY 1/2 TIMES
            CMP.B   #5,D0
            BLE     .SPWEN2                 ; SPAWN A LVL2 ENEMY 1/3 TIMES

            CMP.B   #NENMLVL3,(NENMLVL)     ; CHECK ALL LEVEL 3 ENEMIES SPAWNED
            BEQ     .SPAWNED

            LEA     EN3INIT,A1              ; SPAWN A LVL3 ENEMY 1/6 TIMES
            LEA     EN3UPDT,A2
            LEA     EN3PLOT,A3
            MOVE.W  #EN3TYPE,D0
            MOVE.B  #NSHOTEN3,D1
            JSR     AGLADD
            ADDQ.B  #1,(NENMLVL)
            BRA     .END
            
.SPWEN1     LEA     EN1INIT,A1
            LEA     EN1UPDT,A2
            LEA     EN1PLOT,A3
            MOVE.W  #EN1TYPE,D0
            JSR     AGLADD
            BRA     .END
            
.SPWEN2     LEA     EN2INIT,A1
            LEA     EN2UPDT,A2
            LEA     EN2PLOT,A3
            MOVE.W  #EN2TYPE,D0
            MOVE.B  #NSHOTEN2,D1
            JSR     AGLADD
            
.END        MOVEM.L (A7)+,D0-D1/A1-A3
            RTS

.SPAWNED    CMP.B   #NENMLVL3,(BOSKILL)     ; CHECK IF WE KILLED ALL BOSSES
            BNE     .END
            MOVE.W  #STAWON,(STANEXT)
            BRA     .END

.WON        CMP.B   #NENMLVL3,(BOSKILL)     ; CHECK IF WE KILLED ALL BOSSES
            BNE     .RETURN
            MOVE.W  #STAWON,(STANEXT)
            BRA     .END

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
