// import 'package:flutter/material.dart';
// import 'package:ppb_marketplace/service/LoginService.dart';

// class Profile extends StatefulWidget {
//   final int userId;
//   const Profile({super.key, required this.userId});

//   @override
//   State<Profile> createState() => _ProfileState();
// }

// class _ProfileState extends State<Profile> {
//   final Loginservice loginservice = Loginservice();
//   Map<String, dynamic>? user;

//   @override
//   void initState() {
//     super.initState();
//     _loadUser();
//   }

//   Future<void> _loadUser() async {
//     try {
//       final userData = await loginservice.getUserProfile(widget.userId);
//       setState(() {
//         user = userData;
//       });
//     } catch (e) {
//       debugPrint('Error loading user: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (user == null) {
//       return const Center(child: CircularProgressIndicator());
//     }

//     return Scaffold(
//       appBar: AppBar(title: const Text('Profile')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text('Nama: ${user!['name'] ?? '-'}'),
//             Text('Email: ${user!['email'] ?? '-'}'),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 // Tambahkan aksi logout atau edit profil di sini
//               },
//               child: const Text('Logout'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
