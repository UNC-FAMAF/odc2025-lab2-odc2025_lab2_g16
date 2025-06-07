  .equ SCREEN_WIDTH, 		640
	.equ SCREEN_HEIGH, 		480
  .equ H_NUBE, 10
  .text
  .global rectangulo
  .global delay
  .global circulo
//  

//  AJUSTAR DELAY 

//
delay:
    movz x29, 0xff, lsl 16   //cuanto mayor delay, mejor se ve 
delay_loop:
    subs x29, x29, 1
    b.ne delay_loop
    br x30

rectangulo:
  mov x20, x0
  mov x11, x4       // fila actual (Y)
  mov x12, x5       // alto restante
rectangulo_alto_loop:
  cmp x12, 0
  beq fin_rectangulo

  mov x13, x3       // columna actual (X)
  mov x14, x6       // ancho restante

rectangulo_fila_loop:
  mov x15, x11
  mul x15, x15, x1
  add x15, x15, x13
  lsl x15, x15, 2   // multiplicar por 4 (bytes por pixel)
  add x15, x20, x15

  stur w10, [x15]   // pintar pixel

  add x13, x13, 1   // siguiente columna
  sub x14, x14, 1
  cbnz x14, rectangulo_fila_loop

  add x11, x11, 1   // siguiente fila
  sub x12, x12, 1
  b rectangulo_alto_loop

fin_rectangulo:
  br x30

circulo:
/*
valores a asignar:
x3 = centro en X
x4 = centro en Y
x5 = radio
x10 = color
*/
    mov x13, 0              // asignamos y = 0
cicloY:
    cmp x13, x15
    bge finCirculo
 
    mov x15, 0              // asignamos x = 0
cicloX:
    cmp x15, x1
    bge finFila

    sub x11, x15, x3        // x11 = x - centroX
    sub x12, x13, x4        // x12 = y - centroY
    mul x11, x11, x11         // x11²
    mul x12, x12, x12         // x12²
    add x9, x11, x12         // x9 = x3² + x4²

    mul x6, x5, x5       // radio²
    cmp x9, x6
    bgt noPintar

    			  // offset = (y * width + x) * 4
    mul x7, x13, x1       // x7 = y * 640
    add x7, x7, x15
    lsl x7, x7, 2         // *4
    add x8, x0, x7       // dirección del pixel

    stur w10, [x8]         // pinta pixel

noPintar:
    add x15, x15, 1
    b cicloX

finFila:
    add x13, x13, 1
    b cicloY

finCirculo:
  br x30
