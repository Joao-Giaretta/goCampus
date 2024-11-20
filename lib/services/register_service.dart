import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      'tipoUsuario': 'Usuario',
    };

    // Encapsula o mapa dentro de outro mapa, com a chave 'docNovo'
    Map<String, dynamic> parametros = {'docNovo': docNovo};
    
    print("Enviando dados: $parametros");
    // Envia a mensagem para o servidor
    final response = await enviarOperacao("ADD", "Usuario", parametros);
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
      'mediaAvl': 0,
      'tipoUsuario': 'Empresa',
      'avaliacoes': [],
      'trajetos': [],
    };

    // Encapsula o mapa dentro de outro mapa, com a chave 'docNovo'
    Map<String, dynamic> parametros = {'docNovo': docNovo};
    // Envia a mensagem para o servidor
    try {
      // Chama o método Java via MethodChannel
      print("Enviando dados: $parametros");
      final response = await enviarOperacao("ADD", "Empresa", parametros);
      print('Resposta do servidor: $response');
    } on PlatformException catch (e) {
      print('Erro ao chamar o método registerBusiness no Java: ${e.message}');
    }
  }

  Future getUserByEmail(String email) async {
    // Cria um mapa com os dados do usuário
    Map<String, dynamic> parametros = {'email': email};
    // Envia a mensagem para o servidor
    final response = await enviarOperacao("USERNAME", "Usuario", parametros);
    if (response != null) {
      // Trate a resposta aqui, se necessário
      print("Resposta do servidor: $response");
      return response;
    } else {
      print("Falha ao buscar o usuário.");
    }
  }

  Future<void> saveUserData(String email) async {
    // Chama a função para buscar o nome do usuário
    final res = await getUserByEmail(email);
    Map<String, dynamic> userData = jsonDecode(res['message']);

    final nome = userData['name'];
    final tipoUsuario = userData['tipoUsuario'];

    // Armazena o nome nas SharedPreferences
    if (nome != null && nome.isNotEmpty) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userName', nome);
      await prefs.setString('userType', tipoUsuario);
      print('Nome salvo com sucesso: $nome');
      print('usuário: $tipoUsuario');
    } else {
      print('Falha ao salvar o nome.');
    }
  }

  Future updateData(String name, String telefone, String cep, String logradouro, String numero, String bairro, String cidade, String estado, String cnpj) async {
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
      'telefone': telefone,
      'endereco': endereco,
      'cnpj': cnpj,
    };
    // Encapsula o mapa dentro de outro mapa, com a chave 'docNovo'
    Map<String, dynamic> parametros = {'docNovo': docNovo};
    // Envia a mensagem para o servidor
    try {
      // Chama o método Java via MethodChannel
      print("Enviando dados: $parametros");
      final response = await enviarOperacao("UPDATEEMPRESA", "Empresa", parametros);
      print('Resposta do servidor: $response');
      return response;
    } on PlatformException catch (e) {
      print('Erro ao chamar o método updateData no Java: ${e.message}');
    }
  }

  Future addTrajeto(String cnpj, String cidadePartida, String instituicaoDestino) async {
    Map<String, dynamic> docNovo = {
      'cnpj': cnpj,
      'cidadePartida': cidadePartida,
      'instituicaoDestino': instituicaoDestino,
    };

    Map<String, dynamic> parametros = {'docNovo': docNovo};
    print("Enviando dados: $parametros");

    final response = await enviarOperacao("ADDTRAJETO", "Empresa", parametros);
    if (response != null) {
      print("Trajeto adicionado com sucesso.");
      return response;
    } else {
      print("Falha ao adicionar trajeto.");
    }
  }

  Future deleteTrajeto(String cnpj, String cidadePartida, String instituicaoDestino) async {
    Map<String, dynamic> parametros = {
      'cnpj': cnpj,
      'cidadePartida': cidadePartida,
      'instituicaoDestino': instituicaoDestino,
    };
    print("Enviando dados: $parametros");

    final response = await enviarOperacao("DELETETRAJETO", "Empresa", parametros);
    if (response != null) {
      print("Trajeto deletado com sucesso.");
      return response;
    } else {
      print("Falha ao deletar trajeto.");
    }
  }
}