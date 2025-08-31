# Consumer ProGuard rules for Ultimate Alarm Clock
# These rules are applied to all consumers of this library

# Keep overlay permission related classes
-keep class android.provider.Settings { *; }
-keep class android.view.WindowManager { *; }
-keep class android.app.Activity {
    public void startActivity(android.content.Intent);
}

# Keep system alert window permission classes
-keep class android.Manifest$permission {
    public static final java.lang.String SYSTEM_ALERT_WINDOW;
}

# Preserve all public methods in MainActivity for method channel calls
-keep class com.ccextractor.ultimate_alarm_clock.MainActivity {
    public *;
}

# Keep permission checking methods
-keepclassmembers class * {
    public static boolean canDrawOverlays(android.content.Context);
}

