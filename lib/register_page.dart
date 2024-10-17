import 'package:flutter/material.dart';
import 'package:go_campus/login_screen.dart';
import 'services/auth.service.dart';
import 'services/date_picker_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool isPersonPhysical = true;
  bool _obscureText = true;
  bool _obscureTextConfirm = true;
  DateTime? _selectedDate;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _cpfCnpjController = TextEditingController();
  final TextEditingController _cepController = TextEditingController();
  final TextEditingController _logradouroController = TextEditingController();
  final TextEditingController _cidadeController = TextEditingController();
  final TextEditingController _numeroController = TextEditingController();
  final TextEditingController _estadoController = TextEditingController();
  final TextEditingController _dataNascimentoController = TextEditingController();

  void _register() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    var user =
        await AuthService().registerWithEmailAndPassword(email, password);
    if (user != null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cadastro bem-sucedido!')));
      // Navegar para a tela principal ou fazer outra ação após cadastro
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => LoginScreen()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao fazer cadastro')));
    }
  }

  @override
  Widget build(BuildContext content) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro'),
      ),
      body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Seleciona o tipo de pessoa
                Row(
                  children: [
                    Radio(
                      value: true,
                      groupValue: isPersonPhysical,
                      onChanged: (value) {
                        setState(() {
                          isPersonPhysical = true;
                        });
                      },
                    ),
                    const Text('Pessoa Física'),
                    Radio(
                      value: false,
                      groupValue: isPersonPhysical,
                      onChanged: (value) {
                        setState(() {
                          isPersonPhysical = false;
                        });
                      },
                    ),
                    const Text('Pessoa Jurídica'),
                  ],
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Nome',
                    prefixIcon: Icon(Icons.person),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'E-mail',
                    prefixIcon: Icon(Icons.email),
                  ),
                ),
                const SizedBox(height: 20),
                if (isPersonPhysical) ...[
                  TextField(
                    controller: _cpfCnpjController,
                    decoration: const InputDecoration(
                        labelText: 'CPF', prefixIcon: Icon(Icons.description)),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _dataNascimentoController,
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: 'Data de Nascimento',
                      prefixIcon: Icon(Icons.calendar_today),
                    ),
                    onTap: () {
                      DatePickerService.selectDate(
                        context: context,
                        controller: _dataNascimentoController,
                        initialDate: _selectedDate,
                      );
                    },
                  )
                ] else ...[
                  TextField(
                    controller: _cpfCnpjController,
                    decoration: const InputDecoration(
                        labelText: 'CNPJ', prefixIcon: Icon(Icons.business)),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _cepController,
                    decoration: const InputDecoration(
                      labelText: 'CEP',
                      prefixIcon: Icon(Icons.location_on),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _logradouroController,
                    decoration: const InputDecoration(
                      labelText: 'Logradouro',
                      prefixIcon: Icon(Icons.home),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _cidadeController,
                    decoration: const InputDecoration(
                      labelText: 'Cidade',
                      prefixIcon: Icon(Icons.location_city),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _numeroController,
                    decoration: const InputDecoration(
                      labelText: 'Número',
                      prefixIcon: Icon(Icons.confirmation_number),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _estadoController,
                    decoration: const InputDecoration(
                      labelText: 'Estado',
                      prefixIcon: Icon(Icons.flag),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
                TextField(
                  controller: _passwordController,
                  obscureText: _obscureText,
                  decoration: InputDecoration(
                    labelText: 'Senha',
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(_obscureText
                          ? Icons.visibility
                          : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _confirmPasswordController,
                  obscureText: _obscureTextConfirm,
                  decoration: InputDecoration(
                    labelText: 'Confirmar Senha',
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(_obscureTextConfirm
                          ? Icons.visibility
                          : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          _obscureTextConfirm = !_obscureTextConfirm;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: _register,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 80, vertical: 15),
                    ),
                    child: const Text(
                      'Cadastrar',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                )
              ],
            ),
          )),
    );
  }
}
