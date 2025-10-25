package lagerpackage;

import java.util.ArrayList;

import java.util.List;

public class Sorte {
	private String bezeichnung;
	private String teilenummer;
	private String hersteller;
	private double[] abmessungen = new double[3];
	private String grundeinheit;
	private List<Fach> lagerorte = new ArrayList<Fach>();

	public Sorte(String bezeichnung, String teilenummer, double[] abmessungen, String grundeinheit) {
		this.bezeichnung = bezeichnung;
		this.teilenummer = teilenummer;
		this.abmessungen = abmessungen;
		this.grundeinheit = grundeinheit;
	}

	public void setTeilenummer(String s) {
		this.teilenummer = s;
	}

	public String getBezeichnung() {
		return bezeichnung;
	}

	public String getTeilenummer() {
		return teilenummer;
	}

	public String getHersteller() {
		return hersteller;
	}

	public double[] getAbmessungen() {
		return abmessungen;
	}

	public String getGrundeinheit() {
		return grundeinheit;
	}

	public void addLagerort(Fach lagerort) {
		if (!lagerorte.contains(lagerort)) {
			lagerorte.add(lagerort);
		}
	}

	// Gibt die Gesamtmenge aller Teile in allen Lagerorten zurück
	public int getMenge() {
		if (lagerorte.size() == 0) {
			return 0;
		}

		int menge = 0;
		for (Fach lagerort : lagerorte) {
			menge += lagerort.getMenge();
		}
		return menge;
	}

	public List<Fach> getLagerorte() {
		return lagerorte;
	}

	public String toString() {
		return bezeichnung + " " + teilenummer + " " + abmessungen[0] + " " + abmessungen[1] + " " + abmessungen[2]
				+ " " + grundeinheit + " " + lagerorte.toString() + "\n";
	}

	public String[] getStringArray() {
		return new String[] { bezeichnung, teilenummer, String.valueOf(getMenge()), String.valueOf(abmessungen[0]),
				String.valueOf(abmessungen[1]), String.valueOf(abmessungen[2]), grundeinheit };
	}

	public Fach getBestenLagerort() {
		for (Fach fach : lagerorte) {
			if (!fach.getIsFull())
				return fach;
		}
		return null;
	}
}
