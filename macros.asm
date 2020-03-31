print MACRO cadena
	pushear
	MOV AX, @data
	MOV DS, AX
	MOV AH, 09H
	MOV DX, offset cadena
	INT 21H
	poppear
ENDM

getChar MACRO
	MOV AH, 01H
	INT 21H
ENDM

clearScreen MACRO
	MOV AH, 0000H
	MOV AL, 0002H
	INT 10H
ENDM

stringRead MACRO texto
	LOCAL CAPTURAR, SALIR
	pushear
	MOV AH, 1
	XOR SI, SI
	CAPTURAR:
		INT 21H
		CMP AL, 13
		JZ SALIR
		MOV texto[SI], AL
		INC SI
		INC contadorCaracteres
		JMP CAPTURAR
	SALIR:
		poppear
ENDM

pushear MACRO 
	PUSH AX
	PUSH BX
	PUSH CX
	PUSH DX
	PUSH SI
	PUSH DI
ENDM

poppear MACRO
	POP DI
	POP SI
	POP DX
	POP CX
	POP BX
	POP AX
ENDM

fileCreate MACRO
	pushear
	MOV AX,@data  ;Cargamos el segmento de datos para sacar el nombre del archivo.
	MOV DS, AX
	MOV AH,3CH ;instrucción para crear el archivo.
	MOV CX, 0
	MOV DX, offset reporteNombre ;crea el archivo con el nombre ingresado
	INT 21H
	;==================ERROR AL GUARDAR JC ERROR

	MOV BX, AX
	MOV AH,3EH ;cierra el archivo
	INT 21H
	poppear
	;==================GUARDADO CON EXITO JMP EXITO
ENDM

fileOnlyReadOpen MACRO
	pushear
	MOV AH, 3DH
	MOV AL, 01H ; Abrimos en solo lectura
	MOV DX, offset datoTexto
	INT 21H
	fileWrite
	poppear
ENDM

fileWrite MACRO
	pushear
	MOV BX, AX ; mover hadfile
	MOV CX, 0008 ; numero de caracteres a guardar
	;MOV DX, offset imagenFila1
	MOV AH, 40H ; escribe la fila 1
	INT 21H

	CMP CX, AX
	MOV AH, 3EH ; cerrar el archivo
	INT 21H
	poppear
ENDM

getTime MACRO bufferFecha
	PUSH AX
	PUSH BX
	PUSH CX
	PUSH DX
	PUSH SI
	XOR SI, SI
	XOR BX, BX

	MOV AH, 2AH
	INT 21H

	setNumber bufferFecha, DL
	MOV bufferFecha[SI], 2FH
	INC SI
	setNumber bufferFecha, DH
	MOV bufferFecha[SI], 2FH
	INC SI
	MOV bufferFecha[SI], 31H
	INC SI
	MOV bufferFecha[SI], 39H
	INC SI
	MOV bufferFecha[SI], 20H
	INC SI
	MOV bufferFecha[SI], 20H
	INC SI

	MOV AH, 2CH
	INT 21H
	setNumber bufferFecha, CH
	MOV bufferFecha[SI], 3AH
	INC SI
	setNumber bufferFecha, CL

	POP SI
	POP DX
	POP CX
	POP BX
	POP AX
ENDM

setNumber MACRO bufferFecha, registro
	PUSH AX
	PUSH BX

	XOR AX, AX
	XOR BX, BX
	MOV BL, 0AH
	MOV AL, registro
	DIV BL

	getNumber bufferFecha, AL
	getNumber bufferFecha, AH

	POP BX
	POP AX
ENDM

getNumber MACRO bufferFecha, registro
	LOCAL L0, L1, L2, L3, L4, L5, L6, L7, L8, L9, SALIR
	CMP registro , 00H
	JE L0
	CMP registro , 01H
	JE L1
	CMP registro , 02H
	JE L2
	CMP registro , 03H
	JE L3
	CMP registro , 04H
	JE L4
	CMP registro , 05H
	JE L5
	CMP registro , 06H
	JE L6
	CMP registro , 07H
	JE L7
	CMP registro , 08H
	JE L8
	CMP registro , 09H
	JE L9
	JMP SALIR

	L0:
		MOV bufferFecha[SI],30H 	;0
		INC SI
		JMP SALIR
	L1:
		MOV bufferFecha[SI],31H 	;1
		INC SI
		JMP SALIR
	L2:
		MOV bufferFecha[SI],32H 	;2
		INC SI
		JMP SALIR
	L3:
		MOV bufferFecha[SI],33H 	;3
		INC SI
		JMP SALIR
	L4:
		MOV bufferFecha[SI],34H 	;4
		INC SI
		JMP SALIR
	L5:
		MOV bufferFecha[SI],35H 	;5
		INC SI
		JMP SALIR
	L6:
		MOV bufferFecha[SI],36H 	;6
		INC SI
		JMP SALIR
	L7:
		MOV bufferFecha[SI],37H 	;7
		INC SI
		JMP SALIR
	L8:
		MOV bufferFecha[SI],38H 	;8
		INC SI
		JMP SALIR
	L9:
		MOV bufferFecha[SI],39H 	;9
		INC SI
		JMP SALIR
	SALIR:
ENDM

printFuncionOriginal MACRO
	ADD datoCoeficienteFuncion4[0001], 0030H
	ADD datoCoeficienteFuncion3[0001], 0030H
	ADD datoCoeficienteFuncion2[0001], 0030H
	ADD datoCoeficienteFuncion1[0001], 0030H
	ADD datoCoeficienteFuncion0[0001], 0030H

	print mensajeInicioFuncion ; Muestra el mensaje con la funcion 
	print datoCoeficienteFuncion4 ; Muestra el coeficiente 4 de la funcion
	print mensajeMostrarCoeficiente4 ; Muestra *x4
	print datoCoeficienteFuncion3 ; Muestra el coeficiente 3 de la funcion
	print mensajeMostrarCoeficiente3 ; Muestra *x3
	print datoCoeficienteFuncion2 ; Muestra el coeficiente 2 de la funcion
	print mensajeMostrarCoeficiente2 ; Muestra *x2
	print datoCoeficienteFuncion1 ; Muestra el coeficiente 1 de la funcion
	print mensajeMostrarCoeficiente1 ; Muestra *x1
	print datoCoeficienteFuncion0 ; Muestra el coeficiente 0 de la funcion

	SUB datoCoeficienteFuncion4[0001], 0030H
	SUB datoCoeficienteFuncion3[0001], 0030H
	SUB datoCoeficienteFuncion2[0001], 0030H
	SUB datoCoeficienteFuncion1[0001], 0030H
	SUB datoCoeficienteFuncion0[0001], 0030H
ENDM

printFuncionDerivada MACRO
	ADD datoCoeficienteDerivada3[0001], 0030H
	ADD datoCoeficienteDerivada2[0001], 0030H
	ADD datoCoeficienteDerivada1[0001], 0030H
	ADD datoCoeficienteDerivada0[0001], 0030H
	ADD datoCoeficienteDerivada3[0002], 0030H
	ADD datoCoeficienteDerivada2[0002], 0030H
	ADD datoCoeficienteDerivada1[0002], 0030H
	ADD datoCoeficienteDerivada0[0002], 0030H

	print mensajeInicioDerivada
	print datoCoeficienteDerivada3 ; Muestra el coeficiente 3 de la funcion
	print mensajeMostrarCoeficiente3 ; Muestra *x3
	print datoCoeficienteDerivada2 ; Muestra el coeficiente 2 de la funcion
	print mensajeMostrarCoeficiente2 ; Muestra *x2
	print datoCoeficienteDerivada1 ; Muestra el coeficiente 1 de la funcion
	print mensajeMostrarCoeficiente1 ; Muestra *x1
	print datoCoeficienteDerivada0 ; Muestra el coeficiente 0 de la funcion

	SUB datoCoeficienteDerivada3[0001], 0030H
	SUB datoCoeficienteDerivada2[0001], 0030H
	SUB datoCoeficienteDerivada1[0001], 0030H
	SUB datoCoeficienteDerivada0[0001], 0030H
	SUB datoCoeficienteDerivada3[0002], 0030H
	SUB datoCoeficienteDerivada2[0002], 0030H
	SUB datoCoeficienteDerivada1[0002], 0030H
	SUB datoCoeficienteDerivada0[0002], 0030H
ENDM

printFuncionIntegral MACRO
	ADD datoCoeficienteIntegral5[0001], 0030H
	ADD datoCoeficienteIntegral4[0001], 0030H
	ADD datoCoeficienteIntegral3[0001], 0030H
	ADD datoCoeficienteIntegral2[0001], 0030H
	ADD datoCoeficienteIntegral1[0001], 0030H

	ADD datoCoeficienteIntegral5[0003], 0030H
	ADD datoCoeficienteIntegral4[0003], 0030H
	ADD datoCoeficienteIntegral3[0003], 0030H
	ADD datoCoeficienteIntegral2[0003], 0030H

	ADD datoCoeficienteIntegral0[0001], 0030H
	ADD datoCoeficienteIntegral0[0002], 0030H

	print mensajeInicioIntegral
	print datoCoeficienteIntegral5 ; Muestra el coeficiente 3 de la funcion
	print mensajeMostrarCoeficiente5 ; Muestra *x3
	print datoCoeficienteIntegral4 ; Muestra el coeficiente 3 de la funcion
	print mensajeMostrarCoeficiente4 ; Muestra *x3
	print datoCoeficienteIntegral3 ; Muestra el coeficiente 3 de la funcion
	print mensajeMostrarCoeficiente3 ; Muestra *x3
	print datoCoeficienteIntegral2 ; Muestra el coeficiente 2 de la funcion
	print mensajeMostrarCoeficiente2 ; Muestra *x2
	print datoCoeficienteIntegral1 ; Muestra el coeficiente 1 de la funcion
	print mensajeMostrarCoeficiente1 ; Muestra *x1
	print mensajeConstanteIntegracion

	SUB datoCoeficienteIntegral5[0001], 0030H
	SUB datoCoeficienteIntegral4[0001], 0030H
	SUB datoCoeficienteIntegral3[0001], 0030H
	SUB datoCoeficienteIntegral2[0001], 0030H
	SUB datoCoeficienteIntegral1[0001], 0030H

	SUB datoCoeficienteIntegral5[0003], 0030H
	SUB datoCoeficienteIntegral4[0003], 0030H
	SUB datoCoeficienteIntegral3[0003], 0030H
	SUB datoCoeficienteIntegral2[0003], 0030H

	SUB datoCoeficienteIntegral0[0001], 0030H
	SUB datoCoeficienteIntegral0[0002], 0030H
ENDM
