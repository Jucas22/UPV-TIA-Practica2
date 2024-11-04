Esta es la práctica 2 de 4º de ingeniería informática de la asignatura de TIA.
El archivo prblema.pddl tiene el caso concreto del enunciado, donde acaban y terminan las cajas, los robots, etc. Mientras que el dominio marca las normas que debe cumplir cada objeto

Para ejecutar la practica hay que tener el LPG.exe descargado y ejecutar el siguiente comando (desde donde tienes el archivo):

./lpg-td.exe -o ..\Practica_2\domain2.pddl -f ..\Practica_2\problema2.pddl -inst_with_contraddicting_objects  -n 1

El enuciado es el siguiente:
Ejercicio. Gestión inteligente de una flota de robots de almacén logístico 

Utilizando técnicas de planificación inteligente, deseamos gestionar y automatizar una flota de robots autónomos en un almacén logístico. La idea es que los 
robots sean autosuficientes para: 1) apilar y desapilar paquetes de las estanterías, 2) transportar paquetes, y 3) controlar las necesidades de carga de su propia batería.  

El sistema a modelar presenta las siguientes características: 

• Nuestro almacén dispone de dos tipos de robots: robots grúa que permiten manipular (apilar y desapilar) paquetes y robots móviles que permiten transportar paquetes de una posición a otra. Los robots grúa se encargan también de cargar y descargar los paquetes en los robots móviles. 

• Los robots grúa están fijos en una determinada posición, mientras que los robots móviles se mueven entre las distintas posiciones del almacén. 

• Un robot, sea del tipo que sea, solo puede manejar un paquete en cada momento. 

• No se permite que haya paquetes por el suelo del almacén: solo pueden estar apilados o manejados por los robots. 

• Todos los robots son eléctricos. Los robots grúa están fijos en una posición, por lo que tienen conexión directa a la alimentación. Sin embargo, los robots móviles funcionan con batería que debe cargarse en unos puntos de recarga establecidos. Por tanto, se deberá planificar cuándo y dónde se debe recargar la batería para que el robot no se quede sin batería. Los puntos de recarga de batería son limitados. Cada punto de recarga solo puede cargar un robot en cada momento. 

• De momento, el sistema está en modo de pruebas, por lo que el número de robots es bastante limitado. Se prevé que este número aumente considerablemente con el tiempo para disponer de un almacén totalmente automatizado. 

(las distancias quedan marcadas en el problema.pddl)

Existen varias acciones a planificar:

• Cada robot grúa dispone de una mesa de trabajo donde se van colocando los paquetes. La grúa puede apilar un paquete1, que se encuentra en la mesa, sobre un paquete2. Para apilar paquetes, hace falta que ambos paquetes estén libres (es decir, no tengan otro paquete encima). De forma inversa, se dispone de la acción desapilar, que desapila un paquete1 que se encuentra encima de un paquete2 (lógicamente, el paquete1 debe estar libre) y lo deja sobre la mesa de trabajo. Después de desapilar, ambos paquetes quedarán libres. Para realizar ambas acciones, hace falta que el robot grúa esté libre.

• Un robot móvil se puede mover entre dos posiciones. Esta acción se realiza de forma autónoma, por lo que el robot se puede mover con o sin paquete. Por simplicidad, la carga de la batería del robot nos proporciona directamente la autonomía del mismo. Es decir, un robot solo puede moverse si la carga restante de su batería es mayor o igual a la distancia entre la posición origen y destino. En caso contrario, no se ejecutará la acción. Evidentemente, al finalizar el movimiento habrá que disminuir la carga de la batería en un valor igual a dicha distancia.

• Se puede cargar un paquete mediante un robot grúa sobre un robot móvil, estando el paquete sobre la mesa de trabajo. Evidentemente, tanto el paquete como los dos robots deberán de estar en la misma posición y todos libres. De forma inversa, disponemos de la acción descargar, que descarga un paquete de un robot móvil y lo deja sobre la mesa de trabajo del robot grúa (lógicamente, el paquete se queda libre sobre la mesa).

• Se puede recargar la batería de un robot móvil en un punto de recarga. Por seguridad, un robot móvil solo se puede recargar cuando no tiene ningún paquete. Actualmente, solo existe un cargador en cada punto de recarga y solo se puede recargar un robot en cada momento. Por simplicidad, la duración de la recarga de un robot es independiente de su nivel actual de carga. Al finalizar la carga de la batería, el robot pasará a estar cargado a su máxima capacidad. 

Las acciones de apilar, desapilar, cargar y descargar tienen una duración de 2 unidades. La duración de la acción de mover se calcula de forma simple, pues consiste en la distancia entre origen y destino divida por la velocidad del robot móvil (cada robot tiene una velocidad distinta). La duración de la recarga también es distinta para cada robot y debe modelarse. 

Desde el punto de vista de optimización, queremos mantener la información sobre el número total de recargas realizadas (“numero-recargas”). De momento, no nos interesa conocer este dato desglosado por robot, sino simplemente el acumulado. Más concretamente, nos interesa minimizar la duración del plan y el número de las recargas utilizando la siguiente métrica para evaluar la calidad:

(:metric minimize (+ (* 0.7 (total-time)) (* 10 (numero-recargas)))) 

(la carga maxima, velocidad de carga, y velocidad viene indicado en problema.pddl)

