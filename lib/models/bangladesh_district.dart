class BangladeshDistrict {
  final String name;
  final String division;
  final double latitude;
  final double longitude;

  const BangladeshDistrict({
    required this.name,
    required this.division,
    required this.latitude,
    required this.longitude,
  });

  @override
  String toString() => name;

  // All 64 districts of Bangladesh with their coordinates
  static const List<BangladeshDistrict> allDistricts = [
    // Dhaka Division
    BangladeshDistrict(name: 'Dhaka', division: 'Dhaka', latitude: 23.7616, longitude: 90.3492),
    BangladeshDistrict(name: 'Faridpur', division: 'Dhaka', latitude: 23.6070, longitude: 89.8429),
    BangladeshDistrict(name: 'Gazipur', division: 'Dhaka', latitude: 23.9999, longitude: 90.4203),
    BangladeshDistrict(name: 'Gopalganj', division: 'Dhaka', latitude: 23.0050, longitude: 89.8266),
    BangladeshDistrict(name: 'Kishoreganj', division: 'Dhaka', latitude: 24.4449, longitude: 90.7766),
    BangladeshDistrict(name: 'Madaripur', division: 'Dhaka', latitude: 23.1641, longitude: 90.1896),
    BangladeshDistrict(name: 'Manikganj', division: 'Dhaka', latitude: 23.8644, longitude: 90.0047),
    BangladeshDistrict(name: 'Munshiganj', division: 'Dhaka', latitude: 23.5422, longitude: 90.5305),
    BangladeshDistrict(name: 'Narayanganj', division: 'Dhaka', latitude: 23.6238, longitude: 90.4990),
    BangladeshDistrict(name: 'Narsingdi', division: 'Dhaka', latitude: 23.9322, longitude: 90.7151),
    BangladeshDistrict(name: 'Rajbari', division: 'Dhaka', latitude: 23.7574, longitude: 89.6444),
    BangladeshDistrict(name: 'Shariatpur', division: 'Dhaka', latitude: 23.2423, longitude: 90.4348),
    BangladeshDistrict(name: 'Tangail', division: 'Dhaka', latitude: 24.2513, longitude: 89.9167),

    // Chittagong Division
    BangladeshDistrict(name: 'Bandarban', division: 'Chittagong', latitude: 22.1953, longitude: 92.2183),
    BangladeshDistrict(name: 'Brahmanbaria', division: 'Chittagong', latitude: 23.9570, longitude: 91.1119),
    BangladeshDistrict(name: 'Chandpur', division: 'Chittagong', latitude: 23.2332, longitude: 90.6712),
    BangladeshDistrict(name: 'Chittagong', division: 'Chittagong', latitude: 22.3569, longitude: 91.7832),
    BangladeshDistrict(name: 'Comilla', division: 'Chittagong', latitude: 23.4682, longitude: 91.1788),
    BangladeshDistrict(name: 'Cox\'s Bazar', division: 'Chittagong', latitude: 21.4272, longitude: 92.0058),
    BangladeshDistrict(name: 'Feni', division: 'Chittagong', latitude: 23.0159, longitude: 91.3976),
    BangladeshDistrict(name: 'Khagrachhari', division: 'Chittagong', latitude: 23.1193, longitude: 91.9847),
    BangladeshDistrict(name: 'Lakshmipur', division: 'Chittagong', latitude: 22.9447, longitude: 90.8282),
    BangladeshDistrict(name: 'Noakhali', division: 'Chittagong', latitude: 22.8696, longitude: 91.0995),
    BangladeshDistrict(name: 'Rangamati', division: 'Chittagong', latitude: 22.6533, longitude: 92.1751),

    // Rajshahi Division
    BangladeshDistrict(name: 'Bogura', division: 'Rajshahi', latitude: 24.8465, longitude: 89.3772),
    BangladeshDistrict(name: 'Joypurhat', division: 'Rajshahi', latitude: 25.0968, longitude: 89.0227),
    BangladeshDistrict(name: 'Naogaon', division: 'Rajshahi', latitude: 24.7936, longitude: 88.9318),
    BangladeshDistrict(name: 'Natore', division: 'Rajshahi', latitude: 24.4206, longitude: 89.0000),
    BangladeshDistrict(name: 'Nawabganj', division: 'Rajshahi', latitude: 24.5965, longitude: 88.2775),
    BangladeshDistrict(name: 'Pabna', division: 'Rajshahi', latitude: 24.0064, longitude: 89.2372),
    BangladeshDistrict(name: 'Rajshahi', division: 'Rajshahi', latitude: 24.3745, longitude: 88.6042),
    BangladeshDistrict(name: 'Sirajganj', division: 'Rajshahi', latitude: 24.4533, longitude: 89.7006),

    // Khulna Division
    BangladeshDistrict(name: 'Bagerhat', division: 'Khulna', latitude: 22.6602, longitude: 89.7895),
    BangladeshDistrict(name: 'Chuadanga', division: 'Khulna', latitude: 23.6401, longitude: 88.8412),
    BangladeshDistrict(name: 'Jessore', division: 'Khulna', latitude: 23.1697, longitude: 89.2072),
    BangladeshDistrict(name: 'Jhenaidah', division: 'Khulna', latitude: 23.5448, longitude: 89.1539),
    BangladeshDistrict(name: 'Khulna', division: 'Khulna', latitude: 22.8456, longitude: 89.5403),
    BangladeshDistrict(name: 'Kushtia', division: 'Khulna', latitude: 23.9013, longitude: 89.1206),
    BangladeshDistrict(name: 'Magura', division: 'Khulna', latitude: 23.4874, longitude: 89.4198),
    BangladeshDistrict(name: 'Meherpur', division: 'Khulna', latitude: 23.7627, longitude: 88.6318),
    BangladeshDistrict(name: 'Narail', division: 'Khulna', latitude: 23.1725, longitude: 89.5125),
    BangladeshDistrict(name: 'Satkhira', division: 'Khulna', latitude: 22.7185, longitude: 89.0705),

    // Sylhet Division
    BangladeshDistrict(name: 'Habiganj', division: 'Sylhet', latitude: 24.3745, longitude: 91.4156),
    BangladeshDistrict(name: 'Moulvibazar', division: 'Sylhet', latitude: 24.4829, longitude: 91.7774),
    BangladeshDistrict(name: 'Sunamganj', division: 'Sylhet', latitude: 25.0658, longitude: 91.3950),
    BangladeshDistrict(name: 'Sylhet', division: 'Sylhet', latitude: 24.8949, longitude: 91.8687),

    // Barisal Division
    BangladeshDistrict(name: 'Barguna', division: 'Barisal', latitude: 22.1596, longitude: 90.1251),
    BangladeshDistrict(name: 'Barisal', division: 'Barisal', latitude: 22.7010, longitude: 90.3535),
    BangladeshDistrict(name: 'Bhola', division: 'Barisal', latitude: 22.6859, longitude: 90.6482),
    BangladeshDistrict(name: 'Jhalokati', division: 'Barisal', latitude: 22.6406, longitude: 90.1987),
    BangladeshDistrict(name: 'Patuakhali', division: 'Barisal', latitude: 22.3596, longitude: 90.3298),
    BangladeshDistrict(name: 'Pirojpur', division: 'Barisal', latitude: 22.5841, longitude: 89.9720),

    // Rangpur Division
    BangladeshDistrict(name: 'Dinajpur', division: 'Rangpur', latitude: 25.6217, longitude: 88.6354),
    BangladeshDistrict(name: 'Gaibandha', division: 'Rangpur', latitude: 25.3287, longitude: 89.5281),
    BangladeshDistrict(name: 'Kurigram', division: 'Rangpur', latitude: 25.8055, longitude: 89.6361),
    BangladeshDistrict(name: 'Lalmonirhat', division: 'Rangpur', latitude: 25.9923, longitude: 89.2847),
    BangladeshDistrict(name: 'Nilphamari', division: 'Rangpur', latitude: 25.9317, longitude: 88.8560),
    BangladeshDistrict(name: 'Panchagarh', division: 'Rangpur', latitude: 26.3411, longitude: 88.5541),
    BangladeshDistrict(name: 'Rangpur', division: 'Rangpur', latitude: 25.7439, longitude: 89.2752),
    BangladeshDistrict(name: 'Thakurgaon', division: 'Rangpur', latitude: 26.0336, longitude: 88.4616),

    // Mymensingh Division
    BangladeshDistrict(name: 'Jamalpur', division: 'Mymensingh', latitude: 24.9375, longitude: 89.9370),
    BangladeshDistrict(name: 'Mymensingh', division: 'Mymensingh', latitude: 24.7471, longitude: 90.4203),
    BangladeshDistrict(name: 'Netrokona', division: 'Mymensingh', latitude: 24.8709, longitude: 90.7291),
    BangladeshDistrict(name: 'Sherpur', division: 'Mymensingh', latitude: 25.0204, longitude: 90.0152),
  ];

  // Get districts by division
  static List<BangladeshDistrict> getDistrictsByDivision(String division) {
    return allDistricts.where((district) => district.division == division).toList();
  }

  // Get all divisions
  static List<String> getAllDivisions() {
    return allDistricts.map((district) => district.division).toSet().toList()..sort();
  }

  // Find district by name
  static BangladeshDistrict? findByName(String name) {
    try {
      return allDistricts.firstWhere((district) => district.name == name);
    } catch (e) {
      return null;
    }
  }
}