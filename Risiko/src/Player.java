
public class Player {
	
	private int stones = 10;
	private String name;
	private boolean attacker = false;
	public Integer[] rolledDices = new Integer[stones];
	
	
	public Player(String name){
		 this.name = name;
	}
	
	
	public String getName() {
		return name;
	}
	
	
	public void setStones(int stones) {
		this.stones = stones;
	}
	public int getStones() {
		return stones;
	}
	
	
	public void setStatus(boolean attacker) {
		this.attacker = attacker;
	}
	public boolean getStatus() {
		return attacker;
	}

	
	

}
