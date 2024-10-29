import 'dart:io';
import 'dart:convert';


class SocketService {
  static const String _host = '10.0.2.2';
  static const int _port = 3000;

  static Future<void> sendMessage(Map<String, dynamic> message) async {
    try {
      // estabelece a  conexão com o servidor
      Socket socket = await Socket.connect(_host, _port);
      print('Conectado ao servidor: $_host:$_port');

      // Serializa o mapa para Json e envia
      String jsonMessage = jsonEncode(message);
      //String jsonMessage = "{\"name\":\"João\", \"email\":\"joao@gmail.com\", \"birthday\":\"10/10/10\"}";
      socket.write(jsonMessage);
      print('Mensagem enviada: $jsonMessage');

      // Aguarda uma resposta do servidor
      socket.listen((List<int> event) {
        String response = String.fromCharCodes(event);
        try {
          print('Resposta do servidor: $response');
        } catch (e) {
          print('Erro ao decodificar a resposta: $e');
        }
      });
      // Fecha a conexão
      await socket.flush();
      await Future.delayed(Duration(seconds: 1));
      socket.close();
    } catch (e) {
      print('Erro ao enviar mensagem: $e');
    }
  }

  //Future<void> enviarDados() async {
  //  print('Enviando dados...');
  //  final String url = 'http://10.0.2.2:3000'; // Use 10.0.2.2 para emulador Android
//
  //  // Dados que você deseja enviar
  //  final Map<String, dynamic> dados = {
  //    'operacao': 'inserir',
  //    'colecao': 'exemplo',
  //    'parametros': {'nome': 'João', 'idade': 30}
  //  };
  //  print('Dados que estão sendo enviados: ${jsonEncode(dados)}');
//
  //  // Envio da requisição POST
  //  try {
  //    print('conectando ao servidor...');
  //    final response = await http.post(
  //      Uri.parse(url),
  //      headers: {'Content-Type': 'application/json'},
  //      body: jsonEncode(dados),
  //    );
//
//
  //    if (response.statusCode == 200) {
  //      print('Resposta do servidor: ${response.body}');
  //    } else {
  //      print('Erro ao enviar dados: ${response.statusCode}');
  //    }
  //  } catch (e) {
  //    print('Erro: $e');
  //  }
  //}

}