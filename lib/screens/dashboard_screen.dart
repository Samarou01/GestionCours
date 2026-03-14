import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'add_cours_screen.dart';
import 'add_enseignant_screen.dart';
import 'add_salle_screen.dart';
import 'emploi_temps_screen.dart';
import 'login_screen.dart';

class DashboardScreen extends StatelessWidget {

  logout(BuildContext context) async {

    await FirebaseAuth.instance.signOut();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder:(context)=>LoginScreen()),
    );

  }

  Widget menuCard(BuildContext context, IconData icon, String title, Widget page){

    return InkWell(

      onTap: (){
        Navigator.push(
          context,
          MaterialPageRoute(builder:(context)=>page),
        );
      },

      child: Card(

        elevation: 5,

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),

        child: Container(

          padding: EdgeInsets.all(20),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,

            children: [

              Icon(icon, size:40, color: Colors.blue),

              SizedBox(height:10),

              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              )

            ],
          ),
        ),
      ),
    );

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(

        title: Text("Gestion Emploi du Temps"),

        actions: [

          IconButton(
            icon: Icon(Icons.logout),
            onPressed: (){
              logout(context);
            },
          )

        ],
      ),

      body: Padding(

        padding: EdgeInsets.all(20),

        child: GridView.count(

          crossAxisCount: 2,
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,

          children: [

            menuCard(
              context,
              Icons.menu_book,
              "Ajouter Cours",
              AddCoursScreen(),
            ),

            menuCard(
              context,
              Icons.person,
              "Ajouter Enseignant",
              EnseignantsScreen(),
            ),

            menuCard(
              context,
              Icons.meeting_room,
              "Ajouter Salle",
              SallesScreen(),
            ),

            menuCard(
              context,
              Icons.calendar_month,
              "Voir Planning",
              EmploiTempsScreen(),
            ),

          ],
        ),
      ),
    );
  }
}