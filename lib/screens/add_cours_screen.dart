import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddCoursScreen extends StatefulWidget {
  @override
  _AddCoursScreenState createState() => _AddCoursScreenState();
}

class _AddCoursScreenState extends State<AddCoursScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController coursController = TextEditingController();

  String? salle;
  String? enseignant;
  String? jour;
  String? heure;

  final List<String> jours = ["Lundi", "Mardi", "Mercredi", "Jeudi", "Vendredi"];
  final List<String> heures = ["08:00", "10:00", "12:00", "14:00", "16:00"];

  @override
  void dispose() {
    coursController.dispose();
    super.dispose();
  }

  Future<void> ajouterCours() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      // Vérification des conflits
      var conflit = await FirebaseFirestore.instance
          .collection("emplois")
          .where("jour", isEqualTo: jour)
          .where("heure", isEqualTo: heure)
          .get();

      bool salleOccupee = false;
      bool enseignantOccupe = false;

      for (var doc in conflit.docs) {
        if (doc["salle"] == salle) salleOccupee = true;
        if (doc["enseignant"] == enseignant) enseignantOccupe = true;
      }

      if (salleOccupee) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Salle déjà occupée à cette heure")));
        return;
      }

      if (enseignantOccupe) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Cet enseignant a déjà un cours")));
        return;
      }

      // Ajouter le cours
      await FirebaseFirestore.instance.collection("emplois").add({
        "cours": coursController.text,
        "enseignant": enseignant,
        "salle": salle,
        "jour": jour,
        "heure": heure,
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Cours programmé avec succès")));
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Erreur lors de l'ajout : $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ajouter un Cours"),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Nom du cours
              TextFormField(
                controller: coursController,
                decoration: InputDecoration(
                  labelText: "Nom du cours",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.book),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Veuillez entrer le nom du cours";
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),

              // Enseignant
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection("enseignants").snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
                  var docs = snapshot.data!.docs;

                  return DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: "Choisir Enseignant",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person),
                    ),
                    value: enseignant,
                    items: docs
                        .map((doc) => DropdownMenuItem<String>(
                              value: doc["nom"],
                              child: Text(doc["nom"]),
                            ))
                        .toList(),
                    onChanged: (value) => setState(() => enseignant = value),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Veuillez choisir un enseignant";
                      }
                      return null;
                    },
                  );
                },
              ),
              SizedBox(height: 20),

              // Salle
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection("salles").snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
                  var docs = snapshot.data!.docs;

                  return DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: "Choisir Salle",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.meeting_room),
                    ),
                    value: salle,
                    items: docs
                        .map((doc) => DropdownMenuItem<String>(
                              value: doc["nom"],
                              child: Text(doc["nom"]),
                            ))
                        .toList(),
                    onChanged: (value) => setState(() => salle = value),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Veuillez choisir une salle";
                      }
                      return null;
                    },
                  );
                },
              ),
              SizedBox(height: 20),

              // Jour
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: "Jour",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.calendar_today),
                ),
                value: jour,
                items: jours
                    .map((j) => DropdownMenuItem<String>(
                          value: j,
                          child: Text(j),
                        ))
                    .toList(),
                onChanged: (value) => setState(() => jour = value),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Veuillez choisir un jour";
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),

              // Heure
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: "Heure",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.access_time),
                ),
                value: heure,
                items: heures
                    .map((h) => DropdownMenuItem<String>(
                          value: h,
                          child: Text(h),
                        ))
                    .toList(),
                onChanged: (value) => setState(() => heure = value),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Veuillez choisir une heure";
                  }
                  return null;
                },
              ),
              SizedBox(height: 30),

              // Bouton Ajouter
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: ajouterCours,
                  child: Text("Ajouter Cours"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}