import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
      socket.write(jsonMessage);
      print('Mensagem enviada: $jsonMessage');

      // Aguarda uma resposta do servidor
      socket.listen((List<int> event) {
        String response = String.fromCharCodes(event);
        try {
          // Tenta decodificar a resposta como JSON
          Map<String, dynamic> jsonResponse = jsonDecode(response);
          print('Resposta do servidor (JSON): $jsonResponse');
        } catch (e) {
          print('Erro ao decodificar a resposta: $response, $e');
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