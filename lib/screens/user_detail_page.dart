//------------------------------------ Imports ------------------------------------//
import 'package:flutter/material.dart';
import '../Models/user_model.dart';

//------------------------------------ User Detail Page ------------------------------------//
class UserDetailPage extends StatelessWidget {
  //------------------------------------ Properties ------------------------------------//
  final User user;

  //------------------------------------ Constructor ------------------------------------//
  const UserDetailPage({required this.user});

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
          'User Details',
          style: TextStyle(
            fontSize: isTablet ? 24 : 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      //------------------------------------ Body Content ------------------------------------//
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(isTablet ? 24.0 : 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //------------------------------------ User Profile Section ------------------------------------//
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: isTablet ? 60 : 40,
                      backgroundColor: Theme.of(context).primaryColor,
                      child: Text(
                        user.name[0].toUpperCase(),
                        style: TextStyle(
                          fontSize: isTablet ? 48 : 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: isTablet ? 24 : 16),
                    Text(
                      user.name,
                      style: TextStyle(
                        fontSize: isTablet ? 32 : 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: isTablet ? 48 : 32),

              //------------------------------------ Contact Information ------------------------------------//
              _buildDetailCard(
                context,
                icon: Icons.email,
                title: 'Email',
                value: user.email,
                isTablet: isTablet,
              ),
              SizedBox(height: isTablet ? 24 : 16),
              _buildDetailCard(
                context,
                icon: Icons.phone,
                title: 'Phone',
                value: user.phone,
                isTablet: isTablet,
              ),
            ],
          ),
        ),
      ),
    );
  }

  //------------------------------------ Helper Methods ------------------------------------//
  Widget _buildDetailCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
    required bool isTablet,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(isTablet ? 24 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  size: isTablet ? 28 : 24,
                  color: Theme.of(context).primaryColor,
                ),
                SizedBox(width: 12),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: isTablet ? 18 : 16,
                    color: Colors.black54,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            SizedBox(height: isTablet ? 16 : 12),
            Text(
              value,
              style: TextStyle(
                fontSize: isTablet ? 20 : 18,
                color: Colors.black87,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
