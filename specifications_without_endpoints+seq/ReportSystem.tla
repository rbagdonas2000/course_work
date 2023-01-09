-------------------------------- MODULE ReportSystem --------------------------------
EXTENDS Naturals, Sequences, TLC, ReportSystemMC
CONSTANTS TimeOut, NUM_OF_PARTS, MaxMsgs
VARIABLES start_pt, splitter, router, processor_a, processor_b, processor_c, 
aggr, saver, aggr_t, aggr_buf, end_pt

Vars == <<start_pt, splitter, router, processor_a, processor_b, processor_c, 
            aggr, saver, aggr_t, aggr_buf, end_pt>>

Queues == <<start_pt, splitter, router, processor_a, processor_b, processor_c, 
            aggr, saver, aggr_buf, end_pt>>

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
                   /\ Len(end_pt) > 0
                   /\ Print(<<"Report received: ", end_pt>>, TRUE)

TypeInvariant == /\ \/ start_pt = <<>> 
                    \/ \A i \in 1..Len(start_pt) : start_pt[i] \in SubSequence

                 /\ \/ splitter = <<>> 
                    \/ \A i \in 1..Len(splitter) : splitter[i] \in SubSequence

                 /\ \/ router = <<>> 
                    \/ \A i \in 1..Len(router) : router[i] \in Record  

                 /\ \/ processor_a = <<>> 
                    \/ \A i \in 1..Len(processor_a) : processor_a[i] \in reports

                 /\ \/ processor_b = <<>> 
                    \/ \A i \in 1..Len(processor_b) : processor_b[i] \in reports

                 /\ \/ processor_c = <<>> 
                    \/ \A i \in 1..Len(processor_c) : processor_c[i] \in reports

                 /\ \/ saver = <<>> 
                    \/ \A i \in 1..Len(saver) : saver[i] \in FullReport

                 /\ \/ end_pt = <<>> 
                    \/ \A i \in 1..Len(end_pt) : end_pt[i] \in FullReport

                 /\ Aggregator!TypeInvariant

Init == /\ start_pt = <<ReqMsg>>
        /\ splitter = <<>>
        /\ router = <<>>
        /\ processor_a = <<>>
        /\ processor_b = <<>>
        /\ processor_c = <<>>
        /\ aggr = <<>>
        /\ saver = <<>>
        /\ Aggregator!Init
        /\ end_pt = <<>>
    
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
           /\ UNCHANGED <<start_pt, splitter, router, processor_b, 
                            processor_c, aggr_buf, aggr_t, saver, end_pt>>
        \/ /\ BServiceResponseChannel!Send
           /\ UNCHANGED <<start_pt, splitter, router, processor_a, 
                            processor_c, aggr_buf, aggr_t, saver, end_pt>>
        \/ /\ CServiceResponseChannel!Send
           /\ UNCHANGED <<start_pt, splitter, router, processor_a, 
                            processor_b, aggr_buf, aggr_t, saver, end_pt>>
        \/ /\ Aggregator!Aggregate
           /\ UNCHANGED <<start_pt, splitter, router, processor_a, 
                            processor_b, processor_c, end_pt>>
        \/ /\ NotificationChannel!Send
           /\ UNCHANGED <<start_pt, splitter, router, processor_a, 
                            processor_b, processor_c, aggr_buf, aggr_t, aggr>>
        \/ /\ ReportGenerated
           /\ UNCHANGED Vars

GuaranteedDelivery == <>(Len(end_pt) > 0)

MessageCountNotExceeded == [](\A i \in 1..Len(Queues) : Len(Queues[i]) <= MaxMsgs)

Spec == Init /\ [][Next]_Vars /\ WF_Vars(Next)
-----------------------------------------------------------------------------
THEOREM Spec => []TypeInvariant
=============================================================================