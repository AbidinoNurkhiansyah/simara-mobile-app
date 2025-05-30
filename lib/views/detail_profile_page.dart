import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../providers/profile_provider.dart';

class DetailProfilePage extends StatefulWidget {
  @override
  _DetailProfilePageState createState() => _DetailProfilePageState();
}

class _DetailProfilePageState extends State<DetailProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _nohpController;
  late TextEditingController _domisiliController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _nohpController = TextEditingController();
    _domisiliController = TextEditingController();

    // Wait for next frame to ensure context is available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // First ensure auth provider has loaded
      context.read<MyAuthProvider>().loadUserData().then((_) {
        _loadUserData();
      });
    });
  }

  Future<void> _loadUserData() async {
    try {
      // Get user ID from auth provider directly
      final idUser = context.read<MyAuthProvider>().idUser;
      print('Loading profile for user ID from Provider: $idUser');

      if (idUser != null) {
        await context.read<ProfileProvider>().fetchProfile(idUser);
        final profileData = context.read<ProfileProvider>().profileData;

        if (profileData != null) {
          setState(() {
            _nameController.text = profileData['name'] ?? '';
            _emailController.text = profileData['email'] ?? '';
            _nohpController.text = profileData['nohp'] ?? '';
            _domisiliController.text = profileData['domisili'] ?? '';
          });
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Failed to load profile data')),
            );
          }
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('User not logged in')));
          Navigator.of(context).pop(); // Return to previous screen
        }
      }
    } catch (e) {
      print('Error loading user data: $e');
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error loading profile: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Detail Profil',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: Color(0xFF31502C),
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Consumer<ProfileProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: Color(0xFF31502C),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.person,
                            size: 50,
                            color: Color(0xFF31502C),
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Profil Anda',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Card(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                            side: BorderSide(color: Colors.grey.shade200),
                          ),
                          color: Color(0xFFF7FAF2),
                          child: Padding(
                            padding: EdgeInsets.all(20.0),
                            child: Column(
                              children: [
                                TextFormField(
                                  controller: _nameController,
                                  decoration: InputDecoration(
                                    labelText: 'Nama Lengkap',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    prefixIcon: Icon(Icons.person_outline),
                                  ),
                                  validator:
                                      (value) =>
                                          value!.isEmpty
                                              ? 'Nama tidak boleh kosong'
                                              : null,
                                ),
                                SizedBox(height: 20),
                                TextFormField(
                                  controller: _emailController,
                                  decoration: InputDecoration(
                                    labelText: 'Email',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    prefixIcon: Icon(Icons.email_outlined),
                                  ),
                                  validator:
                                      (value) =>
                                          value!.isEmpty
                                              ? 'Email tidak boleh kosong'
                                              : null,
                                ),
                                SizedBox(height: 20),
                                TextFormField(
                                  controller: _nohpController,
                                  decoration: InputDecoration(
                                    labelText: 'Nomor HP',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    prefixIcon: Icon(Icons.phone_outlined),
                                  ),
                                  keyboardType: TextInputType.phone,
                                  validator:
                                      (value) =>
                                          value!.isEmpty
                                              ? 'Nomor HP tidak boleh kosong'
                                              : null,
                                ),
                                SizedBox(height: 20),
                                TextFormField(
                                  controller: _domisiliController,
                                  decoration: InputDecoration(
                                    labelText: 'Domisili',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    prefixIcon: Icon(
                                      Icons.location_on_outlined,
                                    ),
                                  ),
                                  validator:
                                      (value) =>
                                          value!.isEmpty
                                              ? 'Domisili tidak boleh kosong'
                                              : null,
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 30),
                        Container(
                          width: double.infinity,
                          height: 55,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF31502C),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              elevation: 4,
                            ),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                final idUser =
                                    context.read<MyAuthProvider>().idUser;
                                if (idUser == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('User not logged in'),
                                    ),
                                  );
                                  return;
                                }

                                final success = await provider.updateProfile({
                                  'id_user': idUser,
                                  'name': _nameController.text,
                                  'email': _emailController.text,
                                  'nohp': _nohpController.text,
                                  'domisili': _domisiliController.text,
                                });

                                if (success) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Profil berhasil diperbarui',
                                      ),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Gagal memperbarui profil'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              }
                            },
                            child: Text(
                              'Simpan Perubahan',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _nohpController.dispose();
    _domisiliController.dispose();
    super.dispose();
  }
}
