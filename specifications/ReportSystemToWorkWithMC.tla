-------------------------------- MODULE ReportSystemToWorkWithMC --------------------------------
EXTENDS Naturals, Sequences
CONSTANT a_service, b_service, c_service, reportA, reportB, reportC, NULL, reports, services

Record == [elem:reports, routeTo:services]


ReqMsg == <<[elem |-> reportA, routeTo |-> a_service], 
            [elem |-> reportB, routeTo |-> b_service], 
            [elem |-> reportC, routeTo |-> c_service]>>

SubSequence == {
            <<[elem |-> reportA, routeTo |-> a_service], 
              [elem |-> reportB, routeTo |-> b_service], 
              [elem |-> reportC, routeTo |-> c_service]>>,

            <<[elem |-> reportA, routeTo |-> a_service], 
              [elem |-> reportC, routeTo |-> c_service], 
              [elem |-> reportB, routeTo |-> b_service]>>,

            <<[elem |-> reportB, routeTo |-> b_service], 
              [elem |-> reportA, routeTo |-> a_service], 
              [elem |-> reportC, routeTo |-> c_service]>>,

            <<[elem |-> reportB, routeTo |-> b_service], 
              [elem |-> reportC, routeTo |-> c_service], 
              [elem |-> reportA, routeTo |-> a_service]>>,

            <<[elem |-> reportC, routeTo |-> c_service], 
              [elem |-> reportA, routeTo |-> a_service], 
              [elem |-> reportB, routeTo |-> b_service]>>,

            <<[elem |-> reportC, routeTo |-> c_service], 
              [elem |-> reportB, routeTo |-> b_service], 
              [elem |-> reportA, routeTo |-> a_service]>>,
            
            <<[elem |-> reportA, routeTo |-> a_service]>>,
            
            <<[elem |-> reportB, routeTo |-> b_service]>>,

            <<[elem |-> reportC, routeTo |-> c_service]>>,

            <<[elem |-> reportA, routeTo |-> a_service], 
              [elem |-> reportB, routeTo |-> b_service]>>,

            <<[elem |-> reportA, routeTo |-> a_service], 
              [elem |-> reportC, routeTo |-> c_service]>>,

            <<[elem |-> reportB, routeTo |-> b_service], 
              [elem |-> reportA, routeTo |-> a_service]>>,

            <<[elem |-> reportB, routeTo |-> b_service], 
              [elem |-> reportC, routeTo |-> c_service]>>, 

            <<[elem |-> reportC, routeTo |-> c_service], 
              [elem |-> reportA, routeTo |-> a_service]>>,

            <<[elem |-> reportC, routeTo |-> c_service], 
              [elem |-> reportB, routeTo |-> b_service]>>
            }

FullReport == Seq(reports)

Items == UNION {SubSequence, Record, reports, FullReport, {NULL, <<>>}}

=============================================================================