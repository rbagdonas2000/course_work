----------------------------- MODULE SplitterWithQueues -----------------------------
EXTENDS Naturals, Sequences
CONSTANT NULL, NUM_OF_PARTS
VARIABLES src, dst

CanSend == IF Len(dst) < NUM_OF_PARTS THEN TRUE ELSE FALSE

NotEmpty(s) == IF Len(s) > 0 THEN TRUE ELSE FALSE

SplitAndSend ==  /\ src /= NULL
                 /\ NotEmpty(src)
                 /\ CanSend
                 /\ LET h == Head(src)
                    IN IF NotEmpty(h)
                        THEN /\ dst' = Append(dst, Head(h))
                             /\ src' = IF NotEmpty(Tail(src)) THEN <<Tail(h)>> \o Tail(src) ELSE <<Tail(h)>>
                        ELSE /\ src' = Tail(src) 
                             /\ UNCHANGED dst
=============================================================================