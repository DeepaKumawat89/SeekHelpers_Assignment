//------------------------------------ Imports ------------------------------------//
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Models/user_model.dart';  // Updated to use correct case
import '../providers/user_provider.dart';
import '../utils/page_transition.dart';

//------------------------------------ Add User Page Widget ------------------------------------//
class AddUserPage extends StatefulWidget {
  @override
  _AddUserPageState createState() => _AddUserPageState();
}

//------------------------------------ Add User Page State ------------------------------------//
class _AddUserPageState extends State<AddUserPage> {
  //------------------------------------ Form Controllers ------------------------------------//
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();

  //------------------------------------ Build Method ------------------------------------//
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      //------------------------------------ App Bar ------------------------------------//
      appBar: AppBar(
        title: Text(
          'Add New User',
          style: TextStyle(
            fontSize: isTablet ? 24 : 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      //------------------------------------ Form Content ------------------------------------//
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(isTablet ? 24.0 : 16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                //------------------------------------ Input Fields Card ------------------------------------//
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(isTablet ? 24.0 : 16.0),
                    child: Column(
                      children: [
                        //------------------------------------ Name Field ------------------------------------//
                        _buildTextField(
                          controller: nameController,
                          label: 'Name',
                          icon: Icons.person,
                          isTablet: isTablet,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a name';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: isTablet ? 24 : 16),

                        //------------------------------------ Email Field ------------------------------------//
                        _buildTextField(
                          controller: emailController,
                          label: 'Email',
                          icon: Icons.email,
                          isTablet: isTablet,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter an email';
                            }
                            if (!value.contains('@')) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: isTablet ? 24 : 16),

                        //------------------------------------ Phone Field ------------------------------------//
                        _buildTextField(
                          controller: phoneController,
                          label: 'Phone',
                          icon: Icons.phone,
                          isTablet: isTablet,
                          keyboardType: TextInputType.phone,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a phone number';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: isTablet ? 32 : 24),

                //------------------------------------ Submit Button ------------------------------------//
                ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      vertical: isTablet ? 16 : 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Add User',
                    style: TextStyle(
                      fontSize: isTablet ? 18 : 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //------------------------------------ Helper Methods ------------------------------------//
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required bool isTablet,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      style: TextStyle(
        fontSize: isTablet ? 18 : 16,
        color: Colors.black87,
      ),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Theme.of(context).primaryColor),
        labelStyle: TextStyle(
          color: Colors.black54,
          fontSize: isTablet ? 16 : 14,
        ),
      ),
    );
  }

  //------------------------------------ Form Submission ------------------------------------//
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final user = User(
        name: nameController.text,
        email: emailController.text,
        phone: phoneController.text,
      );
      Provider.of<UserProvider>(context, listen: false).addUser(user);

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('User added successfully'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );

      Navigator.pop(context);
    }
  }

  //------------------------------------ Dispose Method ------------------------------------//
  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }
}
