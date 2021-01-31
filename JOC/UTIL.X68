; =============================================================================
; UTILITY MACROS
; =============================================================================

; -----------------------------------------------------------------------------
UTLSPEN     MACRO
; WRAPPER FOR SET PEN TRAP 15 TASK.
; INPUT    - \1 COLOR IN FORMAT $00BBGGRR
; OUTPUT   - NONE
; MODIFIES - D0,D1
; -----------------------------------------------------------------------------
            MOVE.B  #80,D0
            MOVE.L  \1,D1
            TRAP    #15
            ENDM

; -----------------------------------------------------------------------------
UTLSFIL     MACRO
; WRAPPER FOR SET FIL TRAP 15 TASK.
; INPUT    - \1 COLOR IN FORMAT $00BBGGRR
; OUTPUT   - NONE
; MODIFIES - D0,D1
; -----------------------------------------------------------------------------
            MOVE.B  #81,D0
            MOVE.L  \1,D1
            TRAP    #15
            ENDM

; -----------------------------------------------------------------------------
UTLLOCT     MACRO
; WRAPPER TO TEXT POSITIONNING FROM TRAP 15
; INPUT    - \1 X, \2 Y
; OUTPUT   - NONE
; MODIFIES - D0,D1
; -----------------------------------------------------------------------------
            MOVE.W  #\1<<8|\2, D1
            MOVE.B  #11,D0
            TRAP    #15
            ENDM

; =============================================================================
; UTILITY SUBROUTINES
; =============================================================================

; -----------------------------------------------------------------------------
UTLINIT
; INITIALIZES UTILITY CODE
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            CLR.B   (UTLRNDIX)
            RTS
; -----------------------------------------------------------------------------
UTLCHCOL
; CHECKS COLLISION
; INPUT    - D0.W X0 COORDINATE
;            D1.W Y0 COORDINATE
;            D2.W X1 COORDINATE
;            D3.W Y1 COORDINATE
;            D4.W WIDTH 0
;            D5.W WIDTH 1
;            D6.W HEIGHT 0
;            D7.W HEIGHT 1
; OUTPUT   - D0.B=FF - COLLISION, =0 - NO COLLISION
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.W D4-D7,-(A7)
            ADD.W   D0,D4
            CMP.W   D2,D4
            BLE     .NOCOL
            ADD.W   D2,D5
            CMP.W   D0,D5
            BLE     .NOCOL
            ADD.W   D1,D6
            CMP.W   D3,D6
            BLE     .NOCOL
            ADD.W   D3,D7
            CMP.W   D1,D7
            BLE     .NOCOL
            MOVE.B  #$FF,D0
            BRA     .END
.NOCOL      CLR.B   D0
.END        MOVEM.W (A7)+,D4-D7
            RTS

; -----------------------------------------------------------------------------
UTLRAND
; PROVIDES A PSEUDO-RANDOM BYTE
; INPUT    - NONE
; OUTPUT   - D0.L RANDOM VALUE (ONLY BYTE)
; MODIFIES - NONE (ASIDE OF OUTPUT)
; -----------------------------------------------------------------------------
            MOVE.L  A0,-(A7)
            LEA     .RANDVEC,A0
            CLR.L   D0
            MOVE.B  (UTLRNDIX),D0
            MOVE.B  (A0,D0.L),D0
            ADDQ.B  #1,(UTLRNDIX)
            MOVE.L  (A7)+,A0
            RTS


.RANDVEC    DC.B    162, 238, 154, 12 , 245, 36 , 32 , 103
            DC.B    42 , 163, 81 , 38 , 224, 172, 19 , 69
            DC.B    117, 81 , 202, 253, 51 , 235, 108, 154
            DC.B    96 , 204, 231, 184, 154, 235, 34 , 203
            DC.B    29 , 118, 181, 149, 176, 137, 62 , 108
            DC.B    57 , 21 , 72 , 201, 110, 202, 159, 41
            DC.B    67 , 231, 226, 124, 55 , 37 , 84 , 62
            DC.B    233, 148, 206, 233, 228, 82 , 243, 78
            DC.B    55 , 109, 154, 132, 162, 40 , 30 , 39
            DC.B    25 , 226, 198, 119, 128, 212, 232, 225
            DC.B    10 , 90 , 50 , 103, 51 , 194, 222, 40
            DC.B    89 , 128, 220, 14 , 87 , 252, 243, 252
            DC.B    138, 171, 188, 247, 7  , 77 , 29 , 234
            DC.B    239, 213, 119, 110, 30 , 187, 131, 23
            DC.B    214, 224, 42 , 143, 189, 40 , 212, 130
            DC.B    19 , 79 , 102, 236, 10 , 100, 122, 188
            DC.B    86 , 82 , 154, 22 , 155, 144, 7  , 199
            DC.B    6  , 138, 164, 247, 1  , 218, 166, 82
            DC.B    242, 231, 119, 40 , 177, 118, 220, 102
            DC.B    164, 66 , 227, 129, 177, 103, 165, 108
            DC.B    191, 206, 250, 22 , 191, 56 , 30 , 161
            DC.B    209, 139, 80 , 12 , 95 , 73 , 168, 56
            DC.B    222, 76 , 20 , 162, 64 , 220, 93 , 12
            DC.B    182, 155, 10 , 56 , 93 , 171, 89 , 6
            DC.B    226, 27 , 221, 117, 21 , 130, 101, 18
            DC.B    138, 38 , 81 , 48 , 159, 71 , 57 , 21
            DC.B    30 , 138, 187, 113, 198, 110, 185, 152
            DC.B    159, 71 , 229, 52 , 148, 39 , 77 , 6
            DC.B    125, 6  , 214, 186, 48 , 15 , 212, 22
            DC.B    236, 127, 126, 3  , 207, 45 , 193, 2
            DC.B    148, 91 , 35 , 242, 139, 205, 248, 237
            DC.B    116, 51 , 236, 185, 15 , 213, 221, 6
                        

; -----------------------------------------------------------------------------
UTLRAND6
; PROVIDES A PSEUDO-RANDOM BYTE
; INPUT    - NONE
; OUTPUT   - D0.L RANDOM VALUE BETWEEN 1 AND 6 (ONLY BYTE)
; MODIFIES - NONE (ASIDE OF OUTPUT)
; -----------------------------------------------------------------------------
            MOVE.L  A0,-(A7)
            LEA     .RANDVEC,A0
            CLR.L   D0
            MOVE.B  (UTLRNDIX),D0
            MOVE.B  (A0,D0.L),D0
            ADDQ.B  #1,(UTLRNDIX)
            MOVE.L  (A7)+,A0
            RTS

.RANDVEC    DC.B    6, 5, 2, 4, 2, 3, 5, 1
            DC.B    2, 3, 2, 1, 2, 2, 2, 2
            DC.B    5, 5, 4, 4, 2, 4, 6, 4
            DC.B    5, 6, 2, 3, 6, 6, 3, 5
            DC.B    1, 3, 2, 3, 2, 3, 6, 6
            DC.B    6, 6, 2, 6, 1, 2, 3, 5
            DC.B    3, 3, 4, 6, 3, 2, 6, 4
            DC.B    6, 3, 3, 5, 2, 5, 5, 5
            DC.B    1, 4, 1, 1, 2, 2, 4, 6
            DC.B    4, 2, 4, 5, 1, 3, 1, 3
            DC.B    2, 4, 6, 6, 4, 1, 5, 4
            DC.B    2, 4, 3, 3, 3, 3, 2, 3
            DC.B    4, 3, 4, 5, 6, 6, 6, 1
            DC.B    2, 5, 2, 5, 4, 6, 1, 5
            DC.B    6, 4, 4, 4, 3, 6, 5, 2
            DC.B    4, 6, 4, 5, 2, 3, 1, 5
            DC.B    5, 4, 3, 5, 4, 3, 6, 4
            DC.B    4, 4, 2, 3, 5, 1, 6, 4
            DC.B    1, 1, 5, 6, 2, 2, 3, 1
            DC.B    6, 1, 4, 4, 5, 2, 4, 5
            DC.B    2, 3, 6, 4, 4, 5, 5, 6
            DC.B    1, 4, 1, 6, 4, 2, 3, 1
            DC.B    4, 4, 6, 5, 1, 6, 3, 3
            DC.B    3, 1, 3, 4, 1, 3, 2, 4
            DC.B    4, 2, 4, 1, 4, 3, 2, 5
            DC.B    6, 6, 2, 6, 4, 3, 6, 5
            DC.B    1, 4, 4, 4, 4, 5, 3, 3
            DC.B    1, 1, 5, 6, 2, 1, 4, 6
            DC.B    6, 4, 2, 3, 6, 2, 2, 6
            DC.B    6, 3, 5, 3, 4, 1, 5, 6
            DC.B    2, 1, 2, 3, 1, 3, 6, 5
            DC.B    3, 3, 1, 5, 3, 3, 3, 6

; ------------------------------------------------------------------------------
UTLFILI
; INITIALIZE FILE OPERATIONS
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : NONE
; ------------------------------------------------------------------------------

            MOVE.W  D0,-(A7)

            ; CLOSE ALL FILES JUST IN CASE
            MOVE.B  #50,D0
            TRAP    #15

            MOVE.W  (A7)+,D0
            RTS

; ------------------------------------------------------------------------------
UTLFILW
; WRITES A FILE
; INPUT    : A1 - POINTER TO THE FILE NAME
;            A2 - POINTER TO THE BUFFER
;            D2.L - NUMBER OF BYTES TO WRITE
; OUTPUT   : NONE
; MODIFIES : NONE
; ------------------------------------------------------------------------------

            MOVEM.L D0-D1/A1,-(A7)

            ; OPEN FILE POINTED BY A1
            MOVE.B  #52,D0
            TRAP    #15

            ; WRITE DATA FROM BUFFER TO FILE
            MOVE.L  A2,A1
            MOVE.B  #54,D0
            TRAP    #15

            ; CLOSE FILE
            MOVE.B  #56,D0
            TRAP    #15

            MOVEM.L (A7)+,D0-D1/A1
            RTS

; ------------------------------------------------------------------------------
UTLFILR
; READS A FILE
; INPUT    : A1 - POINTER TO THE FILE NAME
;            A2 - POINTER TO THE BUFFER
;            D2.L - NUMBER OF BYTES TO READ
; OUTPUT   : NONE
; MODIFIES : NONE
; ------------------------------------------------------------------------------
            MOVEM.L D0-D1/A1,-(A7)

            ; OPEN FILE POINTED BY A1
            MOVE.B  #51,D0
            TRAP    #15

            ; READ DATA FROM FILE TO BUFFER
            MOVE.L  A2,A1
            MOVE.B  #53,D0
            TRAP    #15

            ; CLOSE FILE
            MOVE.B  #56,D0
            TRAP    #15

            MOVEM.L (A7)+,D0-D1/A1
            RTS




*~Font name~Fixedsys~
*~Font size~18~
*~Tab type~1~
*~Tab size~4~
