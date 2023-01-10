----------------------------- MODULE Aggregator -----------------------------
EXTENDS Naturals, Sequences
CONSTANTS NULL, TimeOut, NUM_OF_PARTS, FullReport, reports
VARIABLES src, dst, time, buffer

TypeInvariant == /\ buffer \in FullReport
                 /\ time \in Nat
                 /\ src \in UNION {reports, {NULL}}
                 
Init == /\ buffer = <<>>
        /\ time = 0
        
ProcessMessage == /\ src /= NULL
                  /\ buffer' = Append(buffer, src)
                  /\ src' = NULL
                  /\ time' = time + 1
                  /\ UNCHANGED dst

SendReport == /\ Len(buffer) > 0
              /\ dst = NULL
              /\ dst' = buffer
              /\ buffer' = <<>>
              /\ time' = 0
              /\ UNCHANGED src

Aggregate == /\ IF time = TimeOut \/ Len(buffer) = NUM_OF_PARTS
                    THEN SendReport 
                    ELSE ProcessMessage
=============================================================================