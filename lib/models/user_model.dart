class UserModel {
  final String id;
  final String name;
  final String email;
  final String passwordHash;
  final int score;
  final int rank;
  final List<String> solvedChallenges;
  final String avatarInitials;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.passwordHash = '',
    this.score = 0,
    this.rank = 0,
    this.solvedChallenges = const [],
    required this.avatarInitials,
  });

  UserModel copyWith({
    String? name,
    String? email,
    String? passwordHash,
    int? score,
    int? rank,
    List<String>? solvedChallenges,
  }) =>
      UserModel(
        id: id,
        name: name ?? this.name,
        email: email ?? this.email,
        passwordHash: passwordHash ?? this.passwordHash,
        score: score ?? this.score,
        rank: rank ?? this.rank,
        solvedChallenges: solvedChallenges ?? this.solvedChallenges,
        avatarInitials: avatarInitials,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'passwordHash': passwordHash,
        'score': score,
        'rank': rank,
        'solvedChallenges': solvedChallenges,
      };

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id'] ?? '',
        name: json['name'] ?? '',
        email: json['email'] ?? '',
        passwordHash: json['passwordHash'] ?? '',
        score: json['score'] ?? 0,
        rank: json['rank'] ?? 0,
        solvedChallenges: List<String>.from(json['solvedChallenges'] ?? []),
        avatarInitials: (json['name'] as String? ?? '??')
            .split(' ')
            .take(2)
            .map((e) => e.isNotEmpty ? e[0] : '')
            .join()
            .toUpperCase(),
      );
}
