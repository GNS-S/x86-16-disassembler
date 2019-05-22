;Partial disassembler for 16bit assembly code
;Recognizes the most prominent commands/operators
;Specifically modeled after intel 8086 architecture
;Takes two parameters: 1) a .com file to dissasemble 2) a text file to write in

;Variables and commands are not named in english 
;(mostly due to the esoteric and self-improvement driven nature of the project)
;(and, addmitedly, a certain lack of foresight),
;however the code has been annotated

;TODO properly align the output

.model small
READSIZE	EQU 10			;size (in bytes) used in reading buffer
WRITESIZE	EQU 10			;size (in bytes) used in writing buffer
.stack 100h
.data
;--------------------------------------------------------------------------------------------
;COMMAND FORM TABLE
;determines the algorhitm by attributing the first command byte (excluding) prefixes to some format
;not the most elegant solution, however it does shave down the complexity of the code itself considerably
;--------------------------------------------------------------------------------------------
	form_table db 	10, 10, 10, 10, 11, 11, 6, 8, 23, 23, 23, 23, 24, 24, 6, 8, 0, 0, 0, 0, 0, 0, 6, 8, 0, 0, 0, 0, 0, 0, 6, 8,25, 25, 25, 25, 26, 26, 0, 0, 13, 13, 13, 13, 14, 14, 0, 0, 21, 21, 21, 21, 22, 22, 0, 0, 16, 16, 16, 16, 17, 17, 0, 0, 12, 12, 12, 12, 12, 12, 12, 12, 15, 15, 15, 15, 15, 15, 15, 15, 7, 7, 7, 7, 7, 7, 7, 7, 9, 9, 9, 9, 9, 9, 9, 9, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32,18, 18, 18, 18, 0, 0, 0, 0, 1, 1, 1, 1, 2, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 28, 0, 0, 0, 0, 0,3, 3, 3, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4,0, 0, 29, 36, 0, 0, 5, 5, 0, 0, 0, 0, 0, 35, 0, 0, 37, 37, 37, 37, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,0, 0, 34, 0, 0, 0, 0, 0, 27, 30, 31, 33, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 19, 19, 0, 0, 0, 0, 0, 0, 20, 20
;---------------------------------------------------------------------------------------------
;RECOGNIZEABLE COMMANDS
;---------------------------------------------------------------------------------------------
    k_MOV db 09h, 'MOV', 09h
	k_PUSH db 09h, 'PUSH', 09h
	k_POP db 09h, 'POP', 09h
	k_INC db 09h, 'INC', 09h
	k_DEC db 09h, 'DEC', 09h
	k_SUB db 09h, 'SUB', 09h
	k_CMP db 09h, 'CMP', 09h
	k_ADD db 09h, 'ADD', 09h
	k_MUL db 09h, 'MUL', 09h
	k_DIV db 09h, 'DIV', 09h
	k_CALL db 09h, 'CALL', 09h
	k_JMPCONDITIONAL db 09h, 'JO ', 09h, 09h, 'JNO', 09h,09h, 'JB ', 09h,09h, 'JAE', 09h,09h, 'JE ', 09h,09h, 'JNE', 09h,09h, 'JBE', 09h,09h, 'JA ', 09h,09h, 'JS ', 09h,09h, 'JNS', 09h,09h, 'JPE', 09h,09h, 'JNP', 09h,09h, 'JL ', 09h,09h, 'JGE', 09h,09h, 'JLE', 09h,09h, 'JG ', 09h
	k_ROTATE db 09h, 'ROL', 09h, 09h, 'ROR', 09h, 09h, 'RCL', 09h, 09h, 'RCR', 09h, 09h, 'SHL', 09h, 09h, 'SHR', 09h, 09h, 'SAR', 09h, 09h, 'SAR', 09h
	k_LOOP db 09h, 'LOOP', 09h
	k_RET db 09h, 'RET', 09h
	k_XOR db 09h, 'XOR', 09h
	k_OR db 09h, 'OR ', 09h
	k_AND db 09h, 'AND', 09h
	k_JMP db 09h, 'JMP', 09h
	k_INT db 09h, 'INT', 09h
;---------------------------------------------------------------------------------------------
;REGISTER NAMES AND THEIR COUNTERPARTS IN NUMBERS
;---------------------------------------------------------------------------------------------
    r_AL db 'al'	;10		bx+si+displacement -> 01
    r_CL db 'cl'	;20		bx+di+displacement -> 02		
    r_DL db 'dl'	;30		bp+si+displacement -> 03
    r_BL db 'bl'	;40		bp+di+displacement -> 04
    r_AH db 'ah'	;50		si+displacement -> 05
    r_CH db 'ch'	;60		di+displacement -> 06
    r_DH db 'dh'	;70		direct/bp+displacement -> 07
    r_BH db 'bh'	;80		bx+displacement -> 08
	r_AX db 'ax'	;11		prefix only -> 09
    r_CX db 'cx'	;21		direct operator -> 90
    r_DX db 'dx'	;31
    r_BX db 'bx'	;41
    r_SP db 'sp'	;51
    r_BP db 'bp'	;61
    r_SI db 'si'	;71
    r_DI db 'di'	;81
	r_bxsi db 'bx+si'
	r_bxdi db 'bx+di'
	r_bpsi db 'bp+si'
	r_bpdi db 'bp+di'
	s_es    db  'es'    ;26h
	s_cs    db  'cs'    ;2Eh
	s_ss    db  'ss'    ;36h
	s_ds    db  'ds'    ;3Eh
;---------------------------------------------------------
;VARIABLES
;---------------------------------------------------------
	cs_poslinkis dw 0100h
	tab db 09h
	newline	db	13, 10
	dvitaskis db ':'
	lauztas1 db '['
	lauztas2 db ']'
	plius db '+'
	kablelis_tarpas db ', '
	word_ptr db 'word ptr'
	byte_ptr db 'byte ptr'
	nezinomas_baitas db 09h, 'UNRECOGNIZED' ;the first byte of the command was not recognized
	pirmas_baitas db ?
	opk_baitas db ?
	prefiksas db 00			;prefix byte, possible values: 26 - ES, 2E - CS, 36 - SS, 3E - DS
	reg_reiksme db 00		;register
	rm_reiksme db 00		;r/m
	seg_reg db 00			;segment register
	pirma_puse db 00 		;the first 'half' of the output
	antra_puse db 00 		;the second 'half' of the output
	poslinkis_kiek db 00	;displacement in bytes
	laikinas db ? 			;temp byte for outputing a hex value
	poslinkis_byte db ?		;displacement byte
	poslinkis_word dw ?		;displacement word
	b_op dw 0000			;direct operator
	b_op2 dw 0000			;direct operator 2
	kiek_b_op db 00 		;how many bytes is the direct operator
	artiesioginis db 00h 	;flag shows whether the operation is 'direct'
	tiesioginis_adr dw 0000h
	ar_ptr	db	00h
	placeholder db ? 		;used for general algebra
	read	db	10 dup (?)
	write	db	10 dup (?)
	rhandle	dw	?
	whandle	dw	?
	kiek_buferis db 00 		;amount read (bytes)
	buferis db READSIZE dup (?)
	rasymo_buferis db WRITESIZE dup (?)
	kur_rasymas db 00		;writing buffer pointer location
;---------------------------------------------------------
;ERRORS/MESSAGES
;---------------------------------------------------------
	open_err	db		'an error occured while trying to open a file', '$'
	close_err	db		'an error occured while trying to close a file', '$'
	reading_err		db	'an error occured while reading a file', '$'
	writing_err		db	'an error occured while writing a file', '$'
	help_message	db 	'16 bit disassembler, takes 2 operators'
					db 	13,10,0 
					db 	'1) .com file to dissasemble'
					db 	13,10,0 
					db	'2) text file to write in.'
					db 	13,10,0 
					db 	'(poorly) Written by Ignas S.', '$'
;---------------------------------
.code
;--------------------------------
mov ax, @data
mov ds, ax
;------------------------------------------------------------
;PARAMETERS, FILE OPENING
;------------------------------------------------------------
	call parametrai
	call atidaryk_failus
;------------------------------------------------------------
;MAIN WORK CYCLE
;------------------------------------------------------------
ciklas:
	call isvesk_cs_poslinki
ciklas_prefix:
	call skaitymas
	inc si
	dec byte ptr[kiek_buferis]
	xor ax, ax
	call atpazinimas 				;tries to recognize the byte
	mov byte ptr[opk_baitas], al
	call komandos_info				;collects the byte info and form both 'sides' of the output
	formatas_sutvarkytas:
	call komandos_rasymas			;writes the command
	komanda_surasyta:
	call nunulinimas				;annulates all variables

jmp ciklas

;------------------------------------------------------------
;PROGRAM END
;------------------------------------------------------------
pabaiga:
	xor cx, cx
	mov cl, kur_rasymas
	call rasyk_buferi
	call uzdaryk_failus ;close the files
;--------------------------------	
pabaiga_return0: ;jump point for when the files were never opened
	mov ax, 4C00h; RETURN 0;
	int 21h
;------------------------------------------------------------
;WRITES THE CODE SEGMENT DISPLACEMENT IN OUTPUT
;------------------------------------------------------------
isvesk_cs_poslinki:
	mov ax, cs_poslinkis
	xchg ah, al
	call surasyk_hexa
	xchg ah, al
	call surasyk_hexa
	mov di, offset dvitaskis
	mov cl, 01
	call surasyk_buferi
	mov di, offset tab
	mov cl, 01
	call surasyk_buferi
	xor di, di
	xor cx, cx
	ret

;---------------------------------------------
;USES THE TABLE TO RECOGNIZE THE COMMAND BYTE
;---------------------------------------------
atpazinimas:
    mov al,[si]
    call ar_prefiksas
	mov bx, offset form_table
	add bx, ax
	mov cl, [bx]
	call surasyk_hexa
	inc word ptr[cs_poslinkis]
    RET
;--------------------------------------------
;CHECKS WHETHER THE BYTE IS A COMMAND PREFIX
;--------------------------------------------
ar_prefiksas:
    cmp al, 26h
	JE prefiksas_yra
	cmp al, 2Eh
	JE prefiksas_yra
	cmp al, 36h
	JE prefiksas_yra
	cmp al, 3Eh
	JE prefiksas_yra
	RET
	
	prefiksas_yra:
	mov prefiksas, al
	call surasyk_hexa
	jmp ciklas_prefix
;--------------------------------
;TAKES NEW BYTE
;--------------------------------
imk_baita:
	xor ax, ax
	call skaitymas
	inc si
	dec byte ptr[kiek_buferis]
	mov al, [si]
	call surasyk_hexa
	inc word ptr[cs_poslinkis]
	ret

;--------------------------------
	
	neatpazintas_baitas: ;unrecognized byte
	mov di, offset nezinomas_baitas
	mov cl, 13
	call surasyk_buferi
	call f_newline
	jmp komanda_surasyta
	baitas_ret:
	mov cl, 29 
	jmp formatas_sutvarkytas

;------------------------------------------------------------
;DETERMINES THE COMMAND BY THE OPERATION BYTE
;then funnels into the right format algorithm accordingly
;------------------------------------------------------------
komandos_info:
    cmp cl, 00
	je neatpazintas_baitas
	cmp cl, 36
	je baitas_ret
    
	cmp cl, 01
	je formatas1
	cmp cl, 10
	je formatas1
	cmp cl, 13
	je formatas1
	cmp cl, 16
	je formatas1
	cmp cl, 21
	je formatas1
	cmp cl, 23
	je formatas1
	cmp cl, 25
	je formatas1
	
	cmp cl, 02
	je formatas2
	
	cmp cl, 03
	je formatas3
	
	cmp cl, 04
	je formatas4
	
	cmp cl, 05
	je formatas5
	
	cmp cl, 10
	jl formatas67
	cmp cl, 12
	je formatas67
	cmp cl, 15
	je formatas67
	
	cmp cl, 11
	je formatas8
	cmp cl, 14
	je formatas8
	cmp cl, 17
	je formatas8
	cmp cl, 22
	je formatas8
	cmp cl, 24
	je formatas8
	cmp cl, 26
	je formatas8
	
	cmp cl, 18
	je formatas9
	
	cmp cl, 21
	jl formatas10
	
	cmp cl, 32
	jl formatas11

	cmp cl, 36
	jl formatas12
	
	cmp cl, 37
	je formatas13

	formatas1:
	jmp pirmas_formatas
	formatas2:
	jmp antras_formatas
	formatas3:
	jmp trecias_formatas
	formatas4:
	jmp ketvirtas_formatas
	formatas5:
	jmp penktas_formatas
	formatas67:
	jmp sestas_septintas_formatas
	formatas8:
	jmp astuntas_formatas
	formatas9:
	jmp devintas_formatas
	formatas10:
	jmp desimtas_formatas
	formatas11:
	jmp vienuoliktas_formatas
	formatas12:
	jmp dvyliktas_formatas
	formatas13:
	jmp tryliktas_formatas
	
;----------------------------------------------------
;GENERAL REGISTER, REGISTER/MEMORY FUNCTIONS
;brings - al the byte itself, bl - w
;----------------------------------------------------
skaiciuok_reg: 
	push bx
	push ax
	
	and al, 00111000b
	shr al, 3
	
	cmp al, 0
	JE Reg000
	cmp al, 1
	JE Reg001
	cmp al, 2
	JE Reg010
	cmp al, 3
	JE Reg011
	cmp al, 4
	JE Reg100
	cmp al, 5
	JE Reg101
	cmp al, 6
	JE Reg110
	cmp al, 7
	JE Reg111
	
	Reg000:
	mov al, 10
	jmp reg_tesinys
	Reg001:
	mov al, 20
	jmp reg_tesinys
	Reg010:
	mov al, 30
	jmp reg_tesinys
	Reg011:
	mov al, 40
	jmp reg_tesinys
	Reg100:
	mov al, 50
	jmp reg_tesinys
	Reg101:
	mov al, 60
	jmp reg_tesinys
	Reg110:
	mov al, 70
	jmp reg_tesinys
	Reg111:
	mov al, 80

	reg_tesinys:
	add al, bl
	mov reg_reiksme, al
	pop ax 
	pop bx
	ret
	
rask_rm: ;brings al - the byte itself, bl - w, bh - d
	push ax
	
	and al, 11000000b
	shr al, 6	
	cmp al, 3
	je mod11
	mov poslinkis_kiek, al

	pop ax
	call skaiciuok_rm	
	ret

	mod11:
	pop ax
	push ax
	and al, 00000111b
	shl al, 3
	call skaiciuok_reg
	mov al, reg_reiksme
	mov rm_reiksme, al
	pop ax	
	ret
	
skaiciuok_rm:	;brings al - the byte itself, bl - w, bh - d
	push ax
	and al, 00000111b
	inc al
	mov rm_reiksme, al
	pop ax
	ret
	
tvarkyk_poslinki:
	push bx
	cmp byte ptr[poslinkis_kiek], 00
	je tvarkyk_poslinki_pabaiga
	call imk_baita
		cmp byte ptr[poslinkis_kiek], 02
		JE tvarkyk_poslinki_word
	mov poslinkis_byte, al
	jmp tvarkyk_poslinki_pabaiga
	tvarkyk_poslinki_word:
	mov bl, al
	call imk_baita
	mov ah, bl
	mov poslinkis_word, ax
	tvarkyk_poslinki_pabaiga:
	pop bx
	ret
	
tvarkyk_tiesioginiadr:
	push bx
	cmp byte ptr[poslinkis_kiek], 00
		jne tvarkyk_tiesioginiadr_pabaiga
	cmp byte ptr[rm_reiksme], 07
		jne tvarkyk_tiesioginiadr_pabaiga
	call imk_baita
	mov bl, al
	call imk_baita
	mov ah, bl
	xchg ah, al
	mov tiesioginis_adr, ax
	tvarkyk_tiesioginiadr_pabaiga:
	pop bx
	ret
	
tvarkyk_b_op: ;brings cl - the size of the direct opetator, writes b_op
	push ax
	push bx
	xor ax, ax
	call imk_baita
	cmp cl, 03
	je tvarkyk_b_op_s01
	mov b_op, ax
	cmp cl, 01
		je tvarkyk_b_op_pabaiga
		mov bl, al
		call imk_baita
		mov ah, bl
		mov b_op, ax
	tvarkyk_b_op_pabaiga:
	mov kiek_b_op, cl
	pop bx
	pop ax
	ret
	
	tvarkyk_b_op_s01:
	dec cl
	cmp al, 7Fh
	jg tvarkyk_b_op_s01FF
	mov b_op, ax
	jmp tvarkyk_b_op_pabaiga
	tvarkyk_b_op_s01FF:
	mov ah, 0FFh
	mov b_op, ax
	jmp tvarkyk_b_op_pabaiga
	
surask_segreg: ; find and writes segreg, brings al - 000000xx
	and al, 00000011b
	cmp al, 00
	je surask_segreg_es
	cmp al, 01
	je surask_segreg_cs
	cmp al, 02
	je surask_segreg_ss
	cmp al, 03
	je surask_segreg_ds

	surask_segreg_es:
	mov al, 26h
	jmp surask_segreg_galas
	surask_segreg_cs:
	mov al, 2Eh
	jmp surask_segreg_galas
	surask_segreg_ss:
	mov al, 36h
	jmp surask_segreg_galas
	surask_segreg_ds:
	mov al, 3Eh
	
	surask_segreg_galas:
	mov seg_reg, al
	mov al, byte ptr[opk_baitas]
	ret
	
	
sukeisk_puses:
	mov dl, pirma_puse
	mov dh, antra_puse
	mov pirma_puse, dh
	mov antra_puse, dl
	ret
	
nunulinimas:
	mov ax, 0000h
	mov reg_reiksme, ah
	mov rm_reiksme, ah
	mov poslinkis_byte, ah
	mov poslinkis_kiek, ah
	mov poslinkis_word, ax
	mov tiesioginis_adr, ax
	mov prefiksas, ah
	mov artiesioginis, ah
	mov opk_baitas, ah
	mov b_op, ax
	mov b_op2, ax
	mov kiek_b_op, ah
	mov pirma_puse, ah
	mov antra_puse, ah
	mov ar_ptr, ah
	mov placeholder, ah
	ret
	
;----------------------------------------------------
;GENERAL INPUT/OUTPUT FUNCTION FOR CONVENIENCE
;----------------------------------------------------
surasyk_buferi:		;adds to the write buffer, brings - di - offset from where to write, cl - how much to write (bytes)
	push si	
	push ax
	push dx
	xor ax, ax
	
	mov si, 00
	mov al, kur_rasymas
	add si, ax
	
	mov ch, kur_rasymas	
	add cl, ch
	
	s_buf_ciklas:
	mov ah, [di]
	mov [rasymo_buferis+si], ah
	inc si
	inc di
	inc ch
	
	call rasymas
	
	cmp cl, ch		; cl - the byte after converting, ch - what we have now
	JNE s_buf_ciklas
	
	mov kur_rasymas, cl
	
	pop dx
	pop ax
	pop si
	ret

surasyk_hexa: ;writes the hex code of the byte within ah into the write buffer
	push bx
	push cx
	push dx
	push ax
	
	mov dx, 0
	
	shr al, 4
	jmp antras_hexas_skip
	antras_hexas:
	pop ax
	push ax
	and al, 00001111b
	antras_hexas_skip:
	
	mov di, offset laikinas
	mov cl, 1
	
		cmp al, 9
			JG surasyk_hexa_r
		add al, 30h
		mov laikinas, al
		call surasyk_buferi
		jmp surasyk_hexa_skip
			surasyk_hexa_r:
			add al, 37h
			mov laikinas, al
			call surasyk_buferi
	surasyk_hexa_skip:
	inc dh
	cmp dh, 2
	jne antras_hexas  
	
	pop ax
	pop dx
	pop cx
	pop bx
	ret
	
f_lauztas1:
	push cx
	push di
	mov di, offset lauztas1 
	mov cl, 01
	call surasyk_buferi
	pop di
	pop cx
	ret

f_lauztas2:
	push cx
	push di
	mov di, offset lauztas2
	mov cl, 01
	call surasyk_buferi
	pop di
	pop cx
	ret
	
f_newline:
	push cx
	mov di, offset newline
	mov cl, 02
	call surasyk_buferi
	pop cx
	ret
	
f_dvitaskis:
	mov di, offset dvitaskis
	mov cl, 01
	call surasyk_buferi
	ret
	
f_tab:
	push di
	push cx
	mov di, offset tab
	mov cl, 01
	call surasyk_buferi
	pop cx
	pop di
	ret
	
f_prefiksas:
	push ax
	push bx
	push cx
	cmp al, 09
	je f_prefiksas_skip
	cmp byte ptr[prefiksas], 00h
	je f_prefiksas_pabaiga
	cmp al, 09
	jg f_prefiksas_pabaiga
	f_prefiksas_skip:
	call f_segreg
	cmp byte ptr[prefiksas], 26h
	je f_prefiksas_26
	cmp byte ptr[prefiksas], 2Eh
	je f_prefiksas_2E
	cmp byte ptr[prefiksas], 36h
	je f_prefiksas_36
	cmp byte ptr[prefiksas], 3Eh
	je f_prefiksas_3E
	
	f_prefiksas_26:
	mov di, offset s_es
	jmp f_prefiksas_nustatytas
	f_prefiksas_2E:
	mov di, offset s_cs
	jmp f_prefiksas_nustatytas
	f_prefiksas_36:
	mov di, offset s_ss
	jmp f_prefiksas_nustatytas
	f_prefiksas_3E:
	mov di, offset s_ds
	
	f_prefiksas_nustatytas:
	mov cl, 2
	call surasyk_buferi
	cmp al, 09
	je f_prefiksas_pabaiga
	call f_dvitaskis
	f_prefiksas_pabaiga:
	call f_segreg
	pop cx
	pop bx
	pop ax
	ret
	
f_segreg:
	cmp al, 09
	jne f_segreg_ret
	mov  ah, byte ptr[seg_reg]
	xchg ah, byte ptr[prefiksas]
	mov byte ptr[seg_reg], ah
	f_segreg_ret:
	ret
	
f_betarpis_operandas:
    push ax
	cmp al, 90
	jne f_betarpis_operandas_ret
	
	mov ax, b_op
	call surasyk_hexa
	cmp byte ptr[kiek_b_op], 01
	je f_betarpis_operandas_ret
		xchg al, ah
		call surasyk_hexa
		
	f_betarpis_operandas_ret:
	pop ax
	ret
	
f_ptr:
	push di
	push cx
	
	cmp b_op, 0000h
	je f_ptr_ret
	f_ptr_cont:
	cmp bl, 01
		je f_ptr_word
	mov di, offset byte_ptr
	jmp f_ptr_skip
		f_ptr_word:
		mov di, offset word_ptr
	f_ptr_skip:
	mov cl, 08
	call surasyk_buferi
	jmp f_ptr_cont_2
	f_ptr_ret:
	cmp ar_ptr, 00
	jne f_ptr_cont
	f_ptr_cont_2:
	pop cx
	pop di
	ret
;-----------------------------------------------------------------------------------------
;DETERMINES THE COMMAND
;used for when the format is insufficient e.g. the command indentificator spans 2 bytes
;-----------------------------------------------------------------------------------------
	f_kokia_komanda20:
	cmp al, 00
	je f_kokia_komanda20_inc
	cmp al, 01
	je f_kokia_komanda20_dec
	cmp al, 04
	jl f_kokia_komanda20_call
	cmp al, 06
	jl f_kokia_komanda20_jmp
	cmp al, 06
	je f_kokia_komanda20_push
	jmp neatpazintas_baitas
	
	f_kokia_komanda20_inc:
	mov cl, 12
	jmp f_kokia_komanda_ret
	f_kokia_komanda20_dec:
	mov cl, 15
	jmp f_kokia_komanda_ret
	f_kokia_komanda20_call:
	mov cl, 27
	jmp f_kokia_komanda_ret
	f_kokia_komanda20_jmp:
	mov cl, 30
	jmp f_kokia_komanda_ret
	f_kokia_komanda20_push:
	mov cl, 6
	jmp f_kokia_komanda_ret
	
f_kokia_komanda:
	push ax
	and al, 00111000b
	shr al, 3
	cmp cl, 19
	je f_kokia_komanda19
	cmp cl, 20
	je f_kokia_komanda20
	cmp al, 00
	je f_kokia_komanda_add
	cmp al, 5
	je f_kokia_komanda_sub
	cmp al, 7
	je f_kokia_komanda_cmp
	cmp al, 6
	je f_kokia_komanda_xor
	cmp al, 1
	je f_kokia_komanda_or
	cmp al, 4
	je f_kokia_komanda_and	
	jmp neatpazintas_baitas
	f_kokia_komanda_ret:
	pop ax
	ret
	
	f_kokia_komanda_add:
	mov cl, 11
	jmp f_kokia_komanda_ret
	f_kokia_komanda_sub:
	mov cl, 14
	jmp f_kokia_komanda_ret
	f_kokia_komanda_cmp:
	mov cl, 17
	jmp f_kokia_komanda_ret
	f_kokia_komanda_xor: 	
	mov cl, 21
	f_kokia_komanda_or: 	
	mov cl, 23
	jmp f_kokia_komanda_ret
	f_kokia_komanda_and:
	mov cl, 25
	jmp f_kokia_komanda_ret
	
	f_kokia_komanda19:
	inc byte ptr [ar_ptr]
	cmp al, 4
	je f_kokia_komanda19_mul
	cmp al, 6
	je f_kokia_komanda19_div
	jmp neatpazintas_baitas
	
	f_kokia_komanda19_mul:
	mov cl, 19
	jmp f_kokia_komanda_ret
	f_kokia_komanda19_div:
	mov cl, 20
	jmp f_kokia_komanda_ret
;--------------------------------
;MAIN OUTPUT SECTION
;brings cl - format, pirma_puse, antra_puse, bl - w
;--------------------------------
komandos_rasymas:

	call f_tab
	call komandos_rasymas_opk
	
	cmp byte ptr[pirma_puse], 00h
	je antra_dalis
	
	mov al, pirma_puse
	call komandos_rasymas_puse
	
	antra_dalis:
	cmp byte ptr[antra_puse], 00h
	je komandos_rasymas_pabaiga
	
	call komandos_rasymas_vidurys
	
	mov al, antra_puse
	call komandos_rasymas_puse
	
	komandos_rasymas_pabaiga:
	call f_newline
	jmp komanda_surasyta
	
komandos_rasymas_vidurys:
	cmp byte ptr[pirma_puse], 90
	je komandos_rasymas_vidurys_ar
	komandos_rasymas_vidurys_ne:
	mov di, offset kablelis_tarpas
	mov cl, 02
	call surasyk_buferi
	ret
	komandos_rasymas_vidurys_ar:
	cmp byte ptr[antra_puse], 90
	jne komandos_rasymas_vidurys_ne
	mov di, offset dvitaskis
	mov cl, 01
	call surasyk_buferi
	mov dx, word ptr[b_op2]
	mov word ptr[b_op], dx 
	ret
	
	
komandos_rasymas_puse:
	mov cl, 2
	mov dl, 0 ;displacement flag
	
	call f_prefiksas
	call f_betarpis_operandas
	
	cmp al, 10
	je krp_al
	cmp al, 20
	je krp_cl
	cmp al, 30
	je krp_dl
	cmp al, 40
	je krp_bl
	cmp al, 50
	je krp_ah
	cmp al, 60
	je krp_ch
	cmp al, 70
	je krp_dh
	cmp al, 80
	je krp_bh
	cmp al, 11
	je krp_ax
	cmp al, 21
	je krp_cx
	cmp al, 31
	je krp_dx
	cmp al, 41
	je krp_bx
	cmp al, 51
	je krp_sp
	cmp al, 61
	je krp_bp
	cmp al, 71
	je krp_si
	cmp al, 81
	jmp krp_sekcija_skip
	
	krp_al:
	mov di, offset r_AL
	jmp komandos_rasymas_puse_pabaiga
	krp_cl:
	mov di, offset r_CL
	jmp komandos_rasymas_puse_pabaiga
	krp_dl:
	mov di, offset r_DL
	jmp komandos_rasymas_puse_pabaiga
	krp_bl:
	mov di, offset r_BL
	jmp komandos_rasymas_puse_pabaiga
	krp_ah:
	mov di, offset r_AH
	jmp komandos_rasymas_puse_pabaiga
	krp_ch:
	mov di, offset r_CH
	jmp komandos_rasymas_puse_pabaiga
	krp_dh:
	mov di, offset r_DH
	jmp komandos_rasymas_puse_pabaiga
	krp_bh:
	mov di, offset r_BH
	jmp komandos_rasymas_puse_pabaiga
	krp_ax:
	mov di, offset r_AX
	jmp komandos_rasymas_puse_pabaiga
	krp_cx:
	mov di, offset r_CX
	jmp komandos_rasymas_puse_pabaiga
	krp_dx:
	mov di, offset r_DX
	jmp komandos_rasymas_puse_pabaiga
	krp_bx:
	mov di, offset r_BX
	jmp komandos_rasymas_puse_pabaiga
	krp_sp:
	mov di, offset r_SP
	jmp komandos_rasymas_puse_pabaiga
	krp_bp:
	mov di, offset r_BP
	jmp komandos_rasymas_puse_pabaiga
	krp_si:
	mov di, offset r_SI
	jmp komandos_rasymas_puse_pabaiga
	krp_di:
	mov di, offset r_DI
	jmp komandos_rasymas_puse_pabaiga
	krp_bxsipsl:
	call komandos_rasymas_puse_trumpinys
	mov cl, 5
	mov di, offset r_bxsi
	jmp komandos_rasymas_puse_pabaiga
	krp_bxdipsl:
	call komandos_rasymas_puse_trumpinys
	mov cl, 5
	mov di, offset r_bxdi
	jmp komandos_rasymas_puse_pabaiga
	krp_bpsipsl:
	call komandos_rasymas_puse_trumpinys
	mov cl, 5
	mov di, offset r_bpsi
	jmp komandos_rasymas_puse_pabaiga
	krp_bpdipsl:
	call komandos_rasymas_puse_trumpinys
	mov cl, 5
	mov di, offset r_bxdi
	jmp komandos_rasymas_puse_pabaiga
	krp_sipsl:
	call komandos_rasymas_puse_trumpinys
	mov di, offset r_SI
	jmp komandos_rasymas_puse_pabaiga
	krp_dipsl:
	call komandos_rasymas_puse_trumpinys
	mov di, offset r_DI
	jmp komandos_rasymas_puse_pabaiga
	krp_bxpsl:
	call komandos_rasymas_puse_trumpinys
	mov di, offset r_BX
	jmp komandos_rasymas_puse_pabaiga
	
	krp_sekcija_skip:
	je krp_di
	cmp al, 01
	je krp_bxsipsl
	cmp al, 02
	je krp_bxdipsl
	cmp al, 03
	je krp_bpsipsl
	cmp al, 04
	je krp_bpdipsl
	cmp al, 05
	je krp_sipsl
	cmp al, 06
	je krp_dipsl
	cmp al, 07
	je krp_tiesbpposl
	cmp al, 08
	je krp_bxpsl
	ret
	
	krp_tiesbpposl:
	cmp byte ptr[poslinkis_kiek], 00h
	je krp_tiesioginis_adr
	call komandos_rasymas_puse_trumpinys
	mov di, offset r_BP
	jmp komandos_rasymas_puse_pabaiga
	
	komandos_rasymas_puse_pabaiga:
	call surasyk_buferi
	cmp dl, 00
	jg komandos_rasymas_puse_psl
	ret
	komandos_rasymas_puse_ret:
	call f_lauztas2
	ret
	
	komandos_rasymas_puse_psl:
	mov dl, byte ptr[poslinkis_kiek]
	cmp dl, 00
		je komandos_rasymas_puse_ret
	
		mov di, offset plius ;isvedam pliusa
		mov cl, 01
		call surasyk_buferi
	
	cmp dl, 02
		je komandos_rasymas_puse_psl_word ;displacement is the size of a word
		
	mov al, poslinkis_byte	;displacement is the size of a byte
	call surasyk_hexa
		jmp komandos_rasymas_puse_ret
		
	komandos_rasymas_puse_psl_word:
	mov ax, poslinkis_word
	call surasyk_hexa
	xchg al, ah
	call surasyk_hexa
		jmp komandos_rasymas_puse_ret
	
	krp_tiesioginis_adr:
	call f_ptr
	call f_lauztas1
	mov ax, tiesioginis_adr
	xchg al, ah
	call surasyk_hexa
	xchg al, ah
	call surasyk_hexa
	jmp komandos_rasymas_puse_ret
	
komandos_rasymas_opk:
	mov ch, 05
	 
	cmp cl, 06
	jl komandos_rasymas_opk_MOV
	cmp cl, 08
	jl komandos_rasymas_opk_PUSH
	cmp cl, 10
	jl  komandos_rasymas_opk_POP
	cmp cl, 12
	jl  komandos_rasymas_opk_ADD
	cmp cl, 12
	je  komandos_rasymas_opk_INC
	cmp cl, 15
	jl  komandos_rasymas_opk_SUB
	cmp cl, 15
	je komandos_rasymas_opk_DEC
	cmp cl, 18
	jl komandos_rasymas_opk_CMP
	cmp cl, 19
	je komandos_rasymas_opk_MUL
	cmp cl, 20
	je komandos_rasymas_opk_DIV
	cmp cl, 23
	jl komandos_rasymas_opk_XOR
	cmp cl, 25
	jl komandos_rasymas_opk_OR
	cmp cl, 27
	jl komandos_rasymas_opk_AND
	cmp cl, 29
	jl komandos_rasymas_opk_CALL
	cmp cl, 29
	je komandos_rasymas_opk_RETK
	cmp cl, 32
	je komandos_rasymas_opk_pagalbinis
	cmp cl, 33
	jl komandos_rasymas_opk_JMP
	cmp cl, 34
	je komandos_rasymas_opk_LOOP
	cmp cl, 35 
	je komandos_rasymas_opk_INT
	cmp cl, 37
	je komandos_rasymas_opk_ROTATE
	komandos_rasymas_opk_pagalbinis:
	jmp komandos_rasymas_opk_JMPCON
	
	komandos_rasymas_opk_MOV:
	mov di, offset k_MOV
	jmp komandos_rasymas_opk_ret
	
	komandos_rasymas_opk_PUSH:
	mov di, offset k_PUSH
	mov ch, 06
	jmp komandos_rasymas_opk_ret
	
	komandos_rasymas_opk_POP:
	mov di, offset k_POP
	jmp komandos_rasymas_opk_ret
	
	komandos_rasymas_opk_ADD:
	mov di, offset k_ADD
	jmp komandos_rasymas_opk_ret
	
	komandos_rasymas_opk_INC:
	mov di, offset k_INC
	jmp komandos_rasymas_opk_ret
	
	komandos_rasymas_opk_SUB:
	mov di, offset k_SUB
	jmp komandos_rasymas_opk_ret
	
	komandos_rasymas_opk_DEC:
	mov di, offset k_DEC
	jmp komandos_rasymas_opk_ret
	
	komandos_rasymas_opk_CMP:
	mov di, offset k_CMP
	jmp komandos_rasymas_opk_ret
	
	komandos_rasymas_opk_MUL:
	mov di, offset k_MUL
	jmp komandos_rasymas_opk_ret
	
	komandos_rasymas_opk_DIV:
	mov di, offset k_DIV
	jmp komandos_rasymas_opk_ret
	
	komandos_rasymas_opk_XOR:
	mov di, offset k_XOR
	jmp komandos_rasymas_opk_ret
	
	komandos_rasymas_opk_OR:
	mov di, offset k_OR
	jmp komandos_rasymas_opk_ret
	
	komandos_rasymas_opk_AND:
	mov di, offset k_AND
	jmp komandos_rasymas_opk_ret
	
	komandos_rasymas_opk_CALL:
	mov di, offset k_CALL
	inc ch
	jmp komandos_rasymas_opk_ret
	
	komandos_rasymas_opk_RETK:
	mov di, offset k_RET
	jmp komandos_rasymas_opk_ret
	
	komandos_rasymas_opk_JMP:
	mov di, offset k_JMP
	jmp komandos_rasymas_opk_ret
	
	komandos_rasymas_opk_LOOP:
	inc ch
	mov di, offset k_LOOP
	jmp komandos_rasymas_opk_ret
	
	komandos_rasymas_opk_INT:
	mov di, offset k_INT
	jmp komandos_rasymas_opk_ret
	
	komandos_rasymas_opk_ROTATE:
	xor ax, ax
	mov al, placeholder
	and al, 00111000b
	shr al, 3
	mov cl, 05
	mul cl
	mov di, offset k_ROTATE
	add di, ax
	mov ch, 05
	jmp komandos_rasymas_opk_ret
	
	komandos_rasymas_opk_JMPCON:
	xor ax, ax
	mov al, byte ptr[opk_baitas]
	and al, 00001111b
	mov cl, 05
	mul cl
	mov di, offset k_JMPCONDITIONAL
	add di, ax
	mov ch, 05
	
	komandos_rasymas_opk_ret:
	xchg ch, cl
	call surasyk_buferi
	ret
	
komandos_rasymas_puse_trumpinys:
	call f_ptr 
	call f_lauztas1
	inc dl
	ret
	
;--------------------------------
;FORMAT PROCESSING
;brings - al the command byte, cl - format
;--------------------------------
pirmas_formatas:
	
	and al, 00000001b
	mov bl, al ; if bl=01, then w=1, vice versa
	mov al, byte ptr[opk_baitas]
	and al, 00000010b
	shr al, 1
	mov bh, al ; if bh=01, then d=01, vice versa
	call imk_baita
	call rask_rm
	call skaiciuok_reg
	call tvarkyk_poslinki
	call tvarkyk_tiesioginiadr
	mov dl, reg_reiksme
	mov pirma_puse, dl
	mov dh, rm_reiksme
	mov antra_puse, dh
	cmp bh, 00
	je sukeisti_puses
	jmp formatas_sutvarkytas
	sukeisti_puses:
	call sukeisk_puses
	jmp formatas_sutvarkytas

antras_formatas:
	
	and al, 00000010b
	shr al, 1
	mov bh, al ;bh=d
	mov bl, 01; w=01
	call imk_baita
	call rask_rm
	call tvarkyk_poslinki
	call tvarkyk_tiesioginiadr
	mov dh, rm_reiksme
	mov antra_puse, dh
	shl al, 3
	call surask_segreg
	mov al, 09
	mov pirma_puse, al
	cmp bh, 00
	je sukeisti_puses
	jmp formatas_sutvarkytas
	
trecias_formatas:
	push cx
	and al, 00000001b; w
	mov bl, 10 ;register al
	add bl, al ; if increases by one - ax
	mov pirma_puse, bl
	mov al, byte ptr[opk_baitas]
	and al, 00000010b
	shr al, 1
	mov bh, al ;bh=d
	mov cl, 07
	mov rm_reiksme, cl ; direct adress
	mov antra_puse, cl
	pop cx
	call tvarkyk_tiesioginiadr
	cmp bh, 01
	je sukeisti_puses
	jmp formatas_sutvarkytas
	
ketvirtas_formatas:
	and al, 00001000b; w
	shr al, 3
	mov bl, al; bl=w
	mov al, byte ptr[opk_baitas]
	shl al, 3
	call skaiciuok_reg
	mov al, reg_reiksme
	mov pirma_puse, al
	mov cl, 01
	add cl, bl 
	call tvarkyk_b_op
	mov al, 90
	mov antra_puse, al
	jmp formatas_sutvarkytas
	
penktas_formatas:
	and al, 00000001b; w
	mov bl, al; if bl=01, then w=1, vice versa
	call imk_baita
	call rask_rm
	call tvarkyk_poslinki
	call tvarkyk_tiesioginiadr
	mov al, rm_reiksme
	mov pirma_puse, al
	mov cl, 01
	add cl, bl 
	call tvarkyk_b_op
	mov al, 90
	mov antra_puse, al
	jmp formatas_sutvarkytas

sestas_septintas_formatas:
	cmp cl, 06
	jne septintas_formatas	
	sestas_formatas:
	shr al, 3
	call surask_segreg
	mov al, 09
	mov pirma_puse, al
	jmp formatas_sutvarkytas
	septintas_formatas:
	cmp cl, 08
	je sestas_formatas
	shl al, 3
	mov bl, 01; w=1, because stack
	call skaiciuok_reg
	mov al, reg_reiksme
	mov pirma_puse, al
	jmp formatas_sutvarkytas
	
astuntas_formatas:
	and al, 00000001b
	mov bl, al ; if bl=01, then w=1, vice versa
	mov al, 10
	add al, bl
	mov pirma_puse, al
	push cx
	mov cl, 01
	add cl, bl
	call tvarkyk_b_op
	pop cx
	mov al, 90
	mov antra_puse, al
	jmp formatas_sutvarkytas
	
devintas_formatas:
	and al, 00000001b
	mov bl, al ; if bl=01, then w=1, vice versa
	mov al, byte ptr[opk_baitas]
	and al, 00000010b
	shr al, 1
	mov bh, al ; bh holds the value of s
	call imk_baita
	call f_kokia_komanda
	push cx
	call rask_rm
	call tvarkyk_poslinki
	call tvarkyk_tiesioginiadr
	mov dh, rm_reiksme
	mov pirma_puse, dh
	mov cl, 01
	add cl, bl
	add cl, bh ; add s_buf_ciklas
	call tvarkyk_b_op 
	mov al, 90
	mov antra_puse, al
	pop cx
	jmp formatas_sutvarkytas
	
desimtas_formatas:
	and al, 00000001b
	mov bl, al ; if bl=01, then w=1, vice versa
	call imk_baita
	call f_kokia_komanda
	cmp cl, 12
	je desimtas_formatas_ptr
	cmp cl, 15
	je desimtas_formatas_ptr
	desimtas_formatas_ptr_cont:
	call rask_rm
	call tvarkyk_poslinki
	call tvarkyk_tiesioginiadr
	mov dh, rm_reiksme
	mov pirma_puse, dh
	jmp formatas_sutvarkytas
	
	desimtas_formatas_ptr:
	inc byte ptr [ar_ptr]
	jmp	desimtas_formatas_ptr_cont
	
vienuoliktas_formatas:
	push cx
	cmp cl, 29
	je vienuoliktas_formatas_ret
	mov cl, 02
	vienuoliktas_formatas_ret_resume:
	call tvarkyk_b_op 
	mov al, 90
	mov pirma_puse, al
	pop cx
	push cx
	cmp cl, 28
	je vienuoliktas_formatas_iso
	cmp cl, 31
	je vienuoliktas_formatas_iso
	pop cx
	jmp formatas_sutvarkytas
	
	vienuoliktas_formatas_ret:
	mov cl, 01
	jmp vienuoliktas_formatas_ret_resume
	
	vienuoliktas_formatas_iso:
	xor dx, dx 
	xchg word ptr[b_op], dx 
	xchg dx, word ptr[b_op2]
	xchg word ptr[b_op], dx 
	mov cl, 02
	call tvarkyk_b_op 
	mov antra_puse, al
	xchg word ptr[b_op], dx 
	xchg dx, word ptr[b_op2]
	xchg word ptr[b_op], dx 
	pop cx
	jmp formatas_sutvarkytas
	
dvyliktas_formatas:
	push cx
	mov cl, 01
	call tvarkyk_b_op
	mov al, 90
	mov pirma_puse, al
	pop cx
	jmp formatas_sutvarkytas
	
tryliktas_formatas:
	and al, 00000001b
	mov bl, al ; if bl=01, then w=1, vice versa
	mov al, byte ptr[opk_baitas]
	call imk_baita
	mov placeholder, al
	call rask_rm
	call tvarkyk_poslinki
	call tvarkyk_tiesioginiadr
	inc byte ptr [ar_ptr]
	mov dh, rm_reiksme
	mov pirma_puse, dh
	mov al, byte ptr[opk_baitas]
	and al, 00000010b
	cmp al, 00000010b
	je tryliktas_formatas_cl
	mov dx, 0001h
	mov b_op, dx
	mov dl, 90
	inc byte ptr[kiek_b_op]
	mov antra_puse, dl
	jmp formatas_sutvarkytas
	
	tryliktas_formatas_cl:
	mov dl, 20
	mov antra_puse, dl
	jmp formatas_sutvarkytas
	
;--------------------------------
;FILE FUNCTIONS
;--------------------------------

atidaryk_failus:
;----------duomenys---------------------------------------------------------------------------
	mov	ah, 3Dh				;open file
	mov	al, 00				;00h - read, 01h - write,  02h - read and write
	mov	dx, offset read		;file name, ending with zero
	int	21h				
	jc	klaidaAtidarant	
	mov	rhandle, ax			;read handle 
;----------rez--------------------------------------------------------------------------------
	mov	ah, 3Ch				;file creation
	mov	cx, 0				;file has no attributes
	mov	dx, offset write			
	int	21h				
	jc	klaidaAtidarant
	mov	whandle, ax			;write handle

	ret
	
	klaidaAtidarant:
	mov ah, 09h 
	mov dx, offset open_err
	int 21h
	jmp pabaiga
	
;--------------------------------------------
;READ BUFFER
;--------------------------------------------
	
skaityk_buferi:
	mov dx, offset buferis
	mov	bx, rhandle			;bx - read handle
	mov	ah, 3Fh								
	mov	cx, READSIZE						
	int	21h			
	jc	klaidaSkaitant
	mov kiek_buferis, al
	
	ret
	
	klaidaSkaitant:
	mov ah, 09h 
	mov dx, offset reading_err
	int 21h
	jmp pabaiga
	
;--------------------------------------------
;WRITE BUFFER
;brings cx - the amount to write
;--------------------------------------------
	
rasyk_buferi: 
	push dx
	push bx
	push ax
	
	mov dx, offset rasymo_buferis
	mov bx, whandle	
	mov	ah, 40h				;write data
	int	21h					
	jc	klaidaRasant	

	pop ax
	pop bx
	pop dx
	ret
	
	klaidaRasant:
	mov ah, 09h 
	mov dx, offset writing_err
	int 21h
	jmp pabaiga
	
;--------------------------------------------
;CLOSE FILES
;--------------------------------------------
	
uzdaryk_failus:
;----------READFILE-----------------------------------------------------------------------------
	mov	ah, 3Eh				
	mov	bx, rhandle			;bx - handle of file to close
	int	21h				
	jc klaidaUzdarant
;----------WRITEFILE----------------------------------------------------------------------------
	mov	ah, 3Eh				
	mov	bx, whandle			
	int	21h				
	jc	klaidaUzdarant	

	ret
	
	klaidaUzdarant:
	mov ah, 09h 
	mov dx, offset close_err
	int 21h
	jmp pabaiga
	
;--------------------------------------------
;READING
;--------------------------------------------

skaitymas:
	push ax
	push dx
	push bx
	push cx
	
	cmp kiek_buferis, 00
	jne skaitymas_ret
	call skaityk_buferi
	cmp kiek_buferis, 00
	je skaitymas_pabaiga
	mov si, offset buferis-1
	
	skaitymas_ret:
	pop cx
	pop bx
	pop dx
	pop ax
	ret
	
	skaitymas_pabaiga:
	jmp pabaiga
	
;--------------------------------------------
;WRITING
;--------------------------------------------
	
rasymas:
	push di
	push ax
	push bx
	
	cmp ch, WRITESIZE
	jl rasymas_ret
	
	push cx
	mov cx, WRITESIZE
	call rasyk_buferi
	mov bx, 0000h
	mov kur_rasymas, bl
	pop cx
	sub cl, WRITESIZE
	sub ch, WRITESIZE
	mov si, bx
	
	rasymas_ret:
	pop bx
	pop ax
	pop di
	ret
	
;--------------------------------------------
;PARAMETER READING
;--------------------------------------------
	
parametrai:
	mov	ch, 00h		
	mov	cl, es:[80h]
	cmp	cx, 00h
	je	skip_pagalba			
	mov	bx, 0081h
	pagalbos_paieska:
	cmp	es:[bx], '?/'
	je	pagalba	
 	cmp	es:[bx], 'h-'
	je	pagalba	
	inc	bx				
	loop pagalbos_paieska			
	jmp	skip_pagalba

	pagalba:
	mov	ah, 9			
	mov	dx, offset help_message			
	int	21h
	jmp pabaiga_return0
 
	skip_pagalba:	
;----------------------------------------------
	xor bx, bx
	mov cl, es:[80h]
	dec cl
	xor ch, ch
	mov si, 0000h	
	mov ah, 01 	;parameter indicator
	mov dx, offset write
	
	parametru_ciklas:
	mov al, es:[82h+si]
	cmp al, ' '
	je parametro_pabaiga
	sub si, bx
	call parametrai_kuris
	add si, bx
	jmp parametru_ciklas_skip
	parametro_pabaiga:
	inc ah
	mov al, 0
	sub si, bx
	call parametrai_kuris
	add si, bx
	mov bx, si
	inc	bx

	parametru_ciklas_skip:
	inc si
	cmp cx, si
	jne parametru_ciklas
	
	mov al, 0
	mov [write+si], al
	cmp ah, 02
	jne Pagalba
	ret
		
parametrai_kuris:

	cmp ah, 01
	je buferis_1
	cmp ah, 02
	je buferis_2
	buferis_1:
	mov [read+si],al
	ret
	buferis_2:
	mov [write+si],al
	ret

end
