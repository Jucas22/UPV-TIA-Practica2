# Práctica 2 - TIA (4º Ingeniería Informática)

Esta es la práctica 2 de 4º de Ingeniería Informática de la asignatura de **TIA**. 

El archivo `problema.pddl` contiene el caso concreto del enunciado, donde se especifica la disposición inicial y final de las cajas, los robots, etc. Por otro lado, el archivo de dominio define las normas y restricciones que debe cumplir cada objeto.

---

## Ejecución de la Práctica

Para ejecutar la práctica, es necesario tener el archivo `lpg-td.exe` descargado. El comando a utilizar (desde la ubicación donde se encuentra el archivo ejecutable) es el siguiente:

```bash
./lpg-td.exe -o ..\Practica_2\domain2.pddl -f ..\Practica_2\problema2.pddl -inst_with_contraddicting_objects -n 1
```

# Gestión inteligente de una flota de robots de almacén logístico

## Enunciado
Utilizando técnicas de planificación inteligente, el objetivo es gestionar y automatizar una flota de robots autónomos en un almacén logístico. Los robots deben ser autosuficientes para realizar las siguientes tareas:

- Apilar y desapilar paquetes de las estanterías.
- Transportar paquetes.
- Controlar las necesidades de carga de su propia batería.

## Características del sistema

### Tipos de robots

- **Robots grúa**: Manipulan paquetes (apilan y desapilan) y cargan/descargan paquetes en los robots móviles. Son fijos y están conectados a una fuente de alimentación.
- **Robots móviles**: Transportan paquetes entre posiciones y funcionan con batería que debe recargarse en puntos específicos.

### Restricciones de manipulación

- Un robot (de cualquier tipo) solo puede manejar un paquete a la vez.
- No se permite que haya paquetes en el suelo; solo pueden estar apilados o manipulados por un robot.

### Carga de batería

- Los robots móviles necesitan recargarse en puntos limitados que solo pueden cargar un robot a la vez.
- Un robot móvil debe estar sin paquetes para recargarse.

### Modo de pruebas

Actualmente, el número de robots es limitado, pero se espera que aumente en el futuro para automatizar completamente el almacén.

### Distancias

- Especificadas en el archivo `problema.pddl`.

## Acciones a planificar

### Acciones con robots grúa

1. **Apilar**: Un robot grúa coloca un paquete `paquete1` sobre otro paquete `paquete2` en la mesa de trabajo. Ambos paquetes deben estar libres.
2. **Desapilar**: Un robot grúa retira un paquete `paquete1` de encima de otro paquete `paquete2` y lo coloca sobre la mesa de trabajo. Ambos paquetes quedan libres después de esta acción.

### Acciones con robots móviles

1. **Moverse**: Un robot móvil se desplaza entre dos posiciones con o sin paquete. Solo puede moverse si la carga de su batería es suficiente para cubrir la distancia entre origen y destino. La carga disminuye proporcionalmente a la distancia recorrida.
2. **Cargar/descargar paquetes**
   - **Cargar**: Un robot grúa coloca un paquete de la mesa de trabajo sobre un robot móvil. Todos los objetos involucrados deben estar libres y en la misma posición.
   - **Descargar**: Un robot móvil deja un paquete en la mesa de trabajo de un robot grúa. El paquete queda libre tras esta acción.
3. **Recargar batería**: Un robot móvil se recarga en un punto específico. Esto solo puede realizarse cuando no lleva paquetes y el cargador está disponible. La recarga lleva un tiempo determinado e independiente del nivel inicial de la batería.

## Duración de las acciones

- **Apilar/desapilar/cargar/descargar**: 2 unidades de tiempo.
- **Mover**: La duración es la distancia entre origen y destino dividida por la velocidad del robot.
- **Recargar batería**: Varía según el robot y debe ser modelada.

## Optimización del plan

Queremos minimizar:

- La duración total del plan.
- El número total de recargas realizadas.

### Métrica para evaluar la calidad del plan

```lisp
(:metric minimize (+ (* 0.7 (total-time)) (* 10 (numero-recargas))))
```

### Nota
La carga máxima, velocidad de carga y velocidad de movimiento de los robots están especificadas en el archivo `problema.pddl`.
