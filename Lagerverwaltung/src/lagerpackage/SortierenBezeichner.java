package lagerpackage;

import java.util.Comparator;

public class SortierenBezeichner implements Comparator<Sorte> {

	@Override
	public int compare(Sorte a, Sorte b) {
		return a.getBezeichnung().compareTo(b.getBezeichnung());
	}

}
