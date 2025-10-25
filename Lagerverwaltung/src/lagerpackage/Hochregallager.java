package lagerpackage;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Random;

import lagerpackage.LagerException.datenWiderspruch;
import lagerpackage.LagerException.fachVoll;
import lagerpackage.LagerException.keineDatenEingegeben;
import lagerpackage.LagerException.lagerVoll;
import lagerpackage.LagerException.mehrereErgebnisse;
import lagerpackage.LagerException.teilNichtGefunden;
import lagerpackage.LagerException.teilenummerDoubling;

public class Hochregallager {
	private static final int REGAL_ANZAHL = 8;
	private static final double REGAL_ABSTAND = 200;

	private SortierenTeilenummer st = new SortierenTeilenummer();
	private SortierenBezeichner sb = new SortierenBezeichner();
	private List<Regal> regale = new ArrayList<Regal>();
	private List<Sorte> inventar = new ArrayList<Sorte>();

	public Hochregallager() {

		for (int i = 0; i < REGAL_ANZAHL; i++) {
			this.regale.add(new Regal(i));
		}
	}

	public Hochregallager(ArrayList<Sorte> inventar) {
		this.setInventar(inventar);
	}

	public List<Sorte> getInventar() {
		return inventar;
	}

	public static double getRegalAbstand() {
		return REGAL_ABSTAND;
	}

	public Regal getRegal(int index) {
		return regale.get(index);
	}

	public int getRegalCount() {
		return this.regale.size();
	}

	public void setInventar(ArrayList<Sorte> inventar) {
		this.inventar = inventar;
	}

	public void einlagern(Teil teil, int regal_index, int spalten_index, int zeilen_index) throws fachVoll {
		if (!inventar.contains(teil.getSorte())) {
			inventar.add(teil.getSorte());
		}
		regale.get(regal_index).einlagern(teil, spalten_index, zeilen_index);
	}

	public Teil erstelleTeil(String bezeichnung, String teilenummer, double laenge, double breite, double hoehe,
			String grundeinheit) throws keineDatenEingegeben, lagerVoll, mehrereErgebnisse, teilenummerDoubling,
			datenWiderspruch, teilNichtGefunden {
		if ((bezeichnung == null && teilenummer == null) || (bezeichnung == "" && teilenummer == ""))
			throw new LagerException.keineDatenEingegeben();
		System.out.println(teilenummer);
		System.out.println(bezeichnung);

		Sorte sorte = null;
		Fach lagerort = null;

		if (bezeichnerExistiert(bezeichnung) || teilenummerExistiert(teilenummer)) {

			if (teilenummerExistiert(teilenummer) && teilenummer != "") {
				sorte = getSorteByTeilenummer(teilenummer);
				if (sorte == null)
					throw new LagerException.teilNichtGefunden();

			}

			if (bezeichnerExistiert(bezeichnung) && bezeichnung != "") {
				List<Sorte> results = getSorteByBezeichnung(bezeichnung);
				if (results.size() > 1 || teilenummer == null)
					throw new LagerException.mehrereErgebnisse();
				if (sorte == null) {
					if (teilenummer.contentEquals(""))
						sorte = results.get(0);
					else {
						sorte = new Sorte(bezeichnung, teilenummer, new double[] { laenge, breite, hoehe },
								grundeinheit);
						lagerort = getSpeicherort();
					}
				}

				if (teilenummerExistiert(teilenummer)) {
					boolean identical = false;
					for (Sorte r : results) {
						if (r == sorte)
							identical = true;
					}
					if (!identical)
						throw new LagerException.datenWiderspruch();
				}
			} else {
				if (sorte != null)
					throw new LagerException.datenWiderspruch();
			}
			if (lagerort == null)
				lagerort = sorte.getBestenLagerort();
		} else if (teilenummer != null && bezeichnung == null) {
			throw new LagerException.teilNichtGefunden();
		} else {
			lagerort = getSpeicherort();
			if (lagerort == null) {
				throw new LagerException.lagerVoll(this);
			}

			if (teilenummer.contentEquals("") || teilenummer == null) {
				Random rand = new Random();
				int max = 99999999;
				int min = 10000000;
				teilenummer = String.valueOf(rand.nextInt((max - min) + 1) + min);
			}
			sorte = new Sorte(bezeichnung, teilenummer, new double[] { laenge, breite, hoehe }, grundeinheit);
		}

		Teil teil = new Teil(sorte);
		teil.setLagerort(lagerort);
		return teil;
	}

	private List<Sorte> getSorteByBezeichnung(String bezeichnung) {
		List<Sorte> results = new ArrayList<Sorte>();

		for (Sorte sorte : inventar) {
			if (sorte.getBezeichnung().contentEquals(bezeichnung))
				results.add(sorte);
		}

		if (results.isEmpty()) {
			return null;
		}

		return results;
	}

	private Sorte getSorteByTeilenummer(String teilenummer) throws teilenummerDoubling {
		List<Sorte> results = new ArrayList<Sorte>();

		for (Sorte sorte : inventar) {
			System.out.println(sorte.getTeilenummer() + " : " + teilenummer + " : "
					+ String.valueOf(sorte.getTeilenummer().contentEquals(teilenummer)));
			if (sorte.getTeilenummer().contentEquals(teilenummer)) {
				results.add(sorte);
			}
		}

		if (results.isEmpty())
			return null;
		if (results.size() > 1)
			throw new LagerException.teilenummerDoubling();
		return results.get(0);
	}

	private Fach getSpeicherort() {
		for (int i = 0; i < REGAL_ANZAHL; i++) {
			Fach fach = regale.get(i).getSpeicherort();
			if (fach != null)
				return fach;
		}
		return null;
	}

	public Fach auslagernBezeichnung(String bezeichnung) {

		if (bezeichnerExistiert(bezeichnung)) {
			Sorte sorte = sucheTeilBezeichner(bezeichnung);
			Teil teil = new Teil(sorte);
			regale.get(sucheTeilBezeichner(bezeichnung).getLagerorte().get(0).getRegalIndex()).auslagern(teil,
					sucheTeilBezeichner(bezeichnung).getLagerorte().get(0).getSpaltenIndex(),
					sucheTeilBezeichner(bezeichnung).getLagerorte().get(0).getZeilenIndex());
			inventar.remove(sucheTeilBezeichner(bezeichnung));

			return sorte.getLagerorte().get(0);
		}
		return null;
	}

	public Fach auslagernTeilenummer(String teilenummer) {
		if (teilenummerExistiert(teilenummer)) {
			Sorte sorte = sucheTeilTeilenummer(teilenummer);
			Teil teil = new Teil(sorte);
			regale.get(sorte.getLagerorte().get(0).getRegalIndex()).auslagern(teil,
					sorte.getLagerorte().get(0).getSpaltenIndex(), sorte.getLagerorte().get(0).getZeilenIndex());
			inventar.remove(teil.getSorte());
			return sorte.getLagerorte().get(0);
		}
		return null;
	}

	// Prüfung ob mehere bezeichner einer Art gibt für entnahme
	public int zaehler(String bezeichnung) {
		int counter = 0;

		for (int i = 0; i < inventar.size(); i++) {
			if (bezeichnung.equals(inventar.get(i).getBezeichnung())) {
				counter++;
			}
		}
		return counter;
	}

	// sortieren nach Teilenummer
	public void sortierenTeilenummer() {
		Collections.sort(inventar, st);
	}

	// sortieren nach Bezeichner
	public void sortierenBezeichner() {
		Collections.sort(inventar, sb);
	}

	public String[][] getInventarString() {
		String[][] invArray = new String[inventar.size()][];
		for (int i = 0; i < inventar.size(); i++) {
			invArray[i] = inventar.get(i).getStringArray();
		}
		return invArray;
	}

	public boolean teilenummerExistiert(String teilenummer) {
		if (teilenummer == null)
			return false;
		for (Sorte sorte : inventar) {
			if (sorte.getTeilenummer().equals(teilenummer)) {
				return true;
			}
		}

		return false;
	}

	public boolean bezeichnerExistiert(String bezeichner) {
		if (bezeichner == null)
			return false;
		for (Sorte sorte : inventar) {
			if (sorte.getBezeichnung().equals(bezeichner)) {
				return true;
			}
		}
		return false;
	}

	public Sorte sucheTeilBezeichner(String bezeichnung) {
		for (int i = 0; i < inventar.size(); i++) {
			if (inventar.get(i).getBezeichnung().equals(bezeichnung)) {
				return inventar.get(i);
			}
		}
		return null;
	}

	public Sorte sucheTeilTeilenummer(String teilenummer) {
		for (int i = 0; i < inventar.size(); i++) {
			if (inventar.get(i).getTeilenummer().equals(teilenummer)) {
				return inventar.get(i);
			}
		}
		return null;
	}

	public int getFreieFaecher() {
		int count = 0;

		for (int i = 0; i < REGAL_ANZAHL; i++) {
			count += regale.get(i).getFreieFaecher();
		}

		return count;
	}

}
