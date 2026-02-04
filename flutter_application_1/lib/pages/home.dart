import 'package:flutter/material.dart';

/* ================== DASHBOARD PAGE ================== */
class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  bool showNotifications = false;
  bool showProfile = false;

  final List<Map<String, dynamic>> roles = [
    {'role': 'Perito', 'total': 24},
    {'role': 'Admin', 'total': 5},
    {'role': 'Soccorso', 'total': 18},
    {'role': 'Officina', 'total': 12},
    {'role': 'Automobilista', 'total': 253},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildHeader(),
          Expanded(child: _buildContent()),
        ],
      ),
    );
  }

  /* ================== HEADER ================== */
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: Colors.blue,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'SafeClaim',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            children: [
              Stack(
                children: [
                  IconButton(
                    onPressed: () => setState(() => showNotifications = !showNotifications),
                    icon: const Icon(Icons.notifications, color: Colors.white),
                  ),
                  Positioned(
                    right: 6,
                    top: 6,
                    child: Container(
                      width: 16,
                      height: 16,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Text(
                          '3',
                          style: TextStyle(color: Colors.white, fontSize: 10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () => setState(() => showProfile = !showProfile),
                child: const CircleAvatar(
                  radius: 14,
                  backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=12'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /* ================== CONTENT ================== */
  Widget _buildContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          _buildStatsCard(),
          const SizedBox(height: 12),
          _buildUserManagementCard(),
          const SizedBox(height: 12),
          _buildRolesTableCard(),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  /* ================== STATS CARD ================== */
  Widget _buildStatsCard() {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Colors.green, Colors.greenAccent],
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 8,
            ),
          ],
        ),
        child: Column(
          children: const [
            Icon(Icons.people, color: Colors.white, size: 40),
            SizedBox(height: 8),
            Text(
              'UTENTI ATTIVI',
              style: TextStyle(color: Colors.white70, fontSize: 12),
            ),
            SizedBox(height: 4),
            Text(
              '312',
              style: TextStyle(
                color: Colors.white,
                fontSize: 36,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Aggiornato ora',
              style: TextStyle(color: Colors.white70, fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }

  /* ================== USER MANAGEMENT CARD ================== */
  Widget _buildUserManagementCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.person, color: Colors.blue),
                SizedBox(width: 6),
                Text(
                  'Gestione Utenti',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _actionButton('Crea Nuovo Account'),
            _actionButton('Gestisci Ruoli Utenti'),
            _actionButton('Visualizza Elenco'),
            const SizedBox(height: 12),
            const Row(
              children: [
                Icon(Icons.shield, size: 16),
                SizedBox(width: 6),
                Text('Assegna Permessi'),
              ],
            ),
            const SizedBox(height: 6),
            const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green, size: 16),
                SizedBox(width: 6),
                Text('Attiva / Disattiva'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _actionButton(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {},
          child: Text(text),
        ),
      ),
    );
  }

  /* ================== ROLES TABLE CARD ================== */
  Widget _buildRolesTableCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.list, color: Colors.blue),
                SizedBox(width: 6),
                Text(
                  'Statistica Ruoli',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 12),
            DataTable(
              columns: const [
                DataColumn(label: Text('Ruolo')),
                DataColumn(label: Text('Totale'), numeric: true),
              ],
              rows: roles
                  .map(
                    (role) => DataRow(
                      cells: [
                        DataCell(Text(role['role'])),
                        DataCell(Text(role['total'].toString())),
                      ],
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
