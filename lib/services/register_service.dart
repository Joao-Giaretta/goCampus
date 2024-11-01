import 'socket_service.dart';

class RegisterService {
  Future<void> registerUser({
    required String name,
    required String email,
    required String birthday,
  }) async {
    // Cria um mapa com os dados do usuário
    Map<String, dynamic> message = {
      'name': name,
      'email': email,
      'birthday': birthday,
    };
    // Envia a mensagem para o servidor
    await SocketService.sendMessage(message);
  }

  Future<void> registerBussiness({
    required String name,
    required String email,
    required String cnpj,
    required String cep,
    required String logradouro,
    required String numero,
    required String bairro,
    required String cidade,
    required String estado,
  }) async {
    // Cria um mapa com os dados do usuário
    Map<String, dynamic> message = {
      'name': name,
      'email': email,
      'cnpj': cnpj,
      'cep': cep,
      'logradouro': logradouro,
      'numero': numero,
      'bairro': bairro,
      'cidade': cidade,
      'estado': estado,
    };
    // Envia a mensagem para o servidor
    await SocketService.sendMessage(message);
  }
}