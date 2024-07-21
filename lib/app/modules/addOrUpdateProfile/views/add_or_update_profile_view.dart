import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/add_or_update_profile_controller.dart';

class AddOrUpdateProfileView extends GetView<AddOrUpdateProfileController> {
  const AddOrUpdateProfileView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AddOrUpdateProfileView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'AddOrUpdateProfileView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
