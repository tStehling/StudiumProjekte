import java.util.Arrays;
import java.util.Collections;
import java.util.Random;

public class Game {
	
	private int roundCount = 0;
	
    
	public void play(){
    	
    	Player player1 = new Player("Spieler1");
    	
    	Player player2 = new Player("Spieler2");
    	
    	update(player1, player2);
    }
    
    
    private void update(Player p1, Player p2) {
    	
    	while(p1.getStones() > 0 & p2.getStones() > 0) {
    		if(roundCount % 2 == 0) {
    			p1.setStatus(true);
    			p2.setStatus(false);
    		}
    		else {
    			p1.setStatus(false);
    			p2.setStatus(true);
    		}
    		
    		rollDice(p1);
    		rollDice(p2);
    		evaluator(p1, p2);
    		
    		roundCount +=1;
    		System.out.println("***********************************");
    	}
    }

    private void rollDice(Player player){        
    	Random dice = new Random();
    	
    	
    	for(int i = 0; i < player.getStones(); i++) {
    		Integer roll = dice.nextInt(6) + 1;
    		player.rolledDices[i] = roll;
    		}
    	Arrays.sort(player.rolledDices, Collections.reverseOrder());
    	
    	if(player.getStatus() == true) {
    		System.out.print(player.getName());
    		System.out.print(" - Angreifer");
    		System.out.print(":   ");
    		printRolls(player);
    		System.out.println();
    	}
    	else {
    		System.out.print(player.getName());
    		System.out.print(" - Verteidiger");
    		System.out.print(": ");
    		printRolls(player);
    		System.out.println();
    	}
    }

    
    private void printRolls(Player player){      //gibt die gewürfelten Zahlen aus
    	
    	for(int i = 0; i < player.getStones(); i++) {
    		System.out.print(player.rolledDices[i]);
    		System.out.print(" ");
    	}
    }
    
    
    private void evaluator(Player p1, Player p2) {
    	int p1minus = 0, p2minus = 0;
 
    	for(int i = 0; i < Math.min(p1.getStones(), p2.getStones()); i++) {
    		if(p1.getStatus()) {										//Spieler1 ist Angreifer
    			 				
    			if(p1.rolledDices[i] > p2.rolledDices[i]) {
    				p2minus +=1;
    			}
    			if(p1.rolledDices[i] <= p2.rolledDices[i]) {
    				p1minus += 1;
    			}
    		}
    		
    		if(p2.getStatus()) {										//Spieler2 ist Angreifer
    			
    			if(p2.rolledDices[i] > p1.rolledDices[i]) {
    				p1minus += 1;
    			}
    			if(p2.rolledDices[i] <= p1.rolledDices[i]) {
    				p2minus +=1;
    			}
    		}
    	}
    	p1.setStones(p1.getStones() - p1minus);
    	p2.setStones(p2.getStones() - p2minus);
    	
    	if(p1.getStones() == 0) {
    		System.out.println("***********************************");
    		System.out.println("Gratulation! Spieler2 hat gewonnen!");
    	}
    	if(p2.getStones() == 0) {
    		System.out.println("***********************************");
    		System.out.println("Gratulation! Spieler1 hat gewonnen!");
    	}
    }
    
}
