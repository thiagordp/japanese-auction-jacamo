// Agent auctioneer in project japanese_auction_msg

/* Initial beliefs and rules */

/* Initial goals */

!start_price.


/* Plans */

+!start_price: true <- +service(quadro, math.random * 100 + 10).

+service(S,V) <- .broadcast(tell, service(S,V));
				 .at("now + 3 seconds", {+!decide(service(S, V))}).
				 
				 
+!decide(Service)
	: Service = service(S, V) &
	.findall(b(V,A),bidok(Service,A),L) &
	 .length(L,X) &
	  X > 1 &
	 Service = service(S, V)	  
    <-  +service(S, V + 1).
  
       
+!decide(Service)
	: Service = service(S, V) &
	  .findall(b(V,A),bidok(Service,A),[b(V,W)| L]) &
	  .length(L,X) &
	  X == 0	  
    <- .print("Winner for ", Service, " is ",W," with ", V);
       .broadcast(tell, winner(Service,W,V)).



+bid(Service)[source(A)]
	: desiste(Service,_)[source(A)] &
	  Service = service(_, V)
	<- .send(A, tell, reject(Service, V)).

+bid(Service)[source(A)]
	: Service = service(_, V)
	<- +bidok(Service, A).



{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }

// uncomment the include below to have an agent compliant with its organisation
{ include("$moiseJar/asl/org-obedient.asl") }
