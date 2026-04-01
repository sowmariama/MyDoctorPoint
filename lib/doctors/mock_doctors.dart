// lib/doctors/mock_doctors.dart

class MockDoctor {
  final String id;
  final String fullName;
  final String specialty;
  final String hospital;
  final String about;
  final String? photoUrls;
  final List<String> workingDays;
  final List<String> workingHours;
  final Map<String, int> fees;
  final double rating;
  final int experienceYears;

  MockDoctor({
    required this.id,
    required this.fullName,
    required this.specialty,
    required this.hospital,
    required this.about,
    this.photoUrls,
    required this.workingDays,
    required this.workingHours,
    required this.fees,
    required this.rating,
    required this.experienceYears,
  });
}

final List<MockDoctor> mockDoctors = [
  MockDoctor(
    id: '1',
    fullName: 'Dr. Fatou Ndiaye',
    specialty: 'Cardiologue',
    hospital: 'Hôpital Principal de Dakar',
    about: 'Spécialiste en cardiologie avec 12 ans d\'expérience. Diplômée de l\'Université Cheikh Anta Diop.',
    photoUrls: 'https://randomuser.me/api/portraits/women/1.jpg',
    workingDays: ['lun.', 'mar.', 'mer.', 'jeu.', 'ven.'],
    workingHours: ['09:00', '10:00', '11:00', '14:00', '15:00', '16:00'],
    fees: {'voice': 10000, 'message': 5000, 'video': 15000},
    rating: 4.8,
    experienceYears: 12,
  ),
  MockDoctor(
    id: '2',
    fullName: 'Dr. Mamadou Diallo',
    specialty: 'Dentiste',
    hospital: 'Clinique Dentaire Fann',
    about: 'Chirurgien-dentiste, spécialiste en implantologie et esthétique dentaire.',
    photoUrls: 'https://randomuser.me/api/portraits/men/2.jpg',
    workingDays: ['mar.', 'mer.', 'jeu.', 'ven.', 'sam.'],
    workingHours: ['10:00', '11:00', '14:00', '15:00', '16:00'],
    fees: {'voice': 8000, 'message': 4000, 'video': 12000},
    rating: 4.9,
    experienceYears: 8,
  ),
  MockDoctor(
    id: '3',
    fullName: 'Dr. Aissatou Sow',
    specialty: 'Pédiatre',
    hospital: 'Centre Hospitalier pour Enfants',
    about: 'Pédiatre, experte en développement de l\'enfant et vaccinations.',
    photoUrls: 'https://randomuser.me/api/portraits/women/2.jpg',
    workingDays: ['lun.', 'mer.', 'ven.'],
    workingHours: ['08:30', '09:30', '10:30', '14:00', '15:30'],
    fees: {'voice': 7000, 'message': 3500, 'video': 10000},
    rating: 4.7,
    experienceYears: 10,
  ),
  MockDoctor(
    id: '4',
    fullName: 'Dr. Cheikh Mbaye',
    specialty: 'Généraliste',
    hospital: 'Cabinet Médical Mermoz',
    about: 'Médecin généraliste, consultations à domicile disponibles.',
    photoUrls: 'https://randomuser.me/api/portraits/men/3.jpg',
    workingDays: ['lun.', 'mar.', 'mer.', 'jeu.', 'ven.', 'sam.'],
    workingHours: ['08:00', '09:00', '10:00', '11:00', '14:00', '15:00', '16:00'],
    fees: {'voice': 6000, 'message': 3000, 'video': 9000},
    rating: 4.6,
    experienceYears: 15,
  ),
  MockDoctor(
    id: '5',
    fullName: 'Dr. Marie Diouf',
    specialty: 'Gynécologue',
    hospital: 'Clinique de la Femme',
    about: 'Gynécologue-obstétricienne, suivi de grossesse, fertilité.',
    photoUrls: 'https://randomuser.me/api/portraits/women/3.jpg',
    workingDays: ['lun.', 'mar.', 'jeu.', 'ven.'],
    workingHours: ['09:00', '10:00', '11:00', '14:00', '15:00'],
    fees: {'voice': 12000, 'message': 6000, 'video': 18000},
    rating: 4.9,
    experienceYears: 14,
  ),
];