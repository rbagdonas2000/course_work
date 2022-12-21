-------------------------------- MODULE ReportSystemToWorkWith --------------------------------
EXTENDS Naturals, Sequences, TLC, ReportSystemToWorkWithMC
CONSTANTS TimeOut, NUM_OF_PARTS
VARIABLES adapter, splitter, router, processor_a, processor_b, processor_c, aggr, notif, aggr_t, aggr_buf,
backoffice

Vars == <<adapter, splitter, router, processor_a, processor_b, processor_c, aggr, notif, aggr_t, aggr_buf, backoffice>>

RequestReportChannel == INSTANCE PointToPointChannel WITH src <- adapter, dst <- splitter
ReportSplitter == INSTANCE Split WITH src <- splitter, dst <- router
Router == INSTANCE ContentBasedRouter WITH src <- router
AServiceResponseChannel == INSTANCE PointToPointChannel WITH src <- processor_a, dst <- aggr
BServiceResponseChannel == INSTANCE PointToPointChannel WITH src <- processor_b, dst <- aggr
CServiceResponseChannel == INSTANCE PointToPointChannel WITH src <- processor_c, dst <- aggr
Aggregator == INSTANCE MyAggregator WITH src <- aggr, dst <- notif, time <- aggr_t, buffer <- aggr_buf
NotificationChannel == INSTANCE PointToPointChannel WITH src <- notif, dst <- backoffice

ReportGenerated == /\ backoffice /= NULL
                   /\ Print(<<"Report received: ", backoffice>>, TRUE)


TypeInvariant == /\ adapter \in UNION {SubSequence, {NULL}}
                 /\ splitter \in UNION {SubSequence, {NULL}, {<<>>}}
                 /\ router \in UNION {Record, {NULL}}
                 /\ processor_a \in UNION {reports, {NULL}}
                 /\ processor_b \in UNION {reports, {NULL}}
                 /\ processor_c \in UNION {reports, {NULL}}
                 /\ Aggregator!TypeInvariant
                 /\ \/ notif \in FullReport \/ notif = NULL
                 /\ \/ backoffice \in FullReport \/ backoffice = NULL

Init == /\ adapter = ReqMsg
        /\ splitter = NULL
        /\ router = NULL
        /\ processor_a = NULL
        /\ processor_b = NULL
        /\ processor_c = NULL
        /\ aggr = NULL
        /\ notif = NULL
        /\ Aggregator!Init
        /\ backoffice = NULL
    
Next == \/ /\ RequestReportChannel!Send
           /\ UNCHANGED <<router, processor_a, processor_b, processor_c, aggr, aggr_buf, aggr_t, notif, backoffice>>
        \/ /\ ReportSplitter!SplitAndSend
           /\ UNCHANGED <<adapter, processor_a, processor_b, processor_c, aggr, aggr_buf, aggr_t, notif, backoffice>>
        \/ /\ Router!Route
           /\ UNCHANGED <<adapter, splitter, aggr, aggr_buf, aggr_t, notif, backoffice>>
        \/ /\ AServiceResponseChannel!Send
           /\ UNCHANGED <<adapter, splitter, router, processor_b, processor_c, aggr_buf, aggr_t, notif, backoffice>>
        \/ /\ BServiceResponseChannel!Send
           /\ UNCHANGED <<adapter, splitter, router, processor_a, processor_c, aggr_buf, aggr_t, notif, backoffice>>
        \/ /\ CServiceResponseChannel!Send
           /\ UNCHANGED <<adapter, splitter, router, processor_a, processor_b, aggr_buf, aggr_t, notif, backoffice>>
        \/ /\ Aggregator!Aggregate
           /\ UNCHANGED <<adapter, splitter, router, processor_a, processor_b, processor_c, backoffice>>
        \/ /\ NotificationChannel!Send
           /\ UNCHANGED <<adapter, splitter, router, processor_a, processor_b, processor_c, aggr_buf, aggr_t, aggr>>
        \/ /\ ReportGenerated
           /\ UNCHANGED Vars
=============================================================================