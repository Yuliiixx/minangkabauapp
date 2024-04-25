import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:minangkabauapp/apiUrl.dart';
import 'package:minangkabauapp/bottomNavBar.dart';
import 'package:minangkabauapp/model/modelLogin.dart';
import 'package:minangkabauapp/register.dart';
import 'package:minangkabauapp/sessionManager.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var logger = Logger();
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtPassword = TextEditingController();
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();

  Future<ModelLogin?> login() async {
    if (_formKey.currentState!.validate()) {
      try {
        isLoading = true;
        http.Response res = await http.post(Uri.parse('${ApiUrl().baseUrl}auth.php'),
            body: {
              "login": "1",
              "email": txtEmail.text,
              "password": txtPassword.text,
            });

        ModelLogin data = modelLoginFromJson(res.body);
        logger.d("data :: ${data.pesan}");

        if (data.sukses) {
          setState(() {
            isLoading = false;

            sessionManager.saveSession(
              data.sukses,
              data.data.idUser,
              data.data.namaUser,
              data.data.email,
            );
            sessionManager.getSession();
            sessionManager.getSession().then((value) {
              logger.d("nama :: ${sessionManager.namaUser}");
            });
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${data.pesan}')));
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => BottomNavigation("home")),
              (route) => false,
            );
          });
        } else {
          setState(() {
            isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${data.pesan}')));
        }
      } catch (e) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('error: ${e.toString()}')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(height: 50),
              Image.asset(
                'images/logo.png', // Ganti dengan path gambar logo Anda
                height: 150,
                width: 150,
              ),
              SizedBox(height: 50),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: TextFormField(
                  controller: txtEmail,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email tidak boleh kosong';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: TextFormField(
                  obscureText: true,
                  controller: txtPassword,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password tidak boleh kosong';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: isLoading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : MaterialButton(
                        minWidth: 150,
                        height: 45,
                        onPressed: () {
                          login();
                        },
                        color: Colors.blue[900],
                        child: Text('Login', style: TextStyle(color: Colors.white)),
                      ),
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterPage()),
                  );
                },
                child: Text(
                  'Belum punya akun? Silahkan daftar',
                  style: TextStyle(
                    color: Colors.blue[900],
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
