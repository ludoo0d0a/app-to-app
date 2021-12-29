import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:android_intent_plus/android_intent.dart';

import 'package:intent/intent.dart' as ai;
import 'package:intent/extra.dart' as ae;
import 'package:intent/typedExtra.dart' as at;
import 'package:intent/action.dart' as aa;

import 'package:linker/linker.dart' as linker;

void main() {
  runApp(new SenderApp());
}

// Theme.of(context).primaryColor;
const MaterialColor primaryColor = Colors.red;

class SenderApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Intent sender App',
      theme: new ThemeData(
        primarySwatch: primaryColor,
      ),
      home: new SenderPage(),
    );
  }
}

class SenderPage extends StatefulWidget {
  SenderPage({Key? key}) : super(key: key);

  @override
  _SenderPageState createState() => new _SenderPageState();
}

class _SenderPageState extends State<SenderPage> {
  static const CHANNEL = 'app.channel.shared.data';
  List<String>? dataResult;

  final myController = TextEditingController(
      text: "gcw://geocaching/sample/GC1234?c=49.1448473,6.1287041");

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //return new Scaffold (body: Container(child: Center(child: Text(dataShared)))

    return Scaffold(
      appBar: AppBar(
        title: Text("Intent sender"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'Text to send:',
              ),
              TextField(
                controller: myController,
              ),
              Container(
                height: 40,
              ),
              ElevatedButton(
                onPressed: _openChooser,
                child: const Text(' Intent with Chooser...'),
              ),
              const Text(
                'Choose an intent to send with result',
              ),
              ElevatedButton(
                onPressed: _sendWithResult_Linker,
                child: const Text(' Intent with result (Linker)'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.orange, // background
                  onPrimary: Colors.white, // foreground
                ),
              ),
              ElevatedButton(
                onPressed: _sendWithResult_Intent,
                child: const Text(' Intent with result (itzmeanjan/Intent)'),
                style: ElevatedButton.styleFrom(
                  primary: primaryColor, // background
                  onPrimary: Colors.white, // foreground
                ),
              ),
              ElevatedButton(
                onPressed: _sendWithResult_ReceiveIntent,
                child: const Text(' Intent with result (ReceiveIntent)'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.grey, // background
                  onPrimary: Colors.white, // foreground
                ),
              ),
              Container(
                height: 40,
              ),
              const Text(
                'This is the Result from intent:',
              ),
              Text(
                "${dataResult}",
                style: Theme.of(context).textTheme.headline4,
              ),
              Container(
                height: 40,
              ),
              const Text(
                'Send simple intent',
              ),
              ElevatedButton(
                onPressed: _sendIntent_AndroidIntentPlus,
                child: const Text('send (AndroidIntentPlus)'),
                style: ElevatedButton.styleFrom(
                  primary: primaryColor, // background
                  onPrimary: Colors.white, // foreground
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _sendWithResult_Linker() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      linker.ActivityResult result = await linker.Linker.startActivityForResult(
          new linker.Intent.fromAction(
            'android.intent.action.SEND',
            uri: Uri.parse("gcw://geocaching/cache?type=u&id=123456"),
            //   ..addCategory('android.intent.category.DEFAULT')
            // ..setType("text/plain")
            // ..putExtra(
            //     'android.intent.extra.TEXT', myController.text)
            //className: ''
          ),
          0);
      print(result);

      // appintent = new linker.Intent.callApp(
      //     packageName: "com.tencent.mm",
      //     className: "com.tencent.mm.ui.LauncherUI");

      //} on PlatformException {
    } on Exception catch (e) {
      print(e);
    } catch (error) {
      print(error);
    }
  }

  Future<void> _sendWithResult_Intent() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      // Validate receivedIntent and warn the user, if it is not correct,
      // but keep in mind it could be `null` or "empty"(`receivedIntent.isNull`).

      ai.Intent()
        ..setAction('android.intent.action.SEND')
        ..addCategory('android.intent.category.DEFAULT')
        ..setType("text/plain")
        ..putExtra('android.intent.extra.TEXT', myController.text)
        ..startActivityForResult().then(
            (data) => {
                  setState(() {
                    dataResult = data;
                    print(data);
                  })
                },
            onError: (e) => {print(e)});
      //} on PlatformException {
    } on Exception catch (e) {
      print(e);
    } catch (error) {
      print(error);
    }
  }

  Future<void> _sendWithResult_ReceiveIntent() async {}

  Future<void> _sendIntent_AndroidIntentPlus() async {
    try {
      //if (platform.isAndroid) {

      AndroidIntent intent = AndroidIntent(
        action: 'android.intent.action.SEND',
        category: 'android.intent.category.DEFAULT',
        //package: CHANNEL,
        type: 'text/plain',
        // data: 'i am the TEXT',
        arguments: {
          'android.intent.extra.TEXT': myController.text,
        },
      );
      await intent.launch();
      //}
    } on Exception catch (e) {
      print(e);
    } catch (error) {
      print(error);
    }
  }

  void _openChooser() {
    var intent = AndroidIntent(
      action: 'android.intent.action.SEND',
      category: 'android.intent.category.DEFAULT',
      type: 'text/plain',
      //data: 'text example',
      arguments: {
        'android.intent.extra.TEXT': myController.text,
      },
    );
    intent.launchChooser('Chose an app');
  }
}
