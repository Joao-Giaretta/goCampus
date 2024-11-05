import 'package:flutter/material.dart';
import 'package:go_campus/company_details_screen.dart';
import 'package:go_campus/services/register_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'services/auth_service.dart';
import 'login_screen.dart';
import 'dart:convert';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _startController = TextEditingController();
  final TextEditingController _destinationController = TextEditingController();
  final AuthService _authService = AuthService();
  final RegisterService _registerService = RegisterService();
  List<Map<String, dynamic>> _companies =[];
  bool _showResults = false;

  Future<void> _searchCompanies() async{
    if (_startController.text.isNotEmpty &&
        _destinationController.text.isNotEmpty) {
        Map<String, dynamic> parametros = {
          'cidadePartida': _startController.text,
          'instituicaoDestino': _destinationController.text,
        };
        final response = await _registerService.enviarOperacao("GET", "Empresa", parametros);
        print(response);
        if (response != null && response.isNotEmpty) {
            try {
              // Aqui é onde você deve decodificar a string JSON
              List<dynamic> empresas = jsonDecode(response['message']); // Decodificando a string
              setState(() {
                _companies = List<Map<String, dynamic>>.from(empresas.map((empresa) => empresa as Map<String, dynamic>));
                _showResults = true;
              });
            } catch (e) {
                print('Erro ao decodificar JSON: $e'); // Captura de erro para depuração
                setState(() {
                    _companies = [];
                    _showResults = false;
                });
            }
        } else {
            setState(() {
                _companies = [];
                _showResults = false;
            });
        }
    } else {
        setState(() {
            _companies = [];
            _showResults = false;
        });
    }
  }

  void _logout() async {
    // Logout do Firebase
    _authService.signOut();
    // Remover dados do SharedPreferences
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(
        'isLoggedIn', false); // Defina a chave isLoggedIn como false
    await prefs
        .remove('userEmail'); // Remova a chave usada para armazenar o email

    // Navegar de volta para a tela de login
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GoCampus'),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: _logout,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/logo_go_campus.png',
              height: 200,
            ),
            const SizedBox(height: 10),
            const Text(
              'Digite a cidade de partida e a Instituição de destino',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _startController,
                    decoration: const InputDecoration(
                      labelText: 'Cidade de partida',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: _destinationController,
                    decoration: const InputDecoration(
                      labelText: 'Instituição de destino',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _searchCompanies,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
              ),
              child: const Text(
                'Buscar Empresas',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
            const SizedBox(height: 16),
            if (_showResults)
              ListView.builder(
                shrinkWrap:
                    true, // Evita que a lista ocupe todo o espaço disponível
                physics:
                    const NeverScrollableScrollPhysics(), // Desativa a rolagem interna da ListView
                itemCount: _companies.length,
                itemBuilder: (context, index) {
                  final company = _companies[index];
                  return Card(
                    child: ListTile(
                      title: Text(company['name']),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CompanyDetailsScreen(
                              company: company
                            ),
                          ),
                        );
                      }
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _startController.dispose();
    _destinationController.dispose();
    super.dispose();
  }
}
