(define (domain robots)
    (:requirements :durative-actions :typing :fluents)
    (:types
        rg rm box position - object

    )
    (:predicates
        (robot-at ?r -
            (either rm rg) ?p - position) ;el robot movil está en la posicion x
        (lifting ?r - rg ?b - box) ;el robot grua esta cargando la caja x
        (transporting ?r - rm ?b -box) ;el robot moivl esta transportando la caja x
        (robot-free ?r -
            (either rg rm)) ;el robot no tiene ningun paquete cargado

        (box-at ?b - box ?p - position) ;la caja está en la posición X
        (box-trnasporting ?b - box) ;la caja está siendo transportada
        (on ?b1 - box ?b2 - box) ;la baja x esta encima de la caja y
        (box-free ?b - box) ;la caja no tiene ninguna caja encima

        (charging_point ?p - position) ;hay un punto de carga en la posicion
        (charging_point_status ?p - position) ;está libre el punto de carga?
        (charging ?r - rm) ;el robot movil está cargando

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
        :parameters ( ?r - rg ?b1 ?b2 - box ?pos - position)
        :duration (= ?duration 2)
        :condition (and
            (at start (robot-at ?r ?pos)) ;el robot esta en la posicion
            (at start (box-at ?b1 ?pos)) ;la caja esta en la posicion
            (at start (box-at ?b2 ?pos)) ;la caja esta en la posicion
            (at start (robot-free ?r)) ;el robot está libre
            (at start (box-free ?b1)) ;el paquete b1 no tiene ningun paquete encima
            (at start (box-free ?b2)) ;el paquete b2 no tiene ningun paquete encima
        )
        :effect (and
            (at start (not (robot-free ?r))) ;el robot esta ocupado
            (at start (not (box-free ?b2))) ;el paquete b2 pasa a no estsar libre
            (at start (lifting ?r ?b1)) ;el robot grua esta cargando el paquete b1
            (at end (on ?b1 ?b2)) ;al final b1 está encima de b2
            (at end (not (lifting ?r ?b1)));el robot grua ya no esta cargando el paquete
            (at end (robot-free ?r)) ;el robot esta libre
            (at end (increase (time-total) 2))
        )
    )

    (:durative-action un-stack
        :parameters ( ?r - rg ?b1 ?b2 - box ?pos - position)
        :duration (= ?duration 2)
        :condition (and
            (at start (robot-at ?r ?pos)) ;el robot esta en la posicion del paquete
            (at start (box-at ?b1 ?pos)) ;la caja esta en la posicion
            (at start (box-at ?b2 ?pos)) ;la caja esta en la posicion
            (at start (robot-free ?r))
            (at start (box-free ?b1)) ;el paquete b1 no tiene ningun paquete encima
            (at start (on ?b1 ?b2)) ;el paquete b1 está encima de b2
        )
        :effect (and
            (at start (not (robot-free ?r))) ;el robot esta ocupado
            (at start (lifting ?r ?b1)) ;el robot grua esta cargando el paquete b1
            (at end (not (on ?b1 ?b2))) ;al final b1 ya no está encima de b2
            (at end (box-free ?b1)) ;el paquete b1 no tiene ningun paquete encima
            (at end (box-free ?b2)) ;el paquete b1 no tiene ningun paquete encima
            (at end (not (lifting ?r ?b1))) ;el robot grua ya no esta cargando el paquete b1
            (at end (robot-free ?r)) ;el robot esta libre
            (at end (increase (time-total) 2))
        )
    )

    (:durative-action load
        :parameters ( ?rg - rg ?rm - rm ?b1 - box ?pos - position)
        :duration (= ?duration 2)
        :condition (and
            (at start (robot-free ?rg)) ;el robot grua esta libre
            (at start (robot-free ?rm)) ;el robot movil esta libre
            (at start (robot-at ?rg ?pos)) ;el robot grua esta en la posicion correcta
            (at start (robot-at ?rm ?pos)) ;el robot movil esta en la posicion correcta
            (at start (box-at ?b1 ?pos)) ;la caja está en la posicion correcta
            (at start (not (box-trnasporting ?b1)))
            (at start (box-free ?b1)) ;el paquete b1 no tiene ningun paquete encima
        )
        :effect (and
            (at start (lifting ?rg ?b1)) ;el robot grua esta cargando el paquete b1
            (at start (not (robot-free ?rg))) ;el robot grua no esta libre
            (at end (not (lifting ?rg ?b1))) ;el robot grua ya no esta cargando el paquete b1
            (at end (robot-free ?rg)) ;el robot grua esta libre
            (at end (transporting ?rm ?b1)) ;el robot movil esta transportando el paquete
            (at end (not (robot-free ?rm))) ;el robot movil no está libre
            (at end (box-trnasporting ?b1)) ;la caja está siendo transportada
            (at end (increase (time-total) 2))
        )
    )

    (:durative-action un-load
        :parameters ( ?rg - rg ?rm - rm ?b1 - box ?pos - position)
        :duration (= ?duration 2)
        :condition (and
            (at start (robot-free ?rg)) ;el robot grua esta libre
            (at start (transporting ?rm ?b1)) ;el robot movil esta cargarndo el paquete b1
            (at start (robot-at ?rg ?pos)) ;el robot grua esta en la posicion correcta
            (at start (robot-at ?rm ?pos)) ;el robot movil esta en la posicion correcta
            (at start (box-at ?b1 ?pos)) ;la caja está en la posicion correcta
        )
        :effect (and
            (at start (lifting ?rg ?b1)) ;el robot grua esta cargando el paquete b1
            (at start (not (robot-free ?rg))) ;el robot grua no esta libre
            (at end (not (lifting ?rg ?b1))) ;el robot grua ya no esta cargando el paquete b1
            (at end (not (transporting ?rm ?b1)));el robot movil ya no esta transportando el paquete
            (at end (robot-free ?rg)) ;el robot grua esta libre
            (at end (robot-free ?rm)) ;el robot movil esta libre
            (at end (increase (time-total) 2))
        )
    )

    (:durative-action charge-robot
        :parameters ( ?r - rm ?pos - position)
        :duration (= ?duration (recharge-duration ?r))
        :condition (and
            (at start (robot-free ?r)) ;el robot movil esta libre
            (at start (robot-at ?r ?pos))
            (at start (charging_point ?pos));está en una estación de carga
            (at start (charging_point_status ?pos));esta libre el punto de carga?
        )
        :effect (and
            (at start (not (charging_point_status ?pos)))
            (at start (charging ?r))
            (at end (not (charging ?r)))
            (at end (charging_point_status ?pos))
            (at end (assign (battery ?r) (battery-max ?r)))
            (at end (increase (num-recharges) 1))
            (at end (increase (time-total) (recharge-duration ?r)))
        )
    )

    (:durative-action move-robot
        :parameters (?r - rm ?from ?to - position)
        :duration (= ?duration (/ (distance ?from ?to) (velocity ?r)))
        :condition (and
            (at start (robot-at ?r ?from))
            (at start (>= (battery ?r) (distance ?from ?to)))
        )
        :effect (and
            (at start (not (robot-at ?r ?from)))
            (at end (robot-at ?r ?to))
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
            (at start (robot-at ?r ?from))
            (at start (box-at ?b ?from))
            (at start (transporting ?r ?b))
            (at start (>= (battery ?r) (distance ?from ?to)))
        )
        :effect (and
            (at start (not (robot-at ?r ?from)))
            (at start (not (box-at ?b ?from)))
            (at end (robot-at ?r ?to))
            (at end (decrease (battery ?r) (distance ?from ?to)))
            (at end (box-at ?b ?to))
            (at end (increase
                    (time-total)
                    (/ (distance ?from ?to) (velocity ?r))))
        )
    )

)