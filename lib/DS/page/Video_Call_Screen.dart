import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:dicionario/shared/color.dart';


class VideoCallScreen extends StatefulWidget {
  final String channelName;
  final String appId; // Seu App ID fornecido pelo painel do Agora.io

  const VideoCallScreen({
    Key? key,
    required this.channelName,
    required this.appId,
  }) : super(key: key);

  @override
  State<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  late RtcEngine _engine;
  bool _isJoined = false;
  bool _isMuted = false;
  bool _isVideoEnabled = true;
  bool _isScreenSharing = false; // Estado da transmissão de tela estilo Discord
  int? _remoteUid;

  @override
  void initState() {
    super.initState();
    _initAgora();
  }

  Future<void> _initAgora() async {
    // 1. Solicitar permissões de câmera e microfone
    await [Permission.microphone, Permission.camera].request();

    // 2. Criar e inicializar o motor do Agora
    _engine = createAgoraRtcEngine();
    await _engine.initialize(RtcEngineContext(
      appId: widget.appId,
      channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
    ));

    // 3. Registrar eventos de conexão
    _engine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          setState(() {
            _isJoined = true;
          });
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          setState(() {
            _remoteUid = remoteUid;
          });
        },
        onUserOffline: (RtcConnection connection, int remoteUid, UserOfflineReasonType reason) {
          setState(() {
            _remoteUid = null;
          });
        },
      ),
    );

    // 4. Habilitar vídeo e entrar no canal
    await _engine.enableVideo();
    await _engine.startPreview();
    
    await _engine.joinChannel(
      token: '', // Insira seu Token temporário ou de produção aqui
      channelId: widget.channelName,
      options: const ChannelMediaOptions(
        clientRoleType: ClientRoleType.clientRoleBroadcaster,
        channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
      ),
      uid: 0,
    );
  }

  // Função para Alternar a Transmissão de Tela (Estilo Discord)
  // Função para Alternar a Transmissão de Tela (Estilo Discord)
  Future<void> _toggleScreenSharing() async {
    setState(() {
      _isScreenSharing = !_isScreenSharing;
    });

    if (_isScreenSharing) {
      // Inicia a captura de tela nativa do dispositivo usando ScreenVideoParameters
      await _engine.startScreenCapture(
        const ScreenCaptureParameters2(
          captureAudio: true,
          captureVideo: true,
          videoParams: ScreenVideoParameters(
            dimensions: VideoDimensions(width: 1280, height: 720),
            frameRate: 15,
            bitrate: 1000,
          ),
        ),
      );
    } else {
      // Para a transmissão de tela e retorna para a câmera frontal
      await _engine.stopScreenCapture();
    }
  }

  @override
  void dispose() {
    _engine.leaveChannel();
    _engine.release();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: techBackground,
      appBar: AppBar(
        backgroundColor: techSurface,
        title: Text('Canal: ${widget.channelName}', style: const TextStyle(color: techTextWhite)),
        iconTheme: const IconThemeData(color: techTextWhite),
      ),
      body: Stack(
        children: [
          // Exibição da Câmera ou da Tela Compartilhada do Participante Remoto
          Center(
            child: _remoteUid != null
                ? AgoraVideoView(
                    controller: VideoViewController.remote(
                      rtcEngine: _engine,
                      canvas: VideoCanvas(uid: _remoteUid),
                      connection: RtcConnection(channelId: widget.channelName),
                    ),
                  )
                : const Text(
                    'Aguardando outros participantes...',
                    style: TextStyle(color: techTextGray),
                  ),
          ),

          // Miniatura da Câmera do Próprio Usuário (Picture-in-Picture)
          Positioned(
            top: 16,
            right: 16,
            width: 100,
            height: 150,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: techBorderColor),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: _isJoined && _isVideoEnabled
                    ? AgoraVideoView(
                        controller: VideoViewController(
                          rtcEngine: _engine,
                          canvas: const VideoCanvas(uid: 0), // 0 representa o próprio usuário
                        ),
                      )
                    : Container(
                        color: techSurface,
                        child: const Center(
                          child: Icon(Icons.videocam_off, color: techTextGray),
                        ),
                      ),
              ),
            ),
          ),

          // ==========================================
          // BARRA DE CONTROLES INFERIOR (ESTILO DISCORD)
          // ==========================================
          Positioned(
            bottom: 24,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Botão de Áudio (Microfone)
                FloatingActionButton(
                  heroTag: 'mic',
                  backgroundColor: _isMuted ? Colors.red : techSurface,
                  onPressed: () {
                    setState(() {
                      _isMuted = !_isMuted;
                      _engine.muteLocalAudioStream(_isMuted);
                    });
                  },
                  child: Icon(_isMuted ? Icons.mic_off : Icons.mic, color: techTextWhite),
                ),
                const SizedBox(width: 16),

                // Botão de Vídeo (Câmera)
                FloatingActionButton(
                  heroTag: 'video',
                  backgroundColor: !_isVideoEnabled ? Colors.red : techSurface,
                  onPressed: () {
                    setState(() {
                      _isVideoEnabled = !_isVideoEnabled;
                      _engine.enableLocalVideo(_isVideoEnabled);
                    });
                  },
                  child: Icon(_isVideoEnabled ? Icons.videocam : Icons.videocam_off, color: techTextWhite),
                ),
                const SizedBox(width: 16),

                // Botão de Transmissão de Tela (Screen Share - Estilo Discord)
                FloatingActionButton(
                  heroTag: 'screenshare',
                  backgroundColor: _isScreenSharing ? techPrimary : techSurface,
                  onPressed: _toggleScreenSharing,
                  child: Icon(
                    _isScreenSharing ? Icons.screen_share : Icons.stop_screen_share,
                    color: techTextWhite,
                  ),
                ),
                const SizedBox(width: 16),

                // Botão de Desligar (Encerrar Chamada)
                FloatingActionButton(
                  heroTag: 'hangup',
                  backgroundColor: Colors.redAccent,
                  onPressed: () => Navigator.pop(context),
                  child: const Icon(Icons.call_end, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}