
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_campus/login_screen.dart';
import 'package:go_campus/services/register_service.dart';
import 'services/auth_service.dart';
import 'services/date_picker_service.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';

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

  late MaskedTextController _cpfCnpjController;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final MaskedTextController _cepController = MaskedTextController(mask: '00000-000');
  final TextEditingController _logradouroController = TextEditingController();
  final TextEditingController _cidadeController = TextEditingController();
  final TextEditingController _numeroController = TextEditingController();
  final TextEditingController _bairroController = TextEditingController();
  final TextEditingController _dataNascimentoController = TextEditingController();
  final TextEditingController _telefoneController = MaskedTextController(mask: '(00) 00000-0000');

  final RegisterService _registerService = RegisterService();
  String? _selectedEstado;

  @override
  void initState() {
    super.initState();
    _cpfCnpjController = MaskedTextController(
      mask: isPersonPhysical ? '000.000.000-00' : '00.000.000/0000-00',
    );
  }

  _register(bool isPersonPhysical) async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    var user =
        await AuthService().registerWithEmailAndPassword(email, password);
    if (user != null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cadastro bem-sucedido!')));
      if (isPersonPhysical) {
        _registerServerUser();
      } else {
        _registerServerBussiness();
      }

    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao fazer cadastro')));
    }
  }

  void _registerServerUser() async {
    String name = _nameController.text.trim();
    String email = _emailController.text.trim();
    String birthday = _dataNascimentoController.text.trim();
    String cpf = _cpfCnpjController.text.trim();

    final res = await _registerService.registerUser(
      name: name,
      email: email,
      cpf: cpf,
      birthday: birthday,
    );

    if (res == 'success') {
      Navigator.push(
        context, MaterialPageRoute(builder: (context) => LoginScreen()));
    }
    else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao registrar o usuário.'))
      );
    }

  }

  void _registerServerBussiness() async {
    String name = _nameController.text.trim();
    String email = _emailController.text.trim();
    String cnpj = _cpfCnpjController.text.trim();
    String cep = _cepController.text.trim();
    String logradouro = _logradouroController.text.trim();
    String numero = _numeroController.text.trim();
    String bairro = _bairroController.text.trim();
    String cidade = _cidadeController.text.trim();
    String estado = _selectedEstado!;
    String telefone = _telefoneController.text.trim();

    final res = await _registerService.registerBussiness(
      name: name,
      email: email,
      cnpj: cnpj,
      cep: cep,
      logradouro: logradouro,
      numero: numero,
      bairro: bairro,
      cidade: cidade,
      estado: estado,
      telefone: telefone,
    );

    if (res == 'success') {
      Navigator.push(
        context, MaterialPageRoute(builder: (context) => LoginScreen()));
    }
    else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao registrar o usuário.'))
      );
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
                          _cpfCnpjController.updateMask(isPersonPhysical ? '000.000.000-00' : '00.000.000/0000-00');
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
                          _cpfCnpjController.updateMask(isPersonPhysical ? '000.000.000-00' : '00.000.000/0000-00');
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
                  ),
                  const SizedBox(height: 20),
                ] else ...[
                  TextField(
                    controller: _cpfCnpjController,
                    decoration: InputDecoration(
                      labelText: isPersonPhysical ? 'CPF' : 'CNPJ',
                      prefixIcon: Icon(isPersonPhysical ? Icons.description : Icons.business),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _telefoneController,
                    decoration: const InputDecoration(
                      labelText: 'Telefone',
                      prefixIcon: Icon(Icons.phone),
                    ),
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
                    controller: _numeroController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: const InputDecoration(
                      labelText: 'Número',
                      prefixIcon: Icon(Icons.numbers),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _bairroController,
                    decoration: const InputDecoration(
                      labelText: 'Bairro',
                      prefixIcon: Icon(Icons.location_city),
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
                  DropdownButtonFormField<String>(
                    value: _selectedEstado,
                    items: [
                      'AC', 'AL', 'AP', 'AM', 'BA', 'CE', 'DF', 'ES', 'GO', 
                      'MA', 'MT', 'MS', 'MG', 'PA', 'PB', 'PR', 'PE', 'PI', 
                      'RJ', 'RN', 'RS', 'RO', 'RR', 'SC', 'SP', 'SE', 'TO'
                    ].map((String estado) {
                      return DropdownMenuItem<String>(
                        value: estado,
                        child: Text(estado),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedEstado = newValue!;
                      });
                    },
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
                    onPressed: () {
                      if (_passwordController.text == _confirmPasswordController.text) {
                        _register(isPersonPhysical);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Senhas não conferem!'))
                        );
                      }
                    },
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
