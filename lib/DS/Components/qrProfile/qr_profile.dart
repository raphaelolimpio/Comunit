import 'package:dicionario/shared/color.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

void mostrarQrCodePerfil(BuildContext context, {required String perfilUrl, required String nomeUsuario}) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: techSurface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: techBorderColor),
      ),
      title: Column(
        children: [
          const Text(
            'QR Code do Perfil',
            style: TextStyle(
              color: techTextWhite,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            nomeUsuario,
            style: const TextStyle(
              color: techPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 8),
          // Contêiner com fundo branco para garantir contraste perfeito na leitura do QR Code
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: QrImageView(
              data: perfilUrl, // Ex: 'https://seuapp.com/usuario/123'
              version: QrVersions.auto,
              size: 200.0,
              backgroundColor: Colors.white,
              embeddedImage: const AssetImage('assets/images/logo.png'), // Opcional: Logo no centro do QR Code
              embeddedImageStyle: const QrEmbeddedImageStyle(
                size: Size(40, 40),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Peça para outro desenvolvedor escanear\neste código para ver seu perfil.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: techTextGray,
              fontSize: 12,
              height: 1.4,
            ),
          ),
        ],
      ),
      actions: [
        Center(
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: techPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Fechar',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}