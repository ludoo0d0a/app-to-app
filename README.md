# How 2 apps Android/Flutter can communicate

## Context

Idea is to connect these 2 apps : 
 - GCWizard, a flutter app 
 - c:geo, a native Android app

## Prototype

This project is made with 2 apps : 
- sender
- receiver

## Flow

- Sender request input from user, and click on "send".
- Via Android share intent feature, an activtiy from receiver is opened.
- At opening, receiver controls input parameters.
- UI from receiver is opened.
- Click on "send result" to go back to "sender" app, with result using Activity#setResult()
- Sender can use computed response from receiver.

## References

- Discussion on [cgeo#12389](https://github.com/cgeo/cgeo/issues/12389)

Starting with intent reception analysis [How do I handle incoming intents from external applications in Flutter?](https://docs.flutter.dev/get-started/flutter-for/android-devs#how-do-i-handle-incoming-intents-from-external-applications-in-flutter)

These are possible plugins, but all with limitations :
- [receive_intent](https://github.com/daadu/receive_intent)
- [linker](https://github.com/best-flutter/linker)
- [itzmeanjan/intent](https://github.com/itzmeanjan/intent)
- [android_intent_plus](https://pub.dev/packages/android_intent_plus) => will never support [startActivityForResult](https://github.com/fluttercommunity/plus_plugins/issues/344)

Activity result in flutter need to focus on [MethodChannel for platform-specific code](https://flutter.dev/docs/development/platform-integration/platform-channels)
also discussed [here](https://stackoverflow.com/questions/60091309/how-can-i-implement-onactivityresult-and-onnewintent-on-flutteractivity/60279982).

API doc: 
- [Activity#setResult()](https://developer.android.com/reference/android/app/Activity#setResult(int,%20android.content.Intent))
- [Intent](https://developer.android.com/reference/android/content/Intent)

Other researchs on this topic:
- [Receive Share Text intents in Flutter](http://blog.wafrat.com/receive-share-intents-in-flutter/#flutter-side)
- [Comment puis-je transmettre des données entre les activités dans l'application Android?](https://www.it-swarm-fr.com/fr/android/comment-puis-je-transmettre-des-donnees-entre-les-activites-dans-lapplication-android/968254309/)
- [Activity Results API: A better way to pass data between Activities](https://proandroiddev.com/is-onactivityresult-deprecated-in-activity-results-api-lets-deep-dive-into-it-302d5cf6edd)

## Preview

![Demo](demo.gif "Flow demo")
