import 'package:flutter/material.dart';
import 'company_evaluation_screen.dart';

class CompanyDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> company;

  const CompanyDetailsScreen({Key? key, required this.company}) : super(key: key);

  @override
  _CompanyDetailsScreenState createState() => _CompanyDetailsScreenState();
}

class _CompanyDetailsScreenState extends State<CompanyDetailsScreen> {

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
    final avaliacoes = widget.company['avaliacoes'];
    final mediaAvl = widget.company['mediaAvl'] ?? 0;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.company['name']),
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
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Avaliações:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  ElevatedButton(
                    onPressed: () => evaluate(context), // Função para avaliar
                    child: Text('Deixar Avaliação'),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
              // Verifica se existe avaliações ou se a média é 0
              (avaliacoes.isEmpty || mediaAvl == 0)
                  ? Padding(
                      padding: const EdgeInsets.only(left: 8.0, top: 8.0),
                      child: Text(
                        'Não existem avaliações para esta empresa.',
                        style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                      ),
                    )
                  : Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0, top: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Media das Avaliações: ',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              Row(
                                children: List.generate(5, (index) {
                                  return Icon(
                                    index < mediaAvl
                                        ? Icons.star
                                        : Icons.star_border,
                                    color: Colors.amber,
                                  );
                                }),
                              ),
                            ],
                          )
                        ),
                        
                        SizedBox(height: 8),
                        for (var avaliacao in avaliacoes)
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0, top: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Avaliação de ${avaliacao['nomeUsuario']}',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'Nota: ',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    Row(
                                      children: List.generate(5, (index) {
                                        return Icon(
                                          index < avaliacao['nota']
                                              ? Icons.star
                                              : Icons.star_border,
                                          color: Colors.amber,
                                        );
                                      }),
                                    ),
                                  ],
                                ),
                                Text(
                                  'Comentário: ${avaliacao['comentario']}',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }
}