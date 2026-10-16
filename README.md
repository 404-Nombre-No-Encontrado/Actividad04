# Actividad04

Reporte de Práctica: Simulación y Validación Arquitectónica del Módulo RORO Supreme.

Maestro: Jorge Ernesto López Arce Delgado.
Equipo: 404: Nombre No Encontrado. 
Integrantes del equipo: -Barajas Valencia Alejandro Jesús. 
                        -Camarillo Amaua Juan Pablo. 
                        -Ramirez Ruíz Misssael Salvador. 
                                      
Introducción
El diseño y validación de microprocesadores y sistemas digitales complejos requieren metodologías rigurosas de simulación antes de su implementación física en silicio o en arreglos de compuertas programables (FPGA). En esta práctica, nuestro equipo abordó la simulación de una arquitectura digital basada en los principios fundamentales de la arquitectura MIPS (Microprocessor without Interlocked Pipeline Stages). El marco teórico de nuestro trabajo se sustenta en la descripción de hardware mediante el lenguaje Verilog, utilizando herramientas de simulación de grado industrial como ModelSim.

A nivel conceptual, la arquitectura de procesadores ha evolucionado desde el modelo de Von Neumann, donde datos e instrucciones comparten el mismo bus de memoria, hacia la arquitectura Harvard, la cual separa físicamente la memoria de datos y la memoria de instrucciones para mejorar el rendimiento. Nuestro módulo principal, denominado "RORO Supreme", se inspira en esta separación, instanciando diferentes Memorias de Solo Lectura (ROM) para proveer instrucciones y operandos de forma simultánea.

Un aspecto matemático y lógico fundamental en esta simulación es el tratamiento de números con signo. Las unidades aritmético-lógicas (ALU) en arquitecturas modernas utilizan el sistema de "complemento a dos" para representar números negativos y ejecutar restas mediante sumas lógicas. Adicionalmente, analizamos el comportamiento de las banderas de estado del procesador, específicamente la bandera de cero (Zero Flag o ZF). Esta señal es crítica en el diseño de procesadores, ya que permite la toma de decisiones algorítmicas (saltos condicionales o branching) cuando el resultado de una operación lógica o aritmética es exactamente nulo.

Objetivo
Objetivo General:
Desarrollar, parametrizar y simular exhaustivamente el módulo "RORO Supreme", logrando la integración exitosa de memorias ROM de datos y una ALU tipo MIPS, para comprobar el correcto flujo de información, la ejecución de instrucciones predefinidas y la validación de los resultados mediante un entorno de pruebas automatizado (Testbench).
Objetivos Particulares:
Modificar y adaptar la estructura original de los módulos RORO y ROM para que adquieran la capacidad de recibir parámetros estáticos (FILE, FILE_A, FILE_B), permitiendo la carga dinámica de vectores de prueba desde múltiples archivos de texto (.txt) sin alterar la lógica central.
Interconectar el módulo de control de instrucciones (ROM_Instrucciones) con el núcleo de procesamiento de datos, asegurando la sincronía en el envío de operandos hacia la MIPSALU.
Evaluar un set de 16 instrucciones continuas y comprobar matemáticamente que el diseño maneje correctamente desbordamientos aparentes (números negativos en complemento a dos) y levante la bandera de cero (ZF) cuando corresponda.
Alcances y Limitaciones:
El alcance de este proyecto abarca exclusivamente la etapa de diseño de Transferencia de Registros (RTL) y la simulación funcional del circuito en software. Como limitación, el proyecto actual carece de un Program Counter (PC) autónomo real (siendo emulado por el banco de pruebas) y no contempla por el momento la síntesis física en una tarjeta de desarrollo, limitándose a verificar la consistencia lógica de la ruta de datos.

Desarrollo y Metodología
El desarrollo de esta actividad se llevó a cabo de manera metódica, dividiendo el trabajo en etapas de diseño, adaptación de módulos y depuración (debugging). Como equipo de trabajo, comenzamos analizando el código base proporcionado, compuesto por los módulos de las memorias y la ALU.
Estructura del Diseño:
Implementamos una arquitectura jerárquica encabezada por el módulo RORO_Supreme. Dentro de este, instanciamos dos componentes principales:

ROM_Instrucciones: Encargado de leer el archivo instrucciones.txt y proporcionar el código de operación de 12 bits para cada ciclo.
Núcleo RORO: Este submódulo empaqueta la lógica de procesamiento. En su interior, declaramos dos memorias ROM adicionales (Roma y Romina) que sirven como los bancos de registros temporales para los operandos A y B, y finalmente instanciamos la MIPSALU que ejecuta la operación indicada por los bits de control.




Parametrización y Lectura de Archivos:
El mayor reto técnico que enfrentamos durante la fase de desarrollo fue la inicialización correcta de las memorias. La guía de la práctica requería el uso de archivos de texto distintos (ROMa_init.txt y ROMina_init.txt) para cada memoria de datos. Para lograr esto sin duplicar módulos de código de manera ineficiente, procedimos a parametrizar el módulo ROM. Usamos la sintaxis de Verilog parameter FILE para que, al instanciar el componente, pudiéramos sobrescribir dinámicamente qué archivo leer usando el comando de sistema readmemb.

Esto requirió a su vez que el módulo padre (RORO) también fuera adaptado para aceptar parámetros desde la capa superior (RORO_Supreme), creando una "cadena de parámetros". Durante esta fase enfrentamos persistentes errores de compilación (vsim-3584) en ModelSim, dado que la herramienta mantenía en memoria caché las versiones antiguas de nuestros archivos no parametrizados. Logramos solucionarlo mediante una limpieza profunda de la librería de trabajo y recompilando todo desde cero.
Entorno de Simulación y Validación:
Para verificar nuestro sistema, utilizamos el entorno RORO_Supreme_tb. Este testbench funciona inyectando las direcciones de memoria del 0 al 15 y compara en tiempo real el bus de salida de 32 bits (DD) y la bandera de cero (ZF) contra los valores ideales pre-calculados.

A continuación, documentamos visualmente nuestra demostración de funcionalidad:
<img width="429" height="325" alt="1" src="https://github.com/user-attachments/assets/2fc800c2-6a9f-4965-8499-87dcb036199a" />

(Vista completa de la consola Transcript de ModelSim).
Nuestra simulación fue totalmente exitosa y libre de errores funcionales. Las señales lógicas internas fluyeron correctamente de las memorias a la ALU.
<img width="1132" height="365" alt="2" src="https://github.com/user-attachments/assets/115bf4a0-a942-44dd-a321-0d5e5294dc06" />

(Gráfica general Wave con Zoom Full).
Para ahondar en el rigor técnico de la simulación, analizamos matemáticamente dos instantes específicos que prueban la robustez de la MIPSALU:
Análisis de Resta Negativa (Complemento a Dos):
Al llegar al ciclo de la instrucción 9, el testbench ordenó una resta cuyos operandos daban como resultado -41 (9 - 50).

<img width="412" height="375" alt="3" src="https://github.com/user-attachments/assets/b38d0848-33d1-46d4-84d4-205bec17916b" />

(Acercamiento a la gráfica en la dirección 9, donde se observe el valor -41 o 4294967255 en la salida DD).
Como equipo, validamos que el procesador no colapsa ante valores subcero. En su lugar, debido al límite arquitectónico de 32 bits, la ALU envuelve el valor aplicando el complemento a dos. El sistema interpretó el -41 correctamente, coincidiendo nuestra salida simulada con el valor gigante positivo (4294967255) predicho por la teoría computacional, o su equivalente decimal con signo.
Análisis de la Bandera Zero Flag (ZF):
<img width="371" height="309" alt="Captura de pantalla 2026-10-15 223405" src="https://github.com/user-attachments/assets/974221ed-4085-4590-ae24-8d737b313af3" />

(Acercamiento a la gráfica, mostrando el resultado DD en 0 y el pulso de la señal ZF en 1).
Durante las instrucciones que producen un resultado neto de cero en el bus de datos (como restas de operandos idénticos), monitoreamos el comportamiento del registro de la bandera ZF. Constatamos gráficamente cómo, exactamente en el ciclo de reloj donde DD asume el valor 0, la compuerta lógica interna de la MIPSALU dispara la señal ZF hacia un nivel alto (1 lógico), cumpliendo perfectamente con la especificación de diseño de la arquitectura MIPS.
Conclusión
Como equipo de desarrollo, concluimos que la implementación y simulación de hardware a nivel de Transferencia de Registros (RTL) requiere no solo habilidades de codificación, sino también una profunda comprensión del entorno de simulación. La práctica demostró ser un desafío enriquecedor; inicialmente invertimos bastante tiempo lidiando con los problemas de dependencias, las jerarquías de archivos y los archivos residuales (caché) en la librería work de ModelSim, lo cual causaba frustración al no ver reflejados nuestros cambios de código en las pruebas.
No obstante, una vez dominado el flujo de compilación y limpieza de la herramienta, logramos nuestro objetivo satisfactoriamente. Aprendimos de forma práctica la enorme importancia que tiene la parametrización de módulos en Verilog, lo cual nos permitió diseñar código reutilizable, modular y elegante sin violar la funcionalidad del diseño original. Finalmente, ver nuestras pruebas arrojar cero fallos en la consola y presenciar el comportamiento del complemento a dos de forma gráfica solidificó nuestra comprensión teórica sobre cómo la aritmética computacional se materializa físicamente en las compuertas lógicas de un procesador y cómo se manejan a nivel de hardware.
Referencias
Mano, M. M., & Kime, C. R. (2004). Logic and Computer Design Fundamentals (3rd ed.). Prentice Hall.
Patterson, D. A., & Hennessy, J. L. (2013). Computer Organization and Design: The Hardware/Software Interface (5th ed.). Morgan Kaufmann.
Palnitkar, S. (2003). Verilog HDL: A Guide to Digital Design and Synthesis (2nd ed.). Prentice Hall Professional Technical Reference.
Brown, S., & Vranesic, Z. (2008). Fundamentals of Digital Logic with Verilog Design (2nd ed.). McGraw-Hill Education.
