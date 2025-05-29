  .equ SCREEN_WIDTH, 		640
	.equ SCREEN_HEIGH, 		480
  .equ BLUE, 0x3399FF
  .equ BROWN, 0x663300
  .equ SKIN, 0xffcc99 
  .equ YELLOW, 0xe6b93d
  .equ RED, 0xff0000
  .equ GREY, 0xa0a0a0

  .text
  .global nube_chica
/*
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

delay:
  mov x2, 50000
loopD:
  sub x2, x2, 1
  cmp x2, xzr
  cbnz x2, loopD

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
*/

//dada una direccion base dibujo una nube solo necesito la direccion base de donde debe empezar a dibujar
//llamemosle x3
//color x10
nube_chica:
  mov x1, 640
  mov x4, 4 // tamanio parte de arriba nube
  mov x5, 6 // tamanio parte de abajo nube
  stur w10,[x3]
  b nube_chica_arriba

nube_chica_arriba:
  cbz x4, salto_abajo
  stur w10, [x3]
  add x3, x3, 4
  sub x4, x4, 1
  
  b nube_chica_arriba

salto_abajo:
  //actualizar direccion x3
  mov x6, x1 // x6 = SCREEN_W
  lsl x6, x6, 2
  add x3, x3, x6 // a la direccion que tenia ahora apunta al pixel de abajo donde termino la parte de arriba de la nube
  add x3, x3, 8 // me muevo 2 pixeles hacia la derecha

nube_chica_abajo:
  cbz x5, fin_nube_chica
  stur w10, [x3]
  sub x3, x3, 4 //retrocedo un pixel
  sub x5, x5, 1
  
  b nube_chica_abajo

fin_nube_chica:
  ret
