package lagerpackage;

public class LagerException {
	public static class lagerVoll extends Exception {
		private static final long serialVersionUID = 1L;

		public lagerVoll(Hochregallager lager) {
			super();
		}
	}

	public static class fachVoll extends Exception {
		private static final long serialVersionUID = 1L;

		public fachVoll(Fach fach) {
			super();
		}
	}

	public static class keineDatenEingegeben extends Exception {
		private static final long serialVersionUID = 1L;

		public keineDatenEingegeben() {
			super();
		}
	}

	public static class teilenummerDoubling extends Exception {
		private static final long serialVersionUID = 1L;

		public teilenummerDoubling() {
			super();
		}
	}

	public static class mehrereErgebnisse extends Exception {
		private static final long serialVersionUID = 1L;

		public mehrereErgebnisse() {
			super();
		}
	}

	public static class datenWiderspruch extends Exception {
		private static final long serialVersionUID = 1L;

		public datenWiderspruch() {
			super();
		}
	}

	public static class teilNichtGefunden extends Exception {
		private static final long serialVersionUID = 1L;

		public teilNichtGefunden() {
			super();
		}
	}
}
