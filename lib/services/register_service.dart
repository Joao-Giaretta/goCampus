import 'socket_service.dart';

class RegisterService {
  Future<void> registerUser({
    required String name,
    required String email,
    required String birthday,
  }) async {
    // Cria um mapa com os dados do usuário
    Map<String, dynamic> message = {
      'operacao': 'POST',
      'colecao': 'Usuario',
      'parametros': {
      'name': name,
      'email': email,
      'birthday': birthday,
      }
    };
    // Envia a mensagem para o servidor
    await SocketService.sendMessage(message);
  }
}