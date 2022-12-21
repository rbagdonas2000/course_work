---------------------------- MODULE RouterToTest ----------------------------
EXTENDS Naturals, Sequences
CONSTANT NULL, src, processors
VARIABLES endpts, current

Endpoints == {src} \cup processors
 parts == <<"a", "b", "c">>
 GetPart == /\ Len(parts) > 0
            /\ current' = Head(parts)
            /\ parts' = Tail(parts)

 Init == /\ GetPart
         /\ endpts = [s \in Endpoints |-> CASE s = src -> current []OTHER -> NULL]
        
 SetSrc == /\ endpts[src] = NULL
           /\ GetPart
           /\ endpts'[src] = current


Route == /\ endpts[src] /= NULL
         /\ endpts' = [e \in DOMAIN endpts |-> 
                        CASE e = src -> NULL
                        []\E p \in processors: e = p /\ endpts[src] = p /\ endpts[p] = NULL -> endpts[src]
                        []OTHER -> endpts[e]]

Next == \/ Route
        \/ SetSrc


=============================================================================
\* Modification History
\* Last modified Wed Dec 07 20:32:26 EET 2022 by Rokas
\* Created Wed Dec 07 20:31:13 EET 2022 by Rokas
