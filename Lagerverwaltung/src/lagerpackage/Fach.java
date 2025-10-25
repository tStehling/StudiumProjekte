package lagerpackage;

import java.util.ArrayList;

import java.util.List;

import lagerpackage.LagerException.fachVoll;

public class Fach {
	private static final double LAENGE = 200;
	private static final double BREITE = 200;
	private static final double HOEHE = 200;

	private Sorte sorte;
	private List<Teil> inhalt = new ArrayList<Teil>();
	private boolean full = false;
	private int regalIndex;
	private int spaltenIndex;
	private int zeilenIndex;

	private int capacity;

	public Fach(int regalIndex, int spaltenIndex, int zeilenIndex) {
		this.regalIndex = regalIndex;
		this.spaltenIndex = spaltenIndex;
		this.zeilenIndex = zeilenIndex;
	}

	public Fach(Sorte sorte) {
		this.sorte = sorte;

	}

	private void setSorte(Sorte sorte) {
		this.sorte = sorte;
		setCapacity();
	}

	private void setCapacity() {
		int space_l = (int) Math.floor(LAENGE / sorte.getAbmessungen()[0]);
		int space_b = (int) Math.floor(BREITE / sorte.getAbmessungen()[1]);
		int space_h = (int) Math.floor(HOEHE / sorte.getAbmessungen()[2]);

		capacity = space_l * space_b * space_h;
	}

	public int getCapacity() {
		return capacity;
	}

	public Sorte getSorte() {
		return sorte;
	}

	public boolean getIsFull() {
		return full;
	}

	public void setIsFull(boolean full) {
		this.full = full;
	}

	public void einlagern(Teil teil) throws fachVoll {
		if (sorte == null)
			setSorte(teil.getSorte());
		if (getFreeSpace() == 0) {
			throw new LagerException.fachVoll(this);
		}

		inhalt.add(teil);
		teil.setLagerort(this);

		if (getFreeSpace() == 0)
			full = true;
	}

	public void auslagern(Teil teil) {
		inhalt.remove(teil);
		this.sorte = null;
		teil.setLagerort(null);
	}

	public int getMenge() {
		return inhalt.size();
	}

	public int getRegalIndex() {
		return regalIndex;
	}

	public int getSpaltenIndex() {
		return spaltenIndex;
	}

	public int getZeilenIndex() {
		return zeilenIndex;
	}

	public static double getBreite() {
		return BREITE;
	}

	public static double getLaenge() {
		return LAENGE;
	}

	public static double getHoehe() {
		return HOEHE;
	}

	public String toString() {
		return this.regalIndex + " " + this.spaltenIndex + " " + this.zeilenIndex;
	}

	public int getFreeSpace() {
		return capacity - inhalt.size();
	}
}
