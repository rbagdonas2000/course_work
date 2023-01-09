----------------------------- MODULE Splitter -----------------------------
EXTENDS Naturals, Sequences
CONSTANT NULL, MaxMsgs
VARIABLES src, dst

LOCAL NotEmpty(s) == IF Len(s) > 0 THEN TRUE ELSE FALSE

SplitAndSend ==  /\ src /= NULL
                 /\ NotEmpty(src)
                 /\ Len(dst) < MaxMsgs
                 /\ LET h == Head(src)
                    IN IF NotEmpty(h)
                       THEN /\ dst' = Append(dst, Head(h))
                            /\ src' = IF NotEmpty(Tail(src)) 
                                       THEN <<Tail(h)>> \o Tail(src) 
                                       ELSE <<Tail(h)>>
                       ELSE /\ src' = Tail(src) 
                            /\ UNCHANGED dst
=============================================================================