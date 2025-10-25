package lagerpackage.gui;

import lagerpackage.Hochregallager;

public class Gui {
	Hochregallager lager = new Hochregallager();

	public Gui(Hochregallager lager) {
		this.lager = lager;
		thread.start();
	}

	Thread thread = new Thread(new Runnable() {

		@Override
		public void run() {
			StoragePanel spanel = new StoragePanel(lager);
			Fahrtweg fahrtweg = new Fahrtweg(lager);
			Handler handler = new Handler();
			Layout layout = new Layout(handler, spanel, lager, fahrtweg);
			handler.setLayout(layout);
			handler.setLager(lager);
			handler.setFahrtweg(fahrtweg);
		}
	});
}
