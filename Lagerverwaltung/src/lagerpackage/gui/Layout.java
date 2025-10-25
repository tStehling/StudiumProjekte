package lagerpackage.gui;

import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;
import java.awt.event.WindowListener;
import java.awt.event.WindowAdapter;
import java.awt.event.WindowEvent;

import javax.swing.ButtonGroup;
import javax.swing.JButton;
import javax.swing.JDialog;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JOptionPane;
import javax.swing.JRadioButton;
import javax.swing.JSeparator;
import javax.swing.JTextField;
import javax.swing.SwingConstants;

import lagerpackage.Hochregallager;
import lagerpackage.Speicherverwaltung;

public class Layout extends JFrame {
	private JButton popUpBtnOk, btnInvList, btnTakeName, btnStore, btnTakeID, btnOkNF, btnOkFull, btnSave, btnDontSave;
	private JTextField txtFieldTake, txtFieldStoreName, txtFieldStoreID, txtFieldTakeID, txtFieldAmount, txtFieldSx,
			txtFieldSy, txtFieldSz, txtFieldUnit;
	private JLabel popUpLabel, addNumMSG, lblFS, freeStorage, lblSave;
	private JSeparator seperator;
	private ButtonGroup group;
	private JRadioButton sortName, sortID;

	private JDialog popUpInv, popUpSearchNum, warningNF, warningFull, popUpSave, popUp;

	StoragePanel sPanel;
	Fahrtweg fahrtweg;
	Speicherverwaltung speicherverwaltung;

	private static final long serialVersionUID = 1L;

	public Layout(Handler handler, StoragePanel sPanel, Hochregallager hl, Fahrtweg fahrtweg) {

		super("Lager Manager 3000"); // Das Layout des Standard-Fensters wird festgelegt
		setSize(1200, 700);
		setLayout(null);
		setDefaultCloseOperation(JFrame.DO_NOTHING_ON_CLOSE);
		setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);
		setResizable(false);

		WindowListener exitListener = new WindowAdapter() {

			@Override
			public void windowClosing(WindowEvent e) {
				int confirm = JOptionPane.showOptionDialog(null, "Änderungen speichern?", "Bestätigung",
						JOptionPane.YES_NO_OPTION, JOptionPane.QUESTION_MESSAGE, null, null, null);
				if (confirm == 0) {

					Speicherverwaltung.speichern(hl);

					System.exit(0);
				}
			}
		};
		addWindowListener(exitListener);

		btnInvList = new JButton("Inventarliste anzeigen");
		btnInvList.setBounds(270, 30, 200, 30);
		btnInvList.addActionListener(handler);

		sortName = new JRadioButton("sortieren nach Bezeichnung");
		sortName.setBounds(270, 80, 200, 20);
		sortName.setSelected(true);

		sortID = new JRadioButton("sortieren nach Teilenummer");
		sortID.setBounds(270, 110, 200, 20);

		group = new ButtonGroup();
		group.add(sortName);
		group.add(sortID);

		btnTakeName = new JButton("Ware entnehmen");
		btnTakeName.setBounds(30, 30, 200, 30);
		btnTakeName.addActionListener(handler);

		txtFieldTake = new JTextField("Bezeichnung oder Teilenummer");
		txtFieldTake.setBounds(30, 80, 200, 30);
		txtFieldTake.addMouseListener(new MouseAdapter() {
			@Override
			public void mousePressed(MouseEvent event) {
				txtFieldTake.setText("");
			}
		});

		btnStore = new JButton("Ware einlagern");
		btnStore.setBounds(510, 30, 200, 30);
		btnStore.addActionListener(handler);

		txtFieldStoreName = new JTextField("Bezeichnung");
		txtFieldStoreName.setBounds(510, 80, 200, 30);
		txtFieldStoreName.addMouseListener(new MouseAdapter() {
			@Override
			public void mousePressed(MouseEvent event) {
				txtFieldStoreName.setText("");
			}
		});

		txtFieldStoreID = new JTextField("Teilenummer (optional)");
		txtFieldStoreID.setBounds(510, 130, 200, 30);
		txtFieldStoreID.addMouseListener(new MouseAdapter() {
			@Override
			public void mousePressed(MouseEvent event) {
				txtFieldStoreID.setText("");
			}
		});

		txtFieldAmount = new JTextField("Anzahl der Teile");
		txtFieldAmount.setBounds(510, 180, 200, 30);
		txtFieldAmount.addMouseListener(new MouseAdapter() {
			@Override
			public void mousePressed(MouseEvent event) {
				txtFieldAmount.setText("");
			}
		});

		txtFieldSx = new JTextField("Länge");
		txtFieldSx.setBounds(510, 230, 40, 30);
		txtFieldSx.addMouseListener(new MouseAdapter() {
			@Override
			public void mousePressed(MouseEvent event) {
				txtFieldSx.setText("");
			}
		});

		txtFieldSy = new JTextField("Breite");
		txtFieldSy.setBounds(555, 230, 40, 30);
		txtFieldSy.addMouseListener(new MouseAdapter() {
			@Override
			public void mousePressed(MouseEvent event) {
				txtFieldSy.setText("");
			}
		});

		txtFieldSz = new JTextField("Höhe");
		txtFieldSz.setBounds(600, 230, 40, 30);
		txtFieldSz.addMouseListener(new MouseAdapter() {
			@Override
			public void mousePressed(MouseEvent event) {
				txtFieldSz.setText("");
			}
		});

		txtFieldUnit = new JTextField("Einheit");
		txtFieldUnit.setBounds(645, 230, 50, 30);
		txtFieldUnit.addMouseListener(new MouseAdapter() {
			@Override
			public void mousePressed(MouseEvent event) {
				txtFieldUnit.setText("");
			}
		});

		seperator = new JSeparator();
		seperator.setOrientation(SwingConstants.VERTICAL);
		seperator.setBounds(750, 0, 1, 330);

		lblFS = new JLabel("Die Anzahl der freien Fächer beträgt: ");
		lblFS.setBounds(50, 320, 250, 30);

		int anzahlFreieFächer = hl.getFreieFaecher();
		String anzahlFF = Integer.toString(anzahlFreieFächer);
		freeStorage = new JLabel(anzahlFF);
		freeStorage.setBounds(320, 320, 50, 30);

		this.sPanel = sPanel;
		sPanel.setBounds(0, 350, 1200, 300);
		sPanel.setVisible(true);

		this.fahrtweg = fahrtweg;
		fahrtweg.setBounds(750, 30, 400, 350);
		fahrtweg.setVisible(true);

		add(btnInvList);
		add(sortName);
		add(sortID);
		add(btnTakeName);
		add(txtFieldTake);
		add(btnStore);
		add(txtFieldStoreName);
		add(txtFieldStoreID);
		add(txtFieldAmount);
		add(txtFieldSx);
		add(txtFieldSy);
		add(txtFieldSz);
		add(txtFieldUnit);
		add(seperator);
		add(lblFS);
		add(freeStorage);
		add(sPanel);
		add(fahrtweg);

		setVisible(true);

		// Layout des Pop-up-Fensters bei identischer Bezeichnung wird festgelegt
		popUpSearchNum = new JDialog();
		popUpSearchNum.setModal(true);
		popUpSearchNum.setSize(400, 200);
		popUpSearchNum.setTitle("Mehrere Teile mit identischer Bezeichnung gefunden!");
		popUpSearchNum.setResizable(false);
		popUpSearchNum.setDefaultCloseOperation(JDialog.DISPOSE_ON_CLOSE);
		popUpSearchNum.setLayout(null);

		addNumMSG = new JLabel("Bitte geben Sie die Teilenummer der gesuchten Ware ein.");
		addNumMSG.setBounds(20, 20, 350, 30);

		txtFieldTakeID = new JTextField();
		txtFieldTakeID.setBounds(140, 80, 200, 30);
		txtFieldTakeID.addMouseListener(new MouseAdapter() {
			@Override
			public void mousePressed(MouseEvent event) {
				txtFieldTakeID.setText("");
			}
		});

		btnTakeID = new JButton("Suchen!");
		btnTakeID.setBounds(55, 80, 80, 30);
		btnTakeID.addActionListener(handler);

		popUpSearchNum.add(txtFieldTakeID);
		popUpSearchNum.add(addNumMSG);
		popUpSearchNum.add(btnTakeID);

		// Pop-up-Fensters für jegliche Fehler und Warnungen
		popUp = new JDialog();
		popUp.setModal(true);
		popUp.setSize(400, 200);
		popUp.setTitle("");
		popUp.setResizable(false);
		popUp.setDefaultCloseOperation(JDialog.DISPOSE_ON_CLOSE);
		popUp.setLayout(null);

		popUpLabel = new JLabel("");
		popUpLabel.setBounds(50, 10, 300, 30);

		popUpBtnOk = new JButton("Ok");
		popUpBtnOk.setBounds(160, 80, 80, 30);
		popUpBtnOk.addActionListener(handler);

		popUp.add(popUpLabel);
		popUp.add(popUpBtnOk);

		// PopUp vor dem schließen
		popUpSave = new JDialog();
		popUpSave.setModal(true);
		popUpSave.setSize(400, 200);
		popUpSave.setResizable(false);
		popUpSave.setDefaultCloseOperation(JDialog.DISPOSE_ON_CLOSE);
		popUpSave.setLayout(null);

		lblSave = new JLabel("Möchten Sie vor dem Beenden speichern?");
		lblSave.setBounds(60, 50, 300, 30);

		btnSave = new JButton("Speichern");
		btnSave.setBounds(70, 100, 80, 30);
		btnSave.addActionListener(handler);

		btnDontSave = new JButton("Nicht speichern");
		btnDontSave.setBounds(200, 100, 80, 30);
		btnDontSave.addActionListener(handler);

		popUpSave.add(lblSave);
		popUpSave.add(btnSave);
		popUpSave.add(btnDontSave);
	}

	// Funktion in der das Layout des Pop-up-Fensters festgelegt ist, welches die
	// Inventarliste anzeigt
	public void showInv(String[][] invList) {
		popUpInv = new Inventar(invList);
		popUpInv.setVisible(true);
	}

	public void searchWithNum() {
		popUpSearchNum.setVisible(true);
	}

	// Warnmeldung wenn Teil nciht gefunden wurde
	public void warnNotFound() {
		popUp.setTitle("Die gesuchte Ware konnte nicht gefunden werden");
		popUpLabel.setText("Bitte überprüfen Sie Ihre Eingabe.");
		popUp.setVisible(true);
	}

	// Warnmeldung wenn Lager voll ist
	public void warnFull() {
		popUp.setTitle("Kein freier Lagerplatz!");
		popUpLabel.setText("Alle Lagerplätze sind belegt.");
		popUp.setVisible(true);
	}

	// Warnmeldung wenn das Fach voll ist
	public void warnFieldFull() {
		popUp.setTitle("Fach voll");
		popUpLabel.setText("In diesem Fach ist kein Platz mehr frei");
		popUp.setVisible(true);
	}

	// Warnmeldung bei widersprüchlichen Angaben
	public void warnDataMismath() {
		popUp.setTitle("Fehler");
		popUpLabel.setText("Die angegebenen Daten sind widersprüchlich. ");
		popUp.setVisible(true);
	}

	// Warnmeldung bei mehreren Ergebnissen
	public void warnMultipleResults() {
		popUp.setTitle("Warnung");
		popUpLabel.setText("Es existiert bereits mindestens ein Teil mit dieser Bezeichnung");
		popUp.setVisible(true);
	}

	// Fataler Fehler!!!
	public void warnTeilenummerDoubling() {
		popUp.setTitle("Fataler Fehler!!!");
		popUpLabel.setText("Es gibt eine Dopplung von Teilenummern verschiederner Sorten");
		popUp.setVisible(true);
	}

	// Warnung falls keine Daten aus den Textfeldern angegeben wurden
	public void warnNoInput() {
		popUp.setTitle("Keine Eingabe");
		popUpLabel.setText("Es wurden keine Daten eingetragen.");
		popUp.setVisible(true);
	}

	public void askToSave() {
		popUpSave.setVisible(true);
	}

	public JButton getBtnInvList() {
		return btnInvList;
	}

	public JButton getBtnTakeName() {
		return btnTakeName;
	}

	public JButton getBtnStore() {
		return btnStore;
	}

	public JButton getBtnTakeID() {
		return btnTakeID;
	}

	public JButton getBtnOkNF() {
		return btnOkNF;
	}

	public JButton getBtnOkFull() {
		return btnOkFull;
	}

	public JTextField getTxtFieldTake() {
		return txtFieldTake;
	}

	public JTextField getTxtFieldTakeID() {
		return txtFieldTakeID;
	}

	public JTextField getTxtFieldStoreName() {
		return txtFieldStoreName;
	}

	public JTextField getTxtFieldStoreID() {
		return txtFieldStoreID;
	}

	public JTextField getTxtFieldAmount() {
		return txtFieldAmount;
	}

	public JTextField getTxtFieldSx() {
		return txtFieldSx;
	}

	public JTextField getTxtFieldSy() {
		return txtFieldSy;
	}

	public JTextField getTxtFieldSz() {
		return txtFieldSz;
	}

	public JTextField getTxtFieldUnit() {
		return txtFieldUnit;
	}

	public JDialog getWarningNF() {
		return warningNF;
	}

	public JDialog getWarningFull() {
		return warningFull;
	}

	public JRadioButton getSortID() {
		return sortID;
	}

	public JRadioButton getSortName() {
		return sortName;
	}

	public JDialog getPopUpSearchNum() {
		return popUpSearchNum;
	}

	public JDialog getPopUp() {
		return popUp;
	}

	public JButton getPopUpBtnOk() {
		return popUpBtnOk;
	}

}
