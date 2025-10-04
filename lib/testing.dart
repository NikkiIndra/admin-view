// lib/main.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:multi_admin/tes2sirine.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(ChangeNotifierProvider(create: (_) => AuthState(), child: MyApp()));
}

class AuthState extends ChangeNotifier {
  final storage = const FlutterSecureStorage();
  String? token;
  String? role;
  int? desaId;

  Future<void> load() async {
    token = await storage.read(key: 'access_token');
    role = await storage.read(key: 'role');
    final desaIdStr = await storage.read(key: 'desa_id');
    desaId = desaIdStr != null ? int.tryParse(desaIdStr) : null;
    notifyListeners();
  }

  Future<void> saveAuth(String tokenVal, String roleVal, int? desaIdVal) async {
    token = tokenVal;
    role = roleVal;
    desaId = desaIdVal;
    await storage.write(key: 'access_token', value: tokenVal);
    await storage.write(key: 'role', value: roleVal);
    if (desaIdVal != null) {
      await storage.write(key: 'desa_id', value: desaIdVal.toString());
    }
    notifyListeners();
  }

  Future<void> logout() async {
    token = null;
    role = null;
    desaId = null;
    await storage.deleteAll();
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  // Change this to your flask server ip if different
  static const String baseUrl = 'http://192.168.0.99:5000';

  @override
  Widget build(BuildContext context) {
    // load token on start
    Provider.of<AuthState>(context, listen: false).load();

    return MaterialApp(
      title: 'SmartCity Auth',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Consumer<AuthState>(
        builder: (context, auth, _) {
          if (auth.token != null) return HomeScreen();
          return RoleChoiceScreen();
        },
      ),
    );
  }
}

class RoleChoiceScreen extends StatefulWidget {
  @override
  _RoleChoiceScreenState createState() => _RoleChoiceScreenState();
}

class _RoleChoiceScreenState extends State<RoleChoiceScreen> {
  String _mode = 'user'; // 'user' or 'admin'

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SmartCity - Auth demo')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ToggleButtons(
              isSelected: [_mode == 'user', _mode == 'admin'],
              onPressed: (i) {
                setState(() {
                  _mode = i == 0 ? 'user' : 'admin';
                });
              },
              children: const [
                Padding(padding: EdgeInsets.all(8), child: Text('User')),
                Padding(padding: EdgeInsets.all(8), child: Text('Admin')),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.person_add),
              label: const Text('Register'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => RegisterScreen(mode: _mode),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              icon: const Icon(Icons.login),
              label: const Text('Login'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => LoginScreen(mode: _mode)),
                );
              },
            ),
            const SizedBox(height: 24),
            const Text(
              'Note: use your Flask server IP: http://192.168.0.99:5000',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

/// ------------------ REGISTER SCREEN ------------------
class RegisterScreen extends StatefulWidget {
  final String mode; // 'user' or 'admin'
  const RegisterScreen({Key? key, required this.mode}) : super(key: key);
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _form = GlobalKey<FormState>();
  final Map<String, String> data = {};
  bool loading = false;

  Future<void> _submit() async {
    if (!_form.currentState!.validate()) return;
    _form.currentState!.save();
    setState(() {
      loading = true;
    });

    try {
      final baseUrl = MyApp.baseUrl;
      final url = widget.mode == 'admin'
          ? Uri.parse('$baseUrl/auth/register-admin')
          : Uri.parse('$baseUrl/auth/register-user');

      // build payload per original server expectations
      Map<String, dynamic> payload;
      if (widget.mode == 'admin') {
        // signup-admin expects: email, katasandi, latlong, code_desa (see your app.py)
        payload = {
          'email': data['email']!,
          'katasandi': data['password']!,
          'latlong': data['latlong'] ?? '',
          'code_desa': data['code_desa'] ?? '',
        };
      } else {
        // signup-user expects: nama_lengkap, rt, rw, blok, desa, code_desa, email, katasandi
        payload = {
          'nama_lengkap': data['nama']!,
          'rt': data['rt'] ?? '',
          'rw': data['rw'] ?? '',
          'blok': data['blok'] ?? '',
          'desa': data['desa'] ?? '',
          'code_desa': data['code_desa'] ?? '',
          'email': data['email']!,
          'katasandi': data['password']!,
        };
      }

      final resp = await http
          .post(
            url,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(payload),
          )
          .timeout(const Duration(seconds: 10));
      final body = jsonDecode(resp.body);

      if (resp.statusCode == 200 || resp.statusCode == 201) {
        _showMessage('Berhasil: ${body['message'] ?? body}');
        Navigator.pop(context);
      } else {
        _showMessage('Gagal: ${body['message'] ?? resp.body}');
      }
    } catch (e) {
      _showMessage('Error: $e');
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  void _showMessage(String msg) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

  @override
  Widget build(BuildContext context) {
    final isAdmin = widget.mode == 'admin';
    return Scaffold(
      appBar: AppBar(title: Text(isAdmin ? 'Register Admin' : 'Register User')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _form,
          child: Column(
            children: [
              if (!isAdmin)
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Nama Lengkap'),
                  validator: (v) => v == null || v.isEmpty ? 'wajib' : null,
                  onSaved: (v) => data['nama'] = v ?? '',
                ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (v) => v == null || v.isEmpty ? 'wajib' : null,
                onSaved: (v) => data['email'] = v ?? '',
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (v) =>
                    v == null || v.length < 6 ? 'minimal 6' : null,
                onSaved: (v) => data['password'] = v ?? '',
              ),
              if (!isAdmin)
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        decoration: const InputDecoration(labelText: 'RT'),
                        onSaved: (v) => data['rt'] = v ?? '',
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextFormField(
                        decoration: const InputDecoration(labelText: 'RW'),
                        onSaved: (v) => data['rw'] = v ?? '',
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextFormField(
                        decoration: const InputDecoration(labelText: 'Blok'),
                        onSaved: (v) => data['blok'] = v ?? '',
                      ),
                    ),
                  ],
                ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Nama Desa (optional)',
                ),
                onSaved: (v) => data['desa'] = v ?? '',
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Kode Desa (code_desa)',
                ),
                onSaved: (v) => data['code_desa'] = v ?? '',
              ),
              if (isAdmin)
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'LatLong (optional)',
                  ),
                  onSaved: (v) => data['latlong'] = v ?? '',
                ),
              const SizedBox(height: 20),
              loading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(onPressed: _submit, child: Text('Register')),
            ],
          ),
        ),
      ),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required String mode});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  bool loading = false;

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    setState(() => loading = true);

    try {
      final url = Uri.parse("${MyApp.baseUrl}/auth/login");
      final resp = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "katasandi": password}),
      );

      final body = jsonDecode(resp.body);

      if (resp.statusCode == 200) {
        final auth = Provider.of<AuthState>(context, listen: false);
        await auth.saveAuth(
          body['token'], // JWT token dari backend
          body['role'], // role dari backend
          body['desa_id'], // desa_id
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Login sukses sebagai ${body['role']}")),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => LatestReportScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Login gagal: ${body['message']}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: "Email"),
                keyboardType: TextInputType.emailAddress,
                validator: (v) => v!.isEmpty ? "Wajib isi email" : null,
                onSaved: (v) => email = v!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "Password"),
                obscureText: true,
                validator: (v) =>
                    v == null || v.length < 6 ? "Minimal 6 karakter" : null,
                onSaved: (v) => password = v!,
              ),
              const SizedBox(height: 20),
              loading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _login,
                      child: const Text("Login"),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

/// ------------------ HOME SCREEN ------------------
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthState>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('SmartCity Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await Provider.of<AuthState>(context, listen: false).logout();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => RoleChoiceScreen()),
                (r) => false,
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Logged in as: ${auth.role ?? 'user'}'),
            const SizedBox(height: 8),
            Text('Desa_id: ${auth.desaId ?? '-'}'),
            const SizedBox(height: 18),
            ElevatedButton(
              onPressed: () {
                // quick demo: open endpoint laporan-terbaru (admin-only)
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => LatestReportScreen()),
                );
              },
              child: const Text('Check latest report (admin)'),
            ),
          ],
        ),
      ),
    );
  }
}

/// ------------------ Admin latest report screen (example) ------------------
class LatestReportScreen extends StatefulWidget {
  @override
  _LatestReportScreenState createState() => _LatestReportScreenState();
}

class _LatestReportScreenState extends State<LatestReportScreen> {
  String? result;
  bool loading = false;

  Future<void> _fetch() async {
    setState(() {
      loading = true;
    });
    try {
      final auth = Provider.of<AuthState>(context, listen: false);
      final token = auth.token;
      final url = Uri.parse('${MyApp.baseUrl}/admin/latest');
      final resp = await http
          .get(
            url,
            headers: {
              'Content-Type': 'application/json',
              if (token != null) 'Authorization': 'Bearer $token',
            },
          )
          .timeout(const Duration(seconds: 10));
      if (resp.statusCode == 200) {
        setState(() {
          result = resp.body;
        });
      } else {
        setState(() {
          result = 'Error ${resp.statusCode}: ${resp.body}';
        });
      }
    } catch (e) {
      setState(() {
        result = 'Exception: $e';
      });
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Latest report (admin)')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: _fetch,
              child: loading
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Fetch latest'),
            ),
            const SizedBox(height: 12),
            if (result != null) SelectableText(result!),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ReportScreen(
                    token:
                        Provider.of<AuthState>(context, listen: false).token ??
                        '',
                  ),
                ),
              ),
              child: const Text('Go to Test Report Screen'),
            ),
          ],
        ),
      ),
    );
  }
}
