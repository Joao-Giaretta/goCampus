import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'services/auth_service.dart';
import 'login_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _startController = TextEditingController();
  final TextEditingController _destinationController = TextEditingController();
  final AuthService _authService = AuthService();
  List<String> _companies = [];
  bool _showResults = false;

  void _searchCompanies() {
    setState(() {
      if (_startController.text.isNotEmpty &&
          _destinationController.text.isNotEmpty) {
        _companies = [
          'Empresa X - ${_startController.text} - ${_destinationController.text}',
          'Empresa Y - ${_startController.text} - ${_destinationController.text}',
          'Empresa Z - ${_startController.text} - ${_destinationController.text}',
        ];
        _showResults = true;
      } else {
        _companies = [];
        _showResults = false;
      }
    });
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
                  return Card(
                    child: ListTile(
                      title: Text(_companies[index]),
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
