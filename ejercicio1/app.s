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

	movz x10, 0x00, lsl 16
	movk x10, 0x0099, lsl 00

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

/* parametros, x12 alto, x14 ancho, x13 pixel x, x11 pixel y*/
dibujar_rectangulo:
  mov x1, SCREEN_WIDTH //en x1 esta SCREEN_WIDTH
  movz x10, 0xffff, lsl 16 // color
  movk x10, 0x3399, lsl 00 // color
  
  mov x11, 0 // aqui va el pixel y inicial
  mov x12, 200 // alto deseado

rect_y_loop:
  cmp x12, 0
  beq fin_rect

  mov x13, 320 // aqui va el pixel x inicial
  mov x14, 50 // ancho deseado 

rect_x_loop:
  // offset = ((x * SCREEN_W)+x) * 4
  mov x15, x11
  mul x15, x15, x1
  add x15, x15, x13

  lsl x15, x15, 2

  add x15, x20, x15
  stur w10, [x15]

  add x13, x13, 1
  sub x14, x14, 1
  cbnz x14, rect_x_loop

  add x11, x11, 1
  sub x12, x12, 1
  b rect_y_loop

fin_rect:

// INTENTO DE CIRCULO (QUIZAS SIRVA PARA TRIANGULO)
/*
dibujarCirculo:
  movz x10, 0xff80, lsl 16
  movk x10, 0xff00, lsl 00 // color verde

  // Framebuffer: x20
  mov x1, SCREEN_WIDTH// SCREEN_W: x1, SCREEN_H: x2

  mov x11, 300        // Y inicial
  mov x12, 50        // Diámetro
  mov x13, 310        // X inicial izquierda
  mov x14, 330        // X inicial derecha
  mov x15, 1          // Delta expansión
  mov x16, 0          // Iterador vertical
  
  lsr x19, x12, 1     // radio = diam / 2

linea_circulo:
  // x21 = ax actual (izquierda)
  // x22 = bx actual (derecha)
  sub x21, x13, x16, lsl #2  // x21 = x13 - 4*i
  add x22, x14, x16, lsl #2  // x22 = x14 + 4*i

  // Calcular dirección de inicio (x21, y)
  mov x5, x11
  mul x5, x5, x1
  add x5, x5, x21
  lsl x5, x5, 2
  add x17, x20, x5

  // Calcular dirección de fin (x22, y)
  mov x6, x11
  mul x6, x6, x1
  add x6, x6, x22
  lsl x6, x6, 2
  add x18, x20, x6

pintar_linea:
  cmp x17, x18
  bge siguiente_linea
  stur w10, [x17]
  add x17, x17, 4
  b pintar_linea

siguiente_linea:
  cmp x16, x19
  beq fin_circulo

  add x11, x11, 1     // bajar una línea
  add x16, x16, 1     // i++

  b linea_circulo

fin_circulo:
*/



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

	//---------------------------------------------------------------
	// Infinite Loop

InfLoop:
	b InfLoop
