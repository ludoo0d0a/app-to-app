import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:receive_intent/receive_intent.dart' as ri;

void main() {
  runApp(new ReceiverApp());
}

// Theme.of(context).primaryColor;
const MaterialColor primaryColor = Colors.blue;

class ReceiverApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Intent receiver App',
      theme: new ThemeData(primarySwatch: primaryColor),
      home: new ReceiverPage(),
    );
  }
}

class ReceiverPage extends StatefulWidget {
  ReceiverPage({Key? key}) : super(key: key);

  @override
  _ReceiverPageState createState() => new _ReceiverPageState();
}

class _ReceiverPageState extends State<ReceiverPage> {
  static const CHANNEL = 'app.channel.shared.data';
  static const platform = const MethodChannel(CHANNEL);
  String dataShared = "No data";
  String inputCoord = "";
  ri.Intent? _initialIntent;

  @override
  void initState() {
    super.initState();
    debugPrint('');
    getSharedText();
    _initReceivedIntent();
  }

  Future<void> _initReceivedIntent() async {
    final receivedIntent = await ri.ReceiveIntent.getInitialIntent();

    if (!mounted) return;

    setState(() {
      _initialIntent = receivedIntent;
    });
  }

  final myController = TextEditingController(text: "Metz");

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
        title: Text("Intent receiver"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          //crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Text(
                          'This is the shared text from intent:',
                        ),
                        Text(
                          dataShared,
                          style: Theme.of(context).textTheme.headline4,
                        ),
                      ]),
                )
              ],
            ),
            Row(
              //mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        const Text(
                          'Data from receive_intent:',
                        ),
                        Text(
                            "fromPackage: ${_initialIntent?.fromPackageName}\nfromSignatures: ${_initialIntent?.fromSignatures}"),
                        Text(
                            'action: ${_initialIntent?.action}\ndata: ${_initialIntent?.data}\ncategories: ${_initialIntent?.categories}'),
                        Text("extras: ${_initialIntent?.extra}"),
                      ]),
                ),
              ],
            ),
            Row(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: _sendResult_Linker,
                      style: ElevatedButton.styleFrom(
                        primary: Colors.grey, // background
                        onPrimary: Colors.white, // foreground
                      ),
                      child: const Text(' Returns result (Linker)'),
                    ),
                    ElevatedButton(
                      onPressed: _sendResult_Intent,
                      style: ElevatedButton.styleFrom(
                        primary: Colors.grey, // background
                        onPrimary: Colors.white, // foreground
                      ),
                      child: const Text(' Returns result (itzmeanjan/Intent)'),
                    ),
                    TextField(
                      controller: myController,
                    ),
                    ElevatedButton(
                      onPressed: _sendResult_ReceiveIntent,
                      style: ElevatedButton.styleFrom(
                        primary: primaryColor, // background
                        onPrimary: Colors.white, // foreground
                      ),
                      child: const Text(' Returns result (ReceiveIntent)'),
                    ),
                    ElevatedButton(
                      onPressed: _finishActivity,
                      style: ElevatedButton.styleFrom(
                        primary: Colors.red, // background
                        onPrimary: Colors.white, // foreground
                      ),
                      child: const Text(' close this activity'),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _sendResult_Linker() async {}
  Future<void> _sendResult_Intent() async {}

  void _finishActivity() {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    } else {
      SystemNavigator.pop();
    }
    debugPrint('pop / exit activity');
  }

  Future<void> _sendResult_ReceiveIntent() async {
    try {
      //final receivedIntent = await ReceiveIntent.getInitialIntent();
      debugPrint('RECEIVER - ReceiveIntent.setResult...');
      var data = {
        "coord": inputCoord,
        "city": myController.text,
      };
      debugPrint('RECEIVER - send result:' + data.toString());
      await ri.ReceiveIntent.setResult(
        ri.kActivityResultOk,
        shouldFinish: true,
        data: data,
      );
      debugPrint('RECEIVER - ReceiveIntent.setResult DONE !');

      // debugPrint('RECEIVER - close activity ??');
      // _finishActivity();
    } on Exception catch (e) {
      print(e);
    } catch (error) {
      print(error);
    }
  }

  getSharedText() async {
    var sharedData = await platform.invokeMethod("getSharedText");
    if (sharedData != null) {
      setState(() {
        dataShared = sharedData;
        inputCoord = parseCoord(dataShared)!;
      });
    }
  }

  String? parseCoord(String uriText) {
    var uri = Uri.parse(uriText);
    return uri.queryParameters.containsKey("c") ? uri.queryParameters["c"] : "";
  }
}
