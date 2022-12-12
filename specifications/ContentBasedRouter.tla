------------------------- MODULE ContentBasedRouter -------------------------
EXTENDS Naturals, Sequences
CONSTANT NULL, src, processors
VARIABLES endpts
\* Endpoints ir Init reikes istrint
\* Endpoints == {src} \cup processors

\* Init == /\ endpts = [s \in Endpoints |-> CASE s = src -> "a" []OTHER -> NULL]

Route == /\ endpts[src] /= NULL
         /\ endpts' = [e \in DOMAIN endpts |-> 
                        CASE e = src -> NULL
                        []\E p \in processors: e = p /\ endpts[src] = p /\ endpts[p] = NULL -> endpts[src]
                        []OTHER -> endpts[e]]

Next == Route

=============================================================================
\* Modification History
\* Created Wed Dec 07 16:03:37 EET 2022 by Rokas
