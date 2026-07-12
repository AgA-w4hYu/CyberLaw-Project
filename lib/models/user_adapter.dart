import 'package:hive/hive.dart';

import 'user_model.dart';

/// Manual Hive TypeAdapter for [UserModel].
/// typeId = 0
class UserModelAdapter extends TypeAdapter<UserModel> {
  @override
  final int typeId = 0;

  @override
  UserModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{};
    for (int i = 0; i < numOfFields; i++) {
      fields[reader.readByte()] = reader.read();
    }
    return UserModel(
      id: fields[0] as String,
      name: fields[1] as String,
      email: fields[2] as String,
      passwordHash: fields[3] as String? ?? '',
      score: fields[4] as int? ?? 0,
      rank: fields[5] as int? ?? 0,
      solvedChallenges: (fields[6] as List?)?.cast<String>() ?? const [],
      avatarInitials: fields[7] as String? ?? '??',
    );
  }

  @override
  void write(BinaryWriter writer, UserModel obj) {
    writer.writeByte(8); // number of fields
    writer.writeByte(0);
    writer.write(obj.id);
    writer.writeByte(1);
    writer.write(obj.name);
    writer.writeByte(2);
    writer.write(obj.email);
    writer.writeByte(3);
    writer.write(obj.passwordHash);
    writer.writeByte(4);
    writer.write(obj.score);
    writer.writeByte(5);
    writer.write(obj.rank);
    writer.writeByte(6);
    writer.write(obj.solvedChallenges);
    writer.writeByte(7);
    writer.write(obj.avatarInitials);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
