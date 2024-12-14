# Práctica 2 - TIA (4º Ingeniería Informática)

Esta es la práctica 2 de 4º de Ingeniería Informática de la asignatura de **TIA**. 

El archivo `problema.pddl` contiene el caso concreto del enunciado, donde se especifica la disposición inicial y final de las cajas, los robots, etc. Por otro lado, el archivo de dominio define las normas y restricciones que debe cumplir cada objeto.

---

## Ejecución de la Práctica

Para ejecutar la práctica, es necesario tener el archivo `lpg-td.exe` descargado. El comando a utilizar (desde la ubicación donde se encuentra el archivo ejecutable) es el siguiente:

```bash
./lpg-td.exe -o ..\Practica_2\domain2.pddl -f ..\Practica_2\problema2.pddl -inst_with_contraddicting_objects -n 1
