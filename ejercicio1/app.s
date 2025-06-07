	.equ SCREEN_WIDTH, 		640
	.equ SCREEN_HEIGH, 		480
	.equ BITS_PER_PIXEL,  	32

	.equ GPIO_BASE,      0x3f200000
	.equ GPIO_GPFSEL0,   0x00
	.equ GPIO_GPLEV0,    0x34

	.globl main

main:
	// x0 contiene la direccion base del framebuffer
 	mov x20, x0	// Guarda la dirección base del framebuffer en x20
	//---------------- CODE HERE ------------------------------------

	movz x10, 0x0033, lsl 16
	movk x10, 0x0066, lsl 00

  mov x26, SCREEN_WIDTH

	mov x2, SCREEN_HEIGH         // Y Size
loop1:
	mov x1, SCREEN_WIDTH         // X Size
loop0:
	stur w10,[x0]  // Colorear el pixel N
	add x0,x0,4	   // Siguiente pixel
	sub x1,x1,1	   // Decrementar contador X
	cbnz x1,loop0  // Si no terminó la fila, salto
	sub x2,x2,1	   // Decrementar contador Y
	cbnz x2,loop1  // Si no es la última fila, salto


// DIBUJAR RECTANGULO
dibujar_rectangulo:
  mov x1, 80
  mov x2, 272
  mov x19, 8
  mov x25, 480
  movz x11, 0xffc0, lsl 16
  movk x11, 0xc0c0, lsl 00
  bl rectangulo

	// Ejemplo de uso de gpios
	//mov x9, GPIO_BASE

	// Atención: se utilizan registros w porque la documentación de broadcom
	// indica que los registros que estamos leyendo y escribiendo son de 32 bits

	// Setea gpios 0 - 9 como lectura
	//str wzr, [x9, GPIO_GPFSEL0]

	// Lee el estado de los GPIO 0 - 31
	//ldr w10, [x9, GPIO_GPLEV0]

	// And bit a bit mantiene el resultado del bit 2 en w10
	//and w11, w10, 0b10

	// w11 será 1 si había un 1 en la posición 2 de w10, si no será 0
	// efectivamente, su valor representará si GPIO 2 está activo
	//lsr w11, w11, 1

// -------------------- SOL DEL FONDO //
circulo:
    mov x10, 320     // centroX
    mov x11, 530     // centroY
    mov x12, 250     // Radio

    mov x13, SCREEN_WIDTH  // ancho
    mov x14, SCREEN_HEIGH  // alto
    // color naranja
    movz x15, 0xFC4B, lsl 16
    movk x15, 0x08, lsl 00
    // fin color

    mov x1, 0              // asignamos y = 0
cicloY:
    cmp x1, x14
    bge finCirculo

    mov x2, 0              // asignamos x = 0
cicloX:
    cmp x2, x13
    bge finFila

    sub x3, x2, x10        // x3 = x - centroX
    sub x4, x1, x11        // x4 = y - centroY
    mul x3, x3, x3         // x3²
    mul x4, x4, x4         // x4²
    add x5, x3, x4         // x5 = x3² + x4²

    mul x6, x12, x12       // radio²
    cmp x5, x6
    bgt noPintar

    			  // offset = (y * width + x) * 4
    mul x7, x1, x13       // x7 = y * 4
    add x7, x7, x2
    lsl x7, x7, 2         // *4
    add x8, x20, x7       // dirección del pixel

    str w15, [x8]         // pinta pixel

noPintar:
    add x2, x2, 1
    b cicloX

finFila:
    add x1, x1, 1
    b cicloY

finCirculo:

// ----------------
// * Dibujar ODC 2025 en la pantalla 
// ----------------
// O
dibujar_o:
  mov x1, 140
  mov x2, 385
  mov x19, 75
  mov x25, 40
  movz x11, 0xfc, lsl 16
  movk x11, 0x4b08, lsl 00
  bl rectangulo

  mov x1, 150
  mov x2, 410
  mov x19, 30
  mov x25, 22
  movz x11, 0xfc4b, lsl 16
  movk x11, 0x08, lsl 00
  bl rectangulo
// D
dibujar_d:
  mov x1, 190
  mov x2, 385
  mov x19, 75
  mov x25, 40
  movz x11, 0xfc, lsl 16
  movk x11, 0x4b08, lsl 00
  bl rectangulo

  mov x19, 40
  mov x25, 28
  movz x11, 0xfc4b, lsl 16
  movk x11, 0x08, lsl 00
  bl rectangulo

  mov x1, 200
  mov x2, 435
  mov x19, 15
  mov x25, 18
  bl rectangulo
// C
dibujar_c:
  mov x1, 240
  mov x2, 385
  mov x19, 75
  mov x25, 40
  movz x11, 0xfc, lsl 16
  movk x11, 0x4b08, lsl 00
  bl rectangulo

  mov x1, 255
  mov x2, 400
  mov x19, 45
  mov x25, 25
  movz x11, 0xfc4b, lsl 16
  movk x11, 0x08, lsl 00
  bl rectangulo

//dibujar 2025
primer_2:
  mov x1, 300
  mov x2, 385
  mov x19, 75
  mov x25, 40
  movz x11, 0xfc, lsl 16
  movk x11, 0x4b08, lsl 00
  bl rectangulo

  mov x2, 400
  mov x19, 20
  mov x25, 25
  movz x11, 0xfc4b, lsl 16
  movk x11, 0x08, lsl 00
  bl rectangulo

  mov x1, 315
  mov x2, 430
  bl rectangulo

dibujar_0:
  mov x1, 350
  mov x2, 385
  mov x19, 75
  mov x25, 40
  movz x11, 0xfc, lsl 16
  movk x11, 0x4b08, lsl 00
  bl rectangulo

  mov x1, 360
  mov x2, 395
  mov x19, 55
  mov x25, 20
  movz x11, 0xfc4b, lsl 16
  movk x11, 0x08, lsl 00
  bl rectangulo

segundo_2:
  mov x1, 400
  mov x2, 385
  mov x19, 75
  mov x25, 40
  movz x11, 0xfc, lsl 16
  movk x11, 0x4b08, lsl 00
  bl rectangulo

  mov x2, 400
  mov x19, 20
  mov x25, 25
  movz x11, 0xfc4b, lsl 16
  movk x11, 0x08, lsl 00
  bl rectangulo

  mov x1, 415
  mov x2, 430
  bl rectangulo

dibujar_5:
  mov x1, 450
  mov x2, 385
  mov x19, 75
  mov x25, 40
  movz x11, 0xfc, lsl 16
  movk x11, 0x4b08, lsl 00
  bl rectangulo

  mov x2, 430
  mov x19, 20
  mov x25, 25
  movz x11, 0xfc4b, lsl 16
  movk x11, 0x08, lsl 00
  bl rectangulo

  mov x1, 465
  mov x2, 400
  bl rectangulo


// ----------------
// * FIN : Dibujar ODC 2025 en la pantalla 
// ----------------


//LUNA
    mov x1, SCREEN_WIDTH
    mov x2, SCREEN_HEIGH
    mov x3, 0x0034             // color negro
    mov x4, x20                // puntero actual
Luna1:
    mov x10, 560     // centroX
    mov x11, 80     // centroY
    mov x12, 50     // Radio

    mov x13, SCREEN_WIDTH  // ancho
    mov x14, SCREEN_HEIGH  // alto
    mov x15, 0xFFFFFF    // color

    mov x1, 0     // y = 0
cicloY1:
    cmp x1, x14   // ancho >= alto
    bge finLuna1

    mov x2, 0     // x = 0
cicloX1:
    cmp x2, x13   // comparo x con ancho
    bge finFila1

    sub x3, x2, x10 // dx = x - centroX
    sub x4, x1, x11 // dy = y - centroY
    mul x3, x3, x3 // dx^2
    mul x4, x4, x4 // dy^2
    add x5, x3, x4 // distancia² = dx^2 + dy^2

    mul x6, x12, x12 // radio²
    cmp x5, x6 // distancia² > radio²
    bgt noPintarLuna

    // offset = (y * width + x) * 4
    mul x7, x1, x13
    add x7, x7, x2
    lsl x7, x7, 2         // *4 porque 32 bits por pixel
    add x8, x20, x7       // dirección del pixel

    str w15, [x8]         // pintar pixel (blanco)

noPintarLuna:
    add x2, x2, 1	// x + 1
    b cicloX1

finFila1:
    add x1, x1, 1	// y + 1
    b cicloY1

finLuna1:

Luna2:
    mov x10, 540     // centroX
    mov x11, 95     // centroY
    mov x12, 40     // Radio

    mov x13, SCREEN_WIDTH  // ancho
    mov x14, SCREEN_HEIGH  // alto
    movz x15, 0x33,   lsl 16    // color
    movk x15, 0x0066, lsl 00

    mov x1, 0     // y = 0
cicloY2:
    cmp x1, x14   // ancho >= alto
    bge finLuna2

    mov x2, 0     // x = 0
cicloX2:
    cmp x2, x13
    bge finFila2

    sub x3, x2, x10 // dx = x - centroX
    sub x4, x1, x11 // dy = y - centroY
    mul x3, x3, x3 // dx^2
    mul x4, x4, x4 // dy^2
    add x5, x3, x4 // distancia² = dx^2 + dy^2

    mul x6, x12, x12 // radio²
    cmp x5, x6 // distancia² > radio²
    bgt noPintar2

    // offset = (y * width + x) * 4
    mul x7, x1, x13
    add x7, x7, x2
    lsl x7, x7, 2         // *4 porque 32 bits por pixel
    add x8, x20, x7       // dirección del pixel

    str w15, [x8]         // pintar pixel (blanco)

noPintar2:
    add x2, x2, 1
    b cicloX2

finFila2:
    add x1, x1, 1
    b cicloY2

finLuna2:

seteox5:
    mov x5, 0  //x5 solo es usado para detectar cuantos rombos hay

rombos_balanceados:
    mov x19, 50  //x19 decide el tamaño de los rombos
    movz x10, 0x00,   lsl 16
    movk x10, 0x0000, lsl 00
    movz x11, 0xff,   lsl 16
    movk x11, 0xffff, lsl 00

    mov x1, 120  //posicion en el eje X del primer rombo
    mov x2, 260  //posicion en el eje Y del primer rombo

    cmp x5, 0
    beq seteo_rombo  //si no hay rombos en la imagen crea uno usando las especificaciones anteriores

    mov x10, x11
    movz x11, 0x00,   lsl 16
    movk x11, 0x0000, lsl 00

    mov x1, 520     //movemos el 2do rombo al otro lado de la imagen en el eje X

    cmp x5, 1
    beq seteo_rombo  //si hay 1 rombo en la imagen crea otro con las nuevas especificaciones

InfLoop:
	b InfLoop

//ROMBO
seteo_rombo:
//todoo menos x4 puede cambiarse a conveniencia

/*
memorias temporales utilizadas: x4, x6, x11, x17, x18, x19, x21, x22 y x23 
(x11 es el color utilizado)
(x17 y x18 son SCREEN_WIDTH y SCREEN_HEIGH respectivamente)
*/ 
  	mov x17, SCREEN_WIDTH
  	mov x18, SCREEN_HEIGH
	mov x4, 0     //x4 es usado para decidir que parte del rombo falta
	b rombo
 
rombo:
	add x21, x1, x19  //punto B
	sub x22, x1, x19  //punto A
	sub x23, x18, x2  //preparando eje y para el calculo de direccion
	mul x0, x23, x17
	add x0, x0, x22
	lsl x0, x0, 2
	add x0, x0, x20
	add x4, x4, 1     //pasando al siguiente paso del rombo
	b limite

limite:
	//usando x6 para crear el limite de la fila
	mul x6, x23, x17
	add x6, x6, x21
	lsl x6, x6, 2
	add x6, x6, x20

	//actualizando x0 con los datos actuales de limites (punto a y eje Y)
	mul x0, x23, x17
	add x0, x0, x22
	lsl x0, x0, 2
	add x0, x0, x20

	//decidiendo a que parte del rombo ir
	cmp x4, 1
	beq semirombo1
	cmp x4, 2
	beq semirombo2
 
semirombo1:
	stur w11, [x0]    //cambiar a color de preferencia
	add x0, x0, 4
	cmp x0, x6
	ble semirombo1

	//actualizando datos para los limites
	add x22, x22, 1
	sub x21, x21, 1
	sub x23, x23, 1

	//decidiendo si pasar a la siguiente fila o ir al siguiente paso
	cmp x22, x1
	ble limite
	b rombo
 
semirombo2:
	stur w10, [x0]   //cambiar a color de preferencia
	add x0, x0, 4
	cmp x0, x6
	ble semirombo2

	//actualizando datos para los limites
	add x22, x22, 1
	sub x21, x21, 1
	add x23, x23, 1

	//decidiendo si pasar a la siguiente fila o ir al siguiente paso
	cmp x22, x1
	ble limite
	mov x4, 0   //reseteando x4 para preparar un proximo rombo
    add x5, x5, 1
    b rombos_balanceados

rectangulo:
  mov x21, x1 //X actual
  mov x22, x2 //Y actual
  add x23, x19, x2 //largo
  add x24, x25, x1 //ancho
seteo_direccion:
  mul x0, x22, x26
  add x0, x0, x21
  lsl x0, x0, 2
  add x0, x0, x20
rectangulo_ancho_loop:
    stur w11, [x0]
    add x0, x0, 4
    add x21, x21, 1
    cmp x21, x24
    ble rectangulo_ancho_loop
    mov x21, x1
rectangulo_largo_loop:
  add x22, x22, 1
  cmp x22, x23
  ble seteo_direccion
  br x30
