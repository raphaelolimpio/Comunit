import 'package:livekit_client/livekit_client.dart';
import '../Config/Api/Api.dart';
import '../Config/server/Api_service.dart';

class CallService {
  Room? _room;
  Room? get room => _room;

  // 1. Requisitar token da sala para a API FastAPI
  static Future<Map<String, String>?> obterTokenCall(int conversaId) async {
    final response = await ApiService.request<Map<String, dynamic>>(
      endpoint: AppApi.callToken(conversaId),
      verb: HttpVerb.post,
      fromJson: (json) => json as Map<String, dynamic>,
    );

    if (response.isSuccess && response.data != null) {
      return {
        'url': response.data!['livekit_url'] ?? '',
        'token': response.data!['token'] ?? '',
      };
    }
    return null;
  }

  // 2. Conectar na sala de vídeo/voz
  Future<Room?> iniciarCall({required int conversaId}) async {
    final credenciais = await obterTokenCall(conversaId);
    if (credenciais == null) return null;

    final room = Room();

    await room.connect(
      credenciais['url']!,
      credenciais['token']!,
      roomOptions: const RoomOptions(
        adaptiveStream: true,
        dynacast: true,
        defaultCameraCaptureOptions: CameraCaptureOptions(maxFrameRate: 30),
      ),
    );

    await room.localParticipant?.setCameraEnabled(true);
    await room.localParticipant?.setMicrophoneEnabled(true);

    _room = room;
    return room;
  }

  // 3. Encerrar e sair da chamada
  Future<void> desconectar() async {
    await _room?.disconnect();
    _room = null;
  }
}