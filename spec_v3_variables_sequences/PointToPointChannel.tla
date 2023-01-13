------------------------ MODULE PointToPointChannel ------------------------
EXTENDS Naturals, Sequences
CONSTANTS NULL, MaxMsgs
VARIABLE src, dst

CanSend == Len(dst) < MaxMsgs

NotEmpty == Len(src) > 0

Send == /\ src /= NULL
        /\ NotEmpty
        /\ CanSend
        /\ dst' = Append(dst, Head(src))
        /\ src' = Tail(src)
=============================================================================
