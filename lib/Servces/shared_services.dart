import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../Models/flashcard_model.dart';

class SharedServices {
  final List<Flashcard> _flashcards = [];
  Future<void> saveFlashcards() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList =
        _flashcards.map((flashcard) => flashcard.toJson()).toList();
    await prefs.setString('flashcards', jsonEncode(jsonList));
  }

  static getFlashcards() async {
    final prefs = await SharedPreferences.getInstance();
    final flashcardsData = prefs.getString('flashcards');
    return flashcardsData;
  }
}
