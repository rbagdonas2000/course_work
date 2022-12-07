------------------------ MODULE PointToPointChannel ------------------------
EXTENDS Naturals, Sequences
CONSTANTS NULL, src, dst
VARIABLE endpts

Send == /\ endpts[src] /= NULL
        /\ endpts[dst] = NULL
        /\ endpts' = [e \in DOMAIN endpts |-> 
                        CASE e = src -> NULL
                        []e = dst -> endpts[src]
                        []OTHER -> endpts[e]]

=============================================================================
\* Modification History
\* Last modified Sun Dec 04 13:59:54 EET 2022 by Rokas
\* Created Sun Dec 04 13:57:55 EET 2022 by Rokas
