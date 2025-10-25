package lagerpackage.gui;

import java.awt.BorderLayout;

import javax.swing.BorderFactory;
import javax.swing.JDialog;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.JTable;
import javax.swing.table.DefaultTableModel;

public class Inventar extends JDialog {
	private static final long serialVersionUID = 1L;

	String[] title = new String[] { "Bezeichnung", "Teilenummer", "Menge", "Länge", "Briete", "Höhe", "Grundeinheit" };

	public Inventar(Object[][] invList) {
		setTitle("Inventarliste");
		setSize(700, 700);

		setDefaultCloseOperation(JDialog.DISPOSE_ON_CLOSE);

		JTable table = new JTable(invList, title);

		DefaultTableModel tableModel = new DefaultTableModel(invList, title) {

			private static final long serialVersionUID = 1L;

			@Override
			public boolean isCellEditable(int row, int column) {
				// all cells false
				return false;
			}
		};

		table.setModel(tableModel);

		JPanel content = new JPanel();

		content.add(new JScrollPane(table));
		content.setLayout(new BorderLayout());
		content.setBorder(BorderFactory.createEmptyBorder(10, 10, 10, 10));
		content.add(table.getTableHeader(), BorderLayout.PAGE_START);
		content.add(table, BorderLayout.CENTER);

		add(content);

		table.setModel(tableModel);
	}
}
