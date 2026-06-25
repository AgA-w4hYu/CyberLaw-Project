class CtfChallengeModel {
  final String id;
  final String title;
  final String category;
  final String difficulty;
  final String description;
  final String hint;
  final String flag;
  final int points;
  final bool isSolved;

  const CtfChallengeModel({
    required this.id,
    required this.title,
    required this.category,
    required this.difficulty,
    required this.description,
    required this.hint,
    required this.flag,
    required this.points,
    this.isSolved = false,
  });

  CtfChallengeModel copyWith({bool? isSolved}) => CtfChallengeModel(
        id: id,
        title: title,
        category: category,
        difficulty: difficulty,
        description: description,
        hint: hint,
        flag: flag,
        points: points,
        isSolved: isSolved ?? this.isSolved,
      );
}

class CtfData {
  static List<CtfChallengeModel> challenges = [
    const CtfChallengeModel(
      id: 'crypto-01',
      title: 'Caesar\'s Secret',
      category: 'crypto',
      difficulty: 'Easy',
      description: 'A message was intercepted from an ancient roman general:\n\n"Ioleh{fdhvdu_flskhu_lv_rog}"\n\nDecrypt it to find the flag. The shift is 3.',
      hint: 'Julius Caesar used a simple substitution cipher where each letter is shifted by a fixed number. Try shifting each letter back by 3 positions.',
      flag: 'flag{caesar_cipher_is_old}',
      points: 100,
    ),
    const CtfChallengeModel(
      id: 'crypto-02',
      title: 'Base Confusion',
      category: 'crypto',
      difficulty: 'Easy',
      description: 'This doesn\'t look like normal text...\n\n"ZmxhZ3tiYXNlNjRfaXNfbm90X2VuY3J5cHRpb259"\n\nDecode it to find the flag.',
      hint: 'Base64 encoding is commonly used to represent binary data as ASCII text. Look for a Base64 decoder tool.',
      flag: 'flag{base64_is_not_encryption}',
      points: 100,
    ),
    const CtfChallengeModel(
      id: 'forensic-01',
      title: 'Hidden in Plain Sight',
      category: 'forensic',
      difficulty: 'Medium',
      description: 'A suspicious file was recovered from a compromised system. The file header reads:\n\n"89 50 4E 47 0D 0A 1A 0A"\n\nWhat type of file is this? The flag is the file extension in lowercase.',
      hint: 'The first bytes of a file are called "magic bytes" or "file signature". Look up PNG magic bytes.',
      flag: 'flag{png}',
      points: 150,
    ),
    const CtfChallengeModel(
      id: 'web-01',
      title: 'Cookie Monster',
      category: 'web',
      difficulty: 'Easy',
      description: 'A website stores its authentication secret in a cookie. The cookie value is:\n\nYWRtaW46cGFzc3dvcmQxMjM=\n\nDecode it to find the hidden credential pair (format: flag{user:pass}).',
      hint: 'Web applications sometimes store credentials in Base64-encoded cookies. Decode the value to find the credentials.',
      flag: 'flag{admin:password123}',
      points: 120,
    ),
    const CtfChallengeModel(
      id: 'reverse-01',
      title: 'Binary Whispers',
      category: 'reverse',
      difficulty: 'Easy',
      description: 'Decode this binary message:\n\n01100110 01101100 01100001 01100111 01111011 01100010 01101001 01101110 01100001 01110010 01111001 01111101\n\nConvert the binary to ASCII text.',
      hint: 'Each group of 8 bits (binary digits) represents one ASCII character. Convert each byte to decimal, then to its ASCII character.',
      flag: 'flag{binary}',
      points: 100,
    ),
  ];
}
