// Agent auctioneer in project auction_env

/* Initial beliefs and rules */

/* Initial goals */

/* Plans */

+!start(Id,P)
   <- makeArtifact(Id, "auction_env.AuctionArtifact", [], ArtId);
      .print("Auction artifact created for ",P);
      Id::focus(ArtId);  // place observable properties of this auction in a particular name space
      Id::start(P, math.random * 100 + 10);
      .broadcast(achieve,focus(Id));  // ask all others to focus on this new artifact
      .at("now + 5 seconds", {+!decide(Id)}).

+!decide(Id): Id::buyers(B) & B == 1
   <- Id::stop.

+!decide(Id)
	: Id::buyers(B) & 
	  B >= 1 &
	  Id::price(P)
   <- Id::updatePrice(P+1);
   	  .at("now + 5 seconds", {+!decide(Id)});
   	  .print("Updating price!").
   	  
+!decide(Id)
   <- .print("Presentes: []");
	  .print("Leilao encerrado sem ganhador").


+NS::winner(W) : W \== no_winner
   <- ?NS::task(S);
      ?NS::price(V);
      .print("Winner for ", S, " is ",W," with ", V).


{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }

// uncomment the include below to have an agent compliant with its organisation
{ include("$moiseJar/asl/org-obedient.asl") }
