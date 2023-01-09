-------------------------------- MODULE ReportSystem --------------------------------
EXTENDS Naturals, Sequences, TLC, ReportSystemMC
CONSTANTS TimeOut, NUM_OF_PARTS
VARIABLES start_pt, splitter, router, processor_a, processor_b, processor_c, 
aggr, saver, aggr_t, aggr_buf, end_pt

Vars == <<start_pt, splitter, router, processor_a, processor_b, processor_c, 
            aggr, saver, aggr_t, aggr_buf, end_pt>>

RequestReportChannel == INSTANCE PointToPointChannel 
                        WITH src <- start_pt, dst <- splitter
ReportSplitter == INSTANCE Splitter 
                  WITH src <- splitter, dst <- router
Router == INSTANCE ContentBasedRouter 
          WITH src <- router
AServiceResponseChannel == INSTANCE PointToPointChannel 
                           WITH src <- processor_a, dst <- aggr
BServiceResponseChannel == INSTANCE PointToPointChannel 
                           WITH src <- processor_b, dst <- aggr
CServiceResponseChannel == INSTANCE PointToPointChannel 
                           WITH src <- processor_c, dst <- aggr
Aggregator == INSTANCE Aggregator 
              WITH src <- aggr, dst <- saver, time <- aggr_t, buffer <- aggr_buf
NotificationChannel == INSTANCE PointToPointChannel 
                       WITH src <- saver, dst <- end_pt

ReportGenerated == /\ end_pt /= NULL
                   /\ Print(<<"Report received: ", end_pt>>, TRUE)


TypeInvariant == /\ start_pt \in UNION {SubSequence, {NULL}}
                 /\ splitter \in UNION {SubSequence, {NULL}, {<<>>}}
                 /\ router \in UNION {Record, {NULL}}
                 /\ processor_a \in UNION {reports, {NULL}}
                 /\ processor_b \in UNION {reports, {NULL}}
                 /\ processor_c \in UNION {reports, {NULL}}
                 /\ Aggregator!TypeInvariant
                 /\ \/ saver \in FullReport \/ saver = NULL
                 /\ \/ end_pt \in FullReport \/ end_pt = NULL

Init == /\ start_pt = ReqMsg
        /\ splitter = NULL
        /\ router = NULL
        /\ processor_a = NULL
        /\ processor_b = NULL
        /\ processor_c = NULL
        /\ aggr = NULL
        /\ saver = NULL
        /\ Aggregator!Init
        /\ end_pt = NULL
    
Next == \/ /\ RequestReportChannel!Send
           /\ UNCHANGED <<router, processor_a, processor_b, processor_c, 
                            aggr, aggr_buf, aggr_t, saver, end_pt>>
        \/ /\ ReportSplitter!SplitAndSend
           /\ UNCHANGED <<start_pt, processor_a, processor_b, processor_c, 
                            aggr, aggr_buf, aggr_t, saver, end_pt>>
        \/ /\ Router!Route
           /\ UNCHANGED <<start_pt, splitter, aggr, aggr_buf, 
                            aggr_t, saver, end_pt>>
        \/ /\ AServiceResponseChannel!Send
           /\ UNCHANGED <<start_pt, splitter, router, processor_b, processor_c, 
                            aggr_buf, aggr_t, saver, end_pt>>
        \/ /\ BServiceResponseChannel!Send
           /\ UNCHANGED <<start_pt, splitter, router, processor_a, processor_c, 
                            aggr_buf, aggr_t, saver, end_pt>>
        \/ /\ CServiceResponseChannel!Send
           /\ UNCHANGED <<start_pt, splitter, router, processor_a, processor_b, 
                            aggr_buf, aggr_t, saver, end_pt>>
        \/ /\ Aggregator!Aggregate
           /\ UNCHANGED <<start_pt, splitter, router, processor_a, processor_b, 
                            processor_c, end_pt>>
        \/ /\ NotificationChannel!Send
           /\ UNCHANGED <<start_pt, splitter, router, processor_a, processor_b, 
                            processor_c, aggr_buf, aggr_t, aggr>>
        \/ /\ ReportGenerated
           /\ UNCHANGED Vars

GuaranteedDelivery == <>(end_pt /= NULL)

Spec == Init /\ [][Next]_Vars /\ WF_Vars(Next)
-----------------------------------------------------------------------------
THEOREM Spec => []TypeInvariant
=============================================================================