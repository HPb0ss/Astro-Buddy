enum ObjectCategory { planet, star, deepSky, moon }

enum EquipmentTier { nakedEye, binoculars, smallTelescope, largeTelescope }

class CelestialObject {
  final String id;
  final String name;
  final String alternateName;
  final String constellation;
  final ObjectCategory category;
  final double magnitude;
  final double altitude; // Degrees above horizon
  final double azimuth; // Degrees 0-360
  final EquipmentTier minEquipment;
  final String descriptionBrief;
  final String descriptionIntermediate;
  final String descriptionDeep;
  final String observationTip;
  final String distance;
  final String bestTimeWindow;
  final int observabilityScore; // 0-100

  const CelestialObject({
    required this.id,
    required this.name,
    required this.alternateName,
    required this.constellation,
    required this.category,
    required this.magnitude,
    required this.altitude,
    required this.azimuth,
    required this.minEquipment,
    required this.descriptionBrief,
    required this.descriptionIntermediate,
    required this.descriptionDeep,
    required this.observationTip,
    required this.distance,
    required this.bestTimeWindow,
    required this.observabilityScore,
  });

  String get equipmentLabel {
    switch (minEquipment) {
      case EquipmentTier.nakedEye:
        return 'Naked Eye';
      case EquipmentTier.binoculars:
        return 'Binoculars';
      case EquipmentTier.smallTelescope:
        return 'Small Scope (3-4")';
      case EquipmentTier.largeTelescope:
        return 'Telescope (6"+)';
    }
  }
}

class HourlyObservability {
  final String hourLabel; // e.g. "8 PM"
  final int score; // 0-100
  final double cloudCover; // %
  final bool isMoonUp;

  const HourlyObservability({
    required this.hourLabel,
    required this.score,
    required this.cloudCover,
    required this.isMoonUp,
  });
}

class MockAstroData {
  static const List<HourlyObservability> tonightHourlyForecast = [
    HourlyObservability(hourLabel: '7 PM', score: 45, cloudCover: 25, isMoonUp: true),
    HourlyObservability(hourLabel: '8 PM', score: 62, cloudCover: 15, isMoonUp: true),
    HourlyObservability(hourLabel: '9 PM', score: 78, cloudCover: 10, isMoonUp: false),
    HourlyObservability(hourLabel: '10 PM', score: 88, cloudCover: 4, isMoonUp: false),
    HourlyObservability(hourLabel: '11 PM', score: 92, cloudCover: 3, isMoonUp: false),
    HourlyObservability(hourLabel: '12 AM', score: 90, cloudCover: 5, isMoonUp: false),
    HourlyObservability(hourLabel: '1 AM', score: 85, cloudCover: 8, isMoonUp: false),
    HourlyObservability(hourLabel: '2 AM', score: 74, cloudCover: 14, isMoonUp: false),
    HourlyObservability(hourLabel: '3 AM', score: 60, cloudCover: 30, isMoonUp: false),
  ];

  static const List<CelestialObject> sampleObjects = [
    CelestialObject(
      id: 'saturn',
      name: 'Saturn',
      alternateName: 'The Ringed Planet',
      constellation: 'Aquarius',
      category: ObjectCategory.planet,
      magnitude: 0.6,
      altitude: 48.2,
      azimuth: 145.0,
      minEquipment: EquipmentTier.binoculars,
      descriptionBrief:
          'The sixth planet from the Sun, famous for its majestic system of icy rings visible through small optics.',
      descriptionIntermediate:
          'Saturn is an oblate gas giant primarily made of hydrogen and helium. Its rings span over 282,000 km but are just tens of meters thick. With 10x binoculars, it appears distinctly oval; with a 3" telescope, the Cassini Division becomes discernible.',
      descriptionDeep:
          'Physical radius 58,232 km, surface gravity 10.44 m/s². The rings are held in resonance by shepherd moons like Prometheus and Pandora. Ring inclination angle varies over an approximate 29.5-year orbital cycle.',
      observationTip:
          'Look southeast around 10:30 PM. With 10x binoculars, mount on a tripod to steady the image and see the elliptical outline. Titan is visible as an 8th-magnitude speck.',
      distance: '1.34 billion km (8.96 AU)',
      bestTimeWindow: '10:00 PM - 01:30 AM',
      observabilityScore: 92,
    ),
    CelestialObject(
      id: 'm45',
      name: 'Pleiades',
      alternateName: 'Messier 45 / Seven Sisters',
      constellation: 'Taurus',
      category: ObjectCategory.deepSky,
      magnitude: 1.6,
      altitude: 62.4,
      azimuth: 110.0,
      minEquipment: EquipmentTier.nakedEye,
      descriptionBrief:
          'A glittering open cluster of hot blue luminous stars that looks like a miniature dipper in the autumn and winter sky.',
      descriptionIntermediate:
          'Messier 45 contains over 1,000 confirmed stars formed roughly 100 million years ago. The cluster is passing through a faint reflection nebula composed of interstellar dust.',
      descriptionDeep:
          'Trumpler type II,3,r open cluster located in Taurus. Tidal radius approximately 43 light-years. Core radius 4.5 light-years. Distance precisely calibrated via Gaia DR3 parallax measurements.',
      observationTip:
          'Best viewed with binoculars or unaided eye. Use averted vision to see fainter outer cluster members and faint nebulosity around Merope.',
      distance: '444 light-years',
      bestTimeWindow: '11:00 PM - 03:00 AM',
      observabilityScore: 89,
    ),
    CelestialObject(
      id: 'jupiter',
      name: 'Jupiter',
      alternateName: 'The Giant Planet',
      constellation: 'Aries',
      category: ObjectCategory.planet,
      magnitude: -2.5,
      altitude: 35.8,
      azimuth: 95.0,
      minEquipment: EquipmentTier.nakedEye,
      descriptionBrief:
          'The solar system\'s largest world, blazing brilliant white in the eastern sky accompanied by four Galilean moons.',
      descriptionIntermediate:
          'Jupiter contains more mass than all other planets combined. Even modest 7x50 binoculars reveal Io, Europa, Ganymede, and Callisto dancing in orbit along the Jovian equatorial plane.',
      descriptionDeep:
          'Atmospheric composition ~90% H2, 10% He. Great Red Spot is an anticyclonic storm raging for >350 years. Magnetosphere is the largest continuous structure in the Solar System.',
      observationTip:
          'Track the movement of the 4 Galilean moons over just two hours to observe orbital mechanics in real time.',
      distance: '620 million km (4.14 AU)',
      bestTimeWindow: '09:30 PM - 04:00 AM',
      observabilityScore: 95,
    ),
    CelestialObject(
      id: 'andromeda',
      name: 'Andromeda Galaxy',
      alternateName: 'Messier 31 / NGC 224',
      constellation: 'Andromeda',
      category: ObjectCategory.deepSky,
      magnitude: 3.4,
      altitude: 54.1,
      azimuth: 75.0,
      minEquipment: EquipmentTier.binoculars,
      descriptionBrief:
          'The closest major spiral galaxy to our Milky Way, containing over one trillion stars and hurtling towards us.',
      descriptionIntermediate:
          'Under Bortle 4 or darker skies, M31 appears as an elongated hazy glow. Binoculars reveal the bright core and faint outer halo. In telescopes, companion dwarf galaxies M32 and M110 appear.',
      descriptionDeep:
          'Barred spiral galaxy (SA(s)b) with mass estimate ~1.5 × 10¹² M☉. Approaching the Milky Way at roughly 110 km/s, predicted merger in ~4.5 billion years into an elliptical galaxy ("Milkomeda").',
      observationTip:
          'Locate the Great Square of Pegasus, star-hop north through Mirach and Mu Andromedae. From Bortle 4, direct vision shows the core; averted vision exposes the 3-degree disk.',
      distance: '2.537 million light-years',
      bestTimeWindow: '08:30 PM - 02:00 AM',
      observabilityScore: 82,
    ),
    CelestialObject(
      id: 'moon',
      name: 'Waxing Crescent Moon',
      alternateName: 'Luna',
      constellation: 'Virgo',
      category: ObjectCategory.moon,
      magnitude: -8.0,
      altitude: 22.0,
      azimuth: 240.0,
      minEquipment: EquipmentTier.nakedEye,
      descriptionBrief:
          'Earth\'s natural satellite showing a delicate silver sliver with earthshine illuminating the unlit face.',
      descriptionIntermediate:
          'At 12% illumination, the lunar terminator highlights dramatic crater relief along Mare Crisium and Langrenus with long shadows emphasizing crater rim topography.',
      descriptionDeep:
          'Mean orbital radius 384,400 km with synchronous tidal lock. Surface composed of lunar maria (basaltic floodplains) and cratered anorthositic highlands.',
      observationTip:
          'Focus along the terminator line (where day meets night) where shadow contrast reveals rim peaks and central crater mounds.',
      distance: '382,100 km',
      bestTimeWindow: '07:15 PM - 09:10 PM',
      observabilityScore: 76,
    ),
  ];
}
