; #########################################################################
;
;   trig.asm - Assembly file for CompEng205 Assignment 3
;
;
; #########################################################################

      .586
      .MODEL FLAT,STDCALL
      .STACK 4096
      option casemap :none  ; case sensitive

include ./Include/trig.inc

.DATA

;;  These are some useful constants (fixed point values that correspond to important angles)
PI_HALF = 102943           	;;  PI / 2
PI =  205887	                ;;  PI 
TWO_PI	= 411774                ;;  2 * PI 
PI_INC_RECIP =  5340353        	;;  Use reciprocal to find the table entry for a given angle
	                        ;;              (It is easier to use than divison would be)


	;; If you need to, you can place global variables here
	
.CODE

FixedSin PROC USES esi angle:FXPT
		mov eax, angle;

		cmp eax, 0;
		jnl Positive

		;; 0 > angle
		neg eax;
		invoke FixedSin, eax
		neg eax
		ret

	Positive:
		cmp eax, PI_HALF

		;; pi/2 > angle -> go to table
		jle Q1;

		cmp eax, PI
		jnl Check34;

		;;quartile 2
		;; pi > angle >= pi/2
		neg eax; Compute the angle as Pi - angle
		add eax, PI;
		jmp Q1; -> go to table

	Check34:
		;;quartiles 3 and 4
		;; 2*pi > angle >= pi
		cmp eax, TWO_PI;
		jnl Normalize;
		mov esi, eax;
		sub esi, PI;
		invoke FixedSin, esi; invoke FixedSin with angle - PI

		neg eax; return the negative of the returned value
		ret;

	Normalize:
		;; angle >= 2pi
		sub eax, TWO_PI; decrement eax until it is less than 2pi
		cmp eax, TWO_PI;
		jnl Normalize; loop while the angle >= 2*pi

		invoke FixedSin, eax; invoke FixedSin and return
		ret
		
	Q1:
		;;quartile 1
		;;the exact index, i, for any angle is 256*angle*(1/pi)
		cmp eax, PI_HALF
		je RET1;;return exactly 1 for PI_HALF

		mov esi, PI_INC_RECIP
		imul esi;;multiply the result by 1/pi = 0x0000517d
		movzx eax, WORD PTR [SINTAB + edx*2];;edx holds the truncated integer result, thus i
		ret
		
	RET1:
		mov eax, 1
		shl eax, 16

		ret	
FixedSin ENDP 
	
FixedCos PROC USES esi angle:FXPT

	mov esi, angle
	add esi, PI_HALF;; increment angle for use in sin function
	invoke FixedSin, esi;; invoke sin function with x + pi/2

	ret			; Don't delete this line!!!	
FixedCos ENDP	
END
