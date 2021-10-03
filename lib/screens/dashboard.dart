import 'package:flutter/material.dart';
import 'package:sunshiner/components/local_data_display.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('19monitor'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: const [
            Text('Dados do seu local'),
            SizedBox(height: 16),
            LocalDataDisplay(),
            Text('Outros dados abaixo')
          ],
        ),
      ),
    );
  }
}
