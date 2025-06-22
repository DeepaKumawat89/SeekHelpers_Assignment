//------------------------------------ Imports ------------------------------------//
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../widgets/user_card.dart';
import '../utils/page_transition.dart';
import '../Models/user_model.dart';  // Updated to use correct case
import 'user_detail_page.dart';
import 'add_user_page.dart';

//------------------------------------ Home Page Widget ------------------------------------//
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

//------------------------------------ Home Page State ------------------------------------//
class _HomePageState extends State<HomePage> {
  //------------------------------------ State Variables ------------------------------------//
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  //------------------------------------ Lifecycle Methods ------------------------------------//
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchUsers();
    });
  }

  //------------------------------------ Data Fetching ------------------------------------//
  Future<void> _fetchUsers() async {
    try {
      await Provider.of<UserProvider>(context, listen: false).fetchUsers();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading users: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  //------------------------------------ Helper Methods ------------------------------------//
  List<User> _filterUsers(List<User> users) {
    if (_searchQuery.isEmpty) return users;
    return users.where((user) =>
      user.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
      user.email.toLowerCase().contains(_searchQuery.toLowerCase()) ||
      user.phone.toLowerCase().contains(_searchQuery.toLowerCase())
    ).toList();
  }

  //------------------------------------ Build Method ------------------------------------//
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;
    final crossAxisCount = size.width > 1200 ? 4 : (isTablet ? 2 : 1);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      //------------------------------------ App Bar ------------------------------------//
      appBar: AppBar(
        title: Text(
          'User List',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: isTablet ? 24 : 20,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _fetchUsers,
          ),
          IconButton(
            icon: Icon(Icons.add, size: isTablet ? 28 : 24),
            onPressed: () {
              Navigator.push(
                context,
                SlidePageRoute(child: AddUserPage()),
              ).then((_) => _fetchUsers());
            },
          ),
        ],
      ),
      //------------------------------------ Body Content ------------------------------------//
      body: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          //------------------------------------ Loading State ------------------------------------//
          if (userProvider.isLoading) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: Theme.of(context).primaryColor,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Loading users...',
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: isTablet ? 16 : 14,
                    ),
                  ),
                ],
              ),
            );
          }

          //------------------------------------ Error State ------------------------------------//
          if (userProvider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline,
                    size: 48,
                    color: Colors.red[400],
                  ),
                  SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      userProvider.error!,
                      style: TextStyle(
                        color: Colors.red[400],
                        fontSize: isTablet ? 16 : 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: _fetchUsers,
                    icon: Icon(Icons.refresh),
                    label: Text('Retry'),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          //------------------------------------ Empty State ------------------------------------//
          final users = userProvider.users;
          if (users.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.people_outline,
                    size: 48,
                    color: Colors.grey[400],
                  ),
                  SizedBox(height: 16),
                  Text(
                    'No users found',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: isTablet ? 16 : 14,
                    ),
                  ),
                ],
              ),
            );
          }

          //------------------------------------ Users List Grid ------------------------------------//
          final filteredUsers = _filterUsers(users);
          return Column(
            children: [
              //------------------------------------ Search Bar ------------------------------------//
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _searchController,
                  onChanged: (query) {
                    setState(() {
                      _searchQuery = query;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Search',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(
                        color: Colors.grey,
                        width: 1.0,
                      ),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 12.0,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GridView.builder(
                  padding: EdgeInsets.all(isTablet ? 16.0 : 8.0),
                  itemCount: filteredUsers.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: isTablet ? 16.0 : 8.0,
                    mainAxisSpacing: isTablet ? 16.0 : 8.0,
                    childAspectRatio: 3,
                  ),
                  itemBuilder: (context, index) => GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      Navigator.push(
                        context,
                        SlidePageRoute(child: UserDetailPage(user: filteredUsers[index])),
                      );
                    },
                    child: Theme(
                      data: Theme.of(context).copyWith(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                      ),
                      child: UserCard(user: filteredUsers[index]),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
