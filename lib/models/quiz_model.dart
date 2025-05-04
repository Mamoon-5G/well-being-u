class QuizModel {
  final String id;
  final String title;
  final List<Question> questions;

  QuizModel({
    required this.id,
    required this.title,
    required this.questions,
  });

  // FromMap constructor for Firestore data
  factory QuizModel.fromMap(String id, Map<String, dynamic> map) {
    return QuizModel(
      id: id,
      title: map['title'] ?? '',
      questions: List<Question>.from(
        (map['questions'] as List).map((questionMap) => Question.fromMap(questionMap)),
      ),
    );
  }
}

class Question {
  final String question;
  final List<String> options;
  final int correctAnswerIndex;

  Question({
    required this.question,
    required this.options,
    required this.correctAnswerIndex,
  });

  // FromMap constructor for Firestore data
  factory Question.fromMap(Map<String, dynamic> map) {
    return Question(
      question: map['question'] ?? '',
      options: List<String>.from(map['options'] ?? []),
      correctAnswerIndex: map['correctAnswerIndex'] ?? 0,
    );
  }
}
