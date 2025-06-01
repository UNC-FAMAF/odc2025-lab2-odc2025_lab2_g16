  .equ SCREEN_WIDTH, 		640
	.equ SCREEN_HEIGH, 		480
  .equ H_NUBE, 10
  .text
  .global rectangulo
  .global delay
  .global limpiar_fondo
  .global dibujar_nube


rectangulo:
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
    movz x9, 0xff, lsl 16    
delay_loop:
    subs x9, x9, 1
    b.ne delay_loop
    ret

limpiar_fondo:
  movz x10, 0x33, lsl 16    // azul claro
  movk x10, 0x99ff, lsl 0

  mov x0, x20               // base del framebuffer
  mov x1, SCREEN_WIDTH
  mov x2, SCREEN_HEIGH

loop_fondo_y:
  mov x3, x1
loop_fondo_x:
  stur w10, [x0]
  add x0, x0, 4
  subs x3, x3, 1
  bne loop_fondo_x
  subs x2, x2, 1
  bne loop_fondo_y

  ret

dibujar_nube:
  // Color blanco grisáceo para la nube
  movz x10, 0xffff, lsl 16
  movk x10, 0xf0f0, lsl 0
  //mov x30, 4
  // Primer rectángulo (arriba): más corto
  //mov x5, 10      // altura
  //mov x6, 20      // ancho
  //bl rectangulo

  // Segundo rectángulo (abajo): más largo
  //add x4, x4, 10  // bajamos 10 píxeles (altura del rectángulo de arriba)
  //sub x3, x3, 4   // lo hacemos empezar un poco antes (más ancho)
  //mov x5, 10      // altura
  //mov x6, 28      // ancho
  
  //br delay
  bl rectangulo

  ret
