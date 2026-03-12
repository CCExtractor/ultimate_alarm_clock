package com.ajinasokan.flutter_fgbg;


import androidx.annotation.NonNull;
import androidx.lifecycle.Lifecycle;
import androidx.lifecycle.LifecycleObserver;
import androidx.lifecycle.OnLifecycleEvent;
import androidx.lifecycle.ProcessLifecycleOwner;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.EventChannel;

/** FlutterFGBGPlugin */
public class FlutterFGBGPlugin implements FlutterPlugin, ActivityAware, LifecycleObserver, EventChannel.StreamHandler {
  EventChannel.EventSink lifecycleSink;

  @Override
  public void onListen(Object o, EventChannel.EventSink eventSink) {
    lifecycleSink = eventSink;
  }

  @Override
  public void onCancel(Object o) {
    lifecycleSink = null;
  }

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    new EventChannel(flutterPluginBinding.getBinaryMessenger(), "com.ajinasokan.flutter_fgbg/events")
            .setStreamHandler(this);
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {}

  @Override
  public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
    ProcessLifecycleOwner.get().getLifecycle().addObserver(this);
  }

  @OnLifecycleEvent(Lifecycle.Event.ON_STOP)
  void onAppBackgrounded() {
    if (lifecycleSink != null) {
      lifecycleSink.success("background");
    }
  }

  @OnLifecycleEvent(Lifecycle.Event.ON_START)
  void onAppForegrounded() {
    if (lifecycleSink != null) {
      lifecycleSink.success("foreground");
    }
  }

  @Override
  public void onDetachedFromActivityForConfigChanges() {}

  @Override
  public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {}

  @Override
  public void onDetachedFromActivity() {
    ProcessLifecycleOwner.get().getLifecycle().removeObserver(this);
  }
}
