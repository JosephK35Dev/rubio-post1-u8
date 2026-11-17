# Post 8 — Operaciones con cadenas y aritmética

**Estudiante:** Rubio  
**Curso:** Arquitectura de Computadores — NASM en DOSBox

Este repositorio reúne los programas de las dos partes del laboratorio, sus fuentes NASM, los ejecutables `.COM`, las evidencias de compilación y ejecución y las decisiones técnicas. Los programas son de 16 bits, se ensamblan como binarios planos con `org 100h` y se ejecutan desde DOSBox.

## Cómo compilar y ejecutar

En DOSBox, desde la carpeta que contiene los archivos:

```dos
NASM -f bin POST1.ASM -o POST1.COM
POST1
```

También se puede ejecutar `BUILD.BAT` para compilar los nueve programas. El archivo `EVID.BAT` compila un programa individual y muestra el `.COM` generado. Al finalizar cada aplicación se pulsa una tecla cuando el programa lo solicita.

## Parte 1 — Cadenas

| Fuente | Propósito | Resultado observado |
|---|---|---|
| `post1.asm` | Copia una cadena con `REP MOVSB`; informa SI, DI, CX y DF. | `HOLA, MUNDO!`, CX=0000 y DF=0. |
| `post1b.asm` | Copia con `MOVSW` y procesa el byte final restante. | Cadena copiada, CX=0000 y DF=0. |
| `post1c.asm` | Busca un carácter con `REPNE SCASB`. | Encuentra `d` en índice 13 y reporta que `z` no aparece. |
| `post1d.asm` | Compara cadenas de longitudes conocidas con `REPE CMPSB`. | Reporta igualdad y primera diferencia en índice 05. |
| `post1e.asm` | Convierte minúsculas a mayúsculas mediante `LODSB`/`STOSB`. | `HOLA, MUNDO!`; DF queda en cero. |

`CLD` fija DF=0 para que los índices de las instrucciones de cadena avancen. `REP MOVSB` usa CX como contador, SI como dirección de origen y DI como destino; `MOVSW` transfiere palabras y requiere tratar por separado un byte sobrante cuando la longitud es impar. `SCASB` compara AL con el byte apuntado por DI y `CMPSB` compara los bytes apuntados por SI y DI. Las capturas `p1-*` documentan compilación y ejecución de cada programa.

### Decisión técnica 1 — REP MOVSB frente a LODSB/STOSB

Para una copia sin cambios, `REP MOVSB` es la opción más eficiente porque el procesador repite la operación de movimiento usando CX como contador y SI y DI como punteros. El programa no necesita ejecutar una instrucción de carga, otra de almacenamiento y un salto condicional por cada byte. Con DF en cero, ambos índices avanzan de menor a mayor dirección y el bloque se copia en el orden esperado. En cambio, `post1e` requiere examinar AL entre la carga y el almacenamiento, comparar si pertenece al rango de letras minúsculas y restar 20h cuando corresponde. `REP MOVSB` no ofrece ese punto para transformar cada byte, por lo que el bucle LODSB/STOSB es necesario aunque ejecute más instrucciones. Para una cadena larga que solo debe duplicarse, se recomienda `REP MOVSB`; se reserva el bucle manual para transformaciones, validaciones u otra lógica por carácter.

### Decisión técnica 2 — Longitud fija y terminador

Una longitud CX fija resulta adecuada cuando el programa conoce de antemano el tamaño de las cadenas, como las ocho posiciones comparadas en `post1d`. Sin embargo, `REPNE SCASB` no interpreta el cero como fin de cadena: si el carácter buscado no aparece y CX sigue positivo, la búsqueda puede continuar por bytes posteriores al terminador. En `REPE CMPSB` hay un matiz: al comparar una cadena de cinco caracteres con otra de ocho, la quinta posición de contenido ya coincide; luego se compara el cero final de la corta con el sexto carácter de la larga y esa diferencia hace que REPE se detenga. No lee necesariamente bytes posteriores al cero en ese caso. Para longitudes desconocidas, un bucle manual debe cargar un byte de cada cadena, detenerse si cualquiera es cero y comparar solo cuando ambos son caracteres. Así se evita depender de memoria adyacente y se distingue igualdad, diferencia y fin de cadena.

## Parte 2 — Aritmética

| Fuente | Propósito | Resultado observado |
|---|---|---|
| `post2.asm` | Suma y resta de 32 bits mediante `ADD/ADC` y `SUB/SBB`. | Suma `0003:0000`; resta `0001:FFFF`. |
| `post2b.asm` | Ajuste decimal empaquetado con `DAA` y `DAS`. | 47+38=85, 99+01=00 con acarreo, 73−28=45 y 20−01=19. |
| `post2c.asm` | Calculadora de un dígito con multiplicación y división. | Probadas 7×8=56, 9÷3=3 y división por cero. |
| `post2d.asm` | Ajuste de suma y resta decimal desempaquetadas con `AAA/AAS`. | 7+8=15 y 13−8=5. |

En la suma de 32 bits, `ADD` calcula la palabra baja y deja el acarreo en CF; `ADC` lo incorpora al sumar la palabra alta. En la resta, `SUB` produce el préstamo que `SBB` resta junto con la siguiente palabra. La calculadora valida el divisor cero antes de dividir. Durante la revisión se corrigió la comprobación de acarreo después de `DAA` para que no se pierda el estado de CF antes de validarlo; también se renombró una etiqueta que NASM interpretaba como el mnemónico POP.

### Decisión técnica 3 — BCD empaquetado y desempaquetado

`DAA` y `DAS` son apropiadas cuando los dos dígitos decimales están empaquetados en un byte, como 47h, donde cada nibble contiene una cifra. `AAA` y `AAS` se usan después de sumar o restar cifras desempaquetadas en AL; ajustan el nibble bajo y, si hay acarreo o préstamo decimal, modifican AH para guardar la decena. Por eso AAA no debe aplicarse a 47h: el nibble alto contiene la cifra 4 y la instrucción lo pone a cero, destruyendo parte del dato. La calculadora transforma caracteres ASCII a cifras desempaquetadas al restar 30h, de modo que una suma directa de 07h y 08h requiere AAA. Si se usara DAA sobre 0Fh, podría producir 15h, que representa dos cifras empaquetadas en un byte y no el formato separado AH:AL esperado por la rutina. La elección depende del formato real de los operandos y del resultado, no solo de que sean cifras decimales.

### Decisión técnica 4 — ADC fijo frente a bucle

La suma de dos números de 32 bits de `post2` usa dos palabras: primero ADD suma las palabras bajas y deja el acarreo en CF; después ADC suma las palabras altas e incorpora ese acarreo. Para N palabras, un algoritmo general guardaría los operandos y el resultado en arreglos, recorrería desde el índice cero —la palabra menos significativa— y avanzaría punteros palabra por palabra. En la primera iteración usaría ADD porque no existe un acarreo anterior; en las siguientes usaría ADC para conservar cada acarreo hacia la palabra de mayor peso. El bucle permite reutilizar la rutina para números de 48, 64 o más bits sin copiar y editar una instrucción por cada tamaño. Esa mantenibilidad y flexibilidad tienen un costo: cada palabra necesita actualizar índices, probar el contador y volver al inicio del ciclo. Para un ancho fijo pequeño, la secuencia desenrollada ADD/ADC suele ser más rápida; para precisión arbitraria, el bucle es más práctico.

## Evidencias

Las imágenes están en `capturas/`. Los nombres `*-compilacion.png` muestran la construcción con NASM y los `*-ejecucion.png` muestran resultados reales en DOSBox.

| Evidencia | Captura |
|---|---|
| Parte 1 — copia REP MOVSB | [compilación](capturas/p1-01-compilacion.png), [ejecución](capturas/p1-01-ejecucion.png) |
| Parte 1 — copia MOVSW | [compilación](capturas/p1-02-compilacion.png), [ejecución](capturas/p1-02-ejecucion.png) |
| Parte 1 — búsqueda SCASB | [compilación](capturas/p1-03-compilacion.png), [ejecución](capturas/p1-03-ejecucion.png) |
| Parte 1 — comparación CMPSB | [compilación](capturas/p1-04-compilacion.png), [ejecución](capturas/p1-04-ejecucion.png) |
| Parte 1 — transformación de cadena | [compilación](capturas/p1-05-compilacion.png), [ejecución](capturas/p1-05-ejecucion.png) |
| Parte 2 — ADC/SBB | [compilación](capturas/p2-01-compilacion.png), [ejecución](capturas/p2-01-ejecucion.png) |
| Parte 2 — DAA/DAS | [compilación](capturas/p2-02-compilacion.png), [ejecución](capturas/p2-02-ejecucion.png) |
| Parte 2 — calculadora | [compilación](capturas/p2-03-compilacion.png), [multiplicación](capturas/p2-03-multiplicacion.png), [división](capturas/p2-03-division.png), [división por cero](capturas/p2-03-div-cero.png) |
| Parte 2 — AAA/AAS | [compilación](capturas/p2-04-compilacion.png), [ejecución](capturas/p2-04-ejecucion.png) |
| Decisiones técnicas | Textos completos en `docs/D1A.TXT`, `docs/D1B.TXT`, `docs/D2A.TXT` y `docs/D2B.TXT`. |

## Archivos

- `post1*.asm` y `post2*.asm`: fuentes de los nueve ejercicios.
- `POST*.COM`: binarios generados para DOSBox.
- `BUILD.BAT`, `EVID.BAT`: compilación total o individual.
- `docs/`: decisiones técnicas completas.
- `capturas/`: evidencia visual.
