// Agent participant in project auction_env

/* Initial beliefs and rules */
rand_exp(R) :- P=math.e**(2*math.random) & R = P / (math.e**2).

/* Initial goals */

!startBudget.

/* Plans */


+!bid[scheme(Sch)]
   <- ?goalArgument(Sch,auction,"Id",Id);
      lookupArtifact(Id,AId);
      focus(AId);
      +init(1);
      !bidAg(AId).
      //bid(math.random * 100 + 10)[artifact_id(ArtId)].

+!startBudget <- +budget(math.random*500 + 110).

+!bidAg(AId) 
	: running("yes")[artifact_id(AId)] &
	  budget(B) &
	  price(P)[artifact_id(AId)] &
  	  rand_exp(R) &
	  I = (1 - R) &
	  P <= B * I
   <- bid[artifact_id(AId)];
   	  .print("Biding bidAg!").
   

+!bidAg(AId)
    : running("yes")[artifact_id(AId)] 
   <- giveUp[artifact_id(AId)];
   	  .print("Giving up bidAg!").

   
+winner(W) : .my_name(W) <- .print("I Won!").

+price(P)[artifact_id(AId)] 
	: running("yes")[artifact_id(AId)] &
	  budget(B) &
	  init(1) &
  	  rand_exp(R) &
	  I = (1 - R) &
	  P <= B * I
   <- bid[artifact_id(AId)];
   	  .print("Biding!").
   

+price(P)[artifact_id(AId)] 
	: running("yes")[artifact_id(AId)] &
      init(1)  
   <- giveUp[artifact_id(AId)];
   	  .print("Giving up!").



{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }

// uncomment the include below to have an agent compliant with its organisation
{ include("$moiseJar/asl/org-obedient.asl") }
