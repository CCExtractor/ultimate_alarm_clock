import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/data/models/word_challenge.dart';

class WordBuilderController extends GetxController {
  final difficulty = 1.obs;
  final Rx<WordChallenge?> currentChallenge = Rx<WordChallenge?>(null);
  final RxBool isCompleted = false.obs;
  final RxInt attemptsCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    generateNewChallenge();
  }

  void generateNewChallenge() {
    currentChallenge.value = WordChallenge.generate(difficulty.value);
    isCompleted.value = false;
    attemptsCount.value = 0;
  }

  void setDifficulty(int level) {
    difficulty.value = level;
    generateNewChallenge();
  }

  bool checkWord(String word) {
    if (currentChallenge.value == null) return false;
    attemptsCount.value++;
    final isCorrect = currentChallenge.value!.checkWord(word);
    if (isCorrect) {
      isCompleted.value = true;
    }
    return isCorrect;
  }

  bool canFormWord(String word) {
    return currentChallenge.value?.canFormWord(word) ?? false;
  }
} 