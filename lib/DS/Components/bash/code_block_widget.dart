import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CodeBlockWidget extends StatefulWidget {
  final String code;
  final String linguagem;

  const CodeBlockWidget({
    super.key,
    required this.code,
    required this.linguagem,
  });

  @override
  State<CodeBlockWidget> createState() => _CodeBlockWidgetState();
}

class _CodeBlockWidgetState extends State<CodeBlockWidget> {
  bool _copied = false;

  // Define cores e ícones baseados na linguagem selecionada para dar identidade visual
  Map<String, dynamic> _getLanguageTheme(String lang) {
    final l = lang.toLowerCase();
    if (l.contains('dart') || l.contains('flutter')) {
      return {
        'bg': const Color(0xFF0D1B2A),
        'headerBg': const Color(0xFF1B263B),
        'accent': const Color(0xFF00B4D8),
        'icon': Icons.flutter_dash,
        'name': 'Dart / Flutter',
      };
    } else if (l.contains('python')) {
      return {
        'bg': const Color(0xFF1E1E24),
        'headerBg': const Color(0xFF2E2E38),
        'accent': const Color(0xFFFFD166),
        'icon': Icons.code,
        'name': 'Python',
      };
    } else if (l.contains('js') || l.contains('ts') || l.contains('javascript')) {
      return {
        'bg': const Color(0xFF18181B),
        'headerBg': const Color(0xFF27272A),
        'accent': const Color(0xFFF7DF1E),
        'icon': Icons.javascript,
        'name': 'JavaScript / TS',
      };
    } else {
      return {
        'bg': const Color(0xFF111827),
        'headerBg': const Color(0xFF1F2937),
        'accent': const Color(0xFF60A5FA),
        'icon': Icons.terminal,
        'name:': widget.linguagem.toUpperCase(),
      };
    }
  }

  void _copyCode() {
    Clipboard.setData(ClipboardData(text: widget.code));
    setState(() => _copied = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _copied = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeInfo = _getLanguageTheme(widget.linguagem);
    final bgColor = themeInfo['bg'] as Color;
    final headerBgColor = themeInfo['headerBg'] as Color;
    final accentColor = themeInfo['accent'] as Color;
    final langIcon = themeInfo['icon'] as IconData;

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Cabeçalho do Bloco de Código (Estilo IDE)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: headerBgColor,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Row(
              children: [
                Icon(langIcon, size: 16, color: accentColor),
                const SizedBox(width: 8),
                Text(
                  widget.linguagem.toUpperCase(),
                  style: TextStyle(
                    color: accentColor,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                InkWell(
                  onTap: _copyCode,
                  borderRadius: BorderRadius.circular(6),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Row(
                      children: [
                        Icon(
                          _copied ? Icons.check : Icons.copy_rounded,
                          size: 14,
                          color: _copied ? Colors.greenAccent : Colors.white70,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _copied ? 'Copiado!' : 'Copiar',
                          style: TextStyle(
                            color: _copied ? Colors.greenAccent : Colors.white70,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Conteúdo do Código
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Text(
                widget.code,
                style: const TextStyle(
                  color: Color(0xFFE5E7EB),
                  fontFamily: 'monospace',
                  fontSize: 13,
                  height: 1.4,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}