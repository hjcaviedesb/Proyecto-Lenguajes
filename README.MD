# Taller #2 Lenguajes de programación
Analizador sintáctico-semántico para un lenguaje de lógica proposicional.Por el momento el analizador funciona con proposiciones simples a las cuales hay que definir su valor en un principio. Se esta trabajando para poder generar las tablas de verdad dado el caso en que no se encuentren los valores. 

## Archivos
* logic.l
* logic.y
* Makefile

## Requisitos
- Flex
- Bison
- Compilador C (g++,gcc,etc)

## Instrucciones

Para correr el programa es necesario contar con los requisitos mencionados anteriormente. En la linea de comandos se ejecuta el Makefile con el comando __make__, el ejecutar el comando se compilara el programa y generara el arhchivo binario __logic__, este se puede ejecutar con el comando __./logic__.