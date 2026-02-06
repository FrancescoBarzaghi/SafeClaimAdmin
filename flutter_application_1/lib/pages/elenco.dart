import 'package:flutter/material.dart';

/// =====================
/// MODELLI E CONFIG
/// =====================

enum UserRole { perito, automobilista, officina, soccorso, admin }

class AppUser {
  final String id;
  final String name;
  final String email;
  final String phone;
  final List<UserRole> roles;

  AppUser({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.roles,
  });
}

class RoleConfig {
  final String label;
  final Color bg;
  final Color text;
  final IconData icon;

  const RoleConfig(this.label, this.bg, this.text, this.icon);
}

final roleConfig = {
  UserRole.perito: RoleConfig(
    "Perito",
    Colors.blue.shade100,
    Colors.blue.shade800,
    Icons.help_outline,
  ),
  UserRole.automobilista: RoleConfig(
    "Automobilista",
    Colors.green.shade100,
    Colors.green.shade800,
    Icons.person,
  ),
  UserRole.officina: RoleConfig(
    "Officina",
    Colors.orange.shade100,
    Colors.orange.shade800,
    Icons.build,
  ),
  UserRole.soccorso: RoleConfig(
    "Soccorso",
    Colors.purple.shade100,
    Colors.purple.shade800,
    Icons.car_crash,
  ),
  UserRole.admin: RoleConfig(
    "Admin",
    Colors.red.shade100,
    Colors.red.shade800,
    Icons.security,
  ),
};

/// =====================
/// MOCK DATA
/// =====================

final mockUsers = <AppUser>[
  AppUser(
    id: "1",
    name: "Marco Rossi",
    email: "marco.rossi@email.it",
    phone: "+39 333 1234567",
    roles: [UserRole.perito],
  ),
  AppUser(
    id: "2",
    name: "Laura Bianchi",
    email: "laura.bianchi@email.it",
    phone: "+39 333 2345678",
    roles: [UserRole.automobilista],
  ),
  AppUser(
    id: "3",
    name: "Officina Auto Sport",
    email: "info@autosport.it",
    phone: "+39 333 3456789",
    roles: [UserRole.officina, UserRole.soccorso],
  ),
  AppUser(
    id: "4",
    name: "Admin Sistema",
    email: "admin@sistema.it",
    phone: "+39 333 5678901",
    roles: [UserRole.admin],
  ),
];

/// =====================
/// PAGINA ELENCO
/// =====================

class ElencoPage extends StatefulWidget {
  const ElencoPage({super.key});

  @override
  State<ElencoPage> createState() => _ElencoPageState();
}

class _ElencoPageState extends State<ElencoPage> {
  String search = "";
  UserRole? selectedRole;

  List<AppUser> get filteredUsers {
    return mockUsers.where((u) {
      final s = search.toLowerCase();
      final matchesSearch =
          u.name.toLowerCase().contains(s) ||
          u.email.toLowerCase().contains(s) ||
          u.phone.contains(search);

      final matchesRole =
          selectedRole == null || u.roles.contains(selectedRole);

      return matchesSearch && matchesRole;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        leading: const BackButton(),
        title: Row(
          children: const [
            Icon(Icons.people),
            SizedBox(width: 8),
            Text("Lista Utenti"),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _searchBar(),
            const SizedBox(height: 16),
            _roleFilter(),
            const SizedBox(height: 12),
            Text(
              "Mostrando ${filteredUsers.length} di ${mockUsers.length} utenti",
              style: TextStyle(color: Colors.grey.shade600),
            ),
            const SizedBox(height: 12),
            ...filteredUsers.map(
              (u) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _userCard(u),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// =====================
  /// SEARCH BAR
  /// =====================

  Widget _searchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        onChanged: (v) => setState(() => search = v),
        style: const TextStyle(color: Colors.white),
        decoration: const InputDecoration(
          hintText: "Cerca utente...",
          hintStyle: TextStyle(color: Colors.white70),
          prefixIcon: Icon(Icons.search, color: Colors.white),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }

  /// =====================
  /// FILTRI RUOLO
  /// =====================

  Widget _roleFilter() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Filtra per ruolo:",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                ChoiceChip(
                  label: const Text("Tutti"),
                  selected: selectedRole == null,
                  onSelected: (_) => setState(() => selectedRole = null),
                ),
                ...UserRole.values.map(
                  (r) => ChoiceChip(
                    label: Text(roleConfig[r]!.label),
                    selected: selectedRole == r,
                    onSelected: (_) => setState(() => selectedRole = r),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// =====================
  /// CARD UTENTE
  /// =====================

  Widget _userCard(AppUser user) {
    final mainRole = user.roles.first;
    final config = roleConfig[mainRole]!;

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: Colors.grey.shade200,
              child: const Icon(Icons.person, color: Colors.grey),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user.email,
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    user.phone,
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: config.bg,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(config.icon,
                            size: 14, color: config.text),
                        const SizedBox(width: 4),
                        Text(
                          config.label,
                          style: TextStyle(
                              color: config.text, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
