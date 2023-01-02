----------------------------- MODULE AggregatorWithQueues -----------------------------
EXTENDS Naturals, Sequences, TLC
CONSTANTS NULL, 
TimeOut, 
NUM_OF_PARTS,
FullReport,
reports,
MaxMsgs
VARIABLES src, dst, time, buffer

TypeInvariant == /\ buffer \in FullReport
                 /\ time \in Nat
                 /\ \/ src = <<>> 
                    \/ \A i \in 1..Len(src) : src[i] \in reports
                 
Init == /\ buffer = <<>>
        /\ time = 0

NotEmpty(s) == IF Len(s) > 0 THEN TRUE ELSE FALSE

CanSend == IF Len(dst) <= MaxMsgs THEN TRUE ELSE FALSE

LOCAL ProcessMessage == /\ src /= NULL
                        /\ NotEmpty(src)
                        /\ LET item == Head(src)
                           IN IF \E i \in 1..Len(buffer) : buffer[i] = item
                              THEN /\ src' = Append(Tail(src), item) 
                                   /\ UNCHANGED buffer
                              ELSE /\ buffer' = Append(buffer, Head(src))
                                   /\ src' = Tail(src)
                        /\ UNCHANGED dst

LOCAL SendReport == /\ Len(buffer) > 0
                    /\ dst /= NULL
                    /\ CanSend
                    /\ dst' = Append(dst, buffer)
                    /\ buffer' = <<>>
                    /\ time' = 0
                    /\ UNCHANGED src

Aggregate == IF time = TimeOut \/ Len(buffer) = NUM_OF_PARTS
                    THEN SendReport 
                    ELSE ProcessMessage /\ time' = time + 1
=============================================================================