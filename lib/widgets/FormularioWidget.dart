import 'package:flutter/material.dart';

abstract class FormularioWidget extends StatefulWidget {
  const FormularioWidget({ Key? key }) : super(key: key);
}

abstract class FormulariowidgetState<T extends FormularioWidget> extends State<T> {

  bool validar();
  void limpar();
  Future<void> salvar();

  @override
  Widget build(BuildContext context);
}