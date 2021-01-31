; =============================================================================
; TITLE    : EXAMPLE GAME (MAIN PROGRAM)
; AUTHOR   : ANTONI BURGUERA, DAWID ROCH AND JULIÁN WALLIS
; HISTORY  : 10-OCT-2020 - CREATION
;            11-OCT-2020 - MINOR CHANGES
;            24-DEC-2020 - MOUSE ISR IMPLEMENTED
;            05-JAN-2021 - FINAL DETAILS
; =============================================================================
            
            ORG     $1000

; --- CODE INCLUDES -----------------------------------------------------------

            INCLUDE "SYSCONST.X68"          ; SYSTEM CONSTANTS
            INCLUDE "SYSTEM.X68"            ; SYSTEM CODE
            INCLUDE "CONST.X68"             ; GAME CONSTANTS
            INCLUDE "UTIL.X68"              ; UTILITIES FILE
            INCLUDE "PLAYER.X68"            ; PLAYER MANAGEMENT
            INCLUDE "AGENTLST.X68"          ; AGENT LIST MANAGEMENT
            INCLUDE "ENEMY1.X68"            ; ENEMY 1 AGENT MANAGEMENT
            INCLUDE "ENEMY2.X68"            ; ENEMY 2 AGENT MANAGEMENT
            INCLUDE "ENEMY3.X68"            ; ENEMY 3 AGENT MANAGEMENT  
            INCLUDE "STAR.X68"              ; STAR AGENT MANAGEMENT       
            INCLUDE "SPAWNER.X68"           ; SPAWNER
            INCLUDE "STATES.X68"            ; STATE MANAGEMENT
            INCLUDE "PLRSHOT.X68"           ; PLAYER SHOT AGENT MANAGEMENT
            INCLUDE "EN3SHOT.X68"           ; ENEMY 3 SHOT AGENT MANAGEMENT

; --- INITIALIZE --------------------------------------------------------------

START       JSR     SYSINIT                 ; INITIALIZE SYSTEM-RELATED STUFF
            JSR     STAINIT                 ; INITIALIZE GAME STATE

; --- UPDATE ------------------------------------------------------------------

.LOOP       TRAP    #KBDTRAP                ; READ KEYBOARD
            JSR     STAUPD                  ; UPDATE DEPENDING ON THE STATE

; --- WAIT SYNCH --------------------------------------------------------------

.WINT        TST.B   (SCRINTCT)              ; WAIT FOR INTERRUPT
             BEQ     .WINT
             CLR.B   (SCRINTCT)

; --- PLOT --------------------------------------------------------------------

            JSR     STAPLOT                 ; PLOT DEPENDING ON THE STATE
            TRAP    #SCRTRAP                ; SHOW GRAPHICS
            BRA     .LOOP                   ; MAIN LOOP
            SIMHALT

; --- VARIABLES ---------------------------------------------------------------

            INCLUDE "SYSVAR.X68"
            INCLUDE "VAR.X68"
            END     START




*~Font name~Fixedsys~
*~Font size~18~
*~Tab type~0~
*~Tab size~4~
