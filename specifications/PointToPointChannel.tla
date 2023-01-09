------------------------ MODULE PointToPointChannel ------------------------
EXTENDS Naturals
CONSTANTS NULL, src, dst
VARIABLE endpts

Send == /\ endpts[src] /= NULL
        /\ endpts[dst] = NULL
        /\ endpts' = [e \in DOMAIN endpts |-> 
                        CASE e = src -> NULL
                        []e = dst -> endpts[src]
                        []OTHER -> endpts[e]]
=============================================================================