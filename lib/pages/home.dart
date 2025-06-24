import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:moduloa1/widgets/modal.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  startApp() async {
    final List<ConnectivityResult> connectivityResult = await (Connectivity()
        .checkConnectivity());
    if (connectivityResult.contains(ConnectivityResult.none)) {
      Modal.net(context);
    }
  }

  @override
  void initState() {
    startApp();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('App')),
      drawer: Drawer(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(Icons.arrow_back),
                    ),
                    Image.asset('assets/perfil.jpg', height: 100),
                  ],
                ),
                Container(height: 10),
                ListTile(
                  title: Text('Home'),
                  onTap: () => Navigator.pop(context),
                ),
                ListTile(
                  title: Text('QuizMyBrain'),
                  onTap: () => Navigator.pushNamed(context, '/quiz'),
                ),
                ListTile(
                  title: Text('GeniusPLay'),
                  onTap: () => Navigator.pushNamed(context, '/genius'),
                ),
                ListTile(
                  title: Text('MemoCheck'),
                  onTap: () => Navigator.pushNamed(context, '/memo'),
                ),
                ListTile(
                  title: Text('Sair'),
                  onTap: () => SystemNavigator.pop(),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/logo.png', height: 150),
          Container(height: 10),
          Text('Bem-vindo ao Aprender+'),
        ],
      ),
    );
  }
}
