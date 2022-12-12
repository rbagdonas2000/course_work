----------------------------- MODULE Split -----------------------------
EXTENDS Naturals, Sequences
CONSTANT NULL, src, dst
VARIABLES endpts

CanSend == IF endpts[dst] = NULL THEN TRUE ELSE FALSE

NotDone == IF Len(endpts[src]) > 0 THEN TRUE ELSE FALSE

ClearSrc == IF endpts[src] = <<>>
            THEN endpts' = [e \in DOMAIN endpts |-> CASE e = src -> NULL []OTHER -> endpts[e]]
            ELSE UNCHANGED endpts

SplitAndSend == \/ /\ endpts[src] /= NULL
                   /\ NotDone
                   /\ CanSend
                   /\ endpts' = [e \in DOMAIN endpts |->
                                    CASE e = src -> Tail(endpts[src])
                                    []e = dst -> Head(endpts[src])
                                    []OTHER -> endpts[e]]
                \/ ClearSrc

=============================================================================
\* Modification History
\* Last modified Wed Dec 07 19:46:24 EET 2022 by Rokas
\* Created Wed Dec 07 19:46:15 EET 2022 by Rokas
