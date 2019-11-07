// Agent buyer in project japanese_auction_msg

/* Initial beliefs and rules */

rand(R) :- a(X).

/* Initial goals */

!startBudget.

/* Plans */


+!startBudget <- +budget(math.random*500 + 110).

/*
 * Quando receber uma proposta de serviço mas já ter desistido desse ou resolveu voltar (rand > 0.9)
 */
+service(S, V)[source(A)]
	: desiste(service(S, _)) &
	  X = math.random &
	  X < 0.95 						/* 5% de chance de querer voltar ao leilão (mas o leiloeiro não vai deixar) */
	<- .print("Recebi oferta de ", S, ", mas já desisti.").

/*
 * Quando receber uma proposta de serviço e:
 * - Tiver um budget definido
 * - Ter a intenção (I) de pagar o valor oferecido 
 * 
 * Quanto menor a intenção, menor deve ser o valor para entrar/continuar na disputa,
 * mesmo que o comprador tenha dinheiro suficiente para cobrir a proposta.
 */
+service(S,V)[source(A)]
	: budget(B) &  
	  I = math.min(math.random * 2, 1) & 
	  V <= B * I
	  <- .send(A, tell, bid(service(S,V)));
	 	.my_name(X);
	 	.print( X, " continua no leilao");
	 	+propose(S, V, I).

/*
 * Em último caso, desiste do leilão
 */
+service(S,V)[source(A)]
	 <- .send(A, tell, desiste(service(S, V)));
	 	.my_name(Self);
	 	.send(Self, tell, desiste(service(S, V)));
	 	.print("Desistindo de ", S, " por ", V).
	 	
/**
 * TODO: Evento pra transferência do valor
 */
	  

{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }

// uncomment the include below to have an agent compliant with its organisation
{ include("$moiseJar/asl/org-obedient.asl") }
