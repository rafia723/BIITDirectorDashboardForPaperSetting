class Difficulty {
  int easy;
  int medium;
  int hard;
  int numberOfQuestions;

  Difficulty({required this.easy, required this.medium, required this.hard, required this.numberOfQuestions});

  Map<String, dynamic> toJson() {
    return {
      'easy': easy,
      'medium': medium,
      'hard': hard,
      'numberOfQuestions': numberOfQuestions,
    };
  }
}