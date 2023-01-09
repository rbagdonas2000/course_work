----------------------------- MODULE Splitter -----------------------------
EXTENDS Naturals, Sequences
CONSTANT NULL
VARIABLES src, dst

CanSend == IF dst = NULL THEN TRUE ELSE FALSE

NotDone == IF Len(src) > 0 THEN TRUE ELSE FALSE

ClearSrc == IF src = <<>>
            THEN src' = NULL /\ UNCHANGED dst
            ELSE UNCHANGED <<src, dst>>

SplitAndSend == \/ /\ src /= NULL
                   /\ NotDone
                   /\ CanSend
                   /\ dst' = Head(src)
                   /\ src' = Tail(src)
                \/ ClearSrc
=============================================================================