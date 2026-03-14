import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EnseignantsScreen extends StatefulWidget {
  @override
  _EnseignantsScreenState createState() => _EnseignantsScreenState();
}

class _EnseignantsScreenState extends State<EnseignantsScreen> {

  final TextEditingController nomController = TextEditingController();

  /// Ajouter enseignant
  void ajouterEnseignant() async {

    if(nomController.text.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Veuillez entrer le nom de l'enseignant"))
      );
      return;
    }

    await FirebaseFirestore.instance.collection("enseignants").add({
      "nom": nomController.text,
      "date_creation": Timestamp.now()
    });

    nomController.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Enseignant ajouté avec succès"))
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: Text("Gestion des Enseignants"),
        centerTitle: true,
      ),

      body: Padding(
        padding: EdgeInsets.all(16),

        child: Column(

          children: [

            /// Champ nom enseignant
            TextField(
              controller: nomController,
              decoration: InputDecoration(
                labelText: "Nom de l'enseignant",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
            ),

            SizedBox(height: 10),

            /// Bouton ajouter
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: ajouterEnseignant,
                child: Text("Ajouter Enseignant"),
              ),
            ),

            SizedBox(height: 20),

            /// Liste enseignants
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("enseignants")
                    .orderBy("date_creation", descending: true)
                    .snapshots(),

                builder: (context, snapshot){

                  if(snapshot.connectionState == ConnectionState.waiting){
                    return Center(child: CircularProgressIndicator());
                  }

                  if(!snapshot.hasData || snapshot.data!.docs.isEmpty){
                    return Center(child: Text("Aucun enseignant ajouté"));
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
                            child: Icon(Icons.person),
                          ),

                          title: Text(
                            doc["nom"],
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),

                          trailing: IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),

                            onPressed: (){
                              FirebaseFirestore.instance
                                  .collection("enseignants")
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