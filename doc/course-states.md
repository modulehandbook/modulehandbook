# Course State Machine


````
stateDiagram-v2

   accTitle: Course Progress States

   classDef in_progress fill:#FF88BB;
   classDef in_review fill:#FAA810
   classDef ready_for_councils fill:#77A2E1
   classDef done fill:#8FD14F
 
    [*] --> In_Progress
    In_Progress --> In_Review: Finish Writing
    In_Review --> In_Progress: Changes Required
    
    In_Progress --> Ready_For_Councils: No Changes Required
    Ready_For_Councils --> In_Progress: Changes Required
    Ready_For_Councils --> Done: Decisions Complete

    class In_Progress in_progress
    class In_Review in_review
    class Ready_For_Councils ready_for_councils
    class Done done


```