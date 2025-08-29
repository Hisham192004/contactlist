import 'package:contactlist/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:hive/hive.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});


  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}
Duration get loadingTime=> Duration(milliseconds: 2000);

  Future<String?>_authUser(LoginData data)async{
    var box=Hive.box('contacts');
    String? storedPassword=box.get(data.name);
     if (storedPassword == null) {
      return "User not found";
    }
    if (storedPassword != data.password) {
      return "Invalid password";
    }
    return null;
    }

  Future<String?> _recoverPassword(String data){
    return Future.delayed(loadingTime).then((value)=>null);
  }

  Future<String?> _signupUser(SignupData data)async{
    var box=Hive.box('contacts');
    box.put(data.name, data.password);
    return null;
  }
class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      body:FlutterLogin(
        onLogin: _authUser,
        onRecoverPassword: _recoverPassword,
        onSignup: _signupUser,
        onSubmitAnimationCompleted: (){
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context)=>MyApp()),
          );
        },
      ),
    );
  }
}