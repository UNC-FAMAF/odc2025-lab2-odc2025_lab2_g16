  .equ SCREEN_WIDTH, 		640
	.equ SCREEN_HEIGH, 		480
  .equ H_NUBE, 10
  .text
  .global rectangulo
  .global delay


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
  ret

delay:
    movz x29, 0xf, lsl 16    
delay_loop:
    subs x29, x29, 1
    b.ne delay_loop
    ret


