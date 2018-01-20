section .text
global editFractal 
;;;;;;;;; ALEKSANDER NUSZEL MANDELBROT SET ;;;;;;;;
;;;;;;;;; 285800 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;; -rdi - bitmap pointer
;;;;; -rsi - current_zoom
;;;;; -rdx - BITMAP_W 
;;;;; -rcx - BITMAP_H
;;;;; -r8 - padding



editFractal:   
	push rbp
	mov rbp, rsp
	
	mov r14, rdx
	add r14, rdx
	add r14, rdx
	
	add r14, r8
	add r14, r14
	

	
;;;;;;;;;; COUNT MISUREWICZ POINT;;;;;;;;
	mov r10, -1528 ; count REAL //-1011
	mov r11,  10000
	cvtsi2sd xmm0, r10 ; load as float
	cvtsi2sd xmm2, r11 ; load as float
	divsd xmm0,xmm2  ; MISUREWICZ x in xmm0

	
	mov r10, 10397 ; count IMAGINARY //9563
	mov r11, 10000;
	cvtsi2sd xmm1, r10 ; load as float
	cvtsi2sd xmm2, r11 ; load as float
	divsd xmm1,xmm2  ; MISUREWICZ y in xmm1

;;;;;;;;; xmm0 : -0,1011
;;;;;;;;; xmm1 :  0,9536


;;;;;;;;; COUNT STARTING POINTs

	mov r10, 4
	cvtsi2sd xmm2, r10
	cvtsi2sd xmm3, rsi
	divsd xmm2, xmm3    ;;; range of x and y divided by current zoom
	
	mov r10, 2         
	cvtsi2sd xmm3, r10 
	divsd xmm2, xmm3    ;;; divide once more
	
	subsd xmm0, xmm2 ;;; -0,1011 - (4/ zoom )/2 
	subsd xmm1, xmm2 ;;; 0,9536 - (4/ zoom )/2

;;;;;;;; xmm0 -starting x 
;;;;;;;; xmm1 -starting y


;;;;;;;; COUNT DIFFERENCES ON X AND Y AND STORE IN xmm3 ADN xmm4

;;;;;;;; 
	mov r10, 4
	cvtsi2sd xmm3, r10
	
	cvtsi2sd xmm4, rdx ; load bitmap width
	
	divsd xmm3, xmm4 ; 4/bitmap_width 
	
	cvtsi2sd xmm4, rsi ; load current zoom
	
	divsd xmm3, xmm4 ; difx/current_zoom  // Dif on X in xmm3
	

	mov r10, 4
	cvtsi2sd xmm4, r10
	
	cvtsi2sd xmm5, rcx ; load bitmap height
	
	divsd xmm4, xmm5 ; 4/bitmap_width 
	
	cvtsi2sd xmm5, rsi ; load current zoom
	
	divsd xmm4, xmm5 ; difx/current_zoom  // Dif on Y in xmm4
	
	movsd xmm2, xmm0

;;;;;;;; xmm2 - copy of starting x ;;;;;;;;;;
;;;;;;;; xmm3 - difference on x ;;;;;;;;;;;;;
;;;;;;;; xmm4 - difference on y ;;;;;;;;;;;;; 
	mov r10, 1
	mov r11, 1
loop_y: 
	cmp r11, rcx ; COMPARE Y counter and height
	jg end  ; jump if r10 is greater than height

	movsd xmm0, xmm2  ; set starting x
	
	mov r10, 1
	


loop_x: 
	cmp r10, rdx ; COMPARE X counter and width
	jg continue_y
	

	;;;;;; copy coordinates ;;;;;;;;;;;;
	;;;;;; to do computation ;;;;;;;;;;;

	movsd xmm5, xmm0  
	movsd xmm6, xmm1
	
	;;;;;; xmm5 - x coordinate ;;;;;;;;;
	;;;;;; xmm6 - y coordinate ;;;;;;;;;
	;;;;;; loop counter ;;;;;;;;;;;;;;;;

	mov r12, 0 ; initialize loop counter with zero
	
loop_z:
	movsd xmm8, xmm5 ; x 
	movsd xmm9, xmm6 ; y
	mulsd xmm5, xmm5 ; x*x = x^2 
	mulsd xmm6, xmm6 ; y*y = y^2
	
	addsd xmm6, xmm5 ; y^2 + x^2 
	mov r13, 4     
	cvtsi2sd xmm7, r13
	ucomisd xmm6, xmm7 ; check if |Xn|^2 > 4 , if yes, jump
	ja loop_finished

	cmp r12, 20 
	jg loop_finished

	add r12, 1 ; increment loop counter

	movsd xmm7, xmm8  ;assign x
 	mulsd xmm7, xmm9  ; x*y // 
	mov r13, 2
	cvtsi2sd xmm6, r13
	mulsd xmm7, xmm6; x*y*2
	
	movsd xmm6, xmm9
	
	mulsd xmm6, xmm6 
	subsd xmm5, xmm6
	
	addsd xmm5, xmm0 ; x^2 - y^2 + x 
	
	addsd xmm7, xmm1 ; x*y*2 + y 
	
	movsd xmm6, xmm7
	
	jmp loop_z
	

loop_finished:
	cmp r12, 20
	jg color_20
	cmp r12, 15
	jg color_15
	cmp r12, 10
	jg color_10
	cmp r12, 8
	jg color_8
	cmp r12, 6
	jg color_6
	cmp r12, 4
	jg color_4
	cmp r12, 2
	jg color_2
	cmp r12, 1
	jg color_1
	cmp r12, 0
	jg color_0

	mov BYTE [rdi], 153
	mov BYTE [rdi+1], 255
	mov BYTE [rdi+2], 255

	

	jmp continue_x

color_20:
	mov BYTE [rdi], 102
	mov BYTE [rdi+1], 0
	mov BYTE [rdi+2], 0
	
	jmp continue_x

color_15:
	mov BYTE [rdi], 255
	mov BYTE [rdi+1], 51
	mov BYTE [rdi+2], 51
	
	jmp continue_x


color_10:
	mov BYTE [rdi], 255
	mov BYTE [rdi+1], 255
	mov BYTE [rdi+2], 255
	
	jmp continue_x


color_8:
	mov BYTE [rdi], 255
	mov BYTE [rdi+1], 102
	mov BYTE [rdi+2], 51
	
	jmp continue_x


color_6:
	mov BYTE [rdi], 255
	mov BYTE [rdi+1], 153
	mov BYTE [rdi+2], 102
	
	jmp continue_x

color_4:
	mov BYTE [rdi], 255
	mov BYTE [rdi+1], 204
	mov BYTE [rdi+2], 153
	
	jmp continue_x

color_2:
	mov BYTE [rdi], 255
	mov BYTE [rdi+1], 204
	mov BYTE [rdi+2], 204
	
	jmp continue_x


color_1:
	mov BYTE [rdi], 255
	mov BYTE [rdi+1], 255
	mov BYTE [rdi+2], 255
	
	jmp continue_x

color_0:
	mov BYTE [rdi], 204
	mov BYTE [rdi+1], 255
	mov BYTE [rdi+2], 255
	
	jmp continue_x

continue_x:
	add rdi,3 ; move bitmap pointer 3bytes
	add r10, 1 ; increment 
	addsd xmm0, xmm3
	jmp loop_x

continue_y:
	
	add rdi,r8 ; add padding
	sub rdi,r14
	addsd xmm1, xmm4
	add r11, 1
	jmp loop_y


end:
	
	mov rsp, rbp
	pop rbp
	ret




