
.ORIG x3000

Hello .STRINGZ "Hello, welcome to the Caesar Cipher program.\n"
Enter .STRINGZ "Do you want to (E)ncrypt, (D)ecrypt or e(X)it?\n"
Cipher .STRINGZ "What is the cipher(1-25)?\n"
String .STRINGZ "What is the string (up to 200 characters)?"

start	LEA R0, Hello	; Load address of Hello into R0
	PUTS		; Print Hello
	LEA R0, Enter	; Load address of Enter into R0
	PUTS		; Print Enter
	AND R0, R0, 0	; Zero out registers
	AND R1, R1, 0	;
	AND R2, R2, 0	;
	AND R3, R3, 0	;
	AND R4, R4, 0	;
	AND R5, R5, 0	;
	AND R6, R6, 0	;
	AND R7, R7, 0	;

input	GETC ; Get input and store to R0
	OUT ; Print input

quit	LD R1, X	; Load X value
	NOT R2, R0	; Negative value for 2's comp
	ADD R2, R2, 1	;
	ADD R1, R2, R1	; Add both values to see if 0
	BRz end		; If zero, end

charE	LD R1, E	; Load E value
	NOT R2, R0	; Negative value for 2's comp
	ADD R2, R2, 1	;
	ADD R1, R2, R1	; Add both values to see if 0
	BRz ciphmsg	; If zero, cipher

charD	LD R1, D	; Load D value
	NOT R2, R0	; Negative value for 2's comp
	ADD R2, R2, 1	;
	ADD R1, R2, R1	; Add both values to see if 0
	BRz ciphmsg	; If zero, cipher

ciphmsg	LEA R0, Cipher	; Load address of Cipher into R0
	PUTS		; Print Cipher

ciph	GETC		; Get input and store to R0
	OUT		; Print input

newline	LD R1, LF	; Load LF value
	NOT R2, R0	; Negative value for 2's comp
	ADD R2, R2, 1	;
	ADD R1, R2, R1	; Add both values to see if 0
	BRz strngmsg	; If zero, strng

conv	LD R4, ZERO	; Load 48 to R4			
	NOT R4, R4	; Negative value for 2's comp
	ADD R4, R4, 1	;
	ADD R4, R4, R0	; char - 48
			; R4 is temp for DIGIT
	LD R5, INT	; Load INT to R5
	AND R1, R1, 0	; Zero out R1
	AND R3, R3, 0	; Zero out R3
	ADD R3, R3, 10	; Add 10 to R3 (counter for multiplying 10)
	whilecipher BRnz endcipher ; If R3 is negative or zero, endwhile
		ADD R1, R1, R5	; Add INT to itself
		ADD R3, R3, -1	; Decrement counter
		BR whilecipher
	endcipher
	ADD R5, R1, R4	;
	ST R5, INT	; Store new INT aka cipher
	BRnzp ciph	; Go to ciph

strngmsg LEA R0, String	; Load address of String into R0
	PUTS		; Print String
	LD R3, Ci	; Load col

strng	GETC		; Get input and store to R0
	OUT		; Print input
	LD R1, LF	; Load LF value
	NOT R6, R0	; Negative value for 2's comp
	ADD R6, R6, 1	;
	ADD R1, R6, R1	; Add both values to see if 0
	BRz setl	; If zero, setl

setst	LEA R1, MSG	; Load address of MSG to R1
	AND R4, R4, 0	; Zero out R4, updated ROW
	LD R2, Ri	; Load row
	LD R5, NUMCOL	; Load 200 to R5
	JSR store	; 
	ADD R3, R3, 1	; increment COL
	BRnzp strng	;

store	ADD R5, R5, 0	;	
	BRnz endstore ; If R5 is negative, endstore
		ADD R4, R4, R2	; Add row to itself
		ADD R5, R5, -1	; Decrement # of COL
		BRnzp store	;
	endstore
	ADD R4, R4, R3	; ((r X #c) + c)
	ADD R4, R4, R1	; Add base address and prev line
			; Address(r,c) = R4
	STR R0, R4, 0	; mem[R4 calculated address] <- R0 input character
	RET		;


setl	LEA R1, MSG	; Load address of MSG to R1
	AND R4, R4, 0	; Zero out R4, updated ROW
	LD R2, Ri	; Load row
	LD R3, Ci	; Load col
	LD R5, NUMCOL	; Load 200 to R5
	JSR load	; 
			
	ADD R6, R6, 0	; Add 0 to R6 to see if last loaded char is 0
	BRz En_print	;

	LD R1, CAPA	; Check if A <= char <= Z
	NOT R1, R1	; Negative value for 2's comp
	ADD R1, R1, 1	;
	ADD R1, R1, R6	; char - 65
	BRn setl_store	; If negative, char is before 65
	LD R1, CAPZ	;
	NOT R1, R1	; Negative value for 2's comp
	ADD R1, R1, 1	;
	ADD R1, R1, R6	; char - 90
	BRp other_range ; If positive, not in range 65-90
	LD R2, CAPA	;
	ST R2, FIRSTL	;
	JSR encrypt	;
	BRnzp setl_store ;
other_range
	LD R1, LOWA	; Check if a <= char <= z
	NOT R1, R1	; Negative value for 2's comp
	ADD R1, R1, 1	;
	ADD R1, R1, R6	; char - 97
	BRn setl_store	; If negative, char is before 97
	LD R1, LOWZ	;
	NOT R1, R1	; Negative value for 2's comp
	ADD R1, R1, 1	;
	ADD R1, R1, R6	; char - 122
	BRp setl_store  ; If positive, not in range 90-122
	LD R2, LOWA	;
	ST R2, FIRSTL	;
	JSR encrypt	;

setl_store LEA R1, MSG	  ; 
	   LD R2, Ri	  ;
	   AND R4, R4, 0  ; Zero out R4, updated ROW
	   AND R2, R2, 0  ; Zero out R2
	   ADD R2, R2, 1  ; Set row = 1
	   LD R5, NUMCOL  ; Load 200 to R5
	   LD R3, Ci	  ;
	   JSR store	  ;
	   ADD R3, R3, 1  ; increment col
	   ST R3, Ci	  ;
	   BRnzp setl	  ;

load	ADD R5, R5, 0	;	
	BRn endload ; If R5 is negative, endload
		ADD R4, R4, R2	; Add row to itself
		ADD R5, R5, -1	; Decrement # of COL
		BRnzp load	;
	endload
	ADD R4, R4, R3	; ((r X #c) + c)
	ADD R4, R4, R1	; Add base address and prev line
			; Address(r,c) = R4
	LDR R6, R4, 0	; Load input character at R4 calculated address to R6
	RET		;

encrypt	LD R1, INT	; Load INT to R1
	LD R2, FIRSTL	; Load 65 or 97 to R2
	LD R3, MOD	; Load 26 to R3
	NOT R2, R2	; Negative value for 2's comp
	ADD R2, R2, 1	;
	ADD R6, R6, R2	; char - 48
	ADD R6, R6, R1	; (char + INT)
	NOT R3, R3	; Negative value for 2's comp
	ADD R3, R3, 1	;
modloop ADD R6, R6, R3	; (char + INT) - 26
		BRnz endmod	;
		BRnzp modloop	;
	endmod		;
	LD R3, MOD	; Load 26 to R3
	ADD R6, R6, R3	; Add back 26 to get number
	LD R2, FIRSTL	; Load 65 or 97 to R2
	ADD R6, R6, R2	; Add back 65 to get ASCII character
	RET		;

En_print LEA R0, HereEn	; Load address of Here to R1
	PUTS		; Print Here
print	LEA R0, MSG	; Load address of MSG
	PUTS		; Print
	LD R1, NUMCOL	; Load 200 to R1
	ADD R0, R0, R1  ; Add 200 to get to row1
	PUTS		; Print 	
	
end	LEA R0, Bye	; Load Bye to R0
	PUTS		; Prints
	TRAP x25	; Halt

Tags
X	.FILL x0058 ; x value to quit
E	.FILL x0045 ; E value
D	.FILL x0044 ; D value
LF 	.FILL x000A ; line feed value 
ZERO	.FILL x0030 ; value for 48
NUMCOL	.FILL x00C8 ; value for 200
Ri	.FILL x0000 ; value for row
Ci	.FILL x0000 ; value for col
INT	.FILL x0000 ; int value
MOD	.FILL x001A ; value for 26
CAPA	.FILL x0041 ; value for 65 aka A
LOWA	.FILL x0061 ; value for 97 aka a
CAPZ	.FILL x005A ; value for 90 aka Z
LOWZ	.FILL x007A ; value for 122 aka z
FIRSTL	.FILL x0041 ; value for first letter
HereDe .STRINGZ "Here is your string and the decrypted result:\n"
HereEn .STRINGZ "Here is your string and the encrypted result:\n"
Bye   .STRINGZ "\nBye!"
MSG	.BLKW 400   ; 2x200 message array

.END
