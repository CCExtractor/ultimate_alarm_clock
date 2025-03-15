import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/data/models/word_challenge.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/controllers/theme_controller.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';

class WordBuilderView extends StatefulWidget {
  final Function onComplete;
  final int difficulty;
  final ThemeController themeController;

  const WordBuilderView({
    Key? key,
    required this.onComplete,
    required this.difficulty,
    required this.themeController,
  }) : super(key: key);

  @override
  State<WordBuilderView> createState() => _WordBuilderViewState();
}

class _WordBuilderViewState extends State<WordBuilderView> {
  late WordChallenge challenge;
  String currentWord = '';
  List<String> selectedLetters = [];
  List<bool> letterUsed = [];
  bool showError = false;
  bool showSuccess = false;

  @override
  void initState() {
    super.initState();
    challenge = WordChallenge.generate(widget.difficulty);
    letterUsed = List.generate(challenge.scrambledLetters.length, (index) => false);
  }

  void _selectLetter(int index) {
    if (!letterUsed[index]) {
      setState(() {
        selectedLetters.add(challenge.scrambledLetters[index]);
        letterUsed[index] = true;
        currentWord = selectedLetters.join();
        showError = false;
      });
    }
  }

  void _removeLetter(int index) {
    setState(() {
      // Find the last occurrence of this letter in the scrambled letters
      final scrambledIndex = challenge.scrambledLetters.lastIndexWhere(
        (letter) => letter == selectedLetters[index] && letterUsed[challenge.scrambledLetters.indexOf(letter)],
      );
      if (scrambledIndex != -1) {
        letterUsed[scrambledIndex] = false;
      }
      selectedLetters.removeAt(index);
      currentWord = selectedLetters.join();
      showError = false;
    });
  }

  void _checkWord() {
    if (challenge.checkWord(currentWord)) {
      setState(() {
        showSuccess = true;
        showError = false;
      });
      Future.delayed(const Duration(milliseconds: 500), () {
        widget.onComplete();
      });
    } else {
      setState(() {
        showError = true;
      });
    }
  }

  void _clearWord() {
    setState(() {
      selectedLetters.clear();
      letterUsed = List.generate(challenge.scrambledLetters.length, (index) => false);
      currentWord = '';
      showError = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Build the Word'.tr,
            style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                  color: widget.themeController.primaryTextColor.value,
                ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: widget.themeController.secondaryBackgroundColor.value,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              'Hint: ${challenge.hint}',
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: widget.themeController.secondaryTextColor.value,
                  ),
            ),
          ),
          const SizedBox(height: 30),
          // Selected letters display
          Container(
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              border: Border.all(
                color: showError
                    ? Colors.red
                    : showSuccess
                        ? Colors.green
                        : widget.themeController.primaryTextColor.value,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (selectedLetters.isEmpty)
                  Text(
                    'Select letters below'.tr,
                    style: TextStyle(
                      color: widget.themeController.secondaryTextColor.value,
                    ),
                  )
                else
                  Wrap(
                    spacing: 5,
                    children: List.generate(
                      selectedLetters.length,
                      (index) => GestureDetector(
                        onTap: () => _removeLetter(index),
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: widget.themeController.primaryBackgroundColor.value,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            selectedLetters[index],
                            style: TextStyle(
                              fontSize: 24,
                              color: widget.themeController.primaryTextColor.value,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Available letters
          Wrap(
            spacing: 10,
            runSpacing: 10,
            alignment: WrapAlignment.center,
            children: List.generate(
              challenge.scrambledLetters.length,
              (index) => GestureDetector(
                onTap: () => _selectLetter(index),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: letterUsed[index]
                        ? widget.themeController.secondaryBackgroundColor.value
                        : ksecondaryColor,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Center(
                    child: Text(
                      challenge.scrambledLetters[index],
                      style: TextStyle(
                        fontSize: 24,
                        color: letterUsed[index]
                            ? widget.themeController.secondaryTextColor.value
                            : Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Action buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: _clearWord,
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.themeController.secondaryBackgroundColor.value,
                ),
                child: Text(
                  'Clear'.tr,
                  style: TextStyle(
                    color: widget.themeController.primaryTextColor.value,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: selectedLetters.isNotEmpty ? _checkWord : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: ksecondaryColor,
                ),
                child: Text(
                  'Check'.tr,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          if (showError) ...[
            const SizedBox(height: 10),
            Text(
              'Try again!'.tr,
              style: const TextStyle(
                color: Colors.red,
                fontSize: 16,
              ),
            ),
          ],
        ],
      ),
    );
  }
} 