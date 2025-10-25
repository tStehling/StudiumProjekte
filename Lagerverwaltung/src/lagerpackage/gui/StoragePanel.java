package lagerpackage.gui;

import java.awt.Color;
import java.awt.Graphics;
import java.util.List;

import javax.swing.JLabel;
import javax.swing.JPanel;

import lagerpackage.Fach;
import lagerpackage.Hochregallager;
import lagerpackage.Regal;





public class StoragePanel extends JPanel {
	

	private static final long serialVersionUID = 1L;

	private static final int width = 12, height = 12;
	private static final int margin_top = 40, margin_left = 30;
	private static final int size_horizontal = width + 2, size_vertical = height + 2;
	private static final int spacing_regal = 2;
	
	JLabel lblEmpty, lblOccupied, lblFull;
	
	
	private Color green = new Color(0,200,0);
	private Color yellow = new Color(210,210,0);
	private Color red = new Color(180,0,0);
	
	
	Hochregallager lager;
	
	public StoragePanel(Hochregallager lager) {
		this.lager = lager;
		
		setLayout(null);
		
		lblEmpty = new JLabel("Freie Fächer");
		lblEmpty.setBounds(70, 190, 150, 30);
		add(lblEmpty);
		
		lblOccupied = new JLabel("Teilweise gefüllte Fächer");
		lblOccupied.setBounds(370, 190, 150, 30);
		add(lblOccupied);
		
		lblFull = new JLabel("Volle Fächer");
		lblFull.setBounds(670, 190, 150, 30);
		add(lblFull);
	
	
	
	}
	
	
	protected void paintComponent(Graphics g) {
		super.paintComponent(g);
		
		g.setColor(green);
		g.fillRect(50, 200, width, height);
		
		g.setColor(yellow);
		g.fillRect(350, 200, width, height);
		
		g.setColor(red);
		g.fillRect(650, 200, width, height);
		
		repaint();
		
		for(int i = 0; i<lager.getRegalCount(); i++) {
			
			Regal regal = lager.getRegal(i);
			
			for(int j = 0; j<Regal.getSpaltenCount(); j++) {
				
				List<Fach> spalte = regal.getSpalte(j);
				
				for(int k = 0; k<Regal.getZeilenCount(); k++) {
					
					Fach fach = spalte.get(k);
					
					int x_pos = margin_left + j * size_horizontal + i * ((Regal.getSpaltenCount() * size_horizontal) + spacing_regal);
					int y_pos = margin_top + k * size_vertical;
					
					g.setColor(assignColor(fach));
					g.fillRect(x_pos, y_pos, width, height);
					
					repaint();
					
				}
			}
		}
	
		try {
			Thread.sleep(10);
		} catch (InterruptedException e) {
			e.printStackTrace();
		}
	}                                      
	
	private Color assignColor(Fach cargo) {
		if(cargo.getIsFull()) {
			return red;
		}
		else if(!cargo.getIsFull() && cargo.getSorte() != null) {
			return yellow;
		}
		else {
			return green;
		}
	}
	
	
}
