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
/* parametros, x12 alto, x14 ancho, x13 pixel x, x11 pixel y */

dibujar_rectangulo:
  mov x1, SCREEN_WIDTH //en x1 esta SCREEN_WIDTH
  movz x10, 0xffc0, lsl 16 // color
  movk x10, 0xc0c0, lsl 00 // color
  
  mov x11, 273 // aqui va el pixel y inicial
  mov x12, 8 // alto deseado

rectangulo_alto_loop0:
  cmp x12, 0  // si no hay pixeles de alto por dibujar finalizo
  beq fin_rectangulo

  mov x13, 80 // aqui va el pixel x inicial
  mov x14, 480 // ancho deseado 

rectangulo_fila_loop0:
  // direccion = dInicio + 4 * (x+(y*640)) 
  mov x15, x11
  mul x15, x15, x1
  add x15, x15, x13

  lsl x15, x15, 2
  
  //aca se pinta el pixel en la direccion x15
  add x15, x20, x15
  stur w10, [x15]
  
  //avanzo un pixel
  add x13, x13, 1
  //resto el pixel hasta llegar al alto deseado (voy bajando desde x14 a 0) 
  sub x14, x14, 1
  // mientras haya pixeles para pintar continuo en la fila 
  cbnz x14, rectangulo_fila_loop0
  
  add x11, x11, 1 //bajo una posicion y 
  sub x12, x12, 1 //dibuje un pixel por lo tanto resto el contador
  b rectangulo_alto_loop0

fin_rectangulo:

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
	//---------------------------------------------------------------
	// Infinite Loop
 

//LUNA
    mov x1, SCREEN_WIDTH
    mov x2, SCREEN_HEIGH
    mov x3, 0x0034             // color negro
    mov x4, x20                // puntero actual
/*
fondo_loop_y:
    cmp x2, 0   // alto = 0
    beq fondo_fin 

    mov x1, SCREEN_WIDTH   
fondo_loop_x:
    cmp x1, 0   // ancho = 0
    beq siguiente_fila

    str w3, [x4]   
    add x4, x4, 4	// siguiente pixel
    sub x1, x1, 1		
    b fondo_loop_x

siguiente_fila:
    sub x2, x2, 1   // altura -= 1
    b fondo_loop_y

fondo_fin:
    bl Luna1                 // dibujar el círculo
    b InfLoop
*/    
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

// Dibujar 2025

// DIBUJO DEL 0

Cero_contorno:
    mov x10, 325     // centroX
    mov x11, 425     // centroY
    mov x12, 30     // Radio

    mov x13, SCREEN_WIDTH  // ancho
    mov x14, SCREEN_HEIGH  // alto
    movz x15, 0xAA00, lsl 16 // color
    movk x15, 0xFFBB, lsl 00 // color
    
    mov x1, 0     // y = 0
cicloY_01:
    cmp x1, x14   // ancho >= alto
    bge fin_cero_contorno

    mov x2, 0     // x = 0
cicloX_01:
    cmp x2, x13
    bge finFila01

    sub x3, x2, x10 // dx = x - centroX
    sub x4, x1, x11 // dy = y - centroY
    mul x3, x3, x3 // dx^2
    mul x4, x4, x4 // dy^2
    add x5, x3, x4 // distancia² = dx^2 + dy^2

    mul x6, x12, x12 // radio²
    cmp x5, x6 // distancia² > radio²
    bgt noPintar01

    // offset = (y * width + x) * 4
    mul x7, x1, x13
    add x7, x7, x2
    lsl x7, x7, 2         // *4 porque 32 bits por pixel
    add x8, x20, x7       // dirección del pixel

    str w15, [x8]         // pintar pixel (verde claro)

noPintar01:
    add x2, x2, 1
    b cicloX_01

finFila01:
    add x1, x1, 1
    b cicloY_01

fin_cero_contorno:

Cero_interior:
    mov x10, 325     // centroX
    mov x11, 425     // centroY
    mov x12, 20     // Radio

    mov x13, SCREEN_WIDTH  // ancho
    mov x14, SCREEN_HEIGH  // alto
    movz x15, 0xFC4B, lsl 16  //color
    movk x15, 0x08, lsl 00    //color
    
    mov x1, 0     // y = 0
cicloY_02:
    cmp x1, x14   // ancho >= alto
    bge fin_cero_interior

    mov x2, 0     // x = 0
cicloX_02:
    cmp x2, x13
    bge finFila02

    sub x3, x2, x10 // dx = x - centroX
    sub x4, x1, x11 // dy = y - centroY
    mul x3, x3, x3 // dx^2
    mul x4, x4, x4 // dy^2
    add x5, x3, x4 // distancia² = dx^2 + dy^2

    mul x6, x12, x12 // radio²
    cmp x5, x6 // distancia² > radio²
    bgt noPintar02

    // offset = (y * width + x) * 4
    mul x7, x1, x13
    add x7, x7, x2
    lsl x7, x7, 2         // *4 porque 32 bits por pixel
    add x8, x20, x7       // dirección del pixel

    str w15, [x8]         // pintar pixel (verde claro)

noPintar02:
    add x2, x2, 1
    b cicloX_02

finFila02:
    add x1, x1, 1
    b cicloY_02

fin_cero_interior:


/* parametros, x12 alto, x14 ancho, x13 pixel x, x11 pixel y */

// DIBUJO PRIMER 2

primer_2:
  mov x1, SCREEN_WIDTH //en x1 esta SCREEN_WIDTH
  movz x10, 0xAA00, lsl 16 // color
  movk x10, 0xFFBB, lsl 00 // color
  
  mov x11, 390 // aqui va el pixel y inicial
  mov x12, 70 // alto deseado

rectangulo_alto_loop:
  cmp x12, 0  // si no hay pixeles de alto por dibujar finalizo
  beq fin_primer_2

  mov x13, 260 // aqui va el pixel x inicial
  mov x14, 30 // ancho deseado 

rectangulo_fila_loop:
  // direccion = dInicio + 4 * (x+(y*640)) 
  mov x15, x11
  mul x15, x15, x1
  add x15, x15, x13

  lsl x15, x15, 2
  
  //aca se pinta el pixel en la direccion x15
  add x15, x20, x15
  stur w10, [x15]
  
  add x13, x13, 1  //avanzo un pixel
  sub x14, x14, 1 //resto el pixel hasta llegar al alto deseado (voy bajando desde x14 a 0)
  cbnz x14, rectangulo_fila_loop // mientras haya pixeles para pintar continuo en la fila
  
  add x11, x11, 1 //bajo una posicion y 
  sub x12, x12, 1 //dibuje un pixel por lo tanto resto el contador
  b rectangulo_alto_loop

fin_primer_2:

cuadrado_aux_1a:
  mov x1, SCREEN_WIDTH //en x1 esta SCREEN_WIDTH
  movz x10, 0xFC4B, lsl 16   //color
  movk x10, 0x08, lsl 00     //color

  mov x11, 400 // aqui va el pixel y inicial
  mov x12, 20 // alto deseado

cuadrado_1a_alto_loop:
  cmp x12, 0  // si no hay pixeles de alto por dibujar finalizo
  beq fin_cuadrado_aux_1a

  mov x13, 260 // aqui va el pixel x inicial
  mov x14, 20 // ancho deseado 

cuadrado_1a_fila_loop:
  // direccion = dInicio + 4 * (x+(y*640)) 
  mov x15, x11
  mul x15, x15, x1
  add x15, x15, x13

  lsl x15, x15, 2
  
  //aca se pinta el pixel en la direccion x15
  add x15, x20, x15
  stur w10, [x15]
  
  add x13, x13, 1  //avanzo un pixel
  sub x14, x14, 1 //resto el pixel hasta llegar al alto deseado (voy bajando desde x14 a 0)
  cbnz x14, cuadrado_1a_fila_loop // mientras haya pixeles para pintar continuo en la fila
  
  add x11, x11, 1 //bajo una posicion y 
  sub x12, x12, 1 //dibuje un pixel por lo tanto resto el contador
  b cuadrado_1a_alto_loop

fin_cuadrado_aux_1a:

cuadrado_aux_1b:
  mov x1, SCREEN_WIDTH //en x1 esta SCREEN_WIDTH
  movz x10, 0xFC4B, lsl 16   //color
  movk x10, 0x08, lsl 00     //color
  
  mov x11, 430 // aqui va el pixel y inicial
  mov x12, 20 // alto deseado

cuadrado_1b_alto_loop:
  cmp x12, 0  // si no hay pixeles de alto por dibujar finalizo
  beq fin_cuadrado_aux_1b

  mov x13, 270 // aqui va el pixel x inicial
  mov x14, 20 // ancho deseado 

cuadrado_1b_fila_loop:
  // direccion = dInicio + 4 * (x+(y*640)) 
  mov x15, x11
  mul x15, x15, x1
  add x15, x15, x13

  lsl x15, x15, 2
  
  //aca se pinta el pixel en la direccion x15
  add x15, x20, x15
  stur w10, [x15]
  
  add x13, x13, 1  //avanzo un pixel
  sub x14, x14, 1 //resto el pixel hasta llegar al alto deseado (voy bajando desde x14 a 0)
  cbnz x14, cuadrado_1b_fila_loop // mientras haya pixeles para pintar continuo en la fila
  
  add x11, x11, 1 //bajo una posicion y 
  sub x12, x12, 1 //dibuje un pixel por lo tanto resto el contador
  b cuadrado_1b_alto_loop

fin_cuadrado_aux_1b:

// DIBUJO SEGUNDO 2

segundo_2:
  mov x1, SCREEN_WIDTH //en x1 esta SCREEN_WIDTH
  movz x10, 0x0000, lsl 16 // color
  movk x10, 0xFFBB, lsl 00 // color
  
  mov x11, 390 // aqui va el pixel y inicial
  mov x12, 70 // alto deseado

rectangulo_alto_loop2:
  cmp x12, 0  // si no hay pixeles de alto por dibujar finalizo
  beq fin_segundo_2

  mov x13, 360 // aqui va el pixel x inicial
  mov x14, 30 // ancho deseado 

rectangulo_fila_loop2:
  // direccion = dInicio + 4 * (x+(y*640)) 
  mov x15, x11
  mul x15, x15, x1
  add x15, x15, x13

  lsl x15, x15, 2
  
  //aca se pinta el pixel en la direccion x15
  add x15, x20, x15
  stur w10, [x15]
  
  add x13, x13, 1  //avanzo un pixel
  sub x14, x14, 1 //resto el pixel hasta llegar al alto deseado (voy bajando desde x14 a 0)
  cbnz x14, rectangulo_fila_loop2 // mientras haya pixeles para pintar continuo en la fila
  
  add x11, x11, 1 //bajo una posicion y 
  sub x12, x12, 1 //dibuje un pixel por lo tanto resto el contador
  b rectangulo_alto_loop2

fin_segundo_2:

cuadrado_aux_2a:
  mov x1, SCREEN_WIDTH //en x1 esta SCREEN_WIDTH
  movz x10, 0xFC4B, lsl 16   //color
  movk x10, 0x08, lsl 00     //color
  
  mov x11, 400 // aqui va el pixel y inicial
  mov x12, 20 // alto deseado

cuadrado_2a_alto_loop:
  cmp x12, 0  // si no hay pixeles de alto por dibujar finalizo
  beq fin_cuadrado_aux_2a

  mov x13, 360 // aqui va el pixel x inicial
  mov x14, 20 // ancho deseado 

cuadrado_2a_fila_loop:
  // direccion = dInicio + 4 * (x+(y*640)) 
  mov x15, x11
  mul x15, x15, x1
  add x15, x15, x13

  lsl x15, x15, 2
  
  //aca se pinta el pixel en la direccion x15
  add x15, x20, x15
  stur w10, [x15]
  
  add x13, x13, 1  //avanzo un pixel
  sub x14, x14, 1 //resto el pixel hasta llegar al alto deseado (voy bajando desde x14 a 0)
  cbnz x14, cuadrado_2a_fila_loop // mientras haya pixeles para pintar continuo en la fila
  
  add x11, x11, 1 //bajo una posicion y 
  sub x12, x12, 1 //dibuje un pixel por lo tanto resto el contador
  b cuadrado_2a_alto_loop

fin_cuadrado_aux_2a:

cuadrado_aux_2b:
  mov x1, SCREEN_WIDTH //en x1 esta SCREEN_WIDTH
  movz x10, 0xFC4B, lsl 16   //color
  movk x10, 0x08, lsl 00     //color
  
  mov x11, 430 // aqui va el pixel y inicial
  mov x12, 20 // alto deseado

cuadrado_2b_alto_loop:
  cmp x12, 0  // si no hay pixeles de alto por dibujar finalizo
  beq fin_cuadrado_aux_2b

  mov x13, 370 // aqui va el pixel x inicial
  mov x14, 20 // ancho deseado 

cuadrado_2b_fila_loop:
  // direccion = dInicio + 4 * (x+(y*640)) 
  mov x15, x11
  mul x15, x15, x1
  add x15, x15, x13

  lsl x15, x15, 2
  
  //aca se pinta el pixel en la direccion x15
  add x15, x20, x15
  stur w10, [x15]
  
  add x13, x13, 1  //avanzo un pixel
  sub x14, x14, 1 //resto el pixel hasta llegar al alto deseado (voy bajando desde x14 a 0)
  cbnz x14, cuadrado_2b_fila_loop // mientras haya pixeles para pintar continuo en la fila
  
  add x11, x11, 1 //bajo una posicion y 
  sub x12, x12, 1 //dibuje un pixel por lo tanto resto el contador
  b cuadrado_2b_alto_loop

fin_cuadrado_aux_2b:

// DIBUJO DEL 5

dibujo_5:
  mov x1, SCREEN_WIDTH //en x1 esta SCREEN_WIDTH
  movz x10, 0x0000, lsl 16 // color
  movk x10, 0xFFBB, lsl 00 // color
  
  mov x11, 390 // aqui va el pixel y inicial
  mov x12, 70 // alto deseado

rectangulo_alto_loop5:
  cmp x12, 0  // si no hay pixeles de alto por dibujar finalizo
  beq fin_dibujo_5

  mov x13, 400 // aqui va el pixel x inicial
  mov x14, 30 // ancho deseado 

rectangulo_fila_loop5:
  // direccion = dInicio + 4 * (x+(y*640)) 
  mov x15, x11
  mul x15, x15, x1
  add x15, x15, x13

  lsl x15, x15, 2
  
  //aca se pinta el pixel en la direccion x15
  add x15, x20, x15
  stur w10, [x15]
  
  add x13, x13, 1  //avanzo un pixel
  sub x14, x14, 1 //resto el pixel hasta llegar al alto deseado (voy bajando desde x14 a 0)
  cbnz x14, rectangulo_fila_loop5 // mientras haya pixeles para pintar continuo en la fila
  
  add x11, x11, 1 //bajo una posicion y 
  sub x12, x12, 1 //dibuje un pixel por lo tanto resto el contador
  b rectangulo_alto_loop5

fin_dibujo_5:

cuadrado_aux_3a:
  mov x1, SCREEN_WIDTH //en x1 esta SCREEN_WIDTH
  movz x10, 0xFC4B, lsl 16   //color
  movk x10, 0x08, lsl 00     //color
  
  mov x11, 400 // aqui va el pixel y inicial
  mov x12, 20 // alto deseado

cuadrado_3a_alto_loop:
  cmp x12, 0  // si no hay pixeles de alto por dibujar finalizo
  beq fin_cuadrado_aux_3a

  mov x13, 410 // aqui va el pixel x inicial
  mov x14, 20 // ancho deseado 

cuadrado_3a_fila_loop:
  // direccion = dInicio + 4 * (x+(y*640)) 
  mov x15, x11
  mul x15, x15, x1
  add x15, x15, x13

  lsl x15, x15, 2
  
  //aca se pinta el pixel en la direccion x15
  add x15, x20, x15
  stur w10, [x15]
  
  add x13, x13, 1  //avanzo un pixel
  sub x14, x14, 1 //resto el pixel hasta llegar al alto deseado (voy bajando desde x14 a 0)
  cbnz x14, cuadrado_3a_fila_loop // mientras haya pixeles para pintar continuo en la fila
  
  add x11, x11, 1 //bajo una posicion y 
  sub x12, x12, 1 //dibuje un pixel por lo tanto resto el contador
  b cuadrado_3a_alto_loop

fin_cuadrado_aux_3a:

cuadrado_aux_3b:
  mov x1, SCREEN_WIDTH //en x1 esta SCREEN_WIDTH
  movz x10, 0xFC4B, lsl 16   //color
  movk x10, 0x08, lsl 00     //color
  
  mov x11, 430 // aqui va el pixel y inicial
  mov x12, 20 // alto deseado

cuadrado_3b_alto_loop:
  cmp x12, 0  // si no hay pixeles de alto por dibujar finalizo
  beq fin_cuadrado_aux_3b

  mov x13, 400 // aqui va el pixel x inicial
  mov x14, 20 // ancho deseado 

cuadrado_3b_fila_loop:
  // direccion = dInicio + 4 * (x+(y*640)) 
  mov x15, x11
  mul x15, x15, x1
  add x15, x15, x13

  lsl x15, x15, 2
  
  //aca se pinta el pixel en la direccion x15
  add x15, x20, x15
  stur w10, [x15]
  
  add x13, x13, 1  //avanzo un pixel
  sub x14, x14, 1 //resto el pixel hasta llegar al alto deseado (voy bajando desde x14 a 0)
  cbnz x14, cuadrado_3b_fila_loop // mientras haya pixeles para pintar continuo en la fila
  
  add x11, x11, 1 //bajo una posicion y 
  sub x12, x12, 1 //dibuje un pixel por lo tanto resto el contador
  b cuadrado_3b_alto_loop

fin_cuadrado_aux_3b:

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
