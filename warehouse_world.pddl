(define (domain warehouse)
	(:requirements :typing)
	(:types robot pallette - bigobject
        	location shipment order saleitem)

  	(:predicates
    	(ships ?s - shipment ?o - order)
    	(orders ?o - order ?si - saleitem)
    	(unstarted ?s - shipment)
    	(started ?s - shipment)
    	(complete ?s - shipment)
    	(includes ?s - shipment ?si - saleitem)

    	(free ?r - robot)
    	(has ?r - robot ?p - pallette)

    	(packing-location ?l - location)
    	(packing-at ?s - shipment ?l - location)
    	(available ?l - location)
    	(connected ?l - location ?l - location)
    	(at ?bo - bigobject ?l - location)
    	(no-robot ?l - location)
    	(no-pallette ?l - location)

    	(contains ?p - pallette ?si - saleitem)
  )

   (:action startShipment
      :parameters (?s - shipment ?o - order ?l - location)
      :precondition (and (unstarted ?s) (not (complete ?s)) (ships ?s ?o) (available ?l) (packing-location ?l))
      :effect (and (started ?s) (packing-at ?s ?l) (not (unstarted ?s)) (not (available ?l)))
   )
   (:action robotMove
      :parameters (?r - robot ? ?l1 - location ?l2 - location)
      :precondition (and (connected ?l1 ?l2 ) (no-robot ?l2) (at ?r ?l1)(free ?r))
      :effect (and (no-robot ?l1) (at ?r ?l2) (not (at ?r ?l1)) (not (no-robot ?l2)))
   )
   (:action robotMoveWithPallette
      :parameters (?r - robot ?p - pallette ?l1 - location ?l2 - location)
      :precondition (and (connected ?l1 ?l2 ) (no-pallette ?l2) (no-robot ?l2) (at ?p ?l1) (at ?r ?l1) (free ?r))
      :effect (and (has ?r ?p) (no-pallette ?l1) (no-robot ?l1) (at ?p ?l2) (at ?r ?l2) (not(at ?r ?l1)) (not (at ?p ?l1))  (not (no-robot ?l2)) (not (no-pallette ?l2)))
   ) 
   (:action moveItemFromPalletteToShipment
      :parameters (?l - location ?s - shipment ?si - saleitem ?p - pallette ?o - order)
      :precondition (and (at ?p ?l) (contains ?p ?si) (not(includes ?s ?si)) (packing-location ?l) (packing-at ?s ?l))
      :effect (and (not(contains ?p ?si)) (includes ?s ?si))
   )
   (:action completeShipment
      :parameters (?l - location ?s - shipment ?o - order)                                                                      
      :precondition (and (started ?s) (packing-location ?l) (not(available ?l)) (ships ?s ?o) (not(complete ?s)))
      :effect (and (complete ?s) (available ?l))
   )

)
