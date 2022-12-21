------------------------ MODULE PointToPointChannel ------------------------
EXTENDS Naturals, Sequences
CONSTANTS NULL
VARIABLE src, dst

Send == /\ src /= NULL
        /\ dst = NULL
        /\ src' = NULL
        /\ dst' = src

=============================================================================
\* Modification History
\* Last modified Sun Dec 04 13:59:54 EET 2022 by Rokas
\* Created Sun Dec 04 13:57:55 EET 2022 by Rokas
