package lagerpackage;

import java.util.Comparator;

// Klasse zur Sortierung der Teilenummer, Comparator Interface implemtiert aus der Standardbibliothek
public class SortierenTeilenummer implements Comparator<Sorte> {

	@Override
	public int compare(Sorte a, Sorte b) {
		return a.getTeilenummer().compareTo(b.getTeilenummer());
	}

}
