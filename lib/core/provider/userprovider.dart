import 'package:flutter/cupertino.dart';
import 'package:wingshield_assignment/core/models/usermodel.dart';

class CurrentUserProvider extends ChangeNotifier {
  UserModel user;
  CurrentUserProvider(this.user);

  updateuser(UserModel updateduser){
    user=updateduser;
    notifyListeners();
  }
}