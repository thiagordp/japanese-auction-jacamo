// Agent buyer in project japanese_auction_msg

/* Initial beliefs and rules */

/* Initial goals */

!startBudget.

/* Plans */

+!startBudget <- +budget(math.random*500 + 110).

+service(S,V)[source(A)]
	: budget(B) &
	 I = math.random*2 &
	 V <= B * I
	 <- .send(A, tell, bid(service(S,V)));
	 	.my_name(X);
	 	.print( X, " enviando proposta");
	 	+propose(S, V, I).

+service(S,V)[source(A)]
	 <- .send(A, tell, desiste(service(S,V)));
	 	.my_name(X);
	 	.print(X, " desistindo").
	  


{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }

// uncomment the include below to have an agent compliant with its organisation
{ include("$moiseJar/asl/org-obedient.asl") }
