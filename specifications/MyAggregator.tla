----------------------------- MODULE MyAggregator -----------------------------
EXTENDS Naturals, Sequences, TLC
CONSTANTS NULL, 
TimeOut, 
src, dst, 
NUM_OF_PARTS
VARIABLES endpts, time, buffer

\* TypeInvariant == /\ buffer \in Message
\*                  /\ time \in Nat
                 
Init == /\ buffer = <<>>
        /\ time = 0

Clear == /\ IF buffer = NULL
            THEN /\ buffer' = <<>>
                /\ time' = 0
                /\ UNCHANGED endpts
            ELSE UNCHANGED <<buffer, time, endpts>>

Wait == time' = time + 1
        
LOCAL ProcessMessage == /\ endpts[src] /= NULL
                        /\ buffer' = Append(buffer, endpts[src])
                        /\ endpts' = [e \in DOMAIN endpts |->
                                        CASE e = src -> NULL
                                        []OTHER -> endpts[e]]

LOCAL SendReport == /\ Len(buffer) > 0
                    /\ endpts[dst] = NULL
                    /\ endpts' = [e \in DOMAIN endpts |->
                                        CASE e = dst -> buffer
                                        []OTHER -> endpts[e]]
                    /\ UNCHANGED buffer

Aggregate == /\ IF time = TimeOut \/ Len(buffer) = NUM_OF_PARTS
                    THEN SendReport
                    ELSE ProcessMessage
             /\ Wait
=============================================================================