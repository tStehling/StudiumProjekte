package lagerpackage;

import lagerpackage.gui.Gui;

public class Main {

	public static void main(String[] args) {
		// TODO Auto-generated method stub

		Hochregallager lager = new Hochregallager();

		Speicherverwaltung.einlesen(lager);

		new Gui(lager);
	}

}
