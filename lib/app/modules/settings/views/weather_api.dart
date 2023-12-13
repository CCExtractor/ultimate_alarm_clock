import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/controllers/settings_controller.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/controllers/theme_controller.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';
import 'package:ultimate_alarm_clock/app/utils/utils.dart';
import 'package:url_launcher/url_launcher_string.dart';

class WeatherApi extends StatefulWidget {
  const WeatherApi({
    super.key,
    required this.controller,
    required this.height,
    required this.width,
    required this.themeController,
  });

  final SettingsController controller;
  final ThemeController themeController;
  final double width;
  final double height;

  @override
  State<WeatherApi> createState() => _WeatherApiState();
}

class _WeatherApiState extends State<WeatherApi> {
  @override
  Widget build(BuildContext context) {
    bool _validate = false;
    return InkWell(
      onTap: () async {
        Utils.hapticFeedback();
        Get.defaultDialog(
          titlePadding: const EdgeInsets.symmetric(vertical: 20),
          backgroundColor: widget.themeController.isLightMode.value
              ? kLightSecondaryBackgroundColor
              : ksecondaryBackgroundColor,
          title: 'API Key',
          titleStyle: Theme.of(context).textTheme.displaySmall,
          content: Obx(
            () => Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  // If the user hasn't clicked on the 'Save' or 'Update' button of
                  // the dialog, or there is no error in the weather key, then
                  // show the dialog
                  child: (widget.controller.weatherKeyState.value !=
                              WeatherKeyState.saveAdded &&
                          widget.controller.weatherKeyState.value !=
                              WeatherKeyState.saveUpdated)
                      ? (widget.controller.didWeatherKeyError.value == false)
                          ? Column(
                              children: [
                                TextField(
                                  obscureText: false,
                                  controller: widget.controller.apiKey,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    hintText: 'API Key',
                                    errorText: _validate
                                        ? 'API Key cannot be empty'
                                        : null,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 20.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      TextButton(
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                            kprimaryColor,
                                          ),
                                        ),
                                        child: Text(
                                          // If the weather state is add, then
                                          // show 'Save' else show 'Update' text
                                          // on the button
                                          widget.controller.weatherKeyState
                                                      .value ==
                                                  WeatherKeyState.add
                                              ? 'Save'
                                              : 'Update',
                                          style: Theme.of(context)
                                              .textTheme
                                              .displaySmall!
                                              .copyWith(
                                                color: widget.themeController
                                                        .isLightMode.value
                                                    ? kLightPrimaryTextColor
                                                    : ksecondaryTextColor,
                                              ),
                                        ),
                                        onPressed: () async {
                                          Utils.hapticFeedback();
                                          widget
                                              .controller
                                              .showingCircularProgressIndicator
                                              .value = true;

                                          // Validation If String is empty
                                          if (await widget
                                              .controller.apiKey.text.isEmpty) {
                                            setState(() {
                                              _validate = true;
                                            });
                                            widget
                                                .controller
                                                .showingCircularProgressIndicator
                                                .value = false;
                                            return;
                                          }

                                          // Reset state after getting error message
                                          if (await widget.controller.apiKey
                                              .text.isNotEmpty) {
                                            setState(() {
                                              _validate = false;
                                            });
                                          }

                                          // Get the user's location
                                          await widget.controller.getLocation();

                                          // If the API key is valid
                                          if (await widget.controller
                                              .isApiKeyValid(
                                            widget.controller.apiKey.text,
                                          )) {
                                            // Add the key to the storage
                                            await widget.controller.addKey(
                                              ApiKeys.openWeatherMap,
                                              widget.controller.apiKey.text,
                                            );

                                            // If it is added for the first time
                                            if (widget.controller
                                                    .weatherKeyState.value ==
                                                WeatherKeyState.add) {
                                              widget.controller.weatherKeyState
                                                      .value =
                                                  WeatherKeyState.saveAdded;
                                              widget.controller
                                                  .addWeatherState('saveAdded');
                                            } else {
                                              // If it is updated
                                              widget.controller.weatherKeyState
                                                      .value =
                                                  WeatherKeyState.saveUpdated;
                                              widget.controller.addWeatherState(
                                                  'saveUpdated');
                                            }
                                          } else {
                                            // If the API key is not valid
                                            widget.controller.didWeatherKeyError
                                                .value = true;
                                          }
                                          widget
                                              .controller
                                              .showingCircularProgressIndicator
                                              .value = false;
                                        },
                                      ),
                                      OutlinedButton(
                                        style: OutlinedButton.styleFrom(
                                          side: const BorderSide(
                                            color: kprimaryColor,
                                            width: 1,
                                          ),
                                        ),
                                        child: Text(
                                          'Get Key',
                                          style: Theme.of(context)
                                              .textTheme
                                              .displaySmall!
                                              .copyWith(
                                                color: kprimaryColor,
                                              ),
                                        ),
                                        onPressed: () async {
                                          Utils.hapticFeedback();
                                          const url =
                                              'https://home.openweathermap.org/api_keys';
                                          if (await canLaunchUrlString(url)) {
                                            await launchUrlString(url);
                                          } else {
                                            throw 'Could not launch $url';
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          : Column(
                              children: [
                                const Icon(
                                  Icons.close,
                                  size: 50,
                                  color: Colors.red,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 15.0),
                                  child: Text(
                                    "Error adding key!",
                                    style: Theme.of(context)
                                        .textTheme
                                        .displaySmall,
                                  ),
                                ),
                                TextButton(
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                      kprimaryColor,
                                    ),
                                  ),
                                  child: Text(
                                    'Retry',
                                    style: Theme.of(context)
                                        .textTheme
                                        .displaySmall!
                                        .copyWith(
                                          color: widget.themeController
                                                  .isLightMode.value
                                              ? kLightSecondaryTextColor
                                              : ksecondaryTextColor,
                                        ),
                                  ),
                                  onPressed: () {
                                    Utils.hapticFeedback();
                                    widget.controller.didWeatherKeyError.value =
                                        false;
                                  },
                                ),
                              ],
                            )
                      : Column(
                          children: [
                            const Icon(
                              Icons.done,
                              size: 50,
                              color: Colors.green,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 15.0),
                              child: Text(
                                // If the user clicked on the 'Save' button, then
                                widget.controller.weatherKeyState.value ==
                                        WeatherKeyState.saveAdded
                                    ? 'Your API Key is added!' // show this message
                                    : 'Your API Key is updated!',
                                // else this message
                                style: Theme.of(context).textTheme.displaySmall,
                              ),
                            ),
                            TextButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(kprimaryColor),
                              ),
                              child: Text(
                                'Okay',
                                style: Theme.of(context)
                                    .textTheme
                                    .displaySmall!
                                    .copyWith(
                                      color: widget
                                              .themeController.isLightMode.value
                                          ? kLightSecondaryTextColor
                                          : ksecondaryTextColor,
                                    ),
                              ),
                              onPressed: () {
                                Utils.hapticFeedback();

                                // Assign the weather state to update, and save
                                // it in the local storage
                                widget.controller.weatherKeyState.value =
                                    WeatherKeyState.update;
                                widget.controller.addWeatherState('update');
                                Get.back();
                              },
                            ),
                          ],
                        ),
                ),
                if (widget.controller.showingCircularProgressIndicator.value)
                  Center(
                    child: CircularProgressIndicator.adaptive(
                      backgroundColor: kprimaryColor.withOpacity(0.5),
                      valueColor: const AlwaysStoppedAnimation(
                        kprimaryColor,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
      child: Container(
        width: widget.width * 0.91,
        height: widget.height * 0.1,
        decoration: Utils.getCustomTileBoxDecoration(
          isLightMode: widget.themeController.isLightMode.value,
        ),
        child: Padding(
          padding: EdgeInsets.only(left: 30, right: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Open Weather Map API',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              Icon(
                Icons.arrow_forward_ios_sharp,
                color: widget.themeController.isLightMode.value
                    ? kLightPrimaryTextColor.withOpacity(0.4)
                    : kprimaryTextColor.withOpacity(0.2),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
