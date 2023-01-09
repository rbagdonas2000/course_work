----------------------------- MODULE Splitter -----------------------------
EXTENDS Naturals, Sequences
CONSTANT NULL, src, dst
VARIABLES endpts

ClearSrc == IF endpts[src] = <<>>
            THEN endpts' = [e \in DOMAIN endpts |-> CASE e = src -> NULL 
                                                         []OTHER -> endpts[e]]
            ELSE UNCHANGED endpts

SplitAndSend == \/ /\ endpts[src] /= NULL
                   /\ endpts[dst] = NULL
                   /\ Len(endpts[src]) > 0
                   /\ endpts' = [e \in DOMAIN endpts |->
                                    CASE e = src -> Tail(endpts[src])
                                    []e = dst -> Head(endpts[src])
                                    []OTHER -> endpts[e]]
                \/ ClearSrc
=============================================================================