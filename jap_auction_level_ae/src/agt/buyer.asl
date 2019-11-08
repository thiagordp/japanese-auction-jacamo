// Agent participant in project auction_env

/* Initial beliefs and rules */

/* Initial goals */

!startBudget.


/* Plans */

+!focus(A) // goal sent by the auctioneer
   <- lookupArtifact(A,ToolId);
      focus(ToolId).

+!startBudget <- +budget(math.random*500 + 110).

+task(D)[artifact_id(AId)] 
	: running("yes")[artifact_id(AId)] &
	  budget(B) &
	  price(P)[artifact_id(AId)] &
	  I = math.random*2 &
	  P <= B * I
   <- bid[artifact_id(AId)];
   	  .print("Biding task!").
   

+task(D)[artifact_id(AId)] : running("yes")[artifact_id(AId)] 
   <- giveUp[artifact_id(AId)];
   	  .print("Giving up task!").

   
+winner(W) : .my_name(W) <- .print("I Won!").

+price(P)[artifact_id(AId)] 
	: running("yes")[artifact_id(AId)] &
	  budget(B) &
	  I = math.random*2 &
	  P <= B * I
   <- bid[artifact_id(AId)];
   	  .print("Biding!").
   

+price(P)[artifact_id(AId)] : running("yes")[artifact_id(AId)] 
   <- giveUp[artifact_id(AId)];
   	  .print("Giving up!").



{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }

// uncomment the include below to have an agent compliant with its organisation
{ include("$moiseJar/asl/org-obedient.asl") }
