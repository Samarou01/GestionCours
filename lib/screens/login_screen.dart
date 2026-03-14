import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isLoading = false;
  bool hidePassword = true;

  /// Connexion
  login() async {

    if(emailController.text.isEmpty || passwordController.text.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Veuillez remplir tous les champs"))
      );
      return;
    }

    try {

      setState(() {
        isLoading = true;
      });

      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context)=>DashboardScreen()),
      );

    } on FirebaseAuthException catch(e){

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? "Erreur de connexion"))
      );

    } finally {

      setState(() {
        isLoading = false;
      });

    }
  }

  /// Mot de passe oublié
  resetPassword() async {

    if(emailController.text.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Entrez votre email pour réinitialiser le mot de passe"))
      );
      return;
    }

    await FirebaseAuth.instance.sendPasswordResetEmail(
      email: emailController.text.trim()
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Email de réinitialisation envoyé"))
    );

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: Colors.grey[200],

      body: Center(

        child: SingleChildScrollView(

          child: Card(

            elevation: 6,
            margin: EdgeInsets.symmetric(horizontal: 30),

            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),

            child: Padding(

              padding: EdgeInsets.all(25),

              child: Column(
                mainAxisSize: MainAxisSize.min,

                children: [

                  /// Logo
                  Icon(
                    Icons.school,
                    size: 80,
                    color: Colors.blue,
                  ),

                  SizedBox(height:10),

                  Text(
                    "Gestion Emploi du Temps",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height:30),

                  /// Email
                  TextField(
                    controller: emailController,

                    decoration: InputDecoration(
                      labelText: "Email",
                      prefixIcon: Icon(Icons.email),
                      border: OutlineInputBorder(),
                    ),
                  ),

                  SizedBox(height:20),

                  /// Mot de passe
                  TextField(
                    controller: passwordController,
                    obscureText: hidePassword,

                    decoration: InputDecoration(
                      labelText: "Mot de passe",
                      prefixIcon: Icon(Icons.lock),

                      suffixIcon: IconButton(
                        icon: Icon(
                          hidePassword
                              ? Icons.visibility
                              : Icons.visibility_off
                        ),
                        onPressed: (){
                          setState(() {
                            hidePassword = !hidePassword;
                          });
                        },
                      ),

                      border: OutlineInputBorder(),
                    ),
                  ),

                  SizedBox(height:10),

                  /// Mot de passe oublié
                  Align(
                    alignment: Alignment.centerRight,

                    child: TextButton(
                      onPressed: (){
                        FirebaseAuth.instance.sendPasswordResetEmail(
                          email: emailController.text,
                        );
                      },
                          
                      child: Text("Mot de passe oublié ?"),
                    ),
                      ),

                  SizedBox(height:10),

                  /// Bouton connexion
                  SizedBox(
                    width: double.infinity,

                    child: ElevatedButton(

                      onPressed: isLoading ? null : login,

                      child: isLoading
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text("Connexion"),

                    ),
                  ),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}