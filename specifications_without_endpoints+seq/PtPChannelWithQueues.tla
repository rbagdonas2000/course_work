------------------------ MODULE PtPChannelWithQueues ------------------------
EXTENDS Naturals, Sequences
CONSTANTS NULL, MaxMsgs
VARIABLE src, dst

CanSend == IF Len(dst) <= MaxMsgs THEN TRUE ELSE FALSE

NotEmpty == IF Len(src) > 0 THEN TRUE ELSE FALSE

Send == /\ src /= NULL
        /\ NotEmpty
        /\ CanSend
        /\ dst' = Append(dst, Head(src))
        /\ src' = Tail(src)

=============================================================================
