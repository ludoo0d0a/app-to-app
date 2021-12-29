# receiver

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

#### Tools to test it
You can test this with either [`adb`](https://developer.android.com/studio/command-line/adb) or [Intent Test](https://play.google.com/store/apps/details?id=com.applauncher.applauncher) app form Playstore.
##### adb
To invoke (start) our `FlutterAcitivity` with `RECEIVE_INTENT_EXAMPLE_ACTION`  intent action name as mentioned in example `<intent-filter>` [above](#add-intent-filter-to-AndroidMainfest.xml):
```sh
adb shell 'am start -W -a android.intent.action.SEND -c android.intent.category.DEFAULT'
```
If you don't have  [`adb`](https://developer.android.com/studio/command-line/adb)  in your path, but have  `$ANDROID_HOME`  env variable then use  `"$ANDROID_HOME"/platform-tools/adb ...`.

Note: Alternatively you could simply enter an  `adb shell`  and run the  [`am`](https://developer.android.com/studio/command-line/adb#am)  commands in it.
