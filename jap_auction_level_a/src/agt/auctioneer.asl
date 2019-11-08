// Agent auctioneer in project japanese_auction_msg


// Rules
getTimeStamp(Timestamp) :- Timestamp=system.time.

/* Initial beliefs and rules */
iteracao(0).

/* Initial goals */

!start_price.
!init_time.

/* Plans */
+!init_time: getTimeStamp(T) <- +time_init(T).

+!finish_time : getTimeStamp(T) 
	<- 	+time_finish(T); 
		!show_elapsed_time.

// Show Elapsed Time
+!show_elapsed_time : time_init(A) & time_finish(B) 
	<- 	+elapsed_time((B-A)/1000);
		.print("Elapsed: ", (B-A)/1000).



+!start_price: true <- +service(quadro, math.random * 100 + 10).

+service(S,V) 
	:
	.findall(b(V,A),bidok(Service,A),L) &
	.findall(A,bidok(Service,A),LA) &
	iteracao(N)
	<- 	
	.print("Nova rodada do leilão do serviço ", S, " por R$", V);
	.print("Iteracao ", N+1);
	-+iteracao(N+1);
	.broadcast(tell, service(S,V));		
	.print("Broadcasting");
	.wait(10000);		 
	//.at("now + 1 seconds", {+!decide(service(S, V))}).
	!decide(service(S, V)).
					 
				
+!decide(Service)
	: Service = service(S, V) &
	 .findall(A,bidok(Service,A),LA) &
	 .length(LA,X) &
	  X > 1 &
	 Service = service(S, V) & 
	 iteracao(N)
    <-  
	.print("Presentes: ", LA);
    +service(S, V + 1).
  
       
+!decide(Service)
	: Service = service(S, V) &
	  .findall(b(V,A),bidok(Service,A),[b(V,W)| L]) &
	  .length(L,X) &
	  iteracao(N) &
	  X == 0	  
    <- .print("Vencedor para ", Service, " é ",W," com ", V);
       .print("Iteracoes: ", N);
		.print("Presentes: [", W, "]");
		.print("Broadcasting winner");
       .broadcast(tell, winner(Service,W,V));
       !finish_time.


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
