import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_campus/services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_campus/services/register_service.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'login_screen.dart';

class CompanyScreen extends StatefulWidget {

  const CompanyScreen({Key? key}) : super(key: key);

  @override
  _CompanyScreenState createState() => _CompanyScreenState();
}

class _CompanyScreenState extends State<CompanyScreen> {
  late Map<String, dynamic> companyData = {};
  late TextEditingController nameController;
  late TextEditingController telefoneController;
  late MaskedTextController cepController = MaskedTextController(mask: '00000-000');
  late TextEditingController logradouroController;
  late TextEditingController cidadeController;
  late TextEditingController numeroController;
  late TextEditingController bairroController;
  String? _selectedEstado;
  final AuthService _authService = AuthService();
  bool isEditing = false;
  final TextEditingController cidadePartidaController = TextEditingController();
  final TextEditingController instituicaoDestinoController = TextEditingController();

  void _showAddTrajetoPopup(String cnpj) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Adiconar Trajeto"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: cidadePartidaController,
                decoration: const InputDecoration(
                  labelText: 'Cidade de Partida',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: instituicaoDestinoController,
                decoration: const InputDecoration(
                  labelText: 'Instituição de Destino',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                // TODO: logicar para adicionar o trajeto
                _addTrajeto(cnpj);
                cidadePartidaController.clear();
                instituicaoDestinoController.clear();
                Navigator.pop(context);
              },
              child: const Text('Adicionar'),
            ),
          ],
        );
      },
    );
  }


  Future<void> _getCompanyData() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('userEmail');

    if (email != null) {
      final response = await RegisterService().getUserByEmail(email);

      if (response != null && response['status'] == 'success') {
        // Acessa os dados do usuário na chave 'message'
        companyData = jsonDecode(response['message']);
        final endereco = companyData['endereco'];
        setState(() {
          companyData = companyData;
          nameController = TextEditingController(text: companyData['name']);
          telefoneController = TextEditingController(text: companyData['telefone']);
          cepController.text = endereco['cep'];
          logradouroController = TextEditingController(text: endereco['logradouro']);
          cidadeController = TextEditingController(text: endereco['cidade']);
          numeroController = TextEditingController(text: endereco['numero']);
          bairroController = TextEditingController(text: endereco['bairro']);
          _selectedEstado = endereco['estado'];
        });
      } else {
        print('Falha ao obter os dados da empresa'); // Retorna um mapa vazio caso haja falha
      }
    } else {
      print('Email não encontrado nas preferências'); // Retorna um mapa vazio caso não haja email nas preferências
    }
  }


  @override
  void initState() {
    super.initState();
    _getCompanyData();
  }

    void _logout() async {
    bool? confirmLogout = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar Logout'),
          content: const Text('Você tem certeza que deseja sair?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); 
              },
              child: const Text('Sair'),
            ),
          ],
        );
      },
    );
  
    if (confirmLogout == true) {
      // Logout do Firebase
      _authService.signOut();
      // Remover dados do SharedPreferences
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', false); // Defina a chave isLoggedIn como false
      await prefs.remove('userEmail'); // Remova a chave usada para armazenar o email
  
      // Navegar de volta para a tela de login
      Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginScreen()));
    }
  }

  Future _addTrajeto(String cnpj) async {
    final response = await RegisterService().addTrajeto(
      cnpj,
      cidadePartidaController.text,
      instituicaoDestinoController.text,
    );
    if (response != null && response['status'] == 'success') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Trajeto adicionado com sucesso!'),
          backgroundColor: Colors.green,
        ),
      );
      setState(() {
        _getCompanyData();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Falha ao adicionar o trajeto.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future _updateData(String cnpj) async {
    final response = await RegisterService().updateData(
      nameController.text,
      telefoneController.text,
      cepController.text,
      logradouroController.text,
      numeroController.text,
      bairroController.text,
      cidadeController.text,
      _selectedEstado!,
      cnpj
    );
    if (response != null && response['status'] == 'success') {
       ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Dados atualizados com sucesso!'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Falha ao atualizar os dados.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future _deleteTrajeto(String cnpj, String cidadePartida, String instituicaoDestino) async {
    bool? confirmDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar Exclusão'),
          content: const Text('Você tem certeza que deseja excluir o trajeto?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); 
              },
              child: const Text('Excluir'),
            ),
          ],
        );
      },
    );
  
    if (confirmDelete == true) {
      final response = await RegisterService().deleteTrajeto(
        cnpj,
        cidadePartida,
        instituicaoDestino,
      );
      if (response != null && response['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Trajeto deletado com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
        setState(() {
          _getCompanyData();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Falha ao deletar o trajeto.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } 
  }
  

  @override
  Widget build(BuildContext context) {
    if (companyData.isEmpty) {
      return Center(child: CircularProgressIndicator());
    }
    final trajetos = companyData['trajetos'];
    final avaliacoes = companyData['avaliacoes'];
    final mediaAvl = companyData['mediaAvl'] ?? 0;

    return Scaffold(
      appBar: AppBar(
        title: Text(companyData['name']),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: _logout,
          ),
        ],
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
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (isEditing)
                    IconButton(
                      icon: const Icon(Icons.save),
                      onPressed: () async {
                        await _updateData(companyData['cnpj']);
                        setState(() {
                          isEditing = false;
                        });
                      },
                    )
                  else
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        setState(() {
                          isEditing = true;
                        });
                      },
                    ),
                ],
              ),
              TextField(
                controller: nameController,
                enabled: isEditing,
                decoration: const InputDecoration(
                  labelText: 'Nome da Empresa',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'CNPJ:',
                style:
                    TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                '${companyData['cnpj']}',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              Text(
                'Endereço:',
                style:
                    TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: cidadeController,
                      enabled: isEditing,
                      decoration: const InputDecoration(
                        labelText: 'Cidade',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _selectedEstado,
                      items: [
                        'AC',
                        'AL',
                        'AP',
                        'AM',
                        'BA',
                        'CE',
                        'DF',
                        'ES',
                        'GO',
                        'MA',
                        'MT',
                        'MS',
                        'MG',
                        'PA',
                        'PB',
                        'PR',
                        'PE',
                        'PI',
                        'RJ',
                        'RN',
                        'RS',
                        'RO',
                        'RR',
                        'SC',
                        'SP',
                        'SE',
                        'TO'
                      ].map((String estado) {
                        return DropdownMenuItem<String>(
                          value: estado,
                          child: Text(estado),
                        );
                      }).toList(),
                      onChanged: isEditing
                        ? (String? newValue) {
                            setState(() {
                            _selectedEstado = newValue!;
                            });
                          } 
                        : null,
                      decoration: const InputDecoration(
                        labelText: 'Estado',
                        prefixIcon: Icon(Icons.flag),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: logradouroController,
                      enabled: isEditing,
                      decoration: const InputDecoration(
                        labelText: 'Logradouro',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      controller: numeroController,
                      enabled: isEditing,
                      decoration: const InputDecoration(
                        labelText: 'Numero',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              TextField(
                controller: bairroController,
                enabled: isEditing,
                decoration: const InputDecoration(
                  labelText: 'Bairro',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 18),
              TextField(
                controller: cepController,
                enabled: isEditing,
                decoration: const InputDecoration(
                  labelText: 'CEP',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "Contato:",
                style:
                    TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: telefoneController,
                enabled: isEditing,
                decoration: const InputDecoration(
                  labelText: 'Telefone',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Email:',
                style:
                    TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                '${companyData['email']}',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Trajetos:',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () => _showAddTrajetoPopup(companyData['cnpj']),
                    tooltip: 'Adicionar Trajeto',
                  ),
                ],
              ),
              for (var trajeto in trajetos)
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, top: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          '${trajeto['cidadePartida']} -> ${trajeto['instituicaoDestino']}',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        tooltip: 'Excluir Trajeto',
                        onPressed: () => _deleteTrajeto(
                          companyData['cnpj'],
                          trajeto['cidadePartida'],
                          trajeto['instituicaoDestino'],
                        ),
                      ),
                    ],
                  )
                ),
              const SizedBox(height: 16),
              Text(
                'Avaliações:',
                style:
                    TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              (avaliacoes.isEmpty || mediaAvl == 0)
                  ? Padding(
                      padding: const EdgeInsets.only(left: 8.0, top: 8.0),
                      child: Text(
                        'Não existem avaliações para esta empresa.',
                        style: TextStyle(
                            fontSize: 16, fontStyle: FontStyle.italic),
                      ),
                    )
                  : Column(
                      children: [
                        Padding(
                            padding: const EdgeInsets.only(
                                left: 8.0, top: 8.0),
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Media das Avaliações: ',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
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
                            )),
                        SizedBox(height: 8),
                        for (var avaliacao in avaliacoes)
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 8.0, top: 8.0),
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Avaliação de ${avaliacao['nomeUsuario']}',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
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
