// Agent buyer in project japanese_auction_msg

/* Initial beliefs and rules */

power(X,Y,Z) :- Z = X**Y.
rand_exp(R) :- P=math.e**(2*math.random) & R = P / (math.e**2).

/* Initial goals */

!startBudget.

/* Plans */


+!startBudget <- +budget(math.random*500 + 110).

/*
 * Quando receber uma proposta de serviço mas já ter desistido desse ou resolveu voltar (rand > 0.9)
 */
+service(S, V)[source(A)]
	: desiste(service(S, _)) &
	  R = math.random &
	  R > 0.95 						/* 5% de chance (não uniform)de querer voltar ao leilão (mas o leiloeiro não vai deixar) */
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
	  rand_exp(R) &
	  I = (1 - R) &
	  V <= B * I
	  <- .send(A, tell, bid(service(S,V)));
	  	.print("Tell");
	 	.my_name(X);	 	
	 	.print( X, " continua no leilao");
	 	+propose(S, V, I).

/*
 * Em último caso, desiste do leilão
 */
+service(S,V)[source(A)]
	 	:rand_exp(R)
	 <- .send(A, tell, desiste(service(S, V)));
	 	.my_name(Self);
	  	.print("Tell");
	 	.send(Self, tell, desiste(service(S, V)));
	 	.print("Desistindo de ", S, " por ", V).
	 	
/**
 * TODO: Evento pra transferência do valor
 */
	  

{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }

// uncomment the include below to have an agent compliant with its organisation
{ include("$moiseJar/asl/org-obedient.asl") }
