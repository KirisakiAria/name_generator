import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebviewPage extends StatefulWidget {
  @override
  _WebviewPageState createState() => _WebviewPageState();
}

class _WebviewPageState extends State<WebviewPage> {
  @override
  Widget build(BuildContext context) {
    Map<String, String> arguments = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          arguments['title'],
          style: TextStyle(color: Colors.black87),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: WebView(
        initialUrl: arguments['url'],
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
