import 'package:google_sign_in/google_sign_in.dart';
import '../Config/Api/Api.dart';
import '../Config/model/Post_model.dart';
import '../Config/server/Api_service.dart';

class AuthService {
  static final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  // 1. Login com Google
  static Future<UsuarioModel?> loginComGoogle() async {
    try {
      // Chama o authenticate diretamente
      final GoogleSignInAccount? account = await _googleSignIn.authenticate();
      if (account == null) return null;

      final GoogleSignInAuthentication auth = await account.authentication;
      final String? idToken = auth.idToken;

      if (idToken == null) return null;

      final response = await ApiService.request<Map<String, dynamic>>(
        endpoint: AppApi.authGoogle,
        verb: HttpVerb.post,
        body: {'id_token': idToken},
        fromJson: (json) => json as Map<String, dynamic>,
      );

      if (response.isSuccess && response.data != null) {
        final token = response.data!['access_token'];
        await ApiService.saveToken(token);
        return UsuarioModel.fromJson(response.data!['usuario']);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // 2. Cadastro de Usuário (E-mail e Senha)
  static Future<UsuarioModel?> cadastrar({
    required String nome,
    required String email,
    required String password,
  }) async {
    final response = await ApiService.request<Map<String, dynamic>>(
      endpoint: '/auth/register',
      verb: HttpVerb.post,
      body: {
        'nome': nome,
        'email': email,
        'password': password,
      },
      fromJson: (json) => json as Map<String, dynamic>,
    );

    if (response.isSuccess && response.data != null) {
      final token = response.data!['access_token'];
      if (token != null) {
        await ApiService.saveToken(token);
      }
      return UsuarioModel.fromJson(response.data!['usuario']);
    }
    return null;
  }

  // 3. Login Convencional (E-mail e Senha)
  static Future<UsuarioModel?> login({
    required String email,
    required String password,
  }) async {
    final response = await ApiService.request<Map<String, dynamic>>(
      endpoint: '/auth/login',
      verb: HttpVerb.post,
      body: {
        'email': email,
        'password': password,
      },
      fromJson: (json) => json as Map<String, dynamic>,
    );

    if (response.isSuccess && response.data != null) {
      final token = response.data!['access_token'];
      await ApiService.saveToken(token);
      return UsuarioModel.fromJson(response.data!['usuario']);
    }
    return null;
  }

  // 4. Obter Perfil do Usuário Logado
  static Future<UsuarioModel?> getMeuPerfil() async {
    final response = await ApiService.request<UsuarioModel>(
      endpoint: AppApi.meuPerfil,
      verb: HttpVerb.get,
      fromJson: (json) => UsuarioModel.fromJson(json),
    );
    return response.data;
  }

  // 5. Atualizar Perfil
  static Future<bool> atualizarPerfil({String? nome, String? bio, String? fotoUrl}) async {
    final response = await ApiService.request(
      endpoint: AppApi.meuPerfil,
      verb: HttpVerb.put,
      body: {
        if (nome != null) 'nome': nome,
        if (bio != null) 'bio': bio,
        if (fotoUrl != null) 'foto_url': fotoUrl,
      },
      fromJson: (json) => json,
    );
    return response.isSuccess;
  }

  // 6. Atualizar Token FCM
  static Future<bool> registrarFcmToken(String fcmToken) async {
    final response = await ApiService.request(
      endpoint: AppApi.fcmToken,
      verb: HttpVerb.post,
      body: {'fcm_token': fcmToken},
      fromJson: (json) => json,
    );
    return response.isSuccess;
  }

  // 7. Logout
  static Future<void> logout() async {
    try {
      await _googleSignIn.signOut();
    } catch (_) {}
    await ApiService.clearSession();
  }
}