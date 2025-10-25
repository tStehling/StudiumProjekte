package lagerpackage;

import java.util.ArrayList;

import java.util.List;

import lagerpackage.LagerException.fachVoll;

public class Regal {
	private static final int ZEILEN_COUNT = 10;
	private static final int SPALTEN_COUNT = 10;
	private List<List<Fach>> faecher = new ArrayList<List<Fach>>(); // Spalte<Zeile>

	public Regal(int regalIndex) {
		for (int i = 0; i < SPALTEN_COUNT; i++) {
			faecher.add(new ArrayList<Fach>());
			for (int j = 0; j < ZEILEN_COUNT; j++) {
				faecher.get(i).add(new Fach(regalIndex, i, j));
			}
		}
	}

	public List<Fach> getSpalte(int index) {
		return faecher.get(index);
	}

	public List<Fach> getZeile(int index) {
		List<Fach> zeile = new ArrayList<Fach>();
		for (int i = 0; i < ZEILEN_COUNT; i++) {
			zeile.add(faecher.get(i).get(index));
		}
		return zeile;
	}

	public void einlagern(Teil teil, int spalten_index, int zeilen_index) throws fachVoll {
		faecher.get(spalten_index).get(zeilen_index).einlagern(teil);
	}

	public void auslagern(Teil teil, int spalten_index, int zeilen_index) {
		faecher.get(spalten_index).get(zeilen_index).auslagern(teil);

	}

	public static int getZeilenCount() {
		return ZEILEN_COUNT;
	}

	public static int getSpaltenCount() {
		return SPALTEN_COUNT;
	}

	public static double getHoehe() {
		return ZEILEN_COUNT * Fach.getHoehe();
	}

	public static double getBreite() {
		return SPALTEN_COUNT * Fach.getBreite();
	}

	public int getFreieFaecher() {
		int count = 0;

		for (List<Fach> spalte : faecher) {
			for (Fach fach : spalte) {
				if (fach.getSorte() == null)
					count++;
			}
		}

		return count;
	}

	public Fach getSpeicherort() {
		for (List<Fach> spalte : faecher) {
			for (Fach fach : spalte) {
				if (fach.getSorte() == null)
					return fach;
			}
		}
		return null;
	}

}
