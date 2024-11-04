(define (domain robots2)
    (:requirements :durative-actions :typing :fluents)
    (:types
        rg rm box position table pile - object

    )
    (:predicates
        (robot-at ?r -
            (either rm rg) ?p - position) ;el robot movil está en la posicion x
        (robot-free ?r -
            (either rg rm)) ;el robot no tiene ningun paquete cargado

        (box-at ?b - box ?p - position) ;la caja está en la posición X
        (box-free ?b - box) ;la caja no tiene ninguna caja encima
        (on ?b1 - box ?place -
            (either box rm table pile)) ;la baja x esta encima de la caja y,  o del robot movil Z, o encima de la mesa de la pos A
        (box-on-pile ?b - box)
        (pile-empty ?pile - pile)

        (charging-point ?p - position) ;hay un punto de carga en la posicion
        (charging-point-free ?p - position) ;está libre el punto de carga?

    )
    (:functions
        (time-total)
        (num-recharges)
        (distance ?p1 - position ?p2 - position)
        (battery ?r - rm)
        (battery-max ?r - rm)
        (velocity ?r -rm)
        (recharge-duration ?r -rm)
    )
    (:durative-action stack
        :parameters ( ?r - rg ?b1 ?b2 - box ?pos - position ?table - table)
        :duration (= ?duration 2)
        :condition (and
            ;La caja 1 tiene que estar en la posición de la grua, en la mesa y libre
            (at start (box-at ?b1 ?pos)) (at start (box-free ?b1)) (at start (on ?b1 ?table))
            ;la caja 2 tiene que estar en la posicion de la grua, en la pila y libre
            (at start (box-at ?b2 ?pos)) (at start (box-free ?b2)) (at start (box-on-pile ?b2))
            ;la grua tiene que estar en la posicion y libre
            (at start (robot-at ?r ?pos)) (at start (robot-free ?r))
        )
        :effect (and
            ;cuando empieza el robot grua esta ocupado y cuando termina se libera
            (at start (not (robot-free ?r))) (at end (robot-free ?r))
            ;cuando termina la caja 1 está encima de b2, en la pila y no en la mesa
            (at start (not (on ?b1 ?table))) (at end (on ?b1 ?b2)) (at end (box-on-pile ?b1))
            ;cuando termina la caja 2 ya no está libre
            (at end (not (box-free ?b2)))
            (at end (increase (time-total) 2))
        )
    )

    (:durative-action first-stack
        :parameters ( ?r - rg ?b - box ?p - pile ?pos - position ?table - table)
        :duration (= ?duration 2)
        :condition (and
            ;La caja 1 tiene que estar en la posición de la grua, en la mesa y libre
            (at start (box-at ?b ?pos)) (at start (box-free ?b)) (at start (on ?b ?table))
            ;la pila debe estar vacía
            (at start (pile-empty ?p))
            ;la grua tiene que estar en la posicion y libre
            (at start (robot-at ?r ?pos)) (at start (robot-free ?r))
        )
        :effect (and
            ;cuando empieza el robot grua esta ocupado y cuando termina se libera
            (at start (not (robot-free ?r))) (at end (robot-free ?r))
            ;cuando termina la caja 1 está en la pila
            (at start (not (on ?b ?table))) (at end (on ?b ?p)) (at end (box-on-pile ?b))
            ;cuando termina la pila no está vacía
            (at end (not (pile-empty ?p)))
            (at end (increase (time-total) 2))
        )
    )

    (:durative-action un-stack
        :parameters ( ?r - rg ?b1 ?b2 - box ?pos - position ?table - table)
        :duration (= ?duration 2)
        :condition (and
            ;La caja 1 tiene que estar en la posición de la grua, encima de la caja 2, en la pila y libre
            (at start (box-at ?b1 ?pos)) (at start (box-free ?b1)) (at start (on ?b1 ?b2)) (at start(box-on-pile ?b1))
            ;la caja 2 tiene que estar en la posicion de la grua
            (at start (box-at ?b2 ?pos)) (at start(box-on-pile ?b2))
            ;la grua tiene que estar en la posicion y libre
            (at start (robot-at ?r ?pos)) (at start (robot-free ?r))
        )
        :effect (and
            ;cuando empieza el robot grua esta ocupado y cuando termina se libera
            (at start (not (robot-free ?r))) (at end (robot-free ?r))
            ;cuando termina la caja 1 está en la mesa, y no encima de b2 y no esta en la pila 
            (at start (not (on ?b1 ?b2))) (at end (on ?b1 ?table)) (at end (not (box-on-pile ?b1)))
            ;cuando termina la caja 2 está libre
            (at end (box-free ?b2))
            (at end (increase (time-total) 2))
        )
    )

    (:durative-action last-un-stack
        :parameters ( ?r - rg ?b - box ?p - pile ?pos - position ?table - table)
        :duration (= ?duration 2)
        :condition (and
            ;La caja 1 tiene que estar en la posición de la grua, en la pila y libre
            (at start (box-at ?b ?pos)) (at start (box-free ?b)) (at start (on ?b ?p)) (at start(box-on-pile ?b))
            ;la grua tiene que estar en la posicion y libre
            (at start (robot-at ?r ?pos)) (at start (robot-free ?r))
        )
        :effect (and
            ;cuando empieza el robot grua esta ocupado y cuando termina se libera
            (at start (not (robot-free ?r))) (at end (robot-free ?r))
            ;cuando termina la caja 1 está en la mesa, y no encima de la pila y no esta en la pila 
            (at start (not (on ?b ?p))) (at end (on ?b ?table)) (at end (not (box-on-pile ?b)))
            ;la pila está libre
            (at end (pile-empty ?p))
        )
    )

    (:durative-action load
        :parameters ( ?rg - rg ?rm - rm ?b1 - box ?pos - position ?table - table)
        :duration (= ?duration 2)
        :condition (and
            ;la grua tiene que estar en la posicion y libre
            (at start (robot-at ?rg ?pos)) (at start (robot-free ?rg))
            ;el robot móvil tiene que estar en la posición y libre
            (at start (robot-at ?rm ?pos)) (at start (robot-free ?rm))
            ;la caja tiene que estar en la posicion, en la mesa y libre
            (at start (box-at ?b1 ?pos)) (at start (on ?b1 ?table)) (at start (box-free ?b1))
        )
        :effect (and
            ;cuando empieza el robot grua esta ocupado y cuando termina se libera
            (at start (not (robot-free ?rg))) (at end (robot-free ?rg))
            ;cuando termina el robot movil esta cupado
            (at end (not (robot-free ?rm)))
            ;cuando termina la caja está en el robot movil y no en la mesa
            (at start (not (on ?b1 ?table))) (at end (on ?b1 ?rm))
            (at end (increase (time-total) 2))
        )
    )

    (:durative-action un-load
        :parameters ( ?rg - rg ?rm - rm ?b1 - box ?pos - position ?table - table)
        :duration (= ?duration 2)
        :condition (and
            ;la grua tiene que estar en la posicion y libre
            (at start (robot-at ?rg ?pos)) (at start (robot-free ?rg))
            ;el robot móvil tiene que estar en la posición
            (at start (robot-at ?rm ?pos))
            ;la caja tiene que estar en la posicion y en el robot movil
            (at start (box-at ?b1 ?pos)) (at start (on ?b1 ?rm))
        )
        :effect (and
            ;cuando empieza el robot grua esta ocupado y cuando termina se libera
            (at start (not (robot-free ?rg))) (at end (robot-free ?rg))
            ;cuando termina el robot movil esta libre
            (at end (robot-free ?rm))
            ;cuando termina la caja está en la mesa y no en el robot
            (at start (not (on ?b1 ?rm))) (at end (on ?b1 ?table))
            (at end (increase (time-total) 2))
        )
    )

    (:durative-action charge-robot
        :parameters ( ?r - rm ?pos - position)
        :duration (= ?duration (recharge-duration ?r))
        :condition (and
            ;el robot movil no tiene ningún paquete encima y está en una estación de carga
            (at start (robot-free ?r)) (at start (charging-point ?pos)) (at start (robot-at ?r ?pos))
            ;la estación de carga está libre
            (at start (charging-point-free ?pos))
        )
        :effect (and
            ;cuando empieza el robot movil esta ocupado y cuando termina se libera
            (at start (not (robot-free ?r))) (at end (robot-free ?r))
            ;cuando empieza la estación de carga esta ocupada y cuando termina se libera
            (at start (not (charging-point-free ?pos))) (at end (charging-point-free ?pos))
            ;cuando termina el robot pasa a tener la carga maxima
            (at end (assign (battery ?r) (battery-max ?r)))
            (at end (increase (time-total) (recharge-duration ?r)))
            (at end (increase (num-recharges) 1))
        )
    )

    (:durative-action move-robot
        :parameters (?r - rm ?from ?to - position)
        :duration (= ?duration (/ (distance ?from ?to) (velocity ?r)))
        :condition (and
            ;cuando empieze el robot tiene que estar en la posición x y tiene que tener suficiente carga para moverse del todo
            (at start (robot-at ?r ?from)) (at start (>= (battery ?r) (distance ?from ?to)))
        )
        :effect (and
            ;al final el robot pasa a estar en la posicion b
            (at start (not (robot-at ?r ?from))) (at end (robot-at ?r ?to))
            ;al robot se le resta la bateria del trayecto
            (at end (decrease (battery ?r) (distance ?from ?to)))
            (at end (increase
                    (time-total)
                    (/ (distance ?from ?to) (velocity ?r))))
        )

    )
    (:durative-action move-robot-package
        :parameters (?r - rm ?from ?to - position ?b - box)
        :duration (= ?duration (/ (distance ?from ?to) (velocity ?r)))
        :condition (and
            ;cuando empieze el robot tiene que estar en la posición x y tiene que tener suficiente carga para moverse del todo
            (at start (robot-at ?r ?from)) (at start (>= (battery ?r) (distance ?from ?to)))
            ;la caja tiene que estar en la posicion from y en el robot
            (at start (box-at ?b ?from)) (at start (on ?b ?r))
        )
        :effect (and
            ;al final el robot pasa a estar en la posicion to
            (at start (not (robot-at ?r ?from))) (at end (robot-at ?r ?to))
            ;la caja pasa a estar en la posición to
            (at start (not (box-at ?b ?from))) (at end (box-at ?b ?to))
            ;se le resta la bateria al robot
            (at end (decrease (battery ?r) (distance ?from ?to)))
            (at end (increase
                    (time-total)
                    (/ (distance ?from ?to) (velocity ?r))))
        )
    )

)