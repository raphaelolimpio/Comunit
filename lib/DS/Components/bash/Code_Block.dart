import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/atom-one-dark.dart';

class CodeBlockCustom extends StatelessWidget {
  final String code;
  final String language;

  const CodeBlockCustom({
    Key? key,
    required this.code,
    this.language = 'dart',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF282C34),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: const BoxDecoration(
              color: Color(0xFF21252B),
              borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  language.toUpperCase(),
                  style: const TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold),
                ),
                InkWell(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: code));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Código copiado!'), duration: Duration(seconds: 1)),
                    );
                  },
                  child: const Row(
                    children: [
                      Icon(Icons.copy, size: 14, color: Colors.white70),
                      SizedBox(width: 4),
                      Text('Copiar', style: TextStyle(color: Colors.white70, fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Código destacado
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(12),
            child: HighlightView(
              code,
              language: language,
              theme: atomOneDarkTheme,
              textStyle: const TextStyle(fontFamily: 'monospace', fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}