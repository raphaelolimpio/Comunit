import 'package:flutter/material.dart';

class ReturnButtonCustom<T> extends StatelessWidget {
  final T? resultadoAoVoltar;
  final VoidCallback? onBeforePop;

  const ReturnButtonCustom({
    Key? key,
    this.resultadoAoVoltar,
    this.onBeforePop,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back_ios_new, size: 20),
      onPressed: () {
        if (onBeforePop != null) {
          onBeforePop!();
        }
        // Desempilha a rota atual entregando o resultado para a anterior
        Navigator.pop(context, resultadoAoVoltar);
      },
    );
  }
}