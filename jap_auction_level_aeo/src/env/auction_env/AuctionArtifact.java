// CArtAgO artifact code for project auction_env

package auction_env;

import java.util.LinkedList;

import javax.swing.JOptionPane;

import cartago.*;
import jade.util.leap.List;
import jason.asSyntax.Atom;
import cartago.*;

public class AuctionArtifact extends Artifact {

    String currentWinner = "no_winner";
    
    String idAgentProp;
    
    LinkedList<AgentId> blockList = new LinkedList<AgentId>();
    
    LinkedList<AgentId> activeList = new LinkedList<AgentId>();
    
    public void init()  {
        // observable properties
        defineObsProperty("running",     "no");
        //defineObsProperty("best_bid",    Double.MAX_VALUE);
        defineObsProperty("winner",      new Atom(currentWinner)); // Atom is a Jason type
        
        defineObsProperty("buyers",     0);
            
    }

    @OPERATION public void start(String task, Double price)  {
    	
    	if(!getCreatorId().equals(getCurrentOpAgentId()) )
        	failed("You are not allowed to do it");
    	
        if (getObsProperty("running").stringValue().equals("yes"))
            failed("The protocol is already running and so you cannot start it!");     
        
        defineObsProperty("task", task);
        
        defineObsProperty("price", price);
               
        getObsProperty("running").updateValue("yes");
        
        
    }

    @OPERATION public void stop()  {
    	
    	if(!getCreatorId().equals(getCurrentOpAgentId()) )
        	failed("You are not allowed to do it");
    	
        if (! getObsProperty("running").stringValue().equals("yes"))
            failed("The protocol is not running, why to stop it?!");

        
        currentWinner = activeList.remove(0).toString();
        
        getObsProperty("running").updateValue("no");
        getObsProperty("winner").updateValue(new Atom(currentWinner));
    }

    @OPERATION public void bid() {
    	
    	AgentId currentOpAgentId = getCurrentOpAgentId();
    	
    	if(blockList.contains(currentOpAgentId))
    		failed("You can not bid for this auction, beacause you already gave up!");
    	
        if (getObsProperty("running").stringValue().equals("no"))
            failed("You can not bid for this auction, it is not running!");
        
        if(!activeList.contains(currentOpAgentId))
        	activeList.add(currentOpAgentId); // Armazena os Id dos agentes ativos 

        //ObsProperty opCurrentValue  = getObsProperty("best_bid");
        
        //if (bidValue < opCurrentValue.doubleValue()) {  // the bid is better than the previous
            //opCurrentValue.updateValue(bidValue);
            //currentWinner = getCurrentOpAgentId().getAgentName(); // the name of the agent doing this operation
       // }
        
        System.out.println("Received bid  from "+getCurrentOpAgentId().getAgentName()+" for "+getObsProperty("task").stringValue());
        
        getObsProperty("buyers").updateValue(activeList.size());
    }
    
    @OPERATION public void giveUp() {
    	
    	AgentId currentOpAgentId = getCurrentOpAgentId();
    	
    	if(activeList.contains(currentOpAgentId))
    		activeList.remove(currentOpAgentId);
    	
    	if(!blockList.contains(currentOpAgentId))
    		blockList.add(currentOpAgentId);
    	
    	getObsProperty("buyers").updateValue(activeList.size());
    		
    }
    
    @OPERATION public void updatePrice(Double p) {
    	
    	if(!getCreatorId().equals(getCurrentOpAgentId()) )
        	failed("You are not allowed to do it");
    	
    	getObsProperty("price").updateValue(p);
    		
    }
    
}
