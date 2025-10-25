package lagerpackage;

public class Teil {
	private Sorte sorte;
	private Fach lagerort;

	public Teil(Sorte sorte) {
		this.sorte = sorte;
	}

	public Sorte getSorte() {
		return this.sorte;
	}

	public void setLagerort(Fach lagerort) {
		this.lagerort = lagerort;

		this.sorte.addLagerort(lagerort);
	}

	public Fach getLagerort() {
		return lagerort;
	}
}
