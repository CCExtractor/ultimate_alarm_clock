import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:overlay_pop_up/overlay_pop_up.dart';
import '../../../utils/constants.dart';
import '../controllers/stopwatch_controller.dart';

class StopWatchOverLayWidget extends GetView<StopwatchController> {
  const StopWatchOverLayWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color:  kprimaryColor ,
            ),
            child: Center(
              child: StreamBuilder(
                stream: OverlayPopUp.dataListener,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  String _data = snapshot.data?['time'] ?? '';
                  return Text(
                    _data,
                    style: const TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                },
              ),
            ),
          ),
          Positioned(
            top: -10,
            left: -11,
            child: IconButton(onPressed: ()async{
              await OverlayPopUp.closeOverlay();
            }, icon: const Icon(Icons.close,size: 20,) ),
          ),
        ],
      ),
    );
  }
}
