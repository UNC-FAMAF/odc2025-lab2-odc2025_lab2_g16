  .equ SCREEN_WIDTH, 		640
	.equ SCREEN_HEIGH, 		480
  .equ BLUE, 0x3399FF
  .equ BROWN, 0x663300
  .equ SKIN, 0xffcc99 
  .equ YELLOW, 0xe6b93d
  .equ RED, 0xff0000

  .text
  .global rectangulo
  .global trapecio
  .global luffy
  .global fist


//  RECTANGULO : param: x11 = x , x12 heightR , x13 = y , x14 = widthR
rectangulo:
  mov x1, SCREEN_WIDTH //en x1 esta SCREEN_WIDTH
  
  mov x11, x5 // aqui va el pixel y inicial
  mov x12, x6 // alto deseado

rectangulo_alto_loop:
  cmp x12, 0  // si no hay pixeles de alto por dibujar finalizo
  beq fin_rectangulo

  mov x13, x7 // aqui va el pixel x inicial
  mov x14, x8 // ancho deseado 

rectangulo_fila_loop:
  // direccion = dInicio + 4 * (x+(y*640)) 
  mov x15, x11
  mul x15, x15, x1
  add x15, x15, x13

  lsl x15, x15, 2
  
  //aca se pinta el pixel en la direccion x15
  add x15, x20, x15
  stur w10, [x15]

/* 
delay:
  mov x2, 50000
loopD:
  sub x2, x2, 1
  cmp x2, xzr
  cbnz x2, loopD
*/

  //avanzo un pixel
  add x13, x13, 1
  //resto el pixel hasta llegar al alto deseado (voy bajando desde x14 a 0) 
  sub x14, x14, 1
  // mientras haya pixeles para pintar continuo en la fila 
  cbnz x14, rectangulo_fila_loop
  
  add x11, x11, 1 //bajo una posicion y 
  sub x12, x12, 1 //dibuje un pixel por lo tanto resto el contador
  b rectangulo_alto_loop

fin_rectangulo:
  ret
