import 'package:flutter/services.dart';

class RegisterService {
  static const MethodChannel _channel = MethodChannel("com.example.go_campus/app");

  Future<Map<String, dynamic>?> enviarOperacao(String operacao, String colecao, Map<String, dynamic> parametros) async {
    try {
      final response = await _channel.invokeMethod('enviarPedido', {
        'operacao': operacao,
        'colecao': colecao,
        'parametros': parametros,
      });
      return Map<String, dynamic>.from(response);
    } on PlatformException catch (e) {
      print("Erro ao chamar o servidor: ${e.message}");
      return null;
    }
  }

  Future<void> registerUser({
    required String name,
    required String email,
    required String cpf,
    required String birthday,
  }) async {
    // Cria um mapa com os dados do usuário
    Map<String, dynamic> docNovo = {
      'name': name,
      'email': email,
      'cpf': cpf,
      'birthday': birthday,
    };

    // Encapsula o mapa dentro de outro mapa, com a chave 'docNovo'
    Map<String, dynamic> parametros = {'docNovo': docNovo};
    
    print("Enviando dados: $parametros");
    // Envia a mensagem para o servidor
    final response = await enviarOperacao("POST", "Usuario", parametros);
    if (response != null) {
      // Trate a resposta aqui, se necessário
      print("Resposta do servidor: $response");
    } else {
      print("Falha ao registrar o usuário.");
    }
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
    required String telefone,
  }) async {

    // Cria um mapa para endereco
    Map<String, dynamic> endereco = {
      'cep': cep,
      'logradouro': logradouro,
      'numero': numero,
      'bairro': bairro,
      'cidade': cidade,
      'estado': estado,
    };

    // Cria um mapa com os dados do usuário
    Map<String, dynamic> docNovo = {
      'name': name,
      'email': email,
      'cnpj': cnpj,
      'telefone': telefone,
      'endereco': endereco,
    };

    // Encapsula o mapa dentro de outro mapa, com a chave 'docNovo'
    Map<String, dynamic> parametros = {'docNovo': docNovo};
    // Envia a mensagem para o servidor
    try {
      // Chama o método Java via MethodChannel
      print("Enviando dados: $parametros");
      final response = await enviarOperacao("POST", "Empresa", parametros);
      print('Resposta do servidor: $response');
    } on PlatformException catch (e) {
      print('Erro ao chamar o método registerBusiness no Java: ${e.message}');
    }
  }
}