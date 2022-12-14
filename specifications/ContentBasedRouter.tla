------------------------- MODULE ContentBasedRouter -------------------------
EXTENDS Naturals, Sequences
CONSTANT NULL, src, processors
VARIABLES endpts

Route == /\ endpts[src] /= NULL
         /\ endpts' = [e \in DOMAIN endpts |-> 
                        CASE e = src -> NULL
                        []\E p \in processors: e = p /\ endpts[src].routeTo = p /\ endpts[p] = NULL -> endpts[src].elem
                        []OTHER -> endpts[e]]
=============================================================================
\* Modification History
\* Created Wed Dec 07 16:03:37 EET 2022 by Rokas
