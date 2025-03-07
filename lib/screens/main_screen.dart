import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  void openApi() async {
    var url = Uri.parse("https://psgc.gitlab.io/api/island-groups/");
    var response = await http.get(url);
    print(response.statusCode);
    print(response.headers);
    print(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ElevatedButton(onPressed: openApi, child: Text("Open API")),
    );
  }
}
