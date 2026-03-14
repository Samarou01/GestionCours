import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SallesScreen extends StatefulWidget {
  @override
  _SallesScreenState createState() => _SallesScreenState();
}

class _SallesScreenState extends State<SallesScreen> {

  final TextEditingController salleController = TextEditingController();

  /// Ajouter salle dans Firebase
  void ajouterSalle() async {

    if(salleController.text.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Veuillez entrer le nom de la salle"))
      );
      return;
    }

    await FirebaseFirestore.instance.collection("salles").add({
      "nom": salleController.text,
      "date_creation": Timestamp.now()
    });

    salleController.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Salle ajoutée avec succès"))
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: Text("Gestion des Salles"),
        centerTitle: true,
      ),

      body: Padding(
        padding: EdgeInsets.all(16),

        child: Column(

          children: [

            /// Champ saisir salle
            TextField(
              controller: salleController,
              decoration: InputDecoration(
                labelText: "Nom de la salle",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.meeting_room),
              ),
            ),

            SizedBox(height: 10),

            /// Bouton ajouter
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: ajouterSalle,
                child: Text("Ajouter Salle"),
              ),
            ),

            SizedBox(height: 20),

            /// Liste des salles
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("salles")
                    .orderBy("date_creation", descending: true)
                    .snapshots(),

                builder: (context, snapshot){

                  if(snapshot.connectionState == ConnectionState.waiting){
                    return Center(child: CircularProgressIndicator());
                  }

                  if(!snapshot.hasData || snapshot.data!.docs.isEmpty){
                    return Center(child: Text("Aucune salle ajoutée"));
                  }

                  var docs = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: docs.length,

                    itemBuilder:(context,index){

                      var doc = docs[index];

                      return Card(
                        elevation: 3,
                        margin: EdgeInsets.symmetric(vertical: 6),

                        child: ListTile(

                          leading: CircleAvatar(
                            child: Icon(Icons.meeting_room),
                          ),

                          title: Text(
                            doc["nom"],
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),

                          trailing: IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),

                            onPressed: (){
                              FirebaseFirestore.instance
                                  .collection("salles")
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
            )

          ],
        ),
      ),
    );
  }
}