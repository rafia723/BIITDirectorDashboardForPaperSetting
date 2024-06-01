class Difficulty {
  int easy;
  int medium;
  int hard;

  Difficulty({required this.easy, required this.medium, required this.hard});

  Map<String, dynamic> toJson() {
    return {
      'easy': easy,
      'medium': medium,
      'hard': hard,
    };
  }
}