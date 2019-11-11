// Agent auctioneer in project auction_env

/* Initial beliefs and rules */

/* Initial goals */

/* Plans */

+!start(Id,P)
   <- makeArtifact(Id, "auction_env.AuctionArtifact", [], ArtId);
      .print("Artefato Auction criado para ",P);
      Id::focus(ArtId);  // place observable properties of this auction in a particular name space
      Id::start(P, math.random * 100 + 10);
      .print("Broadcast para focar no artefato ", ArtId)
      .broadcast(achieve,focus(Id));  // ask all others to focus on this new artifact
      .at("now + 2 seconds", {+!decide(Id)}).

+!decide(Id): 
	Id::buyers(B) & 
	B == 1
   <- Id::stop.

+!decide(Id)
	: Id::buyers(B) & 
	  B >= 1 &
	  Id::price(P)
   <- Id::updatePrice(P+1);
   	  .at("now + 5 seconds", {+!decide(Id)});
   	  .print("Presentes: ", B);
   	  .print("Updating price!").
   	  
+!decide(Id)
   <- .print("Presentes: 0");
	  .print("Leilao encerrado sem ganhador").


+NS::winner(W) : W \== no_winner
   <- ?NS::task(S);
      ?NS::price(V);
      .print("Presentes: 1");
      .print("Vencedor para ", S, " é ",W," com ", V).


{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }

// uncomment the include below to have an agent compliant with its organisation
{ include("$moiseJar/asl/org-obedient.asl") }
