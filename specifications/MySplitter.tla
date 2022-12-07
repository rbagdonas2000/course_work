----------------------------- MODULE MySplitter -----------------------------
EXTENDS Naturals, Sequences
CONSTANT NULL, src, dst \*, parts
VARIABLES endpts

\*Endpoints, Parts ir Init reikes istrint, buvo naudojama pasitikrinimui specifikacijos
Endpoints == {src, dst}
parts == <<"A", "B", "C">>
Init == /\ endpts = [s \in Endpoints |-> CASE s = src -> parts []OTHER -> NULL]

CanSend == IF endpts[dst] = NULL THEN TRUE ELSE FALSE

NotDone == IF Len(endpts[src]) > 0 THEN TRUE ELSE FALSE

Clear == /\ endpts' = [e \in DOMAIN endpts |->
                                CASE e = dst -> NULL
                                []OTHER -> endpts[e]]

SplitAndSend == /\ NotDone
                /\ CanSend
                /\ endpts' = [e \in DOMAIN endpts |->
                                CASE e = src -> Tail(endpts[src])
                                []e = dst -> Head(endpts[src])
                                []OTHER -> endpts[e]]

Next == \/ SplitAndSend
        \/ Clear

=============================================================================
\* Modification History
\* Last modified Wed Dec 07 19:46:24 EET 2022 by Rokas
\* Created Wed Dec 07 19:46:15 EET 2022 by Rokas
