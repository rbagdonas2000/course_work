------------------------- MODULE ContentBasedRouter -------------------------
EXTENDS Naturals
CONSTANT NULL, a_service, b_service, c_service
VARIABLES src, processor_a, processor_b, processor_c

Route == /\ src /= NULL
         /\ IF src.routeTo = a_service /\ processor_a = NULL 
            THEN /\ processor_a' = src.elem 
                 /\ UNCHANGED <<processor_b, processor_c>>
            ELSE IF src.routeTo = b_service /\ processor_b = NULL 
            THEN /\ processor_b' = src.elem 
                 /\ UNCHANGED <<processor_a, processor_c>>
            ELSE IF src.routeTo = c_service /\ processor_c = NULL 
            THEN /\ processor_c' = src.elem 
                 /\ UNCHANGED <<processor_a, processor_b>>
            ELSE UNCHANGED <<processor_a, processor_b, processor_c>>
         /\ src' = NULL
=============================================================================