dibujarPixel MACRO posicionX, posicionY, color
	pushear
	MOV AH, 000CH
	MOV AL, color
	MOV BH, 0000H
	MOV DX, posicionY
	MOV CX, posicionX
	INT 0010H
	poppear
ENDM

dibujarPlano MACRO tipo
	LOCAL EJEX, EJEY, ORIGINAL, DERIVADA, INTEGRAL, SALIR
	MOV AX, 0013H
	INT 0010H
	MOV CX, 013EH

	EJEX:
		dibujarPixel CX, 0063H, 002AH
		LOOP EJEX
		MOV CX, 00C6H

	EJEY:
		dibujarPixel 009FH, CX, 002AH
		LOOP EJEY

	CMP tipo, 0000
	JE ORIGINAL
	CMP tipo, 0001
	JE DERIVADA
	JMP INTEGRAL

	ORIGINAL:
		graficarOriginal
		JMP SALIR

	DERIVADA:
		graficarDerivada
		JMP SALIR

	INTEGRAL:
		graficarIntegral
		JMP SALIR

	SALIR:
		MOV AH, 0010H
		INT 0016H
		MOV AX, 0003H
		INT 0010H
ENDM

transformarRango MACRO numero, guardar
	LOCAL NONUM, SALIR, SIGNOPOSITIVO, SIGNONEGATIVO, TRANSFORMAR
	pushear
	CMP numero[0000], 002BH ; Simbolo +
	JE SIGNOPOSITIVO ; Empieza con el signo +
	CMP numero[0000], 002DH ; Simbolo -
	JE SIGNONEGATIVO ; Empieza con el signo -
	CMP numero[0000], 0030H ; Menor al caracter 0
	JB NONUM
	CMP numero[0000], 0039H ; Mayor al caracter 9
	JA NONUM
	CMP numero[0001], 0030H ; Menor al caracter 0
	JB NONUM
	CMP numero[0001], 0039H ; Mayor al caracter 9
	JA NONUM
	;Si es numero, es positivo
	CMP numero[0002], 0024H ; Caracter $
	JNE NONUM
	MOV SI, 0000
	MOV guardar[0000], 002BH
	JMP TRANSFORMAR

	SIGNOPOSITIVO:
		CMP numero[0003], 0024H ; Caracter $
		JNE NONUM
		CMP numero[0001], 0030H ; Menor al caracter 0
		JB NONUM
		CMP numero[0001], 0039H ; Mayor al caracter 9
		JA NONUM
		CMP numero[0002], 0030H ; Menor al caracter 0
		JB NONUM
		CMP numero[0002], 0039H ; Mayor al caracter 9
		JA NONUM
		MOV guardar[0000], 002BH
		MOV SI, 0001
		JMP TRANSFORMAR

	SIGNONEGATIVO:
		CMP numero[0003], 0024H ; Caracter $
		JNE NONUM
		CMP numero[0001], 0030H ; Menor al caracter 0
		JB NONUM
		CMP numero[0001], 0039H ; Mayor al caracter 9
		JA NONUM
		CMP numero[0002], 0030H ; Menor al caracter 0
		JB NONUM
		CMP numero[0002], 0039H ; Mayor al caracter 9
		JA NONUM 
		MOV guardar[0000], 002DH
		MOV SI, 0001
		JMP TRANSFORMAR

	TRANSFORMAR:
		MOV AL, numero[SI]
		MOV AH, numero[SI + 1]
		SUB AL, 0030H ; Nos quedamos con el valor en hexa
		SUB AH, 0030H ; Nos quedamos con el valor en hexa

		MOV numeroMas, AL ; Guardamos los datos de los numeros
   		MOV numeroMenos, AH ; Guardamos los datos de los numeros

   		MOV BL, numeroMas
   		MOV AL, 0010
   		MUL BL
   		ADD AL, numeroMenos

   		MOV guardar[0001], AL
		JMP SALIR

	NONUM:
		;MENSAJE DE ERROR
		print errorIngresarFuncion
		CALL PAUSA
		poppear
		reiniciarGrafica
		JMP GRAFICAR_FUNCIONES

	SALIR:
		poppear
ENDM

comprobarRango MACRO
	LOCAL SALIR, SIGNOSIGUALES, SIGNOSDIFERENTES, MENOS
	pushear
	MOV AL, graficarIntervaloInicial[0000] ; Toma el signo de la parte inferior del intervalo
	MOV AH, graficarIntervaloFinal[0000] ; Toma el signo de la parte superior del intervalo
	CMP AL, AH ; Comprueba los signos
	JE SIGNOSIGUALES ; Signos iguales
	JMP SIGNOSDIFERENTES

	SIGNOSIGUALES:
		CMP AL, 002DH ; Es signo negativo, se invierten.
		JE MENOS
		MOV AL, graficarIntervaloInicial[0001] ; Tomamos el valor de la parte inferior del intervalo
		MOV AH, graficarIntervaloFinal[0001] ; Tomamos el valor de la parte superior del intervalo
		CMP AH, AL ; Compara los valores
		JL ERROR_RANGO ; El valor superior es menor que el valor inferior 
		JMP SALIR

	MENOS: 
		MOV AH, graficarIntervaloInicial[0001] ; Tomamos el valor de la parte inferior del intervalo
		MOV AL, graficarIntervaloFinal[0001] ; Tomamos el valor de la parte superior del intervalo
		CMP AH, AL ; Compara los valores
		JL ERROR_RANGO ; El valor superior es menor que el valor inferior 
		JMP SALIR

	SIGNOSDIFERENTES:
		CMP AL, AH ; Compara los signos
		JL ERROR_RANGO ; El signo inferior es + y el superior es -
		JMP SALIR

	SALIR:
		poppear
ENDM

reiniciarGrafica MACRO
	MOV graficarIntervaloInicial[0000], 0000
	MOV graficarIntervaloInicial[0001], 0000
	MOV graficarIntervaloFinal[0000], 0000
	MOV graficarIntervaloFinal[0001], 0000
	MOV graficarConstanteIntegracion[0000], 0000
	MOV graficarConstanteIntegracion[0001], 0000
ENDM

reiniciarFuncion MACRO
	MOV datoCoeficienteFuncion4[0001], 0000
	MOV datoCoeficienteFuncion3[0001], 0000
	MOV datoCoeficienteFuncion2[0001], 0000
	MOV datoCoeficienteFuncion1[0001], 0000
	MOV datoCoeficienteFuncion0[0001], 0000
	MOV datoCoeficienteDerivada3[0001], 0000
	MOV datoCoeficienteDerivada3[0002], 0000
	MOV datoCoeficienteDerivada2[0001], 0000
	MOV datoCoeficienteDerivada2[0002], 0000
	MOV datoCoeficienteDerivada1[0001], 0000
	MOV datoCoeficienteDerivada1[0002], 0000
	MOV datoCoeficienteDerivada0[0001], 0000
	MOV datoCoeficienteDerivada0[0002], 0000
	MOV datoCoeficienteIntegral5[0001], 0000
	MOV datoCoeficienteIntegral5[0003], 0000
	MOV datoCoeficienteIntegral4[0001], 0000
	MOV datoCoeficienteIntegral4[0003], 0000
	MOV datoCoeficienteIntegral3[0001], 0000
	MOV datoCoeficienteIntegral3[0003], 0000
	MOV datoCoeficienteIntegral2[0001], 0000
	MOV datoCoeficienteIntegral2[0003], 0000
	MOV datoCoeficienteIntegral1[0001], 0000
	MOV datoCoeficienteIntegral1[0003], 0000
	MOV datoCoeficienteIntegral0[0001], 0000
	MOV datoCoeficienteIntegral0[0003], 0000
ENDM

graficarOriginal MACRO
	LOCAL CN, CP, SALIR, CCN, CCP, SEXTRA, SEXTRA2, SOLOPOS, SOLONEG, INFN, SEXTRA3, VERIFICAR, SEXTRA4, VERIFICAR2
	pushear
	XOR BH, BH
	MOV BL, 0000 ; Numero mas pequeño para evaluar
	CMP graficarIntervaloInicial[0000], 002DH ; Es numero negativo
	JE INFN
	MOV BL, graficarIntervaloInicial[0001]
	JMP SOLOPOS

	INFN:
		CMP graficarIntervaloFinal[0000], 002DH ; Es numero negativo
		MOV BL, graficarIntervaloFinal[0001]
		JE SOLONEG
		MOV BL, 0000
		JMP CN
	CN:
		MOV signoEvaluacion, 0001
		CALL ORIGINALOPERARC4
		JA CCN
		CALL ORIGINALOPERARC3
		JA CCN
		CALL ORIGINALOPERARC2
		JA CCN
		CALL ORIGINALOPERARC1
		JA CCN
		CALL ORIGINALOPERARC0
		JA CCN
		XOR CX, CX
		MOV CL, resultadoGrafica[0000]
		MOV CH, 0063H
		SUB CH, CL
		MOV CL, CH
		XOR CH, CH
		XOR AX, AX
		MOV AL, BL
		MOV AH, 009FH
		SUB AH, AL
		MOV AL, AH
		XOR AH, AH
		MOV posiX, AX
		MOV posiY, CX
		CMP signoResultado, 0001 ; Negativo
		JE SEXTRA
		dibujarPixel posiX, posiY, 2FH
		JMP CCN
		SEXTRA:
			ADD resultadoGrafica[0000], 0063H
			MOV CL, resultadoGrafica[0000]
			XOR CH, CH
			MOV posiY, CX
			dibujarPixel posiX, posiY, 2FH
		CCN:
			MOV resultadoGrafica[0000], 0000
			INC BL
			CMP BL, graficarIntervaloInicial[0001]
			JLE CN
			XOR BH, BH
			MOV BL, 0000 ; Numero mas grande para evaluar
			JMP CP
	CP:
		MOV signoEvaluacion, 0000
		CALL ORIGINALOPERARC4
		JA CCP
		CALL ORIGINALOPERARC3
		JA CCP
		CALL ORIGINALOPERARC2
		JA CCP
		CALL ORIGINALOPERARC1
		JA CCP
		CALL ORIGINALOPERARC0
		JA CCP
		XOR CX, CX
		MOV CL, resultadoGrafica[0000]
		MOV CH, 0063H
		SUB CH, CL
		MOV CL, CH
		XOR CH, CH
		XOR AX, AX
		MOV AL, BL
		MOV AH, 009FH
		ADD AH, AL
		MOV AL, AH
		XOR AH, AH
		MOV posiX, AX
		MOV posiY, CX
		CMP signoResultado, 0001 ; Negativo
		JE SEXTRA2
		dibujarPixel posiX, posiY, 2FH
		JMP CCP
		SEXTRA2:
			ADD resultadoGrafica[0000], 0063H
			MOV CL, resultadoGrafica[0000]
			XOR CH, CH
			MOV posiY, CX
			dibujarPixel posiX, posiY, 2FH
		CCP:
			MOV resultadoGrafica[0000], 0000
			INC BL
			CMP BL, graficarIntervaloFinal[0001]
			JLE CP
			JMP SALIR

	SOLOPOS:
		MOV signoEvaluacion, 0000
		CALL ORIGINALOPERARC4
		JA VERIFICAR
		CALL ORIGINALOPERARC3
		JA VERIFICAR
		CALL ORIGINALOPERARC2
		JA VERIFICAR
		CALL ORIGINALOPERARC1
		JA VERIFICAR
		CALL ORIGINALOPERARC0
		JA VERIFICAR
		XOR CX, CX
		MOV CL, resultadoGrafica[0000]
		MOV CH, 0063H
		SUB CH, CL
		MOV CL, CH
		XOR CH, CH
		XOR AX, AX
		MOV AL, BL
		MOV AH, 009FH
		ADD AH, AL
		MOV AL, AH
		XOR AH, AH
		MOV posiX, AX
		MOV posiY, CX
		CMP signoResultado, 0001 ; Negativo
		JE SEXTRA3
		dibujarPixel posiX, posiY, 2FH
		JMP VERIFICAR
		SEXTRA3:
			ADD resultadoGrafica[0000], 0063H
			MOV CL, resultadoGrafica[0000]
			XOR CH, CH
			MOV posiY, CX
			dibujarPixel posiX, posiY, 2FH
		VERIFICAR:
			MOV resultadoGrafica[0000], 0000
			INC BL
			CMP BL, graficarIntervaloFinal[0001]
			JLE SOLOPOS
			JMP SALIR

	SOLONEG:
		MOV signoEvaluacion, 0001
		CALL ORIGINALOPERARC4
		JA VERIFICAR2
		CALL ORIGINALOPERARC3
		JA VERIFICAR2
		CALL ORIGINALOPERARC2
		JA VERIFICAR2
		CALL ORIGINALOPERARC1
		JA VERIFICAR2
		CALL ORIGINALOPERARC0
		JA VERIFICAR2
		XOR CX, CX
		MOV CL, resultadoGrafica[0000]
		MOV CH, 0063H
		SUB CH, CL
		MOV CL, CH
		XOR CH, CH
		XOR AX, AX
		MOV AL, BL
		MOV AH, 009FH
		SUB AH, AL
		MOV AL, AH
		XOR AH, AH
		MOV posiX, AX
		MOV posiY, CX
		CMP signoResultado, 0001 ; Negativo
		JE SEXTRA4
		dibujarPixel posiX, posiY, 2FH
		JMP VERIFICAR2
		SEXTRA4:
			ADD resultadoGrafica[0000], 0063H
			MOV CL, resultadoGrafica[0000]
			XOR CH, CH
			MOV posiY, CX
			dibujarPixel posiX, posiY, 2FH
		VERIFICAR2:
			MOV resultadoGrafica[0000], 0000
			INC BL
			CMP BL, graficarIntervaloInicial[0001]
			JLE SOLONEG
			JMP SALIR

	SALIR:
		poppear
ENDM

graficarDerivada MACRO
	LOCAL CN, CP, SALIR, CCN, CCP, SEXTRA, SEXTRA2, SOLOPOS, SOLONEG, INFN, SEXTRA3, VERIFICAR, SEXTRA4, VERIFICAR2
	pushear
	XOR BH, BH
	MOV BL, 0000 ; Numero mas pequeño para evaluar
	CMP graficarIntervaloInicial[0000], 002DH ; Es numero negativo
	JE INFN
	MOV BL, graficarIntervaloInicial[0001]
	JMP SOLOPOS

	INFN:
		CMP graficarIntervaloFinal[0000], 002DH ; Es numero negativo
		MOV BL, graficarIntervaloFinal[0001]
		JE SOLONEG
		MOV BL, 0000
		JMP CN
	CN:
		MOV signoEvaluacion, 0001
		CALL DERIVADAOPERARC3
		JA CCN
		CALL DERIVADAOPERARC2
		JA CCN
		CALL DERIVADAOPERARC1
		JA CCN
		CALL DERIVADAOPERARC0
		JA CCN
		XOR CX, CX
		MOV CL, resultadoGrafica[0000]
		MOV CH, 0063H
		SUB CH, CL
		MOV CL, CH
		XOR CH, CH
		XOR AX, AX
		MOV AL, BL
		MOV AH, 009FH
		SUB AH, AL
		MOV AL, AH
		XOR AH, AH
		MOV posiX, AX
		MOV posiY, CX
		CMP signoResultado, 0001 ; Negativo
		JE SEXTRA
		dibujarPixel posiX, posiY, 2FH
		JMP CCN
		SEXTRA:
			ADD resultadoGrafica[0000], 0063H
			MOV CL, resultadoGrafica[0000]
			XOR CH, CH
			MOV posiY, CX
			dibujarPixel posiX, posiY, 2FH
		CCN:
			MOV resultadoGrafica[0000], 0000
			INC BL
			CMP BL, graficarIntervaloInicial[0001]
			JLE CN
			XOR BH, BH
			MOV BL, 0000 ; Numero mas grande para evaluar
			JMP CP
	CP:
		MOV signoEvaluacion, 0000
		CALL DERIVADAOPERARC3
		JA CCP
		CALL DERIVADAOPERARC2
		JA CCP
		CALL DERIVADAOPERARC1
		JA CCP
		CALL DERIVADAOPERARC0
		JA CCP
		XOR CX, CX
		MOV CL, resultadoGrafica[0000]
		MOV CH, 0063H
		SUB CH, CL
		MOV CL, CH
		XOR CH, CH
		XOR AX, AX
		MOV AL, BL
		MOV AH, 009FH
		ADD AH, AL
		MOV AL, AH
		XOR AH, AH
		MOV posiX, AX
		MOV posiY, CX
		CMP signoResultado, 0001 ; Negativo
		JE SEXTRA2
		dibujarPixel posiX, posiY, 2FH
		JMP CCP
		SEXTRA2:
			ADD resultadoGrafica[0000], 0063H
			MOV CL, resultadoGrafica[0000]
			XOR CH, CH
			MOV posiY, CX
			dibujarPixel posiX, posiY, 2FH
		CCP:
			MOV resultadoGrafica[0000], 0000
			INC BL
			CMP BL, graficarIntervaloFinal[0001]
			JLE CP
			JMP SALIR

	SOLOPOS:
		MOV signoEvaluacion, 0000
		CALL DERIVADAOPERARC3
		JA VERIFICAR
		CALL DERIVADAOPERARC2
		JA VERIFICAR
		CALL DERIVADAOPERARC1
		JA VERIFICAR
		CALL DERIVADAOPERARC0
		JA VERIFICAR
		XOR CX, CX
		MOV CL, resultadoGrafica[0000]
		MOV CH, 0063H
		SUB CH, CL
		MOV CL, CH
		XOR CH, CH
		XOR AX, AX
		MOV AL, BL
		MOV AH, 009FH
		ADD AH, AL
		MOV AL, AH
		XOR AH, AH
		MOV posiX, AX
		MOV posiY, CX
		CMP signoResultado, 0001 ; Negativo
		JE SEXTRA3
		dibujarPixel posiX, posiY, 2FH
		JMP VERIFICAR
		SEXTRA3:
			ADD resultadoGrafica[0000], 0063H
			MOV CL, resultadoGrafica[0000]
			XOR CH, CH
			MOV posiY, CX
			dibujarPixel posiX, posiY, 2FH
		VERIFICAR:
			MOV resultadoGrafica[0000], 0000
			INC BL
			CMP BL, graficarIntervaloFinal[0001]
			JLE SOLOPOS
			JMP SALIR

	SOLONEG:
		MOV signoEvaluacion, 0001
		CALL DERIVADAOPERARC3
		JA VERIFICAR2
		CALL DERIVADAOPERARC2
		JA VERIFICAR2
		CALL DERIVADAOPERARC1
		JA VERIFICAR2
		CALL DERIVADAOPERARC0
		JA VERIFICAR2
		XOR CX, CX
		MOV CL, resultadoGrafica[0000]
		MOV CH, 0063H
		SUB CH, CL
		MOV CL, CH
		XOR CH, CH
		XOR AX, AX
		MOV AL, BL
		MOV AH, 009FH
		SUB AH, AL
		MOV AL, AH
		XOR AH, AH
		MOV posiX, AX
		MOV posiY, CX
		CMP signoResultado, 0001 ; Negativo
		JE SEXTRA4
		dibujarPixel posiX, posiY, 2FH
		JMP VERIFICAR2
		SEXTRA4:
			ADD resultadoGrafica[0000], 0063H
			MOV CL, resultadoGrafica[0000]
			XOR CH, CH
			MOV posiY, CX
			dibujarPixel posiX, posiY, 2FH
		VERIFICAR2:
			MOV resultadoGrafica[0000], 0000
			INC BL
			CMP BL, graficarIntervaloInicial[0001]
			JLE SOLONEG
			JMP SALIR

	SALIR:
		poppear
ENDM

graficarIntegral MACRO
	LOCAL CN, CP, SALIR, CCN, CCP, SEXTRA, SEXTRA2, SOLOPOS, SOLONEG, INFN, SEXTRA3, VERIFICAR, SEXTRA4, VERIFICAR2
	pushear
	XOR BH, BH
	MOV BL, 0000 ; Numero mas pequeño para evaluar
	CMP graficarIntervaloInicial[0000], 002DH ; Es numero negativo
	JE INFN
	MOV BL, graficarIntervaloInicial[0001]
	JMP SOLOPOS

	INFN:
		CMP graficarIntervaloFinal[0000], 002DH ; Es numero negativo
		MOV BL, graficarIntervaloFinal[0001]
		JE SOLONEG
		MOV BL, 0000
		JMP CN
	CN:
		MOV signoEvaluacion, 0001
		CALL INTEGRALOPERARC5
		JA CCN
		CALL INTEGRALOPERARC4
		JA CCN
		CALL INTEGRALOPERARC3
		JA CCN
		CALL INTEGRALOPERARC2
		JA CCN
		CALL INTEGRALOPERARC1
		JA CCN
		CALL INTEGRALOPERARC0
		JA CCN
		XOR CX, CX
		MOV CL, resultadoGrafica[0000]
		MOV CH, 0063H
		SUB CH, CL
		MOV CL, CH
		XOR CH, CH
		XOR AX, AX
		MOV AL, BL
		MOV AH, 009FH
		SUB AH, AL
		MOV AL, AH
		XOR AH, AH
		MOV posiX, AX
		MOV posiY, CX
		CMP signoResultado, 0001 ; Negativo
		JE SEXTRA
		dibujarPixel posiX, posiY, 2FH
		JMP CCN
		SEXTRA:
			ADD resultadoGrafica[0000], 0063H
			MOV CL, resultadoGrafica[0000]
			XOR CH, CH
			MOV posiY, CX
			dibujarPixel posiX, posiY, 2FH
		CCN:
			MOV resultadoGrafica[0000], 0000
			INC BL
			CMP BL, graficarIntervaloInicial[0001]
			JLE CN
			XOR BH, BH
			MOV BL, 0000 ; Numero mas grande para evaluar
			JMP CP
	CP:
		MOV signoEvaluacion, 0000
		CALL INTEGRALOPERARC5
		JA CCP
		CALL INTEGRALOPERARC4
		JA CCP
		CALL INTEGRALOPERARC3
		JA CCP
		CALL INTEGRALOPERARC2
		JA CCP
		CALL INTEGRALOPERARC1
		JA CCP
		CALL INTEGRALOPERARC0
		JA CCP
		XOR CX, CX
		MOV CL, resultadoGrafica[0000]
		MOV CH, 0063H
		SUB CH, CL
		MOV CL, CH
		XOR CH, CH
		XOR AX, AX
		MOV AL, BL
		MOV AH, 009FH
		ADD AH, AL
		MOV AL, AH
		XOR AH, AH
		MOV posiX, AX
		MOV posiY, CX
		CMP signoResultado, 0001 ; Negativo
		JE SEXTRA2
		dibujarPixel posiX, posiY, 2FH
		JMP CCP
		SEXTRA2:
			ADD resultadoGrafica[0000], 0063H
			MOV CL, resultadoGrafica[0000]
			XOR CH, CH
			MOV posiY, CX
			dibujarPixel posiX, posiY, 2FH
		CCP:
			MOV resultadoGrafica[0000], 0000
			INC BL
			CMP BL, graficarIntervaloFinal[0001]
			JLE CP
			JMP SALIR

	SOLOPOS:
		MOV signoEvaluacion, 0000
		CALL INTEGRALOPERARC5
		JA CCP
		CALL INTEGRALOPERARC4
		JA VERIFICAR
		CALL INTEGRALOPERARC3
		JA VERIFICAR
		CALL INTEGRALOPERARC2
		JA VERIFICAR
		CALL INTEGRALOPERARC1
		JA VERIFICAR
		CALL INTEGRALOPERARC0
		JA VERIFICAR
		XOR CX, CX
		MOV CL, resultadoGrafica[0000]
		MOV CH, 0063H
		SUB CH, CL
		MOV CL, CH
		XOR CH, CH
		XOR AX, AX
		MOV AL, BL
		MOV AH, 009FH
		ADD AH, AL
		MOV AL, AH
		XOR AH, AH
		MOV posiX, AX
		MOV posiY, CX
		CMP signoResultado, 0001 ; Negativo
		JE SEXTRA3
		dibujarPixel posiX, posiY, 2FH
		JMP VERIFICAR
		SEXTRA3:
			ADD resultadoGrafica[0000], 0063H
			MOV CL, resultadoGrafica[0000]
			XOR CH, CH
			MOV posiY, CX
			dibujarPixel posiX, posiY, 2FH
		VERIFICAR:
			MOV resultadoGrafica[0000], 0000
			INC BL
			CMP BL, graficarIntervaloFinal[0001]
			JLE SOLOPOS
			JMP SALIR

	SOLONEG:
		MOV signoEvaluacion, 0001
		CALL INTEGRALOPERARC5
		JA CCP
		CALL INTEGRALOPERARC4
		JA VERIFICAR2
		CALL INTEGRALOPERARC3
		JA VERIFICAR2
		CALL INTEGRALOPERARC2
		JA VERIFICAR2
		CALL INTEGRALOPERARC1
		JA VERIFICAR2
		CALL INTEGRALOPERARC0
		JA VERIFICAR2
		XOR CX, CX
		MOV CL, resultadoGrafica[0000]
		MOV CH, 0063H
		SUB CH, CL
		MOV CL, CH
		XOR CH, CH
		XOR AX, AX
		MOV AL, BL
		MOV AH, 009FH
		SUB AH, AL
		MOV AL, AH
		XOR AH, AH
		MOV posiX, AX
		MOV posiY, CX
		CMP signoResultado, 0001 ; Negativo
		JE SEXTRA4
		dibujarPixel posiX, posiY, 2FH
		JMP VERIFICAR2
		SEXTRA4:
			ADD resultadoGrafica[0000], 0063H
			MOV CL, resultadoGrafica[0000]
			XOR CH, CH
			MOV posiY, CX
			dibujarPixel posiX, posiY, 2FH
		VERIFICAR2:
			MOV resultadoGrafica[0000], 0000
			INC BL
			CMP BL, graficarIntervaloInicial[0001]
			JLE SOLONEG
			JMP SALIR

	SALIR:
		poppear
ENDM
