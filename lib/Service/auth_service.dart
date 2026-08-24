import 'package:google_sign_in/google_sign_in.dart';
import '../Config/model/Post_model.dart';
import '../Config/server/Api_service.dart';

class AuthService {
  static final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email', 'profile']);

  
  static Future<UsuarioModel?> loginComGoogle() async {
    try {
      final GoogleSignInAccount? account = await _googleSignIn.signIn();
      if (account == null) return null;

      final GoogleSignInAuthentication auth = await account.authentication;
      final String? idToken = auth.idToken;

      if (idToken == null) return null;

      final response = await ApiService.request<Map<String, dynamic>>(
        endpoint: '/auth/google',
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

  // Obter Perfil do Usuário Logado
  static Future<UsuarioModel?> getMeuPerfil() async {
    final response = await ApiService.request<UsuarioModel>(
      endpoint: '/usuarios/me',
      verb: HttpVerb.get,
      fromJson: (json) => UsuarioModel.fromJson(json),
    );
    return response.data;
  }

  // Logout
  static Future<void> logout() async {
    await _googleSignIn.signOut();
    await ApiService.clearSession();
  }
}