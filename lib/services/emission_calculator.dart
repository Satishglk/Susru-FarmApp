/// Standard reference emission factors used for the demo's carbon footprint
/// estimate. These are simplified Tier-1-style defaults (IPCC-style orders of
/// magnitude) meant to illustrate the calculation, not certified figures.
class EmissionFactors {
  // Enteric fermentation: kg CH4 per head per year.
  static const Map<String, double> entericCh4PerHeadPerYear = {
    'Cattle': 61.0,
    'Buffalo': 55.0,
    'Goat': 5.0,
    'Sheep': 5.0,
    'Pig': 1.5,
    'Horse': 18.0,
    'Poultry': 0.0,
    'Other': 10.0,
  };

  // Manure management: kg CH4 per head per year, by method. These vary a lot
  // by climate/system in reality; values below rank methods relative to each
  // other for demo purposes (pasture lowest, lagoon highest, digester captures
  // most of the CH4 so its net factor is low).
  static const Map<String, double> manureCh4Factor = {
    'Pasture / Range': 1.0,
    'Solid Storage': 2.0,
    'Liquid / Slurry': 10.0,
    'Anaerobic Lagoon': 25.0,
    'Daily Spread': 1.0,
    'Biogas Digester': 0.5,
  };

  // Manure management: kg N2O per head per year, by method.
  static const Map<String, double> manureN2oFactor = {
    'Pasture / Range': 0.2,
    'Solid Storage': 0.5,
    'Liquid / Slurry': 0.3,
    'Anaerobic Lagoon': 0.1,
    'Daily Spread': 0.2,
    'Biogas Digester': 0.05,
  };

  static const double dieselKgCo2PerLitre = 2.68;

  // Default India grid average; user-adjustable in Settings.
  static const double defaultElectricityKgCo2PerKwh = 0.82;

  // GWP100 (AR4) conversion factors.
  static const double ch4Gwp = 25.0;
  static const double n2oGwp = 298.0;
}

class EmissionBreakdown {
  final double entericCo2e;
  final double manureCo2e;
  final double dieselCo2e;
  final double electricityCo2e;

  EmissionBreakdown({
    required this.entericCo2e,
    required this.manureCo2e,
    required this.dieselCo2e,
    required this.electricityCo2e,
  });

  double get totalCo2e =>
      entericCo2e + manureCo2e + dieselCo2e + electricityCo2e;
}

class EmissionCalculator {
  static EmissionBreakdown calculate({
    required String species,
    required int count,
    required String manureMethod,
    required double dieselLitres,
    required double electricityKwh,
    double electricityFactorOverride = EmissionFactors.defaultElectricityKgCo2PerKwh,
  }) {
    final entericCh4 =
        (EmissionFactors.entericCh4PerHeadPerYear[species] ?? 10.0) * count;
    final manureCh4 =
        (EmissionFactors.manureCh4Factor[manureMethod] ?? 2.0) * count;
    final manureN2o =
        (EmissionFactors.manureN2oFactor[manureMethod] ?? 0.2) * count;

    final entericCo2e = entericCh4 * EmissionFactors.ch4Gwp;
    final manureCo2e = (manureCh4 * EmissionFactors.ch4Gwp) +
        (manureN2o * EmissionFactors.n2oGwp);
    final dieselCo2e = dieselLitres * EmissionFactors.dieselKgCo2PerLitre;
    final electricityCo2e = electricityKwh * electricityFactorOverride;

    return EmissionBreakdown(
      entericCo2e: entericCo2e,
      manureCo2e: manureCo2e,
      dieselCo2e: dieselCo2e,
      electricityCo2e: electricityCo2e,
    );
  }
}
