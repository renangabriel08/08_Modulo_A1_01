import 'package:flutter/material.dart';

class Modal {
  static bool modalNet = false;

  static net(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Atenção. Problema de conexão.'),
        content: SingleChildScrollView(
          child: Text(
            'Sem conexão com internet, seus dados podem não estar completamente salvos.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Fechar'),
          ),
        ],
      ),
    );
  }

  static bateria(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Atenção. Bateria Baixa.'),
        content: Image.asset('assets/bateria.png'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Fechar'),
          ),
        ],
      ),
    );
  }

  static economia(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text('Modo economia de bateria.'),
        content: SingleChildScrollView(
          child: Text(
            'Seu dispositivo está no modo de economia de energia, alguns recursos podem ser limitados.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Fechar'),
          ),
        ],
      ),
    );
  }
}
