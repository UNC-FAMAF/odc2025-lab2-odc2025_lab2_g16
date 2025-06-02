  .equ SCREEN_WIDTH, 		640
	.equ SCREEN_HEIGH, 		480
  .equ H_NUBE, 10
  .text
  .global rectangulo
  .global delay

delay:
    movz x29, 0xaf, lsl 16    
delay_loop:
    subs x29, x29, 1
    b.ne delay_loop
    ret

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

trapecio:

  mov x1, SCREEN_WIDTH// SCREEN_W: x1, SCREEN_H: x2

  mov x11, 300        // Y inicial
  mov x12, 50        // Diámetro
  mov x13, 310        // X inicial izquierda
  mov x14, 330        // X inicial derecha
  mov x15, 1          // Delta expansión
  mov x16, 0          // Iterador vertical
  
  lsr x19, x12, 1     // radio = diam / 2

linea_trapecio:
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
  beq fin_trapecio

  add x11, x11, 1     // bajar una línea
  add x16, x16, 1     // i++

  b linea_trapecio

fin_trapecio:
  ret
