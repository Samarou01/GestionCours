import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EmploiTempsScreen extends StatelessWidget {
  final List<String> joursOrdre = ["Lundi", "Mardi", "Mercredi", "Jeudi", "Vendredi"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Emploi du Temps"),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("emplois").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("Aucun cours programmé"));
          }

          var docs = snapshot.data!.docs;

          // Trier par jour puis heure
          docs.sort((a, b) {
            final dataA = a.data() as Map<String, dynamic>;
            final dataB = b.data() as Map<String, dynamic>;

            int jourA = joursOrdre.indexOf(dataA["jour"] ?? ""); 
            int jourB = joursOrdre.indexOf(dataB["jour"] ?? "");

            if (jourA != jourB) return jourA.compareTo(jourB);

            String heureA = dataA["heure"] ?? "";
            String heureB = dataB["heure"] ?? "";
            return heureA.compareTo(heureB);
          });

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              var doc = docs[index];
              final data = doc.data() as Map<String, dynamic>;

              // Champs sécurisés avec messages explicites si vide
              String cours = (data["cours"] != null && data["cours"].toString().trim() != "")
                  ? data["cours"]
                  : "Cours non défini";
              String enseignant = (data["enseignant"] != null && data["enseignant"].toString().trim() != "")
                  ? data["enseignant"]
                  : "Enseignant non défini";
              String salle = (data["salle"] != null && data["salle"].toString().trim() != "")
                  ? data["salle"]
                  : "Salle non définie";
              String jour = (data["jour"] != null && data["jour"].toString().trim() != "")
                  ? data["jour"]
                  : "Jour non défini";
              String heure = (data["heure"] != null && data["heure"].toString().trim() != "")
                  ? data["heure"]
                  : "Heure non définie";

              return Card(
                elevation: 3,
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                child: ListTile(
                  leading: CircleAvatar(child: Icon(Icons.book)),
                  title: Text(
                    cours,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    "$jour • $heure\nSalle: $salle\nEnseignant: $enseignant",
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      FirebaseFirestore.instance
                          .collection("emplois")
                          .doc(doc.id)
                          .delete();
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}