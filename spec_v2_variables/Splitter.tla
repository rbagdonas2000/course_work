----------------------------- MODULE Splitter -----------------------------
EXTENDS Naturals, Sequences
CONSTANT NULL
VARIABLES src, dst

ClearSrc == IF src = <<>>
            THEN src' = NULL /\ UNCHANGED dst
            ELSE UNCHANGED <<src, dst>>

SplitAndSend == \/ /\ src /= NULL
                   /\ dst = NULL
                   /\ Len(src) > 0
                   /\ dst' = Head(src)
                   /\ src' = Tail(src)
                \/ ClearSrc
=============================================================================