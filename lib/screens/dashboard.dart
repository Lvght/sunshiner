import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:sunshiner/components/global_data_display.dart';
import 'package:sunshiner/components/local_data_display.dart';
import 'package:sunshiner/models/state_model.dart';

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
        title: Image.asset(
          'lib/images/logo.png',
          height: 24,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text('UPDATES FROM LAST 7 DAYS',
                style: Theme.of(context).textTheme.headline1),
            Observer(
              builder: (BuildContext context) => Text(
                  'Showing data for ${Provider.of<StateModel>(context).state}, ${Provider.of<StateModel>(context).country}',
                  style: Theme.of(context).textTheme.bodyText1),
            ),
            const SizedBox(height: 48),
            Text('DEATHS', style: Theme.of(context).textTheme.headline1),
            const SizedBox(height: 16),
            const GlobalDeathDataDisplay(),
            const SizedBox(height: 16),
            const SizedBox(height: 80),
            Text('NEW CASES', style: Theme.of(context).textTheme.headline1),
            const SizedBox(height: 16),
            const GlobalConfirmedDataDisplay(),
            const SizedBox(height: 80),
            Text('NATIONAL DEATH CASES',
                style: Theme.of(context).textTheme.headline1),
            const SizedBox(height: 16),
            const LocalDataDisplay(),
          ],
        ),
      ),
    );
  }
}
