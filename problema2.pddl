(define (problem robots_pract)
    (:domain robots2)
    (:objects
        rgA - rg
        rgB - rg
        rgC - rg
        rgD - rg
        table - table
        pA - pile
        pB - pile
        pC - pile
        pD - pile
        A - position
        B - position
        C - position
        D - position
        rm1 - rm
        rm2 - rm
        rm3 - rm
        b1 - box
        b2 - box
        b3 - box
        b4 - box
        b5 - box
    )
    (:init
        (robot-at rm1 A)
        (= (battery rm1) 15)
        (= (battery-max rm1) 25)
        (= (recharge-duration rm1) 5)
        (= (velocity rm1) 2)

        (robot-at rm2 B)
        (= (battery rm2) 20)
        (= (battery-max rm2) 40)
        (= (recharge-duration rm2) 6)
        (= (velocity rm2) 4)

        (robot-at rm3 B)
        (= (battery rm3) 25)
        (= (battery-max rm3) 50)
        (= (recharge-duration rm3) 8)
        (= (velocity rm3) 4)

        (robot-at rgA A)
        (robot-at rgB B)
        (robot-at rgC C)
        (robot-at rgD D)

        (robot-free rm1)
        (robot-free rm2)
        (robot-free rm3)
        (robot-free rgA)
        (robot-free rgB)
        (robot-free rgC)
        (robot-free rgD)

        (pile-empty pD)

        (box-on-pile b1)
        (box-on-pile b2)
        (box-on-pile b3)
        (box-on-pile b4)
        (box-on-pile b5)

        (box-at b1 B)
        (box-at b2 A)
        (box-at b3 C)
        (box-at b4 C)
        (box-at b5 C)

        (box-free b1)
        (box-free b2)
        (box-free b5)
        (on b1 pB)
        (on b2 pA)
        (on b3 pC)
        (on b4 b3)
        (on b5 b4)

        (charging-point A)
        (charging-point B)
        (charging-point-free A)
        (charging-point-free B)

        (= (distance A B) 15)
        (= (distance A C) 18)
        (= (distance A D) 20)
        (= (distance B A) 15)
        (= (distance B C) 20)
        (= (distance B D) 16)
        (= (distance C A) 18)
        (= (distance C B) 20)
        (= (distance C D) 25)
        (= (distance D A) 20)
        (= (distance D B) 16)
        (= (distance D C) 25)

    )
    (:goal
        (and
            (box-at b1 C)
            (box-at b2 B)
            (box-at b3 D)
            (box-at b4 B)
            (box-at b5 D)
            (box-free b1)
            (box-free b4)
            (box-free b5)
            (on b4 b2)
            (on b5 b3)

            (robot-at rm1 D)
            (robot-at rgA A)
            (robot-at rgB B)
            (robot-at rgC C)
            (robot-at rgD D)

        )
    )

    (:metric minimize
        (+ (* 0.7 (time-total)) (* 10 (num-recharges)))
    )
)