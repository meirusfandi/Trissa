import 'dart:async';
import 'dart:io' show Platform;
// import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/login_models.dart';
import '../../services/login_service.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  LoginService _loginService;
  LoginRequest loginRequest;

  String appVersion = '1.0.0';
  String oldVersion = '1.0.0';
  bool isRequired = false;
  bool isEnabled = false;
  String url = "https://www.google.com";

  // Future<RemoteConfig> checkVersion() async {
  //   final RemoteConfig remoteConfig = await RemoteConfig.instance;
  //   final defs = <String, dynamic> {'appVersion': '1.0.0'};
  //   await remoteConfig.setDefaults(defs);
  //   await remoteConfig.fetch(expiration: const Duration(hours: 5));
  //   await remoteConfig.activateFetched();
  //   if (this.mounted) {
  //     setState(() {
  //       appVersion = remoteConfig.getString('version');
  //       isEnabled = remoteConfig.getBool('enabled');
  //       isRequired = remoteConfig.getBool('required');
  //       if (Platform.isAndroid) {
  //         url = remoteConfig.getString('url_android');
  //       } else if (Platform.isIOS) {
  //         url = remoteConfig.getString('url_ios');
  //       }
  //     });
  //   }
  //   if (remoteConfig.getBool('enabled')) {
  //     print("enabled update");
  //     if (remoteConfig.getBool('required')) {
  //       print("required");
  //       dialogRequiredUpdate();
  //     } else {
  //       print("not required");
  //       dialogUpdate();
  //     }
  //   }
  //   return remoteConfig;
  // }

  _launchURL() async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  dialogRequiredUpdate() async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('New Version Available'),
          content: Text("New app version is available. Update your app now!"),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                _launchURL();
              },
              child: Text('Update Now'),
            ),
          ],
        );
      },
      barrierDismissible: false,
    );
  }

  dialogUpdate() async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('New Version Available'),
          content: Text("New app version is available. Update your app now!"),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                _launchURL();
              },
              child: Text('Update Now'),
            ),
            FlatButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Ignore'),
            ),
          ],
        );
      },
      barrierDismissible: true,
    );
  }


  @override
  void initState() {
    // TODO: implement initState
    _loginService = LoginService();
    // checkVersion();
    super.initState();
  }

  Widget noDataView(String msg) => Center(
      child: Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
            color: Colors.white,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                msg,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
              )
            ],
          )
      )
  );

  setData(LoginModel models) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setBool('isLogin', true);
      prefs.setString('api_token', models.apiToken);
      prefs.setString('name', models.name);
      prefs.setString('email', models.email);
      prefs.setInt('id', models.id);
    });
  }

  void loginProgress() {
    // ignore: missing_return
    _loginService.login(loginRequest).then((data) {
      if (data != null) {
        // ignore: missing_return
        if (data.code == 200) {
          LoginModel result = data.data;
          setData(result);
          _showLoading();
        } else {
          _errorLogin();
        }
      } else {
        _errorLogin();
      }
    });
  }

  final _formKey = GlobalKey<FormState>();

  void _errorLogin() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Login Failed'),
        content: Text('Login failed. Please check username and password!'),
        actions: <Widget>[
          FlatButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Ok'),
          ),
        ],
      ),
    );
  }

  void _showLoading() {
    Timer(
        Duration(seconds: 3),
        () {
          Navigator.pushNamedAndRemoveUntil(context, '/splash', (r) => false);
        }
    );
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Container(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                CircularProgressIndicator(),
                Text('Loading...', style: TextStyle(color: Colors.black, fontSize: 16),)
              ],
            ),
            height: 100,
          ),
          contentPadding: EdgeInsets.all(16.0),
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff1eee9),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: 32.0),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: <Widget>[
              Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Image.asset("assets/images/pattern.png", fit: BoxFit.cover,)
              ),
              Positioned(
                  left: 16,
                  right: 16,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[

                        SizedBox(height: MediaQuery.of(context).size.height / 10,),
                        Image.asset('assets/images/logofix.png', height: MediaQuery.of(context).size.width / 3, width: MediaQuery.of(context).size.width / 3),

                        SizedBox(height: 32.0,),

                        Column(
                          children: <Widget>[
                            Text('LOGIN', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 24.0),),

                            SizedBox(height: 16.0,),

                            TextFormField(
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please fill a valid email!';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                  enabled: true,
                                  fillColor: Colors.white,
                                  filled: true,
                                  prefixIcon: Icon(Icons.email),
                                  border: OutlineInputBorder(),
                                  labelText: 'Email'
                              ),
                              keyboardType: TextInputType.emailAddress,
                              controller: _emailController,
                            ),

                            SizedBox(height: 8.0,),

                            TextFormField(
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please fill right password!';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                  enabled: true,
                                  fillColor: Colors.white,
                                  filled: true,
                                  prefixIcon: Icon(Icons.vpn_key),
                                  border: OutlineInputBorder(),
                                  labelText: 'Password'
                              ),
                              obscureText: true,
                              keyboardType: TextInputType.visiblePassword,
                              controller: _passwordController,
                            ),

                            SizedBox(height: 32,),

                            InkWell(
                              onTap: () {
                                if (_formKey.currentState.validate()) {
                                  setState(() {
                                    loginRequest = LoginRequest(
                                        email: _emailController.text,
                                        password: _passwordController.text
                                    );
                                  });
                                  loginProgress();
                                }
                              },
                              child: Container(
                                color: Color(0xff189A95),
                                width: MediaQuery.of(context).size.width,
                                padding: EdgeInsets.all(16.0),
                                child: Text('LOGIN', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16.0),),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),),
            ],
          ),
        ),
      ),
    );
  }
}