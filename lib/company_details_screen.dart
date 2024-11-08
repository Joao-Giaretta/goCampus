import 'package:flutter/material.dart';
import 'company_evaluation_screen.dart';
import 'package:go_campus/services/register_service.dart';

class CompanyDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> company;

  const CompanyDetailsScreen({Key? key, required this.company}) : super(key: key);

  @override
  _CompanyDetailsScreenState createState() => _CompanyDetailsScreenState();
}

class _CompanyDetailsScreenState extends State<CompanyDetailsScreen> {
  double _mediaEvaluation = 0.0;
  final RegisterService _registerService = RegisterService();

  @override
  void initState() {
    super.initState();
    _getMediaEvaluation();
  }

  Future<void> _getMediaEvaluation() async {
    Map<String, dynamic> media = {
      'idEmpresa': widget.company['id'],
    };

    Map<String, dynamic> parametros = {'docNovo': media};

    final response = await _registerService.enviarOperacao("GET", "Avaliacao", parametros);

    if (response != null && response.isNotEmpty) {
      List<dynamic> avaliacoes = response['avaliacao'];
      double total = 0.0;
      for (var avaliacao in avaliacoes) {
        total += avaliacao['grade'];
      }
      setState(() {
        _mediaEvaluation = total / avaliacoes.length;
      });
    } else {
      setState(() {
        print("Nenhuma avaliação encontrada para esta empresa.");
        _mediaEvaluation = 0.0;
      });
    }
  }

  void evaluate(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EvaluationPage(company: widget.company),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final endereco = widget.company['endereco'];
    final trajetos = widget.company['trajetos'];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.company['name']),
        actions: [
          IconButton(
            icon: const Icon(Icons.star),
            onPressed: () => evaluate(context),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(30.0),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              'Média de Avaliação: $_mediaEvaluation',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
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
              const SizedBox(height: 16),
              Text(
                'Nome da Empresa:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                '${widget.company['name']}',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              Text(
                'CNPJ:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                '${widget.company['cnpj']}',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              Text(
                'Endereço:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Cidade:',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Estado:',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '${endereco['cidade']}',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      '${endereco['estado']}',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Rua:',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Número:',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '${endereco['logradouro']}',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      '${endereco['numero']}',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                'Bairro:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                '${endereco['bairro']}',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 4),
              Text(
                'CEP:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                '${endereco['cep']}',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              Text(
                "Contato:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                'Telefone:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                '${widget.company['telefone']}',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              Text(
                'Email:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                '${widget.company['email']}',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              Text(
                'Trajetos:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              for (var trajeto in trajetos)
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, top: 8.0),
                  child: Text(
                    '${trajeto['cidadePartida']} -> ${trajeto['instituicaoDestino']}',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}