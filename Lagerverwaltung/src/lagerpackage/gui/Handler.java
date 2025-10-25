package lagerpackage.gui;

import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

import lagerpackage.Fach;
import lagerpackage.Hochregallager;
import lagerpackage.LagerException.datenWiderspruch;
import lagerpackage.LagerException.fachVoll;
import lagerpackage.LagerException.keineDatenEingegeben;
import lagerpackage.LagerException.lagerVoll;
import lagerpackage.LagerException.mehrereErgebnisse;
import lagerpackage.LagerException.teilNichtGefunden;
import lagerpackage.LagerException.teilenummerDoubling;
import lagerpackage.Teil;

public class Handler implements ActionListener {

	Layout layout;
	Hochregallager hl;
	Fahrtweg fahrtweg;

	public void setLayout(Layout layout) {
		this.layout = layout;
	}

	public void setFahrtweg(Fahrtweg fahrtweg) {
		this.fahrtweg = fahrtweg;
	}

	public void setLager(Hochregallager lager) {
		this.hl = lager;
	}

	@Override
	public void actionPerformed(ActionEvent e) { // Den verschiedenen Knöpfen auf der GUI wird eine Funktion zugewiesen
		if (e.getSource() == layout.getBtnInvList()) {
			clickedList();
		}
		if (e.getSource() == layout.getBtnTakeName()) {
			clickedTake();
		}
		if (e.getSource() == layout.getBtnStore()) {
			clickedStore();
		}
		if (e.getSource() == layout.getBtnTakeID()) {
			clickedTakeByID();
		}
		if (e.getSource() == layout.getBtnOkNF()) {
			layout.getWarningNF().dispose();
		}
		if (e.getSource() == layout.getBtnOkFull()) {
			layout.getWarningFull().dispose();
		}
		if (e.getSource() == layout.getPopUpBtnOk()) {
			layout.getPopUp().dispose();
		}

	}

	private void clickedList() {

		if (layout.getSortID().isSelected()) {
			hl.sortierenTeilenummer(); // Die Inventarliste wird nach Teilenummer sortiert angezeigt
			layout.showInv(hl.getInventarString());

		} else { // Die Inventarliste wird nach Bezeichnung sortiert angezeigt

			hl.sortierenBezeichner();
			layout.showInv(hl.getInventarString());

		}

	}

	private void clickedTake() {
		Fach fach = null;
		if (layout.getTxtFieldTake().getText().equals("Bezeichnung oder Teilenummer")
				|| layout.getTxtFieldTake().getText().equals("")) { // Falls nichts eingegeben wurde wird die
																	// Suchfunktion nicht gestartet
			return;
		} else {
			if (!hl.bezeichnerExistiert(layout.getTxtFieldTake().getText())
					&& !hl.teilenummerExistiert(layout.getTxtFieldTake().getText())) { // Wenn sich das gesuchte Teil
																						// nicht im Lager befindet wird
																						// eine Fehlermeldung angezeigt.
				layout.warnNotFound();
			} else { // Das gesuchte Teil wird dem Lager entnommen
				if (hl.zaehler(layout.getTxtFieldTake().getText()) >= 2) { // Sind mehrere Teile mit identischer
																			// Bezeichnung vorhanden, wird die
																			// Teilenummer vom Benutzer abgerfragt
					layout.searchWithNum();
					fach = hl.auslagernTeilenummer(layout.getTxtFieldTakeID().getText());
				}
				if (!hl.bezeichnerExistiert(layout.getTxtFieldTake().getText())
						&& hl.teilenummerExistiert(layout.getTxtFieldTake().getText())) {

					fach = hl.auslagernTeilenummer(layout.getTxtFieldTake().getText());
				} else {
					fach = hl.auslagernBezeichnung(layout.getTxtFieldTake().getText());
				}
			}
		}
		if (fach != null) {
			fahrtweg.berechne(fach);
			fahrtweg.zeichne();
		}
	}

	private void clickedStore() {
		if (layout.getTxtFieldStoreName().getText().equals("Bezeichnung")
				|| layout.getTxtFieldStoreName().getText().equals("")) { // Falls nichts eingegeben wurde wird die
			// Suchfunktion nicht gestartet
			return;
		}
		if (layout.getTxtFieldStoreID().getText().equals("Teilenummer (optional)")
				|| layout.getTxtFieldStoreID().getText().equals("")) { // Falls nichts eingegeben wurde wird die
																		// Suchfunktion nicht gestartet
			layout.getTxtFieldStoreID().setText("");
		}
		if (layout.getTxtFieldAmount().getText().equals("Anzahl der Teile")
				|| layout.getTxtFieldAmount().getText().equals("")) { // Falls nichts eingegeben wurde wird die
																		// Suchfunktion nicht gestartet
			return;
		}

		// Falls nichts eingegeben wurde wird die Suchfunktion nicht gestartet
		if (layout.getTxtFieldSx().getText().equals("Länge") || layout.getTxtFieldSx().getText().equals("")) {
			return;
		}
		if (layout.getTxtFieldSy().getText().equals("Breite") || layout.getTxtFieldSy().getText().equals("")) { // Falls
																												// nichts
																												// eingegeben
																												// wurde
																												// wird
																												// die
																												// Suchfunktion
																												// nicht
																												// gestartet
			return;
		}
		if (layout.getTxtFieldSz().equals("Höhe") || layout.getTxtFieldSz().getText().equals("")) { // Falls nichts
																									// eingegeben wurde
																									// wird die
																									// Suchfunktion
																									// nicht gestartet
			return;
		}
		if (layout.getTxtFieldUnit().getText().equals("Einheit") || layout.getTxtFieldUnit().getText().equals("")) { // Falls
																														// nichts
																														// eingegeben
																														// wurde
																														// wird
																														// die
																														// Suchfunktion
																														// nicht
																														// gestartet
			return;
		}

		Teil teil;
		try {
			teil = hl.erstelleTeil(layout.getTxtFieldStoreName().getText(), layout.getTxtFieldStoreID().getText(),
					Double.parseDouble(layout.getTxtFieldSx().getText()),
					Double.parseDouble(layout.getTxtFieldSy().getText()),
					Double.parseDouble(layout.getTxtFieldSz().getText()), layout.getTxtFieldUnit().getText());
			double menge = Double.parseDouble(layout.getTxtFieldAmount().getText());
			for (int i = 0; i < menge; i++) {
				hl.einlagern(teil, teil.getLagerort().getRegalIndex(), teil.getLagerort().getSpaltenIndex(),
						teil.getLagerort().getZeilenIndex());
			}

		} catch (NumberFormatException e) {
			e.printStackTrace();
		} catch (keineDatenEingegeben e) {
			layout.warnNoInput();
		} catch (lagerVoll e) {
			layout.warnFull();
		} catch (mehrereErgebnisse e) {
			layout.warnMultipleResults();
		} catch (teilenummerDoubling e) {
			layout.warnTeilenummerDoubling();
		} catch (datenWiderspruch e) {
			layout.warnDataMismath();
		} catch (fachVoll e) {
			layout.warnFieldFull();
		} catch (teilNichtGefunden e) {
			layout.warnNotFound();
		}

	}

	private void clickedTakeByID() {
		// Falls nichts eingegeben wurde wird die Suchfunktion nicht gestartet
		if (layout.getTxtFieldTakeID().getText().equals("")) {
			return;
		} else {
			if (hl.teilenummerExistiert(layout.getTxtFieldTake().getText())) {
				hl.auslagernTeilenummer(layout.getTxtFieldTake().getText());
				layout.getPopUpSearchNum().dispose();
				// Wenn sich das gesuchte Teil nicht im Lager befindet wird eine Fehlermeldung
				// angezeigt.

			} else { // Das gesuchte Teil wird aus dem Lager entnommen
				layout.warnNotFound();
			}
		}
	}

}
