;TITLE Program three     (programThree.asm)

; Author: Dylan Drudge
; CS271 / Program three                Date: 07/20/2017
; Description: Program three solution, displaying my name and program title and has the
;			   user input zero number for validation and to calculate said number of composites.

INCLUDE Irvine32.inc

.const
upperLim		DWORD	401
lowerLim		DWORD	1																							;the input bounds

.data
max = 80
prgrmrIntro		BYTE			"Hi, my name is Dylan Drudge and this is the Composite program for CS271!",0
prgrmInstruct1	BYTE			"Please enter your name:",0
userName		BYTE			max + 1 DUP (?)																		;their name restricted to 80 characters
greeting		BYTE			"Hello, ",0
prgrmInstruct2	BYTE			"Please input the amount of composite numbers you would like to see between 1 and 400: ",0
error			BYTE			"Invalid number entered, please enter a number between 1 and 400..."
userInput		DWORD			?					 																;the number of composite #'s theyd like to see
goodBye1		BYTE			"Thanks for using CompositeMaster3000, see you next time!!",0
goodBye2		BYTE			"Please enter a valid number next time, GoodBye.",0
array1			DWORD			400	DUP (?)																			;an array the size of the max
two				DWORD			2																					;2,3,5,7, are the bases of all composites
five			DWORD			5
seven			DWORD			7
three			DWORD			3
difference		DWORD			?
one				DWORD			1
zero			DWORD			0
spaces			BYTE			"   ",0

.code

main proc

	call	greet				; has user input name and greets them as well as introduces me
	call	input
	call	arrayFill
	call	spew
	;call	goodbye

	invoke ExitProcess,0
main endp


greet proc


									;intro programmer
	mov		edx, OFFSET prgrmrIntro
	call	WriteString
	call	CrLF
	call	CrLF

									;display instructions to input name and then greet them

			
	mov		edx,OFFSET prgrmInstruct1
	call	WriteString
	mov		ecx, 80
	mov		edx,OFFSET username
	call	ReadString
	call	CrLF
	call	CrLF
	
	mov		edx, OFFSET greeting
	call	WriteString
	mov		edx,OFFSET username
	call	WriteString
	call	CrLF

	ret
		
greet		ENDP

									;restart procedure that's called when the input is incorrect
									;it then calls the input proc again

restart proc									

	call	CrLF
	mov		edx, OFFSET error
	call	WriteString
	call	CrLF
	call	CrLF
	
	call	input	

restart		endp


input proc							;recieves an input and validates from user

									;display instructions to input amount of composite #'s
	
	mov		edx, OFFSET	prgrmInstruct2
	call	WriteString

									;check comp input and loop if not right

	call	ReadInt
	call	CrLF
	cmp		eax,upperlim
	jg		restart					;reset encounter if too high of an input
	cmp		eax,lowerLim
	jl		restart
	mov		userInput, eax
	
	ret
input		endp

arrayFill	proc							;a procedure that takes the users input and fills an array with numbers that are composite up to the users input
	
	mov		esi, OFFSET array1
	mov		ecx, userInput					;fills one more than user wants to cope with not wanting to print 7
	
	mov		ebx, one

loopArrayy:

restr:	

	mov		eax,UserInput					;getting the difference so we can input at the right index 
	
	sub		eax,ecx
	mov		difference,eax

	inc		ebx								;inc number we're checking everytime, reguardless of ecx

	mov		edx,0
	mov		eax,ebx	
	mov		edi, two						;if it passes the cmp it will be appended to the array
	div		edi
	cmp		eax,1							;compare to one since 2,3,5,7 are all prime and we dont want to append them
	je		restr
	cmp		edx,0
	je		compositee

	mov		edx,0
	mov		eax,ebx	
	mov		edi, three						;do not compare eax to one here since qwe want to include the composite 9						
	div		edi
	cmp		eax,1
	je		restr
	cmp		edx,0
	je		compositee
		
	mov		edx,0
	mov		eax,ebx	
	mov		edi, five										
	div		edi	
	cmp		eax,1
	je		restr
	cmp		edx,0
	je		compositee

	mov		edx,0
	mov		eax,ebx	
	mov		edi, seven								
	div		edi
	cmp		eax,1
	je		restr
	cmp		edx,0


	je		compositee
	jne		restr
	
compositee:

	mov		edi,difference					;indexing
	mov		[esi + 4 * edi ], ebx	
	loop	loopArrayy						;ecx is only decremented once we've found a composite

	
	ret
arrayFill	endp

spew		proc
	mov		ecx,userInput					;incrementing ecx and eax to cope with not printing 7

	mov		esi, OFFSET array1
	call	CrLF
	mov		edi, zero
spewLoop:
	
	mov		eax,UserInput 
											;getting the difference so we can input at the right index 
	sub		eax,ecx
	mov		ebx,eax


	mov		eax,[esi + ebx*4]
	call	WriteDEC
	mov		edx,OFFSET spaces
	call	WriteString
	inc		edi
	
											;formatting
	cmp		edi,9
	jle		skipper
	call	CrLF
	mov		edi, zero

skipper:
	loop	spewLoop

spew		endp

	




goodbye		proc					;goodbye and jump to exit point
	call	CrLF
	call	CrLF
	mov		eax,userInput
	mov		edx, OFFSET goodbye1
	call	WriteString
	cmp		eax,upperLim
	call	CrLF

	ret
goodbye		endp



end main
	