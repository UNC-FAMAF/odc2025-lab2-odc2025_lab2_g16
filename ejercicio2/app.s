	.equ SCREEN_WIDTH, 		640
	.equ SCREEN_HEIGH, 		480
	.equ BITS_PER_PIXEL,  	32
  
	.equ GPIO_BASE,      0x3f200000
	.equ GPIO_GPFSEL0,   0x00
	.equ GPIO_GPLEV0,    0x34

  .global main


main:
    mov x22, 333 // x auto
    mov x27, 174  // x hojas
    mov x21, 200 // x arbol
    mov x23, 640 // x edificio 1
    mov x24, 320 // x edificio 2
    mov x25, 420 // x rueda1
    mov x26, 340 // x rueda2
    mov x28, 0   //ciclo dia noche

odc: 
    movz x10, 0x00, lsl 16 
    movk x10, 0x9999, lsl 0 // color
    mov x20, x0
    mov x1, SCREEN_WIDTH
    mov x2, SCREEN_HEIGH
    mov x3, 0
    mov x4, 400
    mov x5, 80
    mov x6, 640

    bl rectangulo

    // O   parte afuera
    movk x10, 0x4444, lsl 0
    mov x3, 15
    mov x4, 410
    mov x5, 60
    mov x6, 40
    bl rectangulo
    // parte dentro
    movk x10, 0x9999, lsl 0
    mov x3, 27
    mov x4, 430
    mov x5, 20
    mov x6, 15
    bl rectangulo

    // D
    //d pancita 
    movk x10, 0x4444, lsl 0
  
    mov x3, 65
    mov x4, 440
    mov x5, 30
    mov x6, 30
    bl rectangulo
    // parte dentro
    movk x10, 0x9999, lsl 0
    
    mov x3, 74
    mov x4, 450
    mov x5, 10
    mov x6, 10
    bl rectangulo

    // parte arriba d
    movk x10, 0x4444, lsl 0

    mov x3, 85
    mov x4, 410
    mov x5, 30
    mov x6, 10

    bl rectangulo

    // C 
    movk x10, 0x4444, lsl 0
    
    mov x3, 105
    mov x4, 410
    mov x5, 60
    mov x6, 40
    bl rectangulo
      // parte dentro c
    movk x10, 0x9999, lsl 0
    
    mov x3, 115
    mov x4, 425
    mov x5, 30
    mov x6, 40
    bl rectangulo
    
loopMain:
    mov x20, x0
    movz x10, 0x33, lsl 16
    movk x10, 0x99ff, lsl 00
    mov x2, 320
ciclodia:
    cmp x28, 100  //se decide cuanto durara el dia
    bgt ciclonoche

    b loop1
ciclonoche:
    movz x10, 0x29, lsl 16
    movk x10, 0x0090, lsl 00

    cmp x28, 200  //se decide cuanto durara la noche
    ble loop1

    b cicloreset
cicloreset:
    mov x28, 0
    b loopMain
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
    mov x4, 300
    mov x5, 80
    mov x6, 640
    movz x10, 0x80, lsl 16 // color
    movk x10, 0xff00, lsl 0
    bl rectangulo

    //mov x5, 179
    //bl rectangulo
    
    // EDIFICIO 
    mov x3, x23
    mov x4, 33 // y edif
    mov x5, 300
    mov x6, 120
    movz x10, 0xa0, lsl 16
    movk x10, 0xa0a0, lsl 0
    bl rectangulo

    // VENTANAS EDIFICIO
    add x3, x23, 10
    add x4, x4, 10
    mov x5, 230
    mov x6, 100
    movz x10, 0x00, lsl 16
    movk x10, 0xb4ff, lsl 00
    bl rectangulo

    add x3, x23, 50
    mov x5, 230
    mov x6, 20
    movz x10, 0xa0, lsl 16
    movk x10, 0xa0a0, lsl 0
    bl rectangulo

    add x3, x23, 10
    add x4, x4, 30
    mov x5, 10
    mov x6, 100
    bl rectangulo

    add x4, x4, 40
    bl rectangulo

    add x4, x4, 40
    bl rectangulo

    add x4, x4, 40
    bl rectangulo

    add x4, x4, 40
    bl rectangulo

    // EDIFICIO 2
    mov x3, x24
    mov x4, 132 // y edif
    mov x5, 200
    mov x6, 100
    bl rectangulo

    // VENTANAS EDIFICIO 2
    add x3, x24, 10
    add x4, x4, 10
    mov x5, 150
    mov x6, 80
    movz x10, 0x00, lsl 16
    movk x10, 0xb4ff, lsl 00
    bl rectangulo

    add x3, x24, 40
    mov x6, 20
    movz x10, 0xa0, lsl 16
    movk x10, 0xa0a0, lsl 0
    bl rectangulo

    add x3, x24, 10
    add x4, x4, 30
    mov x5, 10
    mov x6, 80
    bl rectangulo

    add x4, x4, 40
    bl rectangulo

    add x4, x4, 40
    bl rectangulo

    // ------------ AUTO ROSA ------------
    mov x3, x22  
    mov x4, 299 // y AUTO
    mov x5, 35 //alt 
    mov x6, 120 // ancho
 
    movz x10, 0xff, lsl 16 // color
    movk x10, 0x66ff, lsl 0 // color
    bl rectangulo

    // ----------- RUEDAS --------------
    add x3, x25, 10
    mov x4, 330 // y rueda1
    mov x5, 15 // alto
    //mov x6, 25 // ancho
    movz x10, 0x00, lsl 16 // color
    movk x10, 0x0000, lsl 0 // color
    bl circulo

    // rueda2
    add x3, x26, 15
    mov x4, 330 // y rueda1
    mov x5, 15 // alto
    //mov x6, 25 // ancho
    bl circulo

    // ------------ ARBOL ------------
    mov x3, x21       
    mov x4, 300 // y arbol
    mov x5, 80 // alt
    mov x6, 10 // ancho
    movz x10, 0x99, lsl 16
    movk x10, 0x4c00, lsl 0
    bl rectangulo

    // ------------ Hojas ------------
    mov x3, x27       
    mov x4, 255 // y arbol
    mov x5, 70 // alt
    mov x6, 70 // ancho
    movz x10, 0x01, lsl 16
    movk x10, 0x6815, lsl 0
    bl rectangulo

    bl delay //delay

    
    sub x21, x21, 1   // cambiar posicion arbol
    add x22, x22, 4   // " " " auto
    sub x23, x23, 1   // "" "" edificio1
    sub x24, x24, 1   // edif 2
    add x25, x25, 4   // avanzan rueda1
    add x26, x26, 4   // ""     rueda2
    sub x27, x27, 1   // "" hojas
    


    cmp x23, 0 // reset si edificio1 llega a 0
    bgt fin_edificio1
    mov x23, SCREEN_WIDTH
fin_edificio1:
    
    cmp x24, 0
    bgt fin_edificio2
    mov x24, SCREEN_WIDTH
fin_edificio2:
    
    cmp x21, SCREEN_WIDTH // reset si llegan al final
    blt fin_arbol
    mov x21, 0
fin_arbol:

    cmp x22, SCREEN_WIDTH
    blt fin_rueda1
    mov x22, 0
fin_rueda1:
    cmp x25, SCREEN_WIDTH
    blt fin_rueda2
    mov x25, 0
fin_rueda2:
    cmp x26, SCREEN_WIDTH
    blt fin_auto
    mov x26, 0
fin_auto:
    add x28, x28, 1

    b loopMain
    
