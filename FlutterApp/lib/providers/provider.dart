import 'package:flutter/foundation.dart';
import 'package:smartinventory/models/UserModel.dart';
import 'package:smartinventory/resources/auth_method.dart';

class UserProvider with ChangeNotifier {
  UserModel? _user;

//initializing out authmethods class
  final AuthMethods _authMethods = AuthMethods();

//creating a global variable user which is nullable and private to prevent bugs
  UserModel get getUser => _user!;
//so if we wanna access this user field or get its data we will be creating get method and returning user and to return it add ! that it's not going to be null
  Future<void> refreshUser() async {
    //it will return user model from it
    UserModel user = await _authMethods.getUserDetails();
    _user = user;

    //it will notify all listeners to this user providers that the data of our global variable (_user) has changed so u need to update ur value
    notifyListeners();
  }

  Future<void> setUser(UserModel user) async {
    _user = user;
  }

  bool isLogin() {
    if (_user == null) {
      return false;
    }
    return true;
  }
  //creating function and refresh the user everytime this function is there so that we can update the values of our user
}
