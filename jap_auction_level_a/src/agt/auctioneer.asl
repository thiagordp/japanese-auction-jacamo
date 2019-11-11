// Agent auctioneer in project japanese_auction_msg


// Rules


/* Initial beliefs and rules */


/* Initial goals */

!start_price.

/* Plans */

+!start_price: true <- +service(quadro, math.random * 100 + 10).

+service(S,V) 
	:
	.findall(b(V,A),bidok(Service,A),L) &
	.findall(A,bidok(Service,A),LA) 
	<- 	
	.print("Nova rodada do leilão do serviço ", S, " por R$", V);
	.broadcast(tell, service(S,V));		
	.print("Broadcasting");
	.wait(20000);		 
	//.at("now + 1 seconds", {+!decide(service(S, V))}).
	!decide(service(S, V)).
					 
				
+!decide(Service)
	: Service = service(S, V) &
	 .findall(A,bidok(Service,A),LA) &
	 .length(LA,X) &
	  X > 1 &
	 Service = service(S, V) 
    <-  
	.print("Presentes: ", LA);
    +service(S, V + 1).
  
       
+!decide(Service)
	: Service = service(S, V) &
	  .findall(b(V,A),bidok(Service,A),[b(V,W)| L]) &
	  .length(L,X) &
	  X == 0	  
    <- .print("Vencedor para ", Service, " é ",W," com ", V);
		.print("Presentes: [", W, "]");
		.print("Broadcasting winner");
       .broadcast(tell, winner(Service,W,V)).


+!decide(Service)
	 <-
	 .print("Presentes: []");
	 .print("Leilao encerrado sem ganhador").
	        
+bid(Service)[source(A)]
	:
	 Service = service(S, V) &
	 desiste(service(S, _))[source(A)]
	 
	<- .send(A, tell, reject(Service, V));
	.print("Tell Reject").

+bid(Service)[source(A)]
	: Service = service(_, V)
	<- +bidok(Service, A).



{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }

// uncomment the include below to have an agent compliant with its organisation
{ include("$moiseJar/asl/org-obedient.asl") }
