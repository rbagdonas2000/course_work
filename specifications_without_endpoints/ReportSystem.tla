-------------------------------- MODULE ReportSystem --------------------------------
EXTENDS Naturals, Sequences, TLC
CONSTANT NULL, splitter, router, adapter, a_service, b_service, c_service, aggr, TimeOut, NUM_OF_PARTS,
notif, backoffice, reportA, reportB, reportC
VARIABLES endpts, aggr_t, aggr_buf

ReqMsg == <<[elem |-> reportA, routeTo |-> a_service], 
            [elem |-> reportB, routeTo |-> b_service], 
            [elem |-> reportC, routeTo |-> c_service]>>

Endpoints == {adapter, splitter, router, a_service, b_service, c_service, aggr, notif, backoffice}

RequestReportChannel == INSTANCE PointToPointChannel WITH src <- adapter, dst <- splitter
AServiceResponseChannel == INSTANCE PointToPointChannel WITH src <- a_service, dst <- aggr
BServiceResponseChannel == INSTANCE PointToPointChannel WITH src <- b_service, dst <- aggr
CServiceResponseChannel == INSTANCE PointToPointChannel WITH src <- c_service, dst <- aggr
NotificationChannel == INSTANCE PointToPointChannel WITH src <- notif, dst <- backoffice
ReportSplitter == INSTANCE Split WITH src <- splitter, dst <- router
Router == INSTANCE ContentBasedRouter WITH src <- router, processors <- {a_service, b_service, c_service}
Aggregator == INSTANCE MyAggregator WITH src <- aggr, dst <- notif, time <- aggr_t, buffer <- aggr_buf

Init == /\ endpts = [e \in Endpoints |->
                            CASE e = adapter -> ReqMsg
                            []OTHER -> NULL]
        /\ Aggregator!Init

Next == \/ /\ RequestReportChannel!Send
           /\ UNCHANGED <<aggr_buf, aggr_t>>
        \/ /\ ReportSplitter!SplitAndSend
           /\ UNCHANGED <<aggr_buf, aggr_t>>
        \/ /\ Router!Route
           /\ UNCHANGED <<aggr_buf, aggr_t>>
        \/ /\ AServiceResponseChannel!Send
           /\ UNCHANGED <<aggr_buf, aggr_t>>
        \/ /\ BServiceResponseChannel!Send
           /\ UNCHANGED <<aggr_buf, aggr_t>>
        \/ /\ CServiceResponseChannel!Send
           /\ UNCHANGED <<aggr_buf, aggr_t>>
        \/ /\ Aggregator!Aggregate
        \/ /\ Aggregator!Clear
        \/ /\ NotificationChannel!Send
           /\ UNCHANGED <<aggr_buf, aggr_t>>

=============================================================================
\* Modification History
\* Created Thu Dec 08 18:15:22 EET 2022 by Rokas