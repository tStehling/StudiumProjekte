package lagerpackage.gui;

import java.awt.BorderLayout;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import javax.swing.BorderFactory;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.JTable;
import javax.swing.table.DefaultTableModel;

import lagerpackage.Fach;
import lagerpackage.Hochregallager;
import lagerpackage.Regal;

public class Fahrtweg extends JPanel {
	private static final long serialVersionUID = 1L;
	List<double[]> pointList = new ArrayList<double[]>();
	List<double[]> moveList = new ArrayList<double[]>();
	private double[] currentPoint;
	double regal_abstand = Hochregallager.getRegalAbstand();
	double regal_breite = Fach.getLaenge();
	Hochregallager lager;
	String[] title = new String[] { "x-Position", "y-Position", "z-Position", "delta-x", "delta-y", "delta-z" };

	JTable table;
	DefaultTableModel tableModel;

	public Fahrtweg(Hochregallager lager) {
		this.lager = lager;

		setLayout(null);

		table = new JTable(new String[][] {}, title);

		tableModel = new DefaultTableModel(new String[][] {}, title) {

			private static final long serialVersionUID = 1L;

			@Override
			public boolean isCellEditable(int row, int column) {
				// all cells false
				return false;
			}
		};

		table.setModel(tableModel);

		add(new JScrollPane(table));
		setLayout(new BorderLayout());
		setBorder(BorderFactory.createEmptyBorder(10, 10, 10, 10));
		add(table.getTableHeader(), BorderLayout.PAGE_START);
		add(table, BorderLayout.CENTER);

		table.setModel(tableModel);
	}

	public void zeichne() {
		String[][] pointArray = new String[pointList.size()][];

		double[] p = pointList.get(0);
		pointArray[0] = new String[] { String.valueOf(p[0]), String.valueOf(p[1]), String.valueOf(p[2]), "0", "0",
				"0" };

		for (int i = 1; i < pointList.size(); i++) {
			p = pointList.get(i);
			double[] m = moveList.get(i - 1);
			pointArray[i] = new String[] { String.valueOf(p[0]), String.valueOf(p[1]), String.valueOf(p[2]),
					String.valueOf(m[0]), String.valueOf(m[1]), String.valueOf(m[2]) };
		}

		table = new JTable(pointArray, title);

		tableModel = new DefaultTableModel(pointArray, title) {

			private static final long serialVersionUID = 1L;

			@Override
			public boolean isCellEditable(int row, int column) {
				// all cells false
				return false;
			}
		};
		add(new JScrollPane(table));
		add(table.getTableHeader(), BorderLayout.PAGE_START);
		add(table, BorderLayout.CENTER);

		table.setModel(tableModel);
	}

	public void berechne(Fach fach) {
		double[] start = point(0, 0, 0);
		this.currentPoint = start;

		pointList.add(start);

		if (fach.getRegalIndex() == 0) {
			pointList.add((move(0, Regal.getBreite() - ((fach.getSpaltenIndex() + 0.5) * Fach.getBreite()), 0)));

			pointList.add(move(100, 0, 0));
		} else {
			pointList.add(move(-100, 0, 0));
			// pointList.add(move(0, 200, 0));

			pointList
					.add(move(0, 200 + fach.getRegalIndex() * (regal_breite + regal_abstand) - 0.5 * regal_abstand, 0));
			pointList.add(move(100 + Regal.getBreite() - ((fach.getSpaltenIndex() + 0.5) * Fach.getBreite()), 0, 0));
		}

		pointList.add((move(0, 0, Regal.getHoehe() - Fach.getHoehe() * (fach.getZeilenIndex() + 1))));

		addWayBackPoints();
		addWayBackMoves();
	}

	private double[] point(double x, double y, double z) {
		return new double[] { x, y, z };
	}

	private double[] move(double dx, double dy, double dz) {
		double[] p = new double[] { currentPoint[0] + dx, currentPoint[1] + dy, currentPoint[2] + dz };
		this.currentPoint = p;

		moveList.add(new double[] { dx, dy, dz });

		return p;
	}

	private double[] invertMove(double[] move) {
		return new double[] { -move[0], -move[1], -move[2] };
	}

	private void addWayBackPoints() {
		List<double[]> back = new ArrayList<double[]>(pointList);
		back.remove(back.size() - 1);

		Collections.reverse(back);
		pointList.addAll(back);
	}

	private void addWayBackMoves() {
		List<double[]> way = new ArrayList<double[]>(moveList);

		Collections.reverse(way);

		for (double[] move : way) {
			moveList.add(invertMove(move));
		}
	}

	public List<double[]> getPunkte() {
		return pointList;
	}

	public List<double[]> getMoves() {
		return moveList;
	}

	public List<String> getPunkteString() {
		List<String> coordList = new ArrayList<String>();

		for (double[] c : pointList) {
			coordList.add("(" + c[0] + ";" + c[1] + ";" + c[2] + ")");
		}

		return coordList;
	}

	public List<String> getMoveString() {
		List<String> coordList = new ArrayList<String>();

		for (double[] c : moveList) {
			coordList.add("(" + c[0] + ";" + c[1] + ";" + c[2] + ")");
		}

		return coordList;
	}
}
