-------------------------------- MODULE ReportSystemToWorkWith --------------------------------
EXTENDS Naturals, Sequences, TLC, ReportSystemToWorkWithMC
CONSTANT splitter, router, adapter, aggr, TimeOut, NUM_OF_PARTS,
notif, backoffice
VARIABLES endpts, aggr_t, aggr_buf

Vars == <<endpts, aggr_t, aggr_buf>>

Endpoints == {adapter, splitter, router, aggr, notif, backoffice} \cup services

RequestReportChannel == INSTANCE PointToPointChannel WITH src <- adapter, dst <- splitter
AServiceResponseChannel == INSTANCE PointToPointChannel WITH src <- a_service, dst <- aggr
BServiceResponseChannel == INSTANCE PointToPointChannel WITH src <- b_service, dst <- aggr
CServiceResponseChannel == INSTANCE PointToPointChannel WITH src <- c_service, dst <- aggr
NotificationChannel == INSTANCE PointToPointChannel WITH src <- notif, dst <- backoffice
ReportSplitter == INSTANCE Split WITH src <- splitter, dst <- router
Router == INSTANCE ContentBasedRouter WITH src <- router, processors <- services
Aggregator == INSTANCE MyAggregator WITH src <- aggr, dst <- notif, time <- aggr_t, buffer <- aggr_buf

TypeInvariant == /\ endpts[adapter] \in UNION {SubSequence, {NULL}}
                 /\ endpts[splitter] \in UNION {SubSequence, {NULL}, {<<>>}}
                 /\ endpts[router] \in UNION {Record, {NULL}}
                 /\ \A s \in services: endpts[s] \in UNION {reports, {NULL}}
                 /\ Aggregator!TypeInvariant
                 /\ \/ endpts[notif] \in FullReport \/ endpts[notif] = NULL
                 /\ \/ endpts[backoffice] \in FullReport \/ endpts[backoffice] = NULL

ReportGenerated == /\ endpts[backoffice] /= NULL
                   /\ Print(<<"Report received: ", endpts[backoffice]>>, TRUE)

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
        \/ /\ ReportGenerated
           /\ UNCHANGED Vars

=============================================================================