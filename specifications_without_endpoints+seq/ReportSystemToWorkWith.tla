-------------------------------- MODULE ReportSystemToWorkWith --------------------------------
EXTENDS Naturals, Sequences, TLC, ReportSystemToWorkWithMC
CONSTANTS TimeOut, NUM_OF_PARTS
VARIABLES adapter, splitter, router, processor_a, processor_b, processor_c, aggr, notif, aggr_t, aggr_buf,
backoffice

Vars == <<adapter, splitter, router, processor_a, processor_b, processor_c, aggr, notif, aggr_t, aggr_buf, backoffice>>

RequestReportChannel == INSTANCE PtPChannelWithQueues WITH src <- adapter, dst <- splitter
ReportSplitter == INSTANCE SplitterWithQueues WITH src <- splitter, dst <- router
Router == INSTANCE CBRWithQueues WITH src <- router
AServiceResponseChannel == INSTANCE PtPChannelWithQueues WITH src <- processor_a, dst <- aggr
BServiceResponseChannel == INSTANCE PtPChannelWithQueues WITH src <- processor_b, dst <- aggr
CServiceResponseChannel == INSTANCE PtPChannelWithQueues WITH src <- processor_c, dst <- aggr
Aggregator == INSTANCE AggregatorWithQueues WITH src <- aggr, dst <- notif, time <- aggr_t, buffer <- aggr_buf
NotificationChannel == INSTANCE PtPChannelWithQueues WITH src <- notif, dst <- backoffice

ReportGenerated == /\ backoffice /= NULL
                   /\ Len(backoffice) > 0
                   /\ Print(<<"Report received: ", backoffice>>, TRUE)

TypeInvariant == /\ \/ adapter = <<>> 
                    \/ \A i \in 1..Len(adapter) : adapter[i] \in SubSequence

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

                 /\ \/ notif = <<>> 
                    \/ \A i \in 1..Len(notif) : notif[i] \in FullReport

                 /\ \/ backoffice = <<>> 
                    \/ \A i \in 1..Len(backoffice) : backoffice[i] \in FullReport

                 /\ Aggregator!TypeInvariant

Init == /\ adapter = <<ReqMsg>>
        /\ splitter = <<>>
        /\ router = <<>>
        /\ processor_a = <<>>
        /\ processor_b = <<>>
        /\ processor_c = <<>>
        /\ aggr = <<>>
        /\ notif = <<>>
        /\ Aggregator!Init
        /\ backoffice = <<>>
    
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