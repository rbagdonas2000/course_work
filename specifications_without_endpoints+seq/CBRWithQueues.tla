------------------------- MODULE CBRWithQueues -------------------------
EXTENDS Naturals, Sequences
CONSTANT NULL, a_service, b_service, c_service, MaxMsgs
VARIABLES src, processor_a, processor_b, processor_c

Route == /\ src /= NULL
         /\ Len(src) > 0
         /\ LET h == Head(src) 
            IN  IF h.routeTo = a_service /\ processor_a /= NULL /\ Len(processor_a) < MaxMsgs 
                    THEN processor_a' = Append(processor_a, h.elem) /\ UNCHANGED <<processor_b, processor_c>>

                ELSE IF h.routeTo = b_service /\ processor_b /= NULL /\ Len(processor_b) < MaxMsgs 
                    THEN processor_b' = Append(processor_b, h.elem) /\ UNCHANGED <<processor_a, processor_c>>

                ELSE IF h.routeTo = c_service /\ processor_c /= NULL /\ Len(processor_c) < MaxMsgs 
                    THEN processor_c' = Append(processor_c, h.elem) /\ UNCHANGED <<processor_a, processor_b>>

                ELSE UNCHANGED <<processor_a, processor_b, processor_c>>
         /\ src' = Tail(src)
=============================================================================