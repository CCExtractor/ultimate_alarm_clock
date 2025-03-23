import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/modules/citySelection/controllers/search_controller.dart' as custom;

class SearchView extends StatelessWidget {
  final custom.SearchController controller = Get.put(custom.SearchController());

  SearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF16171C),
      body: Padding(
        padding: const EdgeInsets.only(top: 60.0, left: 20, right: 20),
        child: Column(
          children: [
            Container(
              height: 50,
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller.searchController,
                      onChanged: controller.searchKeyword,
                      style: const TextStyle(
                        color: Colors.black,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Country or City or Timezone',
                        prefixIcon: GestureDetector(
                          onTap: () {
                            controller.searchKeyword(controller.searchController.text);
                          },
                          child: const Icon(Icons.search, size: 30, color: Colors.black),
                        ),
                        suffixIcon: GestureDetector(
                          onTap: () {
                            controller.clearSearch();
                          },
                          child: const Icon(Icons.cancel, size: 20, color: Colors.black),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        contentPadding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      cursorColor: Colors.black87,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: const Padding(
                      padding: EdgeInsets.only(left: 10.0),
                      child: Text('Cancel',
                        style: TextStyle(color: Color(0xffAFFC41), fontSize: 20),
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 20),

            Expanded(
              child: Obx(() {
                return ListView.builder(
                  itemCount: controller.filteredCities.length,
                  itemBuilder: (context, index) {
                    final city = controller.filteredCities[index];
                    return GestureDetector(
                      onTap: () {
                        controller.onCityTap(city);
                        Get.back();
                      },
                      child: ListTile(
                        title: Text(city['city']!),
                        subtitle: Text(city['timezone']!),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
