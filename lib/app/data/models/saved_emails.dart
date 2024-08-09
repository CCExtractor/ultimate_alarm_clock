import 'package:isar/isar.dart';

part 'saved_emails.g.dart';

@collection
class Saved_Emails {
  Id isarId = Isar.autoIncrement;
  late String email;
  late String username;
  Saved_Emails({required this.email, required this.username});
}
