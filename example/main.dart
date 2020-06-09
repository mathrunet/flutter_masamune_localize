import 'package:masamune_localize/masamune_localize.dart';

void main() async {
  await Localize.initialize("Localization.csv");
  String localized = Localize.get("Hello");
  print(localized);
}
