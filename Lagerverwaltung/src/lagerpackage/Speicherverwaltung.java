package lagerpackage;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.PrintStream;
import java.util.InputMismatchException;
import java.util.Scanner;

import javax.swing.JOptionPane;

public class Speicherverwaltung {
	public static String text = "." + File.separator + "Daten" + File.separator + "Gegenstaende.txt";

	public static void einlesen(Hochregallager lager) {
		try {
			File file = new File(text);
			InputStream i = new FileInputStream(file);
			Scanner scan = new Scanner(i);

			while (scan.hasNext()) {
				String bezeichner = null;
				String teilenummer = null;
				try {
					bezeichner = scan.next();
					bezeichner = bezeichner.replace("_", " ");
				} catch (NullPointerException e) {
					try {

					} catch (InputMismatchException f) {
						JOptionPane.showMessageDialog(null,
								"Ungültige Eingabe! \nGeben Sie einen gültigen Bezeichner ein!");
					}

				}
				try {
					teilenummer = scan.next();
				} catch (InputMismatchException e) {
					JOptionPane.showMessageDialog(null, "Ungueltige Eingabe! \n!");
				}
				int menge = scan.nextInt();

				double abmessung_laenge = scan.nextDouble();
				double abmessung_breite = scan.nextDouble();
				double abmessung_hoehe = scan.nextDouble();
				double[] abmessung = new double[3];
				abmessung[0] = abmessung_laenge;
				abmessung[1] = abmessung_breite;
				abmessung[2] = abmessung_hoehe;

				String grundeinheit = scan.next();

				int regal_nummer = scan.nextInt();
				int regal_spalte = scan.nextInt();
				int regal_zeile = scan.nextInt();

				Sorte s = new Sorte(bezeichner, teilenummer, abmessung, grundeinheit);
				if (grundeinheit.equals("m") || grundeinheit.equals("meter")) {
					abmessung[0] = abmessung_laenge / 100;
					abmessung[1] = abmessung_breite / 100;
					abmessung[2] = abmessung_hoehe / 100;
				}
				for (int m = 0; m < menge; m++) {
					Teil t = new Teil(s);
					try {
						lager.einlagern(t, regal_nummer, regal_spalte, regal_zeile);
					} catch (LagerException.fachVoll e) {

					}
				}

			}
			scan.close();

		} catch (IOException e) {
			JOptionPane.showMessageDialog(null, "Ungültige Eingabe");
		}
	}

	public static void speichern(Hochregallager lager) {
		try {
			File datei = new File(text);
			OutputStream raus = new FileOutputStream(datei);
			PrintStream p = new PrintStream(raus);
			for (Sorte l : lager.getInventar()) {
				String bezeichner = l.getBezeichnung();
				bezeichner = bezeichner.replace(" ", "_");
				p.printf("%s %s %d %f %f %f %s %d %d %d %n", bezeichner, l.getTeilenummer(), l.getMenge(),
						l.getAbmessungen()[0], l.getAbmessungen()[1], l.getAbmessungen()[2], l.getGrundeinheit(),
						l.getLagerorte().get(0).getRegalIndex(), l.getLagerorte().get(0).getSpaltenIndex(),
						l.getLagerorte().get(0).getZeilenIndex());

			}
			p.close();

		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

}
