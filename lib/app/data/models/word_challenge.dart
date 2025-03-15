import 'dart:math';

class WordChallenge {
  final String targetWord;
  final List<String> scrambledLetters;
  final String hint;
  final int difficulty; // 1: Easy, 2: Medium, 3: Hard

  WordChallenge({
    required this.targetWord,
    required this.scrambledLetters,
    required this.hint,
    required this.difficulty,
  });

  factory WordChallenge.generate(int difficulty) {
    // Word lists by difficulty
    const easyWords = [
      {'word': 'WAKE', 'hint': 'Stop sleeping'},
      {'word': 'RISE', 'hint': 'Get up'},
      {'word': 'TIME', 'hint': 'What an alarm tracks'},
      {'word': 'DAWN', 'hint': 'Early morning'},
      {'word': 'DAY', 'hint': 'Opposite of night'},
    ];

    const mediumWords = [
      {'word': 'MORNING', 'hint': 'Start of the day'},
      {'word': 'SUNRISE', 'hint': 'When the day begins'},
      {'word': 'AWAKEN', 'hint': 'Become conscious'},
      {'word': 'ACTIVE', 'hint': 'Not idle'},
      {'word': 'ENERGY', 'hint': 'Power to move'},
    ];

    const hardWords = [
      {'word': 'CONSCIOUS', 'hint': 'Aware and alert'},
      {'word': 'VIGILANT', 'hint': 'Staying watchful'},
      {'word': 'DAYBREAK', 'hint': 'First light of day'},
      {'word': 'SCHEDULE', 'hint': 'Daily plan'},
      {'word': 'PUNCTUAL', 'hint': 'Always on time'},
    ];

    // Select word list based on difficulty
    final wordList = difficulty == 1 
        ? easyWords 
        : difficulty == 2 
            ? mediumWords 
            : hardWords;

    // Randomly select a word-hint pair
    final random = Random();
    final wordData = wordList[random.nextInt(wordList.length)];
    final word = wordData['word']!;
    final hint = wordData['hint']!;

    // Create scrambled letters
    List<String> letters = word.split('');
    letters.shuffle(random);

    // Add some random extra letters for increased difficulty
    if (difficulty > 1) {
      final extraLetters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
          .split('')
          .where((l) => !word.contains(l))
          .toList();
      extraLetters.shuffle(random);
      letters.addAll(extraLetters.take(difficulty == 2 ? 2 : 4));
      letters.shuffle(random);
    }

    return WordChallenge(
      targetWord: word,
      scrambledLetters: letters,
      hint: hint,
      difficulty: difficulty,
    );
  }

  bool checkWord(String attempt) {
    return attempt.toUpperCase() == targetWord;
  }

  bool canFormWord(String attempt) {
    // Check if the attempted word can be formed from available letters
    Map<String, int> letterCount = {};
    for (String letter in scrambledLetters) {
      letterCount[letter] = (letterCount[letter] ?? 0) + 1;
    }
    
    for (String letter in attempt.toUpperCase().split('')) {
      if (!letterCount.containsKey(letter) || letterCount[letter]! <= 0) {
        return false;
      }
      letterCount[letter] = letterCount[letter]! - 1;
    }
    return true;
  }
} 