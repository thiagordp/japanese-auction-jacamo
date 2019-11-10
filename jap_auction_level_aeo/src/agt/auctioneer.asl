// Agent auctioneer in project auction_env

/* Initial beliefs and rules */

/* Initial goals */
!do_auction("a1","flight_ticket(paris,athens,date(15,12,2015))").

/* Plans */


+!do_auction(Id,P)
   <- // creates a scheme to coordinate the auction
      .concat("sch_",Id,SchName);
      makeArtifact(SchName, "ora4mas.nopl.SchemeBoard",["src/org/auction_org.xml", doAuction],SchArtId);
      debug(inspector_gui(on))[artifact_id(SchArtId)];
      setArgumentValue(auction,"Id",Id)[artifact_id(SchArtId)];
      setArgumentValue(auction,"Service",P)[artifact_id(SchArtId)];
      .my_name(Me); 
      setOwner(Me)[artifact_id(SchArtId)];  // I am the owner of this scheme!
      focus(SchArtId);
      addScheme(SchName);  // set the group as responsible for the scheme
      commitMission(mAuctioneer)[artifact_id(SchArtId)].



+!start[scheme(Sch)]
   <- ?goalArgument(Sch,auction,"Id",Id);   // retrieve auction Id and service description S
      ?goalArgument(Sch,auction,"Service",S);
      .print("Start scheme ",Sch," for ",S);
      makeArtifact(Id, "auction_env.AuctionArtifact", [], ArtId);
      .print("Auction artifact created for ",S);
      Sch::focus(ArtId);  // place observable properties of this auction in a particular name space
      Sch::start(S, math.random * 100 + 10).
      //.broadcast(achieve,focus(Id));  // ask all others to focus on this new artifact
      //.at("now + 5 seconds", {+!decide(Id)}).

+!decide[scheme(Sch)]
   : Sch::buyers(B) & B == 1
   <- Sch::stop.

+!decide[scheme(Sch)]
	: Sch::buyers(B) & 
	  B >= 1 &
	  Sch::price(P)
   <- Sch::updatePrice(P+1);
   	  .at("now + 1 seconds", {+!decideAg(Sch)});
   	  .print("Updating price!").
   	  
+!decide[scheme(Sch)]
   <- .print("Presentes: []");
	  .print("Leilao encerrado sem ganhador").
	  
+!decide[scheme(Sch)]
   : Sch::buyers(B) & B == 1
   <- Sch::stop.

//Agente 

+!decideAg(Sch)
	: Sch::buyers(B) & 
	  B > 1 &
	  Sch::price(P)
   <- Sch::updatePrice(P+1);
   	  .at("now + 5 seconds", {+!decideAg(Sch)});
   	  .print("Updating price!").

+!decideAg(Sch)
   : Sch::buyers(B) & B == 1
   <- Sch::stop.
   	  
+!decideAg(Sch)
   <- .print("Presentes: []");
	  .print("Leilao encerrado sem ganhador").


+NS::winner(W) : W \== no_winner
   <- ?NS::task(S);
      ?NS::price(V);
      .print("Winner for ", S, " is ",W," with ", V).
      
+oblUnfulfilled( obligation(Ag,_,done(Sch,bid,Ag),_ ) )[artifact_id(AId)]  // it is the case that a bid was not achieved
   <- .print("Participant ",Ag," didn't bid on time! S/he will be placed in a blacklist");
       // TODO: implement an black list artifact
       admCommand("goalSatisfied(bid)")[artifact_id(AId)].


{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }

// uncomment the include below to have an agent compliant with its organisation
{ include("$moiseJar/asl/org-obedient.asl") }
