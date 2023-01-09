-------------------------------- MODULE ReportSystem --------------------------------
EXTENDS Naturals, Sequences, TLC, ReportSystemMC
CONSTANT splitter, router, start_pt, aggr, TimeOut, NUM_OF_PARTS,
saver, end_pt
VARIABLES endpts, aggr_t, aggr_buf

Vars == <<endpts, aggr_t, aggr_buf>>

Endpoints == {start_pt, splitter, router, aggr, saver, end_pt} \cup services

RequestReportChannel == INSTANCE PointToPointChannel 
                        WITH src <- start_pt, dst <- splitter
AServiceResponseChannel == INSTANCE PointToPointChannel 
                           WITH src <- a_service, dst <- aggr
BServiceResponseChannel == INSTANCE PointToPointChannel 
                           WITH src <- b_service, dst <- aggr
CServiceResponseChannel == INSTANCE PointToPointChannel 
                           WITH src <- c_service, dst <- aggr
NotificationChannel == INSTANCE PointToPointChannel 
                       WITH src <- saver, dst <- end_pt
ReportSplitter == INSTANCE Splitter 
                  WITH src <- splitter, dst <- router
Router == INSTANCE ContentBasedRouter 
          WITH src <- router, processors <- services
Aggregator == INSTANCE Aggregator 
              WITH src <- aggr, dst <- saver, time <- aggr_t, buffer <- aggr_buf

TypeInvariant == /\ endpts[start_pt] \in UNION {SubSequence, {NULL}}
                 /\ endpts[splitter] \in UNION {SubSequence, {NULL}, {<<>>}}
                 /\ endpts[router] \in UNION {Record, {NULL}}
                 /\ \A s \in services: endpts[s] \in UNION {reports, {NULL}}
                 /\ Aggregator!TypeInvariant
                 /\ \/ endpts[saver] \in FullReport \/ endpts[saver] = NULL
                 /\ \/ endpts[end_pt] \in FullReport \/ endpts[end_pt] = NULL

ReportGenerated == /\ endpts[end_pt] /= NULL
                   /\ Print(<<"Report received: ", endpts[end_pt]>>, TRUE)

Init == /\ endpts = [e \in Endpoints |->
                            CASE e = start_pt -> ReqMsg
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

GuaranteedDelivery == <>(endpts[end_pt] /= NULL)

Spec == Init /\ [][Next]_Vars /\ WF_Vars(Next)
-----------------------------------------------------------------------------
THEOREM Spec => []TypeInvariant
=============================================================================