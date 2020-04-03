fileReader MACRO
   pushear
   MOV AH, 3DH ; abre el archivo
      MOV AL, 0 ; abre para lectura
      LEA DX, calculadoraRutaOficial
      INT 21H ; interrupcion
      JC ERROR_ABRIR
      MOV [manejadorArchivoCalculadora], AX ; carga el handler

      MOV AH, 3FH ; leer
      LEA DX, calculadoraTextoRecibido ; se almacena en texto
      MOV CX, 1000H ; lee 100 caracteres
      MOV BX, [manejadorArchivoCalculadora] ; recorre buffer
      INT 21H ; interrupcion
      MOV BX, [manejadorArchivoCalculadora]
      MOV AH, 3EH ; cierra el archivo
      INT 21H  ; interrupcion
   poppear
ENDM

operar MACRO
   LOCAL CICLO, SALIR, ASIG, MULT, DIVI, CONTINUAR, VSIG
   pushear
   XOR BX, BX
   ;pilaOperaciones
   CICLO:
      XOR AX, AX
      ;===================Verificacion si las decenas son digito
         CMP calculadoraTextoRecibido[BX], 0030H
         JB VSIG
         CMP calculadoraTextoRecibido[BX], 0039H
         JA VSIG

      ;===================Verificacion si las unidades son digito
         CMP calculadoraTextoRecibido[BX + 1], 0030H
         JB VSIG
         CMP calculadoraTextoRecibido[BX + 1], 0039H
         JA VSIG

      ;TRANSFORMAR NUMERO Y ALMACENAR EN LA PILA
         MOV AL, calculadoraTextoRecibido[BX] ;Digito mas significativo
         MOV AH, calculadoraTextoRecibido[BX + 1] ;Digito menos significativo
         transformarNumeroAlmacenarPila
         ADD BX, 0003

      CMP calculadoraTextoRecibido[BX], 0024H ; Fin de cadena
      JE ERROR_PUNTOCOMA_ANALISIS
      CMP calculadoraTextoRecibido[BX], 003BH ; Punto y coma
      JE SALIR

      ;===================Verificacion si el caracter es un signo valido
      ;-------------------002A -> *
      ;-------------------002B -> +
      ;-------------------002D -> -
      ;-------------------002F -> /
      VSIG:
         CMP calculadoraTextoRecibido[BX], 002BH ; Es suma
         JE ASIG
         CMP calculadoraTextoRecibido[BX], 002DH ; Es resta
         JE ASIG
         CMP calculadoraTextoRecibido[BX], 002FH ; Es division
         JE DIVI
         CMP calculadoraTextoRecibido[BX], 002AH ; Es multiplicacion
         JE MULT
         JMP ERROR_PUNTOCOMA_ANALISIS

      ASIG:
         ;AGREGAR EL OPERADOR A LA LISTA
         MOV AL, calculadoraTextoRecibido[BX]

         push BX
         XOR BX, BX
         MOV BL, indexOperaciones
         MOV AH, 0000
         MOV pilaOperaciones[BX], AX
         INC indexOperaciones
         pop BX

         ADD BX, 0002
         JMP CONTINUAR

      DIVI:
         ADD BX, 0002 ;==Operador 2
            ;===================Verificacion si las decenas son digito
               CMP calculadoraTextoRecibido[BX], 0030H
               JB ERROR_FUNCION_ANALISIS
               CMP calculadoraTextoRecibido[BX], 0039H
               JA ERROR_FUNCION_ANALISIS
   
            ;===================Verificacion si las unidades son digito
               CMP calculadoraTextoRecibido[BX + 1], 0030H
               JB ERROR_FUNCION_ANALISIS
               CMP calculadoraTextoRecibido[BX + 1], 0039H
               JA ERROR_FUNCION_ANALISIS

         ;TRANSFORMAR NUMERO Y ALMACENAR EN BL
            MOV AL, calculadoraTextoRecibido[BX] ;Digito mas significativo
            MOV AH, calculadoraTextoRecibido[BX + 1] ;Digito menos significativo
            transformarDi

         ADD BX, 0003
         JMP CONTINUAR

      MULT:
         ADD BX, 0002 ;==Operador 2
            ;===================Verificacion si las decenas son digito
               CMP calculadoraTextoRecibido[BX], 0030H
               JB ERROR_FUNCION_ANALISIS
               CMP calculadoraTextoRecibido[BX], 0039H
               JA ERROR_FUNCION_ANALISIS
   
            ;===================Verificacion si las unidades son digito
               CMP calculadoraTextoRecibido[BX + 1], 0030H
               JB ERROR_FUNCION_ANALISIS
               CMP calculadoraTextoRecibido[BX + 1], 0039H
               JA ERROR_FUNCION_ANALISIS

         ;TRANSFORMAR NUMERO Y ALMACENAR EN BL
            MOV AL, calculadoraTextoRecibido[BX] ;Digito mas significativo
            MOV AH, calculadoraTextoRecibido[BX + 1] ;Digito menos significativo
            transformarMu

         ADD BX, 0003
         JMP CONTINUAR

      CONTINUAR:
         CMP calculadoraTextoRecibido[BX], 0024H ; Fin de cadena
         JE ERROR_PUNTOCOMA_ANALISIS
         CMP calculadoraTextoRecibido[BX], 003BH ; Punto y coma
         JE SALIR
         JMP CICLO

   SALIR:
      poppear
ENDM

transformarDi MACRO
   LOCAL SALIR
   pushear
   ;=============SI contiene el numero mas significativo
   ;=============SI + 1 contiene el numero menos significativo
   ;=============Los numeros se reciben en ascii. 0 -> 0030H, 1 -> 0031H, ... , 9 -> 0039H
   SUB AL, 0030H ; Nos quedamos con el valor en hexa
   SUB AH, 0030H ; Nos quedamos con el valor en hexa

   MOV numeroMas, AL ; Guardamos los datos de los numeros
   MOV numeroMenos, AH ; Guardamos los datos de los numeros

   MOV BL, numeroMas
   MOV AL, 0010 ; Para operar las decenas                AB          A = 5, B = 3
   MUL BL ; Obtenemos las decenas                        A*10        5*10 = 50
   ADD AL, numeroMenos ; Sumamos las unidades            A*10 + B    50 + 3 = 53

   MOV BL, AL
   MOV BH, 0000
   ;OBTENER EL ULTIMO DATO INGRESADO EN LA PILA
      obtenerUltimoPila
      XOR AH, AH
      XOR DX, DX
      MOV AX, operador1

   CMP BX, 0000
   JE ERROR_DIVISION_CERO

   DIV BX
   reemplazarUltimoPila
   JMP SALIR

   SALIR:
      poppear
ENDM

transformarMu MACRO
   pushear
   ;=============SI contiene el numero mas significativo
   ;=============SI + 1 contiene el numero menos significativo
   ;=============Los numeros se reciben en ascii. 0 -> 0030H, 1 -> 0031H, ... , 9 -> 0039H
   SUB AL, 0030H ; Nos quedamos con el valor en hexa
   SUB AH, 0030H ; Nos quedamos con el valor en hexa

   MOV numeroMas, AL ; Guardamos los datos de los numeros
   MOV numeroMenos, AH ; Guardamos los datos de los numeros

   MOV BL, numeroMas
   MOV AL, 0010 ; Para operar las decenas                AB          A = 5, B = 3
   MUL BL ; Obtenemos las decenas                        A*10        5*10 = 50
   ADD AL, numeroMenos ; Sumamos las unidades            A*10 + B    50 + 3 = 53
   XOR BH, BH
   MOV BL, AL
   ;OBTENER EL ULTIMO DATO INGRESADO EN LA PILA
      obtenerUltimoPila
      XOR AX, AX
      MOV AX, operador1

   MUL BX
   reemplazarUltimoPila
   poppear
ENDM

reemplazarUltimoPila MACRO
   pushear
   ;============AX contiene el resultado de la conversion de los numeros
   XOR BX, BX
   MOV BL, indexOperaciones
   DEC BX
   MOV pilaOperaciones[BX], AX
   poppear
ENDM

obtenerUltimoPila MACRO
   pushear
   XOR BX, BX
   XOR AX, AX
   MOV BL, indexOperaciones
   DEC BX
   MOV AX, pilaOperaciones[BX]
   MOV operador1, AX
   poppear
ENDM

transformarNumeroAlmacenarPila MACRO
   pushear
   ;=============SI contiene el numero mas significativo
   ;=============SI + 1 contiene el numero menos significativo
   ;=============Los numeros se reciben en ascii. 0 -> 0030H, 1 -> 0031H, ... , 9 -> 0039H
   SUB AL, 0030H ; Nos quedamos con el valor en hexa
   SUB AH, 0030H ; Nos quedamos con el valor en hexa

   MOV numeroMas, AL ; Guardamos los datos de los numeros
   MOV numeroMenos, AH ; Guardamos los datos de los numeros

   MOV BL, numeroMas
   MOV AL, 0010 ; Para operar las decenas                AB          A = 5, B = 3
   MUL BL ; Obtenemos las decenas                        A*10        5*10 = 50
   ADD AL, numeroMenos ; Sumamos las unidades            A*10 + B    50 + 3 = 53

   ;============AL contiene el resultado de la conversion de los numeros
   XOR BX, BX
   MOV BL, indexOperaciones
   MOV SI, BX
   XOR AH, AH
   MOV pilaOperaciones[SI], AX
   INC indexOperaciones
   poppear
ENDM

operarPila MACRO
   LOCAL CICLO, SUMA, RESTA, CONTINUAR, SALIR, OVER
   pushear
   XOR BX, BX
   XOR CX, CX
   MOV AX, pilaOperaciones[BX]
   MOV AH, 0000
   MOV resultado, AX
   CICLO:
      MOV CX, pilaOperaciones[BX + 2]
      MOV DX, pilaOperaciones[BX + 1]
      CMP DL, 002BH ; Es suma
      JE SUMA
      CMP DL, 002DH ; Es suma
      JE RESTA
      JMP SALIR

      SUMA:
         CALL PROBAROVERF
         CMP signoResultado, 002DH ; El resultado anterior es negativo
         JE SUMARRESTA
         ; El resultado anterior es positivo -> genera numero positivo
         ADD resultado, CX ; Se guarda el resultado
         MOV signoResultado, 0000
         ADD BX, 0002
         JMP CONTINUAR

      SUMARRESTA:
         CMP CX, resultado ; operador1 < operador2 -> genera numero negativo
         JL OTRO
         ; operador1 > operador2 -> genera numero positivo
         SUB CX, resultado
         MOV resultado, CX
         ADD BX, 0002
         MOV signoResultado, 0000
         JMP CONTINUAR

      OTRO:
         SUB resultado, CX
         ADD BX, 0002
         MOV signoResultado, 002DH
         JMP CONTINUAR
   
      RESTA:
         CALL PROBAROVERF
         CMP signoResultado, 002DH ; El resultado anterior es negativo
         JE RESTASUMA
         ; El resultado anterior es positivo
         CMP resultado, CX
         JL NEGATIVO ; operador2 > operador1 -> genera numero negativo

         ; operador1 > operador 2 -> genera numero positivo
         SUB resultado, CX ; Se guarda el resultado
         ADD BX, 0002
         MOV signoResultado, 0000
         JMP CONTINUAR

      RESTASUMA:
         CALL PROBAROVERF
         ADD resultado, CX
         ADD BX, 0002
         MOV signoResultado, 002DH
         JMP CONTINUAR

      NEGATIVO:
         CALL PROBAROVERF
         SUB CX, resultado ; Se guarda el resultado
         MOV resultado, CX
         MOV signoResultado, 002DH
         ADD BX, 0002
         JMP CONTINUAR

      CONTINUAR:
         MOV DX, pilaOperaciones[BX + 1]
         CMP DL, '$' ; Fin de cadena
         JE SALIR
         JMP CICLO
         

   SALIR:
      poppear
ENDM

convertirNumero MACRO r
   ; resultadoOperacion tiene el resultado del archivo
   pushear
   MOV DX, 0000
   MOV AX, r
   MOV BX, 2710H
   DIV BX
   MOV mostrarRespuesta[0000], AL
   ADD mostrarRespuesta[0000], 0030H

   MOV AX, DX
   XOR DX, DX
   MOV BX, 03E8H
   DIV BX
   MOV mostrarRespuesta[0001], AL
   ADD mostrarRespuesta[0001], 0030H

   MOV AX, DX
   XOR DX, DX
   MOV BX, 0064H
   DIV BX
   MOV mostrarRespuesta[0002], AL
   ADD mostrarRespuesta[0002], 0030H

   MOV AX, DX
   XOR DX, DX
   MOV BX, 000AH
   DIV BX
   MOV mostrarRespuesta[0003], AL
   ADD mostrarRespuesta[0003], 0030H

   MOV AX, DX
   XOR DX, DX
   MOV BX, 0001H
   DIV BX
   MOV mostrarRespuesta[0004], AL
   ADD mostrarRespuesta[0004], 0030H
   poppear
ENDM

reiniciarAnalisis MACRO
   LOCAL CICLO
   PUSH SI
   XOR SI, SI
   CICLO: 
      MOV pilaOperaciones[SI], '$'
      INC SI
      CMP SI, 4096
      JLE CICLO
   MOV signoResultado, 0000
   MOV numeroMas, 0000
   MOV numeroMenos, 0000
   MOV resultadoOperacion[0000], 0000
   MOV operador1, 0000
   MOV mostrarRespuesta[0000], 0000
   MOV mostrarRespuesta[0001], 0000
   MOV mostrarRespuesta[0002], 0000
   MOV mostrarRespuesta[0003], 0000
   MOV mostrarRespuesta[0004], 0000
   MOV resultado[0000], 0000
   POP SI
ENDM
