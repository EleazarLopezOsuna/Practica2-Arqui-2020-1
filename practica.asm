INCLUDE macros.asm ; Incluye el archivo donde se encuentran todos los macros almacenados
INCLUDE anali.asm
INCLUDE eval.asm

.MODEL large ; Utiliza un espacio 'medium' de almacenamiento

;=================
;==AREA DE STACK==
;=================
.STACK 100H
;=================
;==AREA DE STACK==
;=================

;================
;==AREA DE DATA==
;================
.DATA
	;======================
	;==MENSAJES A MOSTRAR==
	;======================
		mensajeEncabezado DB 0AH, 0DH, '	UNIVERSIDAD DE SAN CARLOS DE GUATEMALA', 0AH, 0DH, '	FACULTAD DE INGENIERIA', 0AH, 0DH, '	CIENCIAS Y SISTEMAS', 0AH, 0DH, '	ARQUITECTURA DE COMPUTADORES Y ENSAMBLADORES 1', 0AH, 0DH, '	NOMBRE: ELEAZAR JARED LOPEZ OSUNA', 0AH, 0DH, '	CARNET: 201700893', 0AH, 0DH, '	SECCION: A', 0AH, 0DH, '	Practica 5', '$'
		mensajeMenuPrincipal DB 0AH, 0DH, '	Seleccione una opcion', 0AH, 0DH, '	1) Ingresar funcion f(x)', 0AH, 0DH, '	2) Funcion en Memoria', 0AH, 0DH, '	3) Derivada f''(x)', 0AH, 0DH, '	4) Integral F(x)', 0AH, 0DH, '	5) Graficar Funciones', 0AH, 0DH, '	6) Reporte', 0AH, 0DH, '	7) Modo Calculadora', 0AH, 0DH, '	8) Salir', 0AH, 0DH, '	',  '$' ; Menu
		mensajeCoeficiente4 DB 0AH, 0DH, '	- Coeficiente de x4: ', '$'
		mensajeCoeficiente3 DB 0AH, 0DH, '	- Coeficiente de x3: ', '$'
		mensajeCoeficiente2 DB 0AH, 0DH, '	- Coeficiente de x2: ', '$'
		mensajeCoeficiente1 DB 0AH, 0DH, '	- Coeficiente de x1: ', '$'
		mensajeCoeficiente0 DB 0AH, 0DH, '	- Coeficiente de x0: ', '$'
		mensajeInicioFuncion DB 0AH, 0DH, '	f(x) = ', '$'
		mensajeInicioDerivada DB 0AH, 0DH, '	f''(x) = ', '$'
		mensajeInicioIntegral DB 0AH, 0DH, '	F(x) = ', '$'
		mensajeConstanteIntegracion DB '+C', '$'
		mensajeNoHayFuncionCargada DB 0AH, 0DH, '	No hay una funcion cargada en memoria', '$'
		mensajeMenuGraficar DB 0AH, 0DH, '	Seleccione una opcion', 0AH, 0DH, '	1) Graficar Original f(x)', 0AH, 0DH, '	2) Graficar Derivada f''(x)', 0AH, 0DH, '	3) Graficar Integral F(x)', 0AH, 0DH, '	4) Regresar', 0AH, 0DH, '	', '$'
		mensajeInicialIntervalo DB 0AH, 0DH, '	Ingrese el valor inicial del intervalo: ', '$'
		mensajeFinalIntervalo DB 0AH, 0DH, '	Ingrese el valor final del intervalo: ', '$'
		mensajeConstanteC DB 0AH, 0DH, '	Ingrese el valor de la constante de integracion C: ', '$'
		mensajeCalculadora DB 0AH, 0DH, '	Ingrese una ruta: ', '$'
		mensajeCaracterInvalido DB 0AH, 0DH, '	Caracter invalido: X', '$' ; X esta en la posicion 20
		mensajeFaltoCaracterDeFinalizacion DB 0AH, 0DH, '	Falto caracter de finalizacion: (:)', '$'
		mensajeResultadoOperacion DB 0AH, 0DH, '	El resultado de la operacion es: ', '$'
		mensajeMostrarCoeficiente5 DB '*x5', '$'
		mensajeMostrarCoeficiente4 DB '*x4', '$'
		mensajeMostrarCoeficiente3 DB '*x3', '$'
		mensajeMostrarCoeficiente2 DB '*x2', '$'
		mensajeMostrarCoeficiente1 DB '*x1', '$'
		mensajeTab DB '	', '$'
		mensajeReporteCreado DB 0AH, 0DH, '	Reporte creado con exito', '$'
	;======================
	;==MENSAJES A MOSTRAR==
	;======================

	;=====================
	;==MENSAJES DE ERROR==
	;=====================
		errorIngresarFuncion DB 0AH, 0DH, '	Error: se esperaba valor numerico con la estructura [+|-]?[0-9]', '$'
		errorFaltaPuntoComa DB 0AH, 0DH, '	Error: falta punto y coma', '$'
		errorDivisionCero DB 0AH, 0DH, '	Error: division por 0 no definida', '$'
		errorIntervalo DB 0AH, 0DH, '	El limite inferior del intervalo no puede ser mayor al limite superior', '$'
		errorNoHayFuncion DB 0AH, 0DH, '	Error: no hay ninguna funcion en memoria', '$'
		errorAbrirArchivo DB 0AH, 0DH, '	Error: hubo un problema al abrir el archivo', '$'
		errorExtension DB 0AH, 0DH, '	Error: extension no soportada, se recomienda .arq', '$'
		errorRuta DB 0AH, 0DH, '	Error: la ruta debe iniciar y terminar con @@', '$'
	;=====================
	;==MENSAJES DE ERROR==
	;=====================

	;===============
	;==CALCULADORA==
	;===============
		calculadoraNombreArchivo DB 80 dup(0)
		calculadoraTextoRecibido DB 9999 dup('$')
		calculadoraRutaOficial DB 80 dup(0)
	;===============
	;==CALCULADORA==
	;===============

	;===========
	;==REPORTE==
	;===========
		fecha DB 15 dup('$')
		reporteNombre DB 'repo.html', 0000
		reporteInicioHtml DB '<html><body>' ; 12
		reporteUniversidad DB 0AH, 0DH, '<h3>UNIVERSIDAD DE SAN CARLOS DE GUATEMALA</h3>' ; 49
		reporteFacultad DB 0AH, 0DH, '<h3>FACULTAD DE INGENIERIA</h3>' ; 33
		reporteEscuela DB 0AH, 0DH, '<h3>ESCUELA DE CIENCIAS Y SISTEMAS</h3>' ; 41
		reporteCurso DB 0AH, 0DH, '<h3>ARQUITECTURA DE COMPUTADORAS Y ENSAMBLADORES 1 | A</h3>' ; 61
		reporteSemestre DB 0AH, 0DH,  '<h3>PRIMER SEMESTRE 2020</h3>' ; 31
		reporteNombreEstudiante DB 0AH, 0DH, '<h3>ELEAZAR JARED LOPEZ OSUNA</h3>' ; 36
		reporteCarnet DB 0AH, 0DH, '<h3>201700893</h3>' ; 20
		reportePractica DB 0AH, 0DH, '<h4>REPORTE PRACTICA NO. 2</h4>' ; 33
		reporteFechaHora DB 0AH, 0DH, '<h4>FECHA Y HORA: ' ; 21
		reporteOriginal DB 0AH, 0DH, '</h4><h4>FUNCION ORIGINAL: f(x) = ' ; 38
		reporteDerivada DB 0AH, 0DH, '</h4><h4>FUNCION DERIVADA: f´(x) = ' ; 39
		reporteIntegral DB 0AH, 0DH, '</h4><h4>FUNCION INTEGRADA: F(x) = ' ; 39
		reporteFinHtml DB 0AH, 0DH, '</h4></body></html>' ; 21
	;===========
	;==REPORTE==
	;===========

	;============
	;==GRAFICAR==
	;============
		graficarIntervaloInicial DB 0000, 0000, '$' ; 2 posiciones: 1 para digitos y 1 para posible signo
		graficarIntervaloFinal DB 0000, 0000, '$' ; 2 posiciones: 1 para digitos y 1 para posible signo
		graficarConstanteIntegracion DB 0000, 0000, '$' ; 2 posiciones: 1 para digitos y 1 para posible signo
	;============
	;==GRAFICAR==
	;============

	;===============
	;==DATOS EXTRA==
	;===============
		datoTextoUsuario DB 15 dup('$')
		manejadorArchivoCalculadora DW ?
		contadorCaracteres DB 0000
		datoVerificacionNumero DB 0000, 0000
		pilaOperaciones DW 4096 dup('$')
		signoResultado DB 0000, '$'
		indexOperaciones DB 0000, '$'
		numeroTransformar DB 0000, 0000
		numeroMas DB 0000
		numeroMenos DB 0000
		resultadoOperacion DB 0000, '$'
		operador1 DW 0000
		multi DB 'Es multi', '$'
		essuma DB 0AH, 0DH, 'Es suma', '$'
		esresta DB 0AH, 0DH, 'Es resta' , '$'
		mostrarRespuesta DB 0000, 0000, 0000, 0000, 0000, '$'
		overF DB 0AH, 0DH, 'Overflow', '$'
		resultado DW 0000, '$'
		textoRangoInferior DB 15 dup('$')
		textoRangoSuperior DB 15 dup('$')
		textoDatoConstante DB 15 dup('$')
		tipoGrafica DB 0000
		resultadoGrafica DB 0000, '$'
		posiX DW 0000, '$'
		posiY DW 0000, '$'
		linea DB ' ', '$'
		signoEvaluacion DB 0000
		ingresoFuncion DB 0000

		datoCoeficienteFuncion5 DB 2 dup('$') ; 2 posiciones: 1 para digitos y 1 para posible signo
		datoCoeficienteFuncion4 DB 002BH, 0000, '$' ; 1 -> positivo, 0 -> negativo
		datoCoeficienteFuncion3 DB 002BH, 0000, '$' ; 1 -> positivo, 0 -> negativo
		datoCoeficienteFuncion2 DB 002BH, 0000, '$' ; 1 -> positivo, 0 -> negativo
		datoCoeficienteFuncion1 DB 002BH, 0000, '$' ; 1 -> positivo, 0 -> negativo
		datoCoeficienteFuncion0 DB 002BH, 0000, '$' ; 1 -> positivo, 0 -> negativo

		datoCoeficienteDerivada3 DB 002BH, 0000, 0000, '$' ; 3 posiciones: 2 para digitos y 1 para posible signo
		datoCoeficienteDerivada2 DB 002BH, 0000, 0000, '$' ; 3 posiciones: 2 para digitos y 1 para posible signo
		datoCoeficienteDerivada1 DB 002BH, 0000, 0000, '$' ; 3 posiciones: 2 para digitos y 1 para posible signo
		datoCoeficienteDerivada0 DB 002BH, 0000, 0000, '$' ; 3 posiciones: 2 para digitos y 1 para posible signo
		datoCoeficienteDerivada3S DB 002BH, 0000, '$'
		datoCoeficienteDerivada2S DB 002BH, 0000, '$'
		datoCoeficienteDerivada1S DB 002BH, 0000, '$'
		datoCoeficienteDerivada0S DB 002BH, 0000, '$'

		datoCoeficienteIntegral5 DB 002BH, 0000, 002EH, 0000, '$' ; 4 posiciones: 1 para parte entera, 1 para punto, 1 para parte decimal y 1 para posible signo
		datoCoeficienteIntegral4 DB 002BH, 0000, 002EH, 0000, '$' ; 4 posiciones: 1 para parte entera, 1 para punto, 1 para parte decimal y 1 para posible signo
		datoCoeficienteIntegral3 DB 002BH, 0000, 002EH, 0000, '$' ; 4 posiciones: 1 para parte entera, 1 para punto, 1 para parte decimal y 1 para posible signo
		datoCoeficienteIntegral2 DB 002BH, 0000, 002EH, 0000, '$' ; 4 posiciones: 1 para parte entera, 1 para punto, 1 para parte decimal y 1 para posible signo
		datoCoeficienteIntegral1 DB 002BH, 0000, '$' ; 2 posiciones: 1 para parte entera y 1 para posible signo
		datoCoeficienteIntegral0 DB 002BH, 0000, '$' ; 3 posiciones: 2 para parte entera y 1 para posible signo
	;==DATOS EXTRA==
	;===============


;==================
;==AREA DE CODIGO==
;==================
.CODE 
	
	main  PROC

		;================
		;==MENU INICIAL==
		;================
			MENU:
				clearScreen ; Limpia la pantalla
				print mensajeEncabezado ; Muestra el encabezado
				print mensajeMenuPrincipal ; Muestra el menu
				getChar ; Captura el caracter
				CMP AL, 49D ; caracter == 1
				JE INGRESAR_FUNCION  ; Ingresar Funcion
				CMP AL, 50D ; caracter == 2
				JE FUNCION_MEMORIA ; Funcion en memoria
				CMP AL, 51D ; caracter == 3
				JE FUNCION_DERIVADA ; Calcular derivada
				CMP AL, 52D ; caracter == 4
				JE FUNCION_INTEGRAL  ; Calcular integral
				CMP AL, 53D ; caracter == 5
				JE GRAFICAR_FUNCIONES  ; Graficar funciones
				CMP AL, 54D ; caracter == 6
				JE GENERAR_REPORTE  ; Generar reporte
				CMP AL, 55D ; caracter == 7
				JE ABRIR_CALCULADORA  ; Abrir calculadora
				CMP AL, 56D ; caracter == 8
				JE SALIR  ; Salir
				JMP MENU ; Si el caracter no es un numero entre [1,8] regresa al menu
		;================
		;==MENU INICIAL==
		;================

		;====================
		;==INGRESAR FUNCION==
		;====================
			INGRESAR_FUNCION:
				PUSH AX
				clearScreen ; Limpia la pantalla
				reiniciarFuncion
				print mensajeCoeficiente4 ; Solicita el coeficiente 4
				CALL LEER_DATO ; Obtiene el coeficiente 4
				CALL PROCESAR_COEFICIENTE
				CMP datoVerificacionNumero, 0001
				JE ERROR_INGRESAR_FUNCION
				MOV AL, datoTextoUsuario[0000]
				MOV datoCoeficienteFuncion4[0000], AL
				MOV AL, datoTextoUsuario[0001]
				MOV datoCoeficienteFuncion4[0001], AL
				
				print mensajeCoeficiente3 ; Solicita el coeficiente 3
				CALL LEER_DATO ; Obtiene el coeficiente 3
				CALL PROCESAR_COEFICIENTE
				CMP datoVerificacionNumero, 0001
				JE ERROR_INGRESAR_FUNCION
				MOV AL, datoTextoUsuario[0000]
				MOV datoCoeficienteFuncion3[0000], AL
				MOV AL, datoTextoUsuario[0001]
				MOV datoCoeficienteFuncion3[0001], AL
				
				print mensajeCoeficiente2 ; Solicita el coeficiente 2
				CALL LEER_DATO ; Obtiene el coeficiente 2
				CALL PROCESAR_COEFICIENTE
				CMP datoVerificacionNumero, 0001
				JE ERROR_INGRESAR_FUNCION
				MOV AL, datoTextoUsuario[0000]
				MOV datoCoeficienteFuncion2[0000], AL
				MOV AL, datoTextoUsuario[0001]
				MOV datoCoeficienteFuncion2[0001], AL
				
				print mensajeCoeficiente1 ; Solicita el coeficiente 1
				CALL LEER_DATO ; Obtiene el coeficiente 1
				CALL PROCESAR_COEFICIENTE
				CMP datoVerificacionNumero, 0001
				JE ERROR_INGRESAR_FUNCION
				MOV AL, datoTextoUsuario[0000]
				MOV datoCoeficienteFuncion1[0000], AL
				MOV AL, datoTextoUsuario[0001]
				MOV datoCoeficienteFuncion1[0001], AL
				
				print mensajeCoeficiente0 ; Solicita el coeficiente 0
				CALL LEER_DATO ; Obtiene el coeficiente 0
				CALL PROCESAR_COEFICIENTE
				CMP datoVerificacionNumero, 0001
				JE ERROR_INGRESAR_FUNCION
				MOV AL, datoTextoUsuario[0000]
				MOV datoCoeficienteFuncion0[0000], AL
				MOV AL, datoTextoUsuario[0001]
				MOV datoCoeficienteFuncion0[0001], AL

				POP AX
				CALL DERIVAR
				CALL INTEGRAR
				MOV ingresoFuncion, 0001
				JMP MENU ; Regresar al menu
		;====================
		;==INGRESAR FUNCION==
		;====================

		;====================
		;==FUNCION ORIGINAL==
		;====================
			FUNCION_MEMORIA:
				clearScreen ; Limpia la pantalla
				CMP ingresoFuncion, 0000
				JE ERROR_FALTA_FUNCION
				printFuncionOriginal
				CALL PAUSA
				JMP MENU ; Regresa al menu
		;====================
		;==FUNCION ORIGINAL==
		;====================

		;====================
		;==FUNCION DERIVADA==
		;====================
			FUNCION_DERIVADA:
				clearScreen ; Limpia la pantalla
				CMP ingresoFuncion, 0000
				JE ERROR_FALTA_FUNCION
				printFuncionDerivada
				CALL PAUSA
				JMP MENU ; Regresa al menu
		;====================
		;==FUNCION DERIVADA==
		;====================

		;====================
		;==FUNCION INTEGRAL==
		;====================
			FUNCION_INTEGRAL:
				clearScreen ; Limpia la pantalla
				CMP ingresoFuncion, 0000
				JE ERROR_FALTA_FUNCION
				printFuncionIntegral
				CALL PAUSA
				JMP MENU ; Regresa al menu
		;====================
		;==FUNCION INTEGRAL==
		;====================

		;====================
		;==GRAFICAR FUNCION==
		;====================
			GRAFICAR_FUNCIONES:
				clearScreen ; Limpia la pantalla
				CMP ingresoFuncion, 0000
				JE ERROR_FALTA_FUNCION
				print mensajeMenuGraficar ; Muestra el menu para graficar
				getChar ; Captura el caracter
				CMP AL, 49D ; caracter == 1
				JE GRAFICAR_ORIGINAL  ; Ingresar Funcion
				CMP AL, 50D ; caracter == 2
				JE GRAFICAR_DERIVADA ; Funcion en memoria
				CMP AL, 51D ; caracter == 3
				JE GRAFICAR_INTEGRAL ; Calcular derivada
				CMP AL, 52D ; caracter == 4
				JE MENU  ; Regresar
				JMP GRAFICAR_FUNCIONES ; Si el caracter no es un numero entre [1,8] regresa al menu
				GRAFICAR_ORIGINAL:
					clearScreen ; Limpia la pantalla
					print mensajeInicialIntervalo ; Solicita el valor inicial del intervalo
					stringRead textoRangoInferior ; El usuario ingresa el dato
					transformarRango textoRangoInferior, graficarIntervaloInicial
					;======================================================================================PROCESAR DATO
					print mensajeFinalIntervalo ; Solicita el valor inicial del intervalo
					stringRead textoRangoSuperior ; El usuario ingresa el dato
					transformarRango textoRangoSuperior, graficarIntervaloFinal
					;======================================================================================PROCESAR DATO
					comprobarRango
					MOV tipoGrafica, 0000
					dibujarPlano tipoGrafica
					CALL PAUSA ; PONER ACA EL CODIGO PARA GRAFICAR LA FUNCION ORIGINAL
					JMP MENU

				GRAFICAR_DERIVADA:
					clearScreen ; Limpia la pantalla
					print mensajeInicialIntervalo ; Solicita el valor inicial del intervalo
					stringRead textoRangoInferior ; El usuario ingresa el dato
					transformarRango textoRangoInferior, graficarIntervaloInicial
					;======================================================================================PROCESAR DATO
					print mensajeFinalIntervalo ; Solicita el valor inicial del intervalo
					stringRead textoRangoSuperior ; El usuario ingresa el dato
					transformarRango textoRangoSuperior, graficarIntervaloFinal
					;======================================================================================PROCESAR DATO
					comprobarRango
					MOV tipoGrafica, 0001
					dibujarPlano tipoGrafica
					CALL PAUSA ; PONER ACA EL CODIGO PARA GRAFICAR LA FUNCION ORIGINAL
					JMP MENU

				GRAFICAR_INTEGRAL:
					clearScreen ; Limpia la pantalla
					print mensajeInicialIntervalo ; Solicita el valor inicial del intervalo
					stringRead textoRangoInferior ; El usuario ingresa el dato
					transformarRango textoRangoInferior, graficarIntervaloInicial
					;======================================================================================PROCESAR DATO
					print mensajeFinalIntervalo ; Solicita el valor inicial del intervalo
					stringRead textoRangoSuperior ; El usuario ingresa el dato
					transformarRango textoRangoSuperior, graficarIntervaloFinal
					comprobarRango
					;======================================================================================PROCESAR DATO
					print mensajeConstanteC ; Solicita el valor de la constante de integracion C
					stringRead textoDatoConstante ; El usuario ingresa el dato
					transformarRango textoDatoConstante, graficarConstanteIntegracion
					;======================================================================================PROCESAR DATO
					MOV tipoGrafica, 0002
					dibujarPlano tipoGrafica
					CALL PAUSA ; PONER ACA EL CODIGO PARA GRAFICAR LA FUNCION ORIGINAL
					JMP MENU
				JMP MENU ; Regresa al menu
		;====================
		;==GRAFICAR FUNCION==
		;====================

		;===================
		;==GENERAR REPORTE==
		;===================
			GENERAR_REPORTE:
				clearScreen ; Limpia la pantalla
				print mensajeReporteCreado
				crearHtml reporteNombre
				CALL PAUSA
				;===========================================================GENERAR REPORTE
				JMP MENU ; Regresa al menu
		;===================
		;==GENERAR REPORTE==
		;===================

		;=====================
		;==ABRIR CALCULADORA==
		;=====================
			ABRIR_CALCULADORA:
				clearScreen ; Limpia la pantalla
				reiniciarAnalisis
				print mensajeCalculadora ; Solicita el nombre del archivo a cargar
				stringRead calculadoraNombreArchivo ; Obtiene la ruta ingresada por el usuario
				comprobarRuta
				comprobarExtension
				fileReader
				operar
				;print pilaOperaciones
				operarPila
				convertirNumero resultado
				;clearScreen
				print mensajeTab
				print calculadoraTextoRecibido
				print mensajeResultadoOperacion
				print signoResultado
				print mostrarRespuesta
				;============================================================PROCESAR DATOS
				CALL PAUSA
				JMP MENU ; Regresa al menu
		;=====================
		;==ABRIR CALCULADORA==
		;=====================

		;===========
		;==ERRORES==
		;===========
			ERROR_INGRESAR_FUNCION:
				print errorIngresarFuncion
				CALL PAUSA
				POP AX
				JMP INGRESAR_FUNCION
			ERROR_FALTA_FUNCION:
				clearScreen
				print errorNoHayFuncion
				CALL PAUSA
				JMP MENU
			ERROR_RANGO:
				print errorIntervalo
				CALL PAUSA
				reiniciarGrafica
				JMP GRAFICAR_FUNCIONES
			ERROR_FUNCION_ANALISIS:
				reiniciarPath
				print errorIngresarFuncion
      			CALL PAUSA
      			JMP MENU
      		ERROR_PUNTOCOMA_ANALISIS:
      			reiniciarPath
      			print errorFaltaPuntoComa
      			CALL PAUSA
      			JMP MENU
      		ERROR_DIVISION_CERO:
      			print errorDivisionCero
      			CALL PAUSA
      			JMP MENU
      		ERROR_ABRIR:
      			print errorAbrirArchivo
      			reiniciarPath
      			CALL PAUSA
      			JMP ABRIR_CALCULADORA
      		ERROR_EXTENSION:
      			print errorExtension
      			reiniciarPath
      			CALL PAUSA
      			JMP ABRIR_CALCULADORA
      		ERROR_RUTA:
      			print errorRuta
      			reiniciarPath
      			CALL PAUSA
      			JMP ABRIR_CALCULADORA
		;===========
		;==ERRORES==
		;===========

		;=========
		;==SALIR==
		;=========
			SALIR:
				MOV AX, 4C00H ; Interrupcion para finalizar el programa
				INT 21H ; Llama a la interrupcion
		;=========
		;==SALIR==
		;=========

		;===================
		;==PROCEDIMIENTOS===
		;===================
			ORIGINALOPERARC4 PROC
				;X^4
				XOR AH, AH
				MOV AL, datoCoeficienteFuncion4[0001] ; Coeficiente
				MUL BL ; Dato
				CMP AX, 0062H
				JA SALIR
				MUL BL ; Dato^2
				CMP AX, 0062H
				JA SALIR
				MUL BL ; Dato^3
				CMP AX, 0062H
				JA SALIR
				MUL BL ; Dato^4
				CMP AX, 0062H
				JA SALIR
				ADD resultadoGrafica[0000], AL
				CMP resultadoGrafica[0000], 0062H ; Se sale del rango
				JA SALIR
				CMP datoCoeficienteFuncion4[0000], 002BH ; Es positivo
				JE SUMAR
				MOV signoResultado, 0001 ; 0000->positivo. 0001->negativo
				JMP SALIR

				SUMAR:
					MOV signoResultado, 0000 ; 0000->positivo. 0001->negativo

				SALIR:
					CMP resultadoGrafica[0000], 0062H
					JA SALIR2
					CMP AX, 0062H
					RET
					
				SALIR2:
					RET
			ORIGINALOPERARC4 ENDP

			ORIGINALOPERARC3 PROC
				;X^3
				XOR AH, AH
				MOV AL, datoCoeficienteFuncion3[0001] ; Coeficiente
				MUL BL ; Dato
				CMP AX, 0062H
				JA SALIR
				MUL BL ; Dato^2
				CMP AX, 0062H
				JA SALIR
				MUL BL ; Dato^3
				CMP AX, 0062H
				JA SALIR
				CMP resultadoGrafica[0000], 0062H
				JA SALIR

				CMP datoCoeficienteFuncion3[0000], 002BH
				JE SEGUNDOPOSITIVO ; El coeficiente 3 es positivo
				JMP SEGUNDONEGATIVO

				SEGUNDOPOSITIVO:
					CMP signoEvaluacion, 0001 ; Se esta evaluando un numero negativo
					JE D
				S:
					CMP signoResultado, 0000 ; Resultado anterior es positivo
					JE PPSP ; Primero positivo Segundo Positivo

					;PNSP -> Primero negativo Segundo positivo
					CMP resultadoGrafica[0000], AL
					JB PPSGP ; Primero pequeño Segundo grande

					;Primero grande Segundo pequeño
					;Primero negativo Segundo positivo
					SUB resultadoGrafica[0000], AL
					MOV signoResultado, 0001 ; Resultado negativo
					JMP SALIR

				;Primero pequeño Segundo grande
				;Primero negativo Segundo positivo
				PPSGP:
					SUB AL, resultadoGrafica[0000]
					MOV resultadoGrafica[0000], AL
					MOV signoResultado, 0000 ; Resultado positivo
					JMP SALIR

				PPSP:
					ADD resultadoGrafica[0000], AL
					MOV signoResultado, 0000 ; Resultado positivo
					JMP SALIR
				SEGUNDONEGATIVO:
					CMP signoEvaluacion, 0001 ; Se esta evaluando un numero negativo
					JE S
				D:
					CMP signoResultado, 0000
					JE PPSN

					;Primero negativo, Segundo negativo
					ADD resultadoGrafica[0000], AL
					MOV signoResultado, 0001 ; Resultado negativo
					JMP SALIR

				PPSN:
					CMP resultadoGrafica[0000], AL
					JB PPSGN

					SUB resultadoGrafica[0000], AL
					MOV signoResultado, 0000 ; Resultado positivo
					JMP SALIR

				PPSGN:
					SUB AL, resultadoGrafica[0000]
					MOV resultadoGrafica[0000], AL
					MOV signoResultado, 0001 ; Resultado negativo
					JMP SALIR
				SALIR:
					CMP resultadoGrafica[0000], 0062H
					JA SALIR2
					CMP AX, 0062H
					RET

				SALIR2:
					RET
			ORIGINALOPERARC3 ENDP

			ORIGINALOPERARC2 PROC
				;X^2
				XOR AH, AH
				MOV AL, datoCoeficienteFuncion2[0001] ; Coeficiente
				MUL BL ; Dato
				MUL BL ; Dato^2
				CMP AX, 0062H
				JA SALIR
				CMP resultadoGrafica[0000], 0062H
				JA SALIR
				CMP datoCoeficienteFuncion2[0000], 002BH ; Coeficiente Positivo
				JE SEGUNDOPOSITIVO ; El coeficiente 2 es positivo
				JMP SEGUNDONEGATIVO

				SEGUNDOPOSITIVO:
					CMP signoResultado, 0000 ; Resultado anterior es positivo
					JE PPSP ; Primero positivo Segundo Positivo

					;PNSP -> Primero negativo Segundo positivo
					CMP resultadoGrafica[0000], AL
					JB PPSGP ; Primero pequeño Segundo grande

					;Primero grande Segundo pequeño
					;Primero negativo Segundo positivo
					SUB resultadoGrafica[0000], AL
					MOV signoResultado, 0001 ; Resultado negativo
					JMP SALIR

				;Primero pequeño Segundo grande
				;Primero negativo Segundo positivo
				PPSGP:
					SUB AL, resultadoGrafica[0000]
					MOV resultadoGrafica[0000], AL
					MOV signoResultado, 0000 ; Resultado positivo
					JMP SALIR

				PPSP:
					ADD resultadoGrafica[0000], AL
					MOV signoResultado, 0000 ; Resultado positivo
					JMP SALIR


				SEGUNDONEGATIVO:
					CMP signoResultado, 0000
					JE PPSN

					;Primero negativo, Segundo negativo
					ADD resultadoGrafica[0000], AL
					MOV signoResultado, 0001 ; Resultado negativo
					JMP SALIR

				PPSN:
					CMP resultadoGrafica[0000], AL
					JB PPSGN

					SUB resultadoGrafica[0000], AL
					MOV signoResultado, 0000 ; Resultado positivo
					JMP SALIR

				PPSGN:
					SUB AL, resultadoGrafica[0000]
					MOV resultadoGrafica[0000], AL
					MOV signoResultado, 0001 ; Resultado negativo
					JMP SALIR

				SALIR:
					CMP resultadoGrafica[0000], 0062H
					JA SALIR2
					CMP AX, 0062H
					RET

				SALIR2:
					RET
			ORIGINALOPERARC2 ENDP

			ORIGINALOPERARC1 PROC
				;X^1
				XOR AH, AH
				MOV AL, datoCoeficienteFuncion1[0001] ; Coeficiente
				MUL BL ; Dato

				CMP resultadoGrafica[0000], 0062H
				JA SALIR
				CMP datoCoeficienteFuncion1[0000], 002BH ; Coeficiente Positivo
				JE SEGUNDOPOSITIVO ; El coeficiente 1 es positivo
				JMP SEGUNDONEGATIVO

				SEGUNDOPOSITIVO:
					CMP signoEvaluacion, 0001 ; Esta evaluando numeros negativos
					JE D
				S:
					CMP signoResultado, 0000 ; Resultado anterior es positivo
					JE PPSP ; Primero positivo Segundo Positivo

					;PNSP -> Primero negativo Segundo positivo
					CMP resultadoGrafica[0000], AL
					JB PPSGP ; Primero pequeño Segundo grande

					;Primero grande Segundo pequeño
					;Primero negativo Segundo positivo
					SUB resultadoGrafica[0000], AL
					MOV signoResultado, 0001 ; Resultado negativo
					JMP SALIR

				;Primero pequeño Segundo grande
				;Primero negativo Segundo positivo
				PPSGP:
					SUB AL, resultadoGrafica[0000]
					MOV resultadoGrafica[0000], AL
					MOV signoResultado, 0000 ; Resultado positivo
					JMP SALIR

				PPSP:
					ADD resultadoGrafica[0000], AL
					MOV signoResultado, 0000 ; Resultado positivo
					JMP SALIR


				SEGUNDONEGATIVO:
					CMP signoEvaluacion, 0001 ; Esta evaluando numeros negativos
					JE S

				D:
					CMP signoResultado, 0000
					JE PPSN

					;Primero negativo, Segundo negativo
					ADD resultadoGrafica[0000], AL
					MOV signoResultado, 0001 ; Resultado negativo
					JMP SALIR

				PPSN:
					CMP resultadoGrafica[0000], AL
					JB PPSGN

					SUB resultadoGrafica[0000], AL
					MOV signoResultado, 0000 ; Resultado positivo
					JMP SALIR

				PPSGN:
					SUB AL, resultadoGrafica[0000]
					MOV resultadoGrafica[0000], AL
					MOV signoResultado, 0001 ; Resultado negativo
					JMP SALIR

				SALIR:
					CMP resultadoGrafica[0000], 0062H
					JA SALIR2
					CMP AX, 0062H
					RET
					
				SALIR2:
					RET
			ORIGINALOPERARC1 ENDP

			ORIGINALOPERARC0 PROC
				MOV AL, datoCoeficienteFuncion0[0001]
				CMP datoCoeficienteFuncion0[0000], 002BH
				JE SEGUNDOPOSITIVO
				JMP SEGUNDONEGATIVO

				SEGUNDOPOSITIVO:
					CMP signoResultado, 0000
					JNE PNSP ; Primero negativo
					ADD resultadoGrafica, AL
					MOV signoResultado, 0000 ; Resultado positivo
					JMP SALIR

				PNSP:
					CMP resultadoGrafica, AL
					JB PPSGP
					SUB resultadoGrafica, AL
					MOV signoResultado, 0001 ; Resultado negativo
					JMP SALIR

				PPSGP:
					SUB AL, resultadoGrafica
					MOV resultadoGrafica, AL
					MOV signoResultado, 0000 ; Resultado positivo
					JMP SALIR

				SEGUNDONEGATIVO:
					CMP signoResultado, 0000
					JE PPSN
					ADD resultadoGrafica, AL
					MOV signoResultado, 0001 ; Resultado negativo

				PPSN:
					CMP resultadoGrafica, AL
					JB PPSGN
					SUB resultadoGrafica, AL
					MOV signoResultado, 0000 ; Resultado positivo
					JMP SALIR

				PPSGN:
					SUB AL, resultadoGrafica
					MOV resultadoGrafica, AL
					MOV signoResultado, 0001 ; Resultado negativo
					JMP SALIR

				SALIR:
					CMP resultadoGrafica[0000], 0062H
					RET
			ORIGINALOPERARC0 ENDP

			DERIVADAOPERARC3 PROC
				;X^3
				XOR AH, AH
				MOV AL, datoCoeficienteDerivada3S[0001] ; Coeficiente
				MUL BL ; Dato
				CMP AX, 0062H
				JA SALIR
				MUL BL ; Dato^2
				CMP AX, 0062H
				JA SALIR
				MUL BL ; Dato^3
				CMP AX, 0062H
				JA SALIR
				CMP resultadoGrafica[0000], 0062H
				JA SALIR

				CMP datoCoeficienteFuncion3[0000], 002BH
				JE SEGUNDOPOSITIVO ; El coeficiente 3 es positivo
				JMP SEGUNDONEGATIVO

				SEGUNDOPOSITIVO:
					CMP signoEvaluacion, 0001 ; Se esta evaluando un numero negativo
					JE D
				S:
					CMP signoResultado, 0000 ; Resultado anterior es positivo
					JE PPSP ; Primero positivo Segundo Positivo

					;PNSP -> Primero negativo Segundo positivo
					CMP resultadoGrafica[0000], AL
					JB PPSGP ; Primero pequeño Segundo grande

					;Primero grande Segundo pequeño
					;Primero negativo Segundo positivo
					SUB resultadoGrafica[0000], AL
					MOV signoResultado, 0001 ; Resultado negativo
					JMP SALIR

				;Primero pequeño Segundo grande
				;Primero negativo Segundo positivo
				PPSGP:
					SUB AL, resultadoGrafica[0000]
					MOV resultadoGrafica[0000], AL
					MOV signoResultado, 0000 ; Resultado positivo
					JMP SALIR

				PPSP:
					ADD resultadoGrafica[0000], AL
					MOV signoResultado, 0000 ; Resultado positivo
					JMP SALIR
				SEGUNDONEGATIVO:
					CMP signoEvaluacion, 0001 ; Se esta evaluando un numero negativo
					JE S
				D:
					CMP signoResultado, 0000
					JE PPSN

					;Primero negativo, Segundo negativo
					ADD resultadoGrafica[0000], AL
					MOV signoResultado, 0001 ; Resultado negativo
					JMP SALIR

				PPSN:
					CMP resultadoGrafica[0000], AL
					JB PPSGN

					SUB resultadoGrafica[0000], AL
					MOV signoResultado, 0000 ; Resultado positivo
					JMP SALIR

				PPSGN:
					SUB AL, resultadoGrafica[0000]
					MOV resultadoGrafica[0000], AL
					MOV signoResultado, 0001 ; Resultado negativo
					JMP SALIR
				SALIR:
					CMP resultadoGrafica[0000], 0062H
					JA SALIR2
					CMP AX, 0062H
					RET

				SALIR2:
					RET
			DERIVADAOPERARC3 ENDP

			DERIVADAOPERARC2 PROC
				;X^2
				XOR AH, AH
				MOV AL, datoCoeficienteDerivada2S[0001] ; Coeficiente
				MUL BL ; Dato
				MUL BL ; Dato^2
				CMP AX, 0062H
				JA SALIR
				CMP resultadoGrafica[0000], 0062H
				JA SALIR
				CMP datoCoeficienteFuncion2[0000], 002BH ; Coeficiente Positivo
				JE SEGUNDOPOSITIVO ; El coeficiente 2 es positivo
				JMP SEGUNDONEGATIVO

				SEGUNDOPOSITIVO:
					CMP signoResultado, 0000 ; Resultado anterior es positivo
					JE PPSP ; Primero positivo Segundo Positivo

					;PNSP -> Primero negativo Segundo positivo
					CMP resultadoGrafica[0000], AL
					JB PPSGP ; Primero pequeño Segundo grande

					;Primero grande Segundo pequeño
					;Primero negativo Segundo positivo
					SUB resultadoGrafica[0000], AL
					MOV signoResultado, 0001 ; Resultado negativo
					JMP SALIR

				;Primero pequeño Segundo grande
				;Primero negativo Segundo positivo
				PPSGP:
					SUB AL, resultadoGrafica[0000]
					MOV resultadoGrafica[0000], AL
					MOV signoResultado, 0000 ; Resultado positivo
					JMP SALIR

				PPSP:
					ADD resultadoGrafica[0000], AL
					MOV signoResultado, 0000 ; Resultado positivo
					JMP SALIR


				SEGUNDONEGATIVO:
					CMP signoResultado, 0000
					JE PPSN

					;Primero negativo, Segundo negativo
					ADD resultadoGrafica[0000], AL
					MOV signoResultado, 0001 ; Resultado negativo
					JMP SALIR

				PPSN:
					CMP resultadoGrafica[0000], AL
					JB PPSGN

					SUB resultadoGrafica[0000], AL
					MOV signoResultado, 0000 ; Resultado positivo
					JMP SALIR

				PPSGN:
					SUB AL, resultadoGrafica[0000]
					MOV resultadoGrafica[0000], AL
					MOV signoResultado, 0001 ; Resultado negativo
					JMP SALIR

				SALIR:
					CMP resultadoGrafica[0000], 0062H
					JA SALIR2
					CMP AX, 0062H
					RET

				SALIR2:
					RET
			DERIVADAOPERARC2 ENDP

			DERIVADAOPERARC1 PROC
				;X^1
				XOR AH, AH
				MOV AL, datoCoeficienteDerivada1S[0001] ; Coeficiente
				MUL BL ; Dato

				CMP resultadoGrafica[0000], 0062H
				JA SALIR
				CMP datoCoeficienteFuncion1[0000], 002BH ; Coeficiente Positivo
				JE SEGUNDOPOSITIVO ; El coeficiente 1 es positivo
				JMP SEGUNDONEGATIVO

				SEGUNDOPOSITIVO:
					CMP signoEvaluacion, 0001 ; Esta evaluando numeros negativos
					JE D
				S:
					CMP signoResultado, 0000 ; Resultado anterior es positivo
					JE PPSP ; Primero positivo Segundo Positivo

					;PNSP -> Primero negativo Segundo positivo
					CMP resultadoGrafica[0000], AL
					JB PPSGP ; Primero pequeño Segundo grande

					;Primero grande Segundo pequeño
					;Primero negativo Segundo positivo
					SUB resultadoGrafica[0000], AL
					MOV signoResultado, 0001 ; Resultado negativo
					JMP SALIR

				;Primero pequeño Segundo grande
				;Primero negativo Segundo positivo
				PPSGP:
					SUB AL, resultadoGrafica[0000]
					MOV resultadoGrafica[0000], AL
					MOV signoResultado, 0000 ; Resultado positivo
					JMP SALIR

				PPSP:
					ADD resultadoGrafica[0000], AL
					MOV signoResultado, 0000 ; Resultado positivo
					JMP SALIR


				SEGUNDONEGATIVO:
					CMP signoEvaluacion, 0001 ; Esta evaluando numeros negativos
					JE S

				D:
					CMP signoResultado, 0000
					JE PPSN

					;Primero negativo, Segundo negativo
					ADD resultadoGrafica[0000], AL
					MOV signoResultado, 0001 ; Resultado negativo
					JMP SALIR

				PPSN:
					CMP resultadoGrafica[0000], AL
					JB PPSGN

					SUB resultadoGrafica[0000], AL
					MOV signoResultado, 0000 ; Resultado positivo
					JMP SALIR

				PPSGN:
					SUB AL, resultadoGrafica[0000]
					MOV resultadoGrafica[0000], AL
					MOV signoResultado, 0001 ; Resultado negativo
					JMP SALIR

				SALIR:
					CMP resultadoGrafica[0000], 0062H
					JA SALIR2
					CMP AX, 0062H
					RET
					
				SALIR2:
					RET
			DERIVADAOPERARC1 ENDP

			DERIVADAOPERARC0 PROC
				MOV AL, datoCoeficienteDerivada0S[0001]
				CMP datoCoeficienteFuncion0[0000], 002BH
				JE SEGUNDOPOSITIVO
				JMP SEGUNDONEGATIVO

				SEGUNDOPOSITIVO:
					CMP signoResultado, 0000
					JNE PNSP ; Primero negativo
					ADD resultadoGrafica, AL
					MOV signoResultado, 0000 ; Resultado positivo
					JMP SALIR

				PNSP:
					CMP resultadoGrafica, AL
					JB PPSGP
					SUB resultadoGrafica, AL
					MOV signoResultado, 0001 ; Resultado negativo
					JMP SALIR

				PPSGP:
					SUB AL, resultadoGrafica
					MOV resultadoGrafica, AL
					MOV signoResultado, 0000 ; Resultado positivo
					JMP SALIR

				SEGUNDONEGATIVO:
					CMP signoResultado, 0000
					JE PPSN
					ADD resultadoGrafica, AL
					MOV signoResultado, 0001 ; Resultado negativo

				PPSN:
					CMP resultadoGrafica, AL
					JB PPSGN
					SUB resultadoGrafica, AL
					MOV signoResultado, 0000 ; Resultado positivo
					JMP SALIR

				PPSGN:
					SUB AL, resultadoGrafica
					MOV resultadoGrafica, AL
					MOV signoResultado, 0001 ; Resultado negativo
					JMP SALIR

				SALIR:
					CMP resultadoGrafica[0000], 0062H
					RET
			DERIVADAOPERARC0 ENDP

			INTEGRALOPERARC5 PROC
				;X^4
				XOR AH, AH
				MOV AL, datoCoeficienteIntegral5[0001] ; Coeficiente
				MUL BL ; Dato
				CMP AX, 0062H
				JA SALIR
				MUL BL ; Dato^2
				CMP AX, 0062H
				JA SALIR
				MUL BL ; Dato^3
				CMP AX, 0062H
				JA SALIR
				MUL BL ; Dato^4
				CMP AX, 0062H
				JA SALIR
				ADD resultadoGrafica[0000], AL
				CMP resultadoGrafica[0000], 0062H ; Se sale del rango
				JA SALIR
				CMP datoCoeficienteFuncion4[0000], 002BH ; Es positivo
				JE SUMAR
				MOV signoResultado, 0001 ; 0000->positivo. 0001->negativo
				JMP SALIR

				SUMAR:
					MOV signoResultado, 0000 ; 0000->positivo. 0001->negativo

				SALIR:
					CMP resultadoGrafica[0000], 0062H
					JA SALIR2
					CMP AX, 0062H
					RET
					
				SALIR2:
					RET
			INTEGRALOPERARC5 ENDP

			INTEGRALOPERARC4 PROC
				;X^4
				XOR AH, AH
				MOV AL, datoCoeficienteIntegral4[0001] ; Coeficiente
				MUL BL ; Dato
				MUL BL ; Dato^2
				CMP AX, 0062H
				JA SALIR
				CMP resultadoGrafica[0000], 0062H
				JA SALIR
				CMP datoCoeficienteFuncion3[0000], 002BH ; Coeficiente Positivo
				JE SEGUNDOPOSITIVO ; El coeficiente 2 es positivo
				JMP SEGUNDONEGATIVO

				SEGUNDOPOSITIVO:
					CMP signoResultado, 0000 ; Resultado anterior es positivo
					JE PPSP ; Primero positivo Segundo Positivo

					;PNSP -> Primero negativo Segundo positivo
					CMP resultadoGrafica[0000], AL
					JB PPSGP ; Primero pequeño Segundo grande

					;Primero grande Segundo pequeño
					;Primero negativo Segundo positivo
					SUB resultadoGrafica[0000], AL
					MOV signoResultado, 0001 ; Resultado negativo
					JMP SALIR

				;Primero pequeño Segundo grande
				;Primero negativo Segundo positivo
				PPSGP:
					SUB AL, resultadoGrafica[0000]
					MOV resultadoGrafica[0000], AL
					MOV signoResultado, 0000 ; Resultado positivo
					JMP SALIR

				PPSP:
					ADD resultadoGrafica[0000], AL
					MOV signoResultado, 0000 ; Resultado positivo
					JMP SALIR


				SEGUNDONEGATIVO:
					CMP signoResultado, 0000
					JE PPSN

					;Primero negativo, Segundo negativo
					ADD resultadoGrafica[0000], AL
					MOV signoResultado, 0001 ; Resultado negativo
					JMP SALIR

				PPSN:
					CMP resultadoGrafica[0000], AL
					JB PPSGN

					SUB resultadoGrafica[0000], AL
					MOV signoResultado, 0000 ; Resultado positivo
					JMP SALIR

				PPSGN:
					SUB AL, resultadoGrafica[0000]
					MOV resultadoGrafica[0000], AL
					MOV signoResultado, 0001 ; Resultado negativo
					JMP SALIR

				SALIR:
					CMP resultadoGrafica[0000], 0062H
					JA SALIR2
					CMP AX, 0062H
					RET

				SALIR2:
					RET
			INTEGRALOPERARC4 ENDP

			INTEGRALOPERARC3 PROC
				;X^3
				XOR AH, AH
				MOV AL, datoCoeficienteIntegral3[0001] ; Coeficiente
				MUL BL ; Dato
				CMP AX, 0062H
				JA SALIR
				MUL BL ; Dato^2
				CMP AX, 0062H
				JA SALIR
				MUL BL ; Dato^3
				CMP AX, 0062H
				JA SALIR
				CMP resultadoGrafica[0000], 0062H
				JA SALIR

				CMP datoCoeficienteFuncion2[0000], 002BH
				JE SEGUNDOPOSITIVO ; El coeficiente 3 es positivo
				JMP SEGUNDONEGATIVO

				SEGUNDOPOSITIVO:
					CMP signoEvaluacion, 0001 ; Se esta evaluando un numero negativo
					JE D
				S:
					CMP signoResultado, 0000 ; Resultado anterior es positivo
					JE PPSP ; Primero positivo Segundo Positivo

					;PNSP -> Primero negativo Segundo positivo
					CMP resultadoGrafica[0000], AL
					JB PPSGP ; Primero pequeño Segundo grande

					;Primero grande Segundo pequeño
					;Primero negativo Segundo positivo
					SUB resultadoGrafica[0000], AL
					MOV signoResultado, 0001 ; Resultado negativo
					JMP SALIR

				;Primero pequeño Segundo grande
				;Primero negativo Segundo positivo
				PPSGP:
					SUB AL, resultadoGrafica[0000]
					MOV resultadoGrafica[0000], AL
					MOV signoResultado, 0000 ; Resultado positivo
					JMP SALIR

				PPSP:
					ADD resultadoGrafica[0000], AL
					MOV signoResultado, 0000 ; Resultado positivo
					JMP SALIR
				SEGUNDONEGATIVO:
					CMP signoEvaluacion, 0001 ; Se esta evaluando un numero negativo
					JE S
				D:
					CMP signoResultado, 0000
					JE PPSN

					;Primero negativo, Segundo negativo
					ADD resultadoGrafica[0000], AL
					MOV signoResultado, 0001 ; Resultado negativo
					JMP SALIR

				PPSN:
					CMP resultadoGrafica[0000], AL
					JB PPSGN

					SUB resultadoGrafica[0000], AL
					MOV signoResultado, 0000 ; Resultado positivo
					JMP SALIR

				PPSGN:
					SUB AL, resultadoGrafica[0000]
					MOV resultadoGrafica[0000], AL
					MOV signoResultado, 0001 ; Resultado negativo
					JMP SALIR
				SALIR:
					CMP resultadoGrafica[0000], 0062H
					JA SALIR2
					CMP AX, 0062H
					RET

				SALIR2:
					RET
			INTEGRALOPERARC3 ENDP

			INTEGRALOPERARC2 PROC
				;X^2
				XOR AH, AH
				MOV AL, datoCoeficienteIntegral1[0001] ; Coeficiente
				MUL BL ; Dato
				MUL BL ; Dato^2
				CMP AX, 0062H
				JA SALIR
				CMP resultadoGrafica[0000], 0062H
				JA SALIR
				CMP datoCoeficienteFuncion1[0000], 002BH ; Coeficiente Positivo
				JE SEGUNDOPOSITIVO ; El coeficiente 2 es positivo
				JMP SEGUNDONEGATIVO

				SEGUNDOPOSITIVO:
					CMP signoResultado, 0000 ; Resultado anterior es positivo
					JE PPSP ; Primero positivo Segundo Positivo

					;PNSP -> Primero negativo Segundo positivo
					CMP resultadoGrafica[0000], AL
					JB PPSGP ; Primero pequeño Segundo grande

					;Primero grande Segundo pequeño
					;Primero negativo Segundo positivo
					SUB resultadoGrafica[0000], AL
					MOV signoResultado, 0001 ; Resultado negativo
					JMP SALIR

				;Primero pequeño Segundo grande
				;Primero negativo Segundo positivo
				PPSGP:
					SUB AL, resultadoGrafica[0000]
					MOV resultadoGrafica[0000], AL
					MOV signoResultado, 0000 ; Resultado positivo
					JMP SALIR

				PPSP:
					ADD resultadoGrafica[0000], AL
					MOV signoResultado, 0000 ; Resultado positivo
					JMP SALIR


				SEGUNDONEGATIVO:
					CMP signoResultado, 0000
					JE PPSN

					;Primero negativo, Segundo negativo
					ADD resultadoGrafica[0000], AL
					MOV signoResultado, 0001 ; Resultado negativo
					JMP SALIR

				PPSN:
					CMP resultadoGrafica[0000], AL
					JB PPSGN

					SUB resultadoGrafica[0000], AL
					MOV signoResultado, 0000 ; Resultado positivo
					JMP SALIR

				PPSGN:
					SUB AL, resultadoGrafica[0000]
					MOV resultadoGrafica[0000], AL
					MOV signoResultado, 0001 ; Resultado negativo
					JMP SALIR

				SALIR:
					CMP resultadoGrafica[0000], 0062H
					JA SALIR2
					CMP AX, 0062H
					RET

				SALIR2:
					RET
			INTEGRALOPERARC2 ENDP

			INTEGRALOPERARC1 PROC
				;X^1
				XOR AH, AH
				MOV AL, datoCoeficienteIntegral0[0001] ; Coeficiente
				MUL BL ; Dato

				CMP resultadoGrafica[0000], 0062H
				JA SALIR
				CMP datoCoeficienteFuncion0[0000], 002BH ; Coeficiente Positivo
				JE SEGUNDOPOSITIVO ; El coeficiente 1 es positivo
				JMP SEGUNDONEGATIVO

				SEGUNDOPOSITIVO:
					CMP signoEvaluacion, 0001 ; Esta evaluando numeros negativos
					JE D
				S:
					CMP signoResultado, 0000 ; Resultado anterior es positivo
					JE PPSP ; Primero positivo Segundo Positivo

					;PNSP -> Primero negativo Segundo positivo
					CMP resultadoGrafica[0000], AL
					JB PPSGP ; Primero pequeño Segundo grande

					;Primero grande Segundo pequeño
					;Primero negativo Segundo positivo
					SUB resultadoGrafica[0000], AL
					MOV signoResultado, 0001 ; Resultado negativo
					JMP SALIR

				;Primero pequeño Segundo grande
				;Primero negativo Segundo positivo
				PPSGP:
					SUB AL, resultadoGrafica[0000]
					MOV resultadoGrafica[0000], AL
					MOV signoResultado, 0000 ; Resultado positivo
					JMP SALIR

				PPSP:
					ADD resultadoGrafica[0000], AL
					MOV signoResultado, 0000 ; Resultado positivo
					JMP SALIR


				SEGUNDONEGATIVO:
					CMP signoEvaluacion, 0001 ; Esta evaluando numeros negativos
					JE S

				D:
					CMP signoResultado, 0000
					JE PPSN

					;Primero negativo, Segundo negativo
					ADD resultadoGrafica[0000], AL
					MOV signoResultado, 0001 ; Resultado negativo
					JMP SALIR

				PPSN:
					CMP resultadoGrafica[0000], AL
					JB PPSGN

					SUB resultadoGrafica[0000], AL
					MOV signoResultado, 0000 ; Resultado positivo
					JMP SALIR

				PPSGN:
					SUB AL, resultadoGrafica[0000]
					MOV resultadoGrafica[0000], AL
					MOV signoResultado, 0001 ; Resultado negativo
					JMP SALIR

				SALIR:
					CMP resultadoGrafica[0000], 0062H
					JA SALIR2
					CMP AX, 0062H
					RET
					
				SALIR2:
					RET
			INTEGRALOPERARC1 ENDP

			INTEGRALOPERARC0 PROC
				MOV AL, graficarConstanteIntegracion[0001]
				CMP graficarConstanteIntegracion[0000], 002BH
				JE SEGUNDOPOSITIVO
				JMP SEGUNDONEGATIVO

				SEGUNDOPOSITIVO:
					CMP signoResultado, 0000
					JNE PNSP ; Primero negativo
					ADD resultadoGrafica, AL
					MOV signoResultado, 0000 ; Resultado positivo
					JMP SALIR

				PNSP:
					CMP resultadoGrafica, AL
					JB PPSGP
					SUB resultadoGrafica, AL
					MOV signoResultado, 0001 ; Resultado negativo
					JMP SALIR

				PPSGP:
					SUB AL, resultadoGrafica
					MOV resultadoGrafica, AL
					MOV signoResultado, 0000 ; Resultado positivo
					JMP SALIR

				SEGUNDONEGATIVO:
					CMP signoResultado, 0000
					JE PPSN
					ADD resultadoGrafica, AL
					MOV signoResultado, 0001 ; Resultado negativo

				PPSN:
					CMP resultadoGrafica, AL
					JB PPSGN
					SUB resultadoGrafica, AL
					MOV signoResultado, 0000 ; Resultado positivo
					JMP SALIR

				PPSGN:
					SUB AL, resultadoGrafica
					MOV resultadoGrafica, AL
					MOV signoResultado, 0001 ; Resultado negativo
					JMP SALIR

				SALIR:
					CMP resultadoGrafica[0000], 0062H
					RET
			INTEGRALOPERARC0 ENDP

			PROBAROVERF PROC
				CMP CH, 002BH
				JE CAMBIAR
				CMP CH, 002DH
				JE CAMBIAR
				JMP SALIR

				CAMBIAR:
					MOV CH, 0000

				SALIR: 
					RET
			PROBAROVERF ENDP

			DELIMITAR PROC 
				MOV BH, 00
				MOV BL, contadorCaracteres ; Delimita cadena introducida a tama¤o namelen
				MOV calculadoraNombreArchivo[BX],00h ; Termina cadena con 00h para poder renombrar 
				MOV calculadoraNombreArchivo[BX+1],'$' ; Pone delimitador de exhibici¢n de caracteres
				RET
			DELIMITAR ENDP

			PAUSA PROC 
				MOV AH, 00H ; Leer pulsaci¢n
			    INT 16H
			    RET
			PAUSA ENDP

			PROCESAR_COEFICIENTE PROC
				pushear
				CMP datoTextoUsuario[0000], 002BH
				JE SIGNO
				CMP datoTextoUsuario[0000], 002DH
				JE SIGNO
				JMP POSITIVO

				SIGNO:
					CMP datoTextoUsuario[0001], 0030H
					JB ERROR
					CMP datoTextoUsuario[0001], 0039H
					JA ERROR
					CMP datoTextoUsuario[0002], '$'
					JNE ERROR
					MOV datoVerificacionNumero, 0000
					SUB datoTextoUsuario[0001], 0030H
					JMP SALIR

				POSITIVO:
					CMP datoTextoUsuario[0000], 0030H
					JB ERROR
					CMP datoTextoUsuario[0000], 0039H
					JA ERROR
					CMP datoTextoUsuario[0001], '$'
					JNE ERROR
					MOV datoVerificacionNumero, 0000

					MOV AL, datoTextoUsuario[0000]
					MOV datoTextoUsuario[0000], 002BH
					MOV datoTextoUsuario[0001], AL
					SUB datoTextoUsuario[0001], 0030H

					JMP SALIR

				ERROR:
					MOV datoVerificacionNumero, 0001
					JMP SALIR

				SALIR:
					poppear
					RET
			PROCESAR_COEFICIENTE ENDP

			LEER_DATO PROC
				pushear
				XOR SI, SI

				CICLO: 
					MOV datoTextoUsuario[SI], '$'
					INC SI
					CMP SI, 0019
					JLE CICLO

				stringRead datoTextoUsuario
				poppear
				RET
			LEER_DATO ENDP 

			DERIVAR PROC
				pushear
				XOR AH, AH
				MOV AL, 0004 ; Obtenemos el valor del coeficiente
				MUL datoCoeficienteFuncion4[0001] ; Multiplicamos por el exponente de x y se almacena en AL
				MOV datoCoeficienteDerivada3S[0001], AL
				AAM ; Desempaquetamos 
				MOV BX, AX ; Se copia el registro AX en BX
				MOV datoCoeficienteDerivada3[0002], BL
				MOV datoCoeficienteDerivada3[0001], BH
				MOV AL, datoCoeficienteFuncion4[0000]
				MOV datoCoeficienteDerivada3[0000], AL

				XOR AH, AH
				MOV AL, 0003 ; Obtenemos el valor del coeficiente
				MUL datoCoeficienteFuncion3[0001] ; Multiplicamos por el exponente de x y se almacena en AL
				MOV datoCoeficienteDerivada2S[0001], AL
				AAM ; Desempaquetamos 
				MOV BX, AX ; Se copia el registro AX en BX
				MOV datoCoeficienteDerivada2[0002], BL
				MOV datoCoeficienteDerivada2[0001], BH
				MOV AL, datoCoeficienteFuncion3[0000]
				MOV datoCoeficienteDerivada2[0000], AL

				XOR AH, AH
				MOV AL, 0002 ; Obtenemos el valor del coeficiente
				MUL datoCoeficienteFuncion2[0001] ; Multiplicamos por el exponente de x y se almacena en AL
				MOV datoCoeficienteDerivada1S[0001], AL
				AAM ; Desempaquetamos 
				MOV BX, AX ; Se copia el registro AX en BX
				MOV datoCoeficienteDerivada1[0002], BL
				MOV datoCoeficienteDerivada1[0001], BH
				MOV AL, datoCoeficienteFuncion2[0000]
				MOV datoCoeficienteDerivada1[0000], AL

				XOR AH, AH
				MOV AL, datoCoeficienteFuncion1[0001] ; Obtenemos el valor del coeficiente
				MOV datoCoeficienteDerivada0S[0001], AL
				AAM ; Desempaquetamos 
				MOV BX, AX ; Se copia el registro AX en BX
				MOV datoCoeficienteDerivada0[0002], BL
				MOV datoCoeficienteDerivada0[0001], BH
				MOV AL, datoCoeficienteFuncion1[0000]
				MOV datoCoeficienteDerivada0[0000], AL
				poppear
				RET
			DERIVAR ENDP

			INTEGRAR PROC
				pushear
				XOR AX, AX

				print datoCoeficienteFuncion4
				
				MOV BL, 0005 ; Obtenemos el valor del coeficiente
				MOV AL, datoCoeficienteFuncion4[0001] ; Multiplicamos por el exponente de x y se almacena en AL
				DIV BL 
				MOV datoCoeficienteIntegral5[0001], AL
				MOV datoCoeficienteIntegral5[0003], AH 
				;Parte decimal 0003 -> decimal
				MOV AL, 000AH ; 10
				MUL AH ; Multiplica el decimal x 10 -> resultado en AL
				DIV BL
				MOV datoCoeficienteIntegral5[0003], AL 
				MOV AL, datoCoeficienteFuncion4[0000]
				MOV datoCoeficienteIntegral5[0000], AL
				XOR AX, AX


				
				MOV BL, 0004 ; Obtenemos el valor del coeficiente
				MOV AL, datoCoeficienteFuncion3[0001] ; Multiplicamos por el exponente de x y se almacena en AL
				DIV BL 
				MOV datoCoeficienteIntegral4[0001], AL
				MOV datoCoeficienteIntegral4[0003], AH 
				;Parte decimal 0003 -> decimal
				MOV AL, 000AH ; 10
				MUL AH ; Multiplica el decimal x 10 -> resultado en AL
				DIV BL
				MOV datoCoeficienteIntegral4[0003], AL 
				MOV AL, datoCoeficienteFuncion3[0000]
				MOV datoCoeficienteIntegral4[0000], AL
				XOR AX, AX
				


				MOV BL, 0003 ; Obtenemos el valor del coeficiente
				MOV AL, datoCoeficienteFuncion2[0001] ; Multiplicamos por el exponente de x y se almacena en AL
				DIV BL 
				MOV datoCoeficienteIntegral3[0001], AL
				MOV datoCoeficienteIntegral3[0003], AH 
				;Parte decimal 0003 -> decimal
				MOV AL, 000AH ; 10
				MUL AH ; Multiplica el decimal x 10 -> resultado en AL
				DIV BL
				MOV datoCoeficienteIntegral3[0003], AL 
				MOV AL, datoCoeficienteFuncion2[0000]
				MOV datoCoeficienteIntegral3[0000], AL
				XOR AX, AX
				
				MOV BL, 0002 ; Obtenemos el valor del coeficiente
				MOV AL, datoCoeficienteFuncion1[0001] ; Multiplicamos por el exponente de x y se almacena en AL
				DIV BL 
				MOV datoCoeficienteIntegral2[0001], AL
				MOV datoCoeficienteIntegral2[0003], AH 
				;Parte decimal 0003 -> decimal
				MOV AL, 000AH ; 10
				MUL AH ; Multiplica el decimal x 10 -> resultado en AL
				DIV BL
				MOV datoCoeficienteIntegral2[0003], AL 
				MOV AL, datoCoeficienteFuncion1[0000]
				MOV datoCoeficienteIntegral2[0000], AL
				XOR AX, AX

				MOV BL, datoCoeficienteFuncion0[0001]
				MOV datoCoeficienteIntegral1[0001], BL
				MOV AL, datoCoeficienteFuncion0[0000]
				MOV datoCoeficienteIntegral1[0000], AL

				poppear
				RET
			INTEGRAR ENDP
		;===================
		;==PROCEDIMIENTOS===
		;===================
		
	main  ENDP

END	main
