# 📚 Gestion des Cours et Enseignants

## 🚀 Description
Application mobile développée avec Flutter et Firebase permettant de gérer les cours et les enseignants de manière simple et sécurisée.

Cette application permet aux enseignants de créer, consulter, modifier et supprimer des cours tout en garantissant la sécurité des données grâce à Firebase Authentication et Firestore.

---

## ✨ Fonctionnalités

- 🔐 Authentification des utilisateurs (connexion sécurisée)
- 👨‍🏫 Gestion des enseignants
- 📚 Ajout de cours
- ✏️ Modification des cours
- ❌ Suppression des cours
- 🔎 Consultation des cours
- 🔒 Sécurisation des données avec Firestore

---

## 🛠️ Technologies utilisées

- Flutter (Frontend mobile)
- Firebase Authentication
- Cloud Firestore
- Dart

---

## 🏗️ Architecture

- Frontend : Flutter
- Backend : Firebase
- Base de données : Firestore
- Authentification : Firebase Auth

---

## 🔐 Sécurité

Les données sont protégées grâce aux règles de sécurité Firestore :
- Accès uniquement aux utilisateurs authentifiés
- Chaque enseignant peut gérer uniquement ses propres cours

---

## 📸 Captures d’écran

Ajoute ici les images de ton application :

- Page de connexion  
- Tableau de bord  
- Liste des cours  
- Ajout de cours  

---

## ⚙️ Installation

```bash
git clone https://github.com/Samarou01/GestionCours.git
cd GestionCours
flutter pub get
flutter run
