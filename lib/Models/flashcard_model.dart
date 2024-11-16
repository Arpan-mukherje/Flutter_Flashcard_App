class Flashcard {
  String question;
  String answer;

  Flashcard({required this.question, required this.answer});

  Map<String, dynamic> toJson() => {
        'question': question,
        'answer': answer,
      };

  factory Flashcard.fromJson(Map<String, dynamic> json) {
    return Flashcard(
      question: json['question'],
      answer: json['answer'],
    );
  }
}
