class CourseModel {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final String category; // mental_health or nutrition
  final int pointsReward;
  final String badgeId;
  final List<LessonModel> lessons;
  final List<QuizModel> quizzes;
  final int difficulty; // 1-5
  final int estimatedMinutes;

  CourseModel({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.category,
    required this.pointsReward,
    required this.badgeId,
    required this.lessons,
    required this.quizzes,
    required this.difficulty,
    required this.estimatedMinutes,
  });

  factory CourseModel.fromMap(Map<String, dynamic> map) {
    return CourseModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      category: map['category'] ?? '',
      pointsReward: map['pointsReward'] ?? 0,
      badgeId: map['badgeId'] ?? '',
      lessons: List<LessonModel>.from(
        (map['lessons'] ?? []).map((lesson) => LessonModel.fromMap(lesson)),
      ),
      quizzes: List<QuizModel>.from(
        (map['quizzes'] ?? []).map((quiz) => QuizModel.fromMap(quiz)),
      ),
      difficulty: map['difficulty'] ?? 1,
      estimatedMinutes: map['estimatedMinutes'] ?? 30,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'category': category,
      'pointsReward': pointsReward,
      'badgeId': badgeId,
      'lessons': lessons.map((lesson) => lesson.toMap()).toList(),
      'quizzes': quizzes.map((quiz) => quiz.toMap()).toList(),
      'difficulty': difficulty,
      'estimatedMinutes': estimatedMinutes,
    };
  }
}

class LessonModel {
  final String id;
  final String title;
  final String content;
  final List<String> mediaUrls;
  final int pointsReward;
  final int order;

  LessonModel({
    required this.id,
    required this.title,
    required this.content,
    this.mediaUrls = const [],
    required this.pointsReward,
    required this.order,
  });

  factory LessonModel.fromMap(Map<String, dynamic> map) {
    return LessonModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      content: map['content'] ?? '',
      mediaUrls: List<String>.from(map['mediaUrls'] ?? []),
      pointsReward: map['pointsReward'] ?? 0,
      order: map['order'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'mediaUrls': mediaUrls,
      'pointsReward': pointsReward,
      'order': order,
    };
  }
}

class QuizModel {
  final String id;
  final String title;
  final int pointsReward;
  final List<QuestionModel> questions;
  final int order;

  QuizModel({
    required this.id,
    required this.title,
    required this.pointsReward,
    required this.questions,
    required this.order,
  });

  factory QuizModel.fromMap(Map<String, dynamic> map) {
    return QuizModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      pointsReward: map['pointsReward'] ?? 0,
      questions: List<QuestionModel>.from(
        (map['questions'] ?? []).map((question) => QuestionModel.fromMap(question)),
      ),
      order: map['order'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'pointsReward': pointsReward,
      'questions': questions.map((question) => question.toMap()).toList(),
      'order': order,
    };
  }
}

class QuestionModel {
  final String id;
  final String text;
  final List<String> options;
  final int correctOptionIndex;
  final String? explanation;

  QuestionModel({
    required this.id,
    required this.text,
    required this.options,
    required this.correctOptionIndex,
    this.explanation,
  });

  factory QuestionModel.fromMap(Map<String, dynamic> map) {
    return QuestionModel(
      id: map['id'] ?? '',
      text: map['text'] ?? '',
      options: List<String>.from(map['options'] ?? []),
      correctOptionIndex: map['correctOptionIndex'] ?? 0,
      explanation: map['explanation'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'options': options,
      'correctOptionIndex': correctOptionIndex,
      'explanation': explanation,
    };
  }
}

class BadgeModel {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final int requiredPoints;

  BadgeModel({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.requiredPoints,
  });

  factory BadgeModel.fromMap(Map<String, dynamic> map) {
    return BadgeModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      requiredPoints: map['requiredPoints'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'requiredPoints': requiredPoints,
    };
  }
}