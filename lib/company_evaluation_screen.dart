import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:go_campus/services/register_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EvaluationPage extends StatefulWidget {
  final Map<String, dynamic> company;

  const EvaluationPage({Key? key, required this.company}) : super(key: key);

  @override
  _EvaluationPageState createState() => _EvaluationPageState();
}

class _EvaluationPageState extends State<EvaluationPage> {
  final TextEditingController _commentController = TextEditingController();
  final RegisterService _registerService = RegisterService();
  double _rating = 0.0;

  Future<String> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    print(prefs.getString('userName'));
    return prefs.getString('userName') ?? '';
  }

  Future<void> _sendEvaluation() async {
    String comment = _commentController.text.trim();

    if (_rating > 0 && comment.isNotEmpty) {
      String nomeUsuario = await getUserName();
      // Cria um mapa com os dados da avaliação
      Map<String, dynamic> avaliacao = {
        'cnpj': widget.company['cnpj'],
        'nomeUsuario': nomeUsuario,
        'comentario': comment,
        'nota': _rating,
      };

      // Encapsula o mapa dentro de outro mapa, com a chave 'docNovo'
      Map<String, dynamic> parametros = {'docNovo': avaliacao};

      print("Enviando dados: $parametros");
      // Envia a mensagem para o servidor
      final response = await _registerService.enviarOperacao("ADDAVL", "Empresa", parametros);

      if (response != null) {
        print("Avaliação enviada com sucesso.");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Avaliação enviada com sucesso!'),
            duration: Duration(seconds: 3),
          ),
        );
      } else {
        print("Falha ao enviar avaliação.");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Falha ao enviar avaliação. Tente novamente.'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, avalie a empresa e escreva um comentário.'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.company['name']),
      ),
      body: SingleChildScrollView(  // Torna o corpo da tela rolável
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.asset(
                'assets/logo_go_campus.png',
                height: 200,
              ),
            ),
            const Text(
              'Avalie a Empresa',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            // Avaliação por estrelas
            RatingBar.builder(
              initialRating: _rating,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: false,
              itemCount: 5,
              itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => const Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {
                setState(() {
                  _rating = rating;
                });
              },
            ),
            const SizedBox(height: 24),
            // Campo de comentário
            TextField(
              controller: _commentController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Comentário',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            // Botão de envio
            Center(
              child: ElevatedButton(
                onPressed: _sendEvaluation,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 80,
                    vertical: 15,
                  ),
                ),
                child: const Text(
                  'Enviar Avaliação',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}