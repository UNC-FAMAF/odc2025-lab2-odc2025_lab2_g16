	.equ SCREEN_WIDTH, 		640
	.equ SCREEN_HEIGH, 		480
	.equ BITS_PER_PIXEL,  	32
  
	.equ GPIO_BASE,      0x3f200000
	.equ GPIO_GPFSEL0,   0x00
	.equ GPIO_GPLEV0,    0x34

  .globl main
  .extern nube_chica

main:
    mov x22, 333 // x arbol
    mov x21, 23 // x nube
    
loopMain:
    mov x20, x0
    movz x10, 0x33, lsl 16
    movk x10, 0x99ff, lsl 00
    mov x2, SCREEN_HEIGH
loop1:
    mov x1, SCREEN_WIDTH
loop0:
    stur w10,[x20]
    add x20, x20, 4
    sub x1, x1, 1
    cbnz x1, loop0
    sub x2, x2, 1
    cbnz x2, loop1

    // CAMPO VERDE
    // un rectangulo que simula un campo
    mov x1, SCREEN_WIDTH
    mov x2, SCREEN_HEIGH
    mov x3, 0
    mov x4, 319
    mov x5, 179
    mov x6, 640
    movz x10, 0x80, lsl 16 // color
    movk x10, 0xff00, lsl 0
    bl rectangulo

    // ------------ ARBOL ------------
    mov x3, x21       
    mov x4, 300 // y arbol
    mov x5, 80 // alt
    mov x6, 10 // ancho
    movz x10, 0x99, lsl 16
    movk x10, 0x4c00, lsl 0
    bl rectangulo

    // ------------ NUBE ------------
    mov x3, x22       
    mov x4, 299 // y nube
    mov x5, 20 //alt 
    mov x6, 60 // ancho

    movz x10, 0xa0, lsl 16 // color
    movk x10, 0xa0a0, lsl 0 // color
    bl rectangulo

    bl delay //delay

    
    add x21, x21, 1   // cambiar posicion arbol
    add x22, x22, 1   // " " " nube

    
    cmp x21, SCREEN_WIDTH // reset si llegan al final
    blt fin_arbol
    mov x21, 0
fin_arbol:

    cmp x22, SCREEN_WIDTH
    blt fin_nube
    mov x22, 0
fin_nube:

    b loopMain
    
InfLoop:
	b InfLoop
