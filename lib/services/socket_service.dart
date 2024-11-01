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

}