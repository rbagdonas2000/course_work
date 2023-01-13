----------------------------- MODULE Splitter -----------------------------
EXTENDS Naturals, Sequences
CONSTANT NULL, MaxMsgs
VARIABLES src, dst

LOCAL NotEmpty(s) == Len(s) > 0

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