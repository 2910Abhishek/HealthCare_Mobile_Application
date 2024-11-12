import 'package:flutter/foundation.dart';

class ProfileData extends ChangeNotifier {
  // Private variables to hold gender and age
  String _gender = 'Male';
  String _age = '25';

  // Public getters for gender and age
  String get gender => _gender;
  String get age => _age;

  // Methods to update gender and age
  void updateGender(String newGender) {
    _gender = newGender;
    notifyListeners(); // Notify listeners that data has changed
  }

  void updateAge(String newAge) {
    _age = newAge;
    notifyListeners(); // Notify listeners that data has changed
  }
}
