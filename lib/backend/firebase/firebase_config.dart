import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

Future initFirebase() async {
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyCXk0pnWjQfABxnVR8KMgNZyAu3ezxgZcE",
            authDomain: "to-check-kdaho6.firebaseapp.com",
            projectId: "to-check-kdaho6",
            storageBucket: "to-check-kdaho6.appspot.com",
            messagingSenderId: "228457942455",
            appId: "1:228457942455:web:24a4afaa5598786905ac32"));
  } else {
    await Firebase.initializeApp();
  }
}
