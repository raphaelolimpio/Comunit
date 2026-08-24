import 'package:livekit_client/livekit_client.dart';

class CallService {
  Room? _room;

  Future<Room> conectarNaCall({
    required String url,
    required String token,
  }) async {
    final room = Room();

    await room.connect(
      url,
      token,
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

  Future<void> desconectar() async {
    await _room?.disconnect();
  }
}
