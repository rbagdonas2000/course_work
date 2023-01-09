------------------------- MODULE ContentBasedRouter -------------------------
EXTENDS Naturals
CONSTANT NULL, src, processors
VARIABLES endpts

Route == /\ endpts[src] /= NULL
         /\ endpts' = [e \in DOMAIN endpts |-> 
                        CASE e = src -> NULL
                        []\E p \in processors: e = p /\ endpts[src].routeTo = p /\ endpts[p] = NULL -> endpts[src].elem
                        []OTHER -> endpts[e]]
=============================================================================