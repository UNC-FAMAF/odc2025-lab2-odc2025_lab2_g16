	.equ SCREEN_WIDTH, 		640
	.equ SCREEN_HEIGH, 		480
	.equ BITS_PER_PIXEL,  	32
  
	.equ GPIO_BASE,      0x3f200000
	.equ GPIO_GPFSEL0,   0x00
	.equ GPIO_GPLEV0,    0x34

  .globl main
  .extern nube_chica


main:
	// x0 contiene la direccion base del framebuffer
 	mov x20, x0	// Guarda la dirección base del framebuffer en x20
	//---------------- CODE HERE ------------------------------------

	movz x10, 0x33, lsl 16
	movk x10, 0x99ff, lsl 00

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

nubeChica:
  movz x10, 0xa0, lsl 16
  movk x10, 0xa0a0, lsl 00
  mov x7, 320
  mov x8, 240

  mul x9, x8, x1        
  add x9, x9, x7        
  lsl x9, x9, 2         
  add x3, x20, x9       
  bl nube_chica

	//---------------------------------------------------------------
	// Infinite Loop

InfLoop:
	b InfLoop
