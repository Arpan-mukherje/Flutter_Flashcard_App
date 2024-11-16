import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_flashcard_app_submission_arpan_mukherjee/Models/flashcard_model.dart';
import 'package:flutter_flashcard_app_submission_arpan_mukherjee/Screens/flashcard_update_upload_screen.dart';
import 'package:flutter_flashcard_app_submission_arpan_mukherjee/Servces/shared_services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FlashcardHomeScreen extends StatefulWidget {
  const FlashcardHomeScreen({super.key});

  @override
  State<FlashcardHomeScreen> createState() => _FlashcardHomeScreenState();
}

class _FlashcardHomeScreenState extends State<FlashcardHomeScreen> {
  final List<Flashcard> _flashcards = [];

  @override
  void initState() {
    super.initState();
    _loadFlashcards();
  }

  // Load flashcards from SharedPreferences
  Future<void> _loadFlashcards() async {
    if (SharedServices.getFlashcards() != null) {
      final List<dynamic> jsonList = jsonDecode(SharedServices.getFlashcards());
      setState(() {
        _flashcards.clear();
        _flashcards.addAll(jsonList.map((json) => Flashcard.fromJson(json)));
      });
    }
  }

  void _addOrEditFlashcard({Flashcard? flashcard}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FlashcardFormScreen(flashcard: flashcard),
      ),
    );

    if (result != null) {
      setState(() {
        if (flashcard == null) {
          _flashcards.add(result);
        } else {
          flashcard.question = result.question;
          flashcard.answer = result.answer;
        }
      });
      SharedServices().saveFlashcards();
    }
  }

  void _deleteFlashcard(Flashcard flashcard) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
          backgroundColor: Colors.deepPurpleAccent.shade100,
          title: const Text(
            'Delete Flashcard',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 22,
            ),
          ),
          content: Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Colors.deepPurpleAccent, Colors.purpleAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(15.r),
            ),
            padding: EdgeInsets.all(15.w),
            child: Text(
              'Are you sure you want to delete this flashcard?',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          actionsAlignment: MainAxisAlignment.spaceAround,
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.r),
                ),
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              ),
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.r),
                ),
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              ),
              onPressed: () {
                setState(() {
                  _flashcards.remove(flashcard);
                });
                SharedServices().saveFlashcards();
                Navigator.pop(context);
              },
              child: Text(
                'Delete',
                style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showAnswerPopup(String answer) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
          backgroundColor: Colors.deepPurpleAccent.shade100,
          title: const Text(
            'Answer',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 22,
            ),
          ),
          content: Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Colors.deepPurpleAccent, Colors.purpleAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(15.r),
            ),
            padding: EdgeInsets.all(15.w),
            child: Text(
              answer,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.r),
                ),
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              ),
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Close',
                style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Flashcards',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.teal, Colors.greenAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 5,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.tealAccent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: EdgeInsets.all(16.w),
        child: _flashcards.isEmpty
            ? Center(
                child: Text(
                  'No Flashcards Yet!',
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                ),
              )
            : ListView.builder(
                itemCount: _flashcards.length,
                itemBuilder: (context, index) {
                  final flashcard = _flashcards[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 10.h),
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.r),
                    ),
                    color: Colors.white,
                    child: ListTile(
                      title: Text(
                        flashcard.question,
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal.shade800,
                        ),
                      ),
                      subtitle: const Text(
                        'Tap to view the answer',
                        style: TextStyle(color: Colors.teal),
                      ),
                      onTap: () {
                        _showAnswerPopup(flashcard.answer);
                      },
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () =>
                                _addOrEditFlashcard(flashcard: flashcard),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteFlashcard(flashcard),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addOrEditFlashcard(),
        backgroundColor: Colors.teal,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
