import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/modules/citySelection/controllers/city_selection_controller.dart';
import 'package:ultimate_alarm_clock/app/modules/citySelection/views/search_view.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/controllers/theme_controller.dart';
import 'package:ultimate_alarm_clock/app/utils/utils_world_gmt_data.dart';

class CitySelectionView extends StatelessWidget {
  final CitySelectionController controller = Get.put(CitySelectionController());

  @override
  Widget build(BuildContext context) {
    ThemeController themeController = Get.find<ThemeController>();
    return Scaffold(
      backgroundColor: Color(0xFF16171C),
      appBar: AppBar(
        backgroundColor: const Color(0xFF16171C),
        iconTheme: const IconThemeData(
          color: Color(0xffAFFC41),
        ),
        shadowColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            const Text('Select City',
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text('Time zones',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),

            const SizedBox(height: 20,),

            Container(
              height: 60,
              width: double.infinity,
              child: TextField(
                readOnly: true,
                onTap: () => Get.to(() => SearchView()),
                decoration: InputDecoration(
                  hintText: 'Search for country or city',
                  hintStyle: const TextStyle(
                    color: Colors.black38,
                    fontSize: 18,
                  ),
                  prefixIcon: const Icon(Icons.search, size: 30, color: Colors.black,),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20,),

            Expanded(
              child: ListView.builder(
                controller: controller.scrollController,
                itemCount: cities.length,
                itemBuilder: (context, index) => ListTile(
                  onTap: () => controller.onCityTap(cities[index]),
                  title: Text(cities[index]['city']!,
                    style: const TextStyle(
                      color: Color(0xffAFFC41),
                    ),
                  ),
                  subtitle: Text(cities[index]['timezone']!),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}