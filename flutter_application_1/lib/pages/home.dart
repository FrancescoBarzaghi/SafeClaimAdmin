import 'package:flutter/material.dart';
import 'newaccount.dart';
import 'login.dart'; // Assicurati di avere questo file o che la classe LoginPage esista

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF5F6FA),
        fontFamily: 'Inter',
        // Questo serve per stilizzare i menu popup globalmente se necessario
        popupMenuTheme: PopupMenuThemeData(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          color: Colors.white,
          elevation: 4,
        ),
      ),
      home: const DashboardPage(),
    );
  }
}

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const _Header(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: const [
                  SizedBox(height: 20),
                  _ActiveUsersCard(),
                  SizedBox(height: 20),
                  _UserManagementCard(),
                  SizedBox(height: 20),
                  _RoleStatisticsCard(),
                  SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/* ---------------- HEADER ---------------- */

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: const BoxDecoration(
        color: Color(0xFF1E66F5),
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(18),
        ),
      ),
      child: SafeArea(
        child: Row(
          children: [
            Image.asset(
              'assets/logo.png',
              height: 50,
              fit: BoxFit.contain,
              // Gestione errore se l'asset non esiste, per evitare crash durante il test
              errorBuilder: (c, o, s) => const Icon(Icons.shield, color: Colors.white, size: 40),
            ),
            const Spacer(),
            
            // --- TENDINA NOTIFICHE ---
            Theme(
              data: Theme.of(context).copyWith(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
              ),
              child: PopupMenuButton<String>(
                offset: const Offset(0, 50), // Sposta la tendina in basso
                tooltip: 'Notifiche',
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                icon: Stack(
                  children: [
                    const Icon(Icons.notifications, color: Colors.white),
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: const Text(
                          '3',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  // Titolo "Notifiche"
                  const PopupMenuItem<String>(
                    enabled: false, // Non cliccabile
                    child: Text(
                      'Notifiche',
                      style: TextStyle(
                        fontSize: 16, 
                        fontWeight: FontWeight.bold, 
                        color: Colors.black
                      ),
                    ),
                  ),
                  const PopupMenuDivider(),
                  // Notifica 1
                  _buildNotificationItem(
                    title: 'Nuovo utente registrato',
                    subtitle: 'Mario Rossi si è registrato come Perito',
                    time: '2 min fa',
                  ),
                  // Notifica 2
                  _buildNotificationItem(
                    title: 'Richiesta permessi',
                    subtitle: 'Luca Bianchi richiede accesso admin',
                    time: '15 min fa',
                  ),
                  // Notifica 3
                  _buildNotificationItem(
                    title: 'Aggiornamento sistema',
                    subtitle: 'Nuova versione disponibile',
                    time: '1 ora fa',
                  ),
                ],
              ),
            ),

            const SizedBox(width: 16),

            // --- TENDINA UTENTE (ACCOUNT) ---
            Theme(
              data: Theme.of(context).copyWith(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
              ),
              child: PopupMenuButton<String>(
                offset: const Offset(0, 50),
                tooltip: 'Account',
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: const CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.black, // O Image.network se hai una foto
                  child: Icon(Icons.person, size: 20, color: Colors.white), // Placeholder se manca foto
                ),
                onSelected: (value) {
                  if (value == 'logout') {
                    // Navigazione verso Login
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginPage()),
                    );
                  }
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  // Sezione Ruolo
                  const PopupMenuItem<String>(
                    enabled: false, // Non cliccabile, solo visualizzazione
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Ruolo', style: TextStyle(fontSize: 12, color: Colors.grey)),
                        SizedBox(height: 4),
                        Text('Admin', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
                      ],
                    ),
                  ),
                  const PopupMenuDivider(),
                  // Tasto Logout
                  const PopupMenuItem<String>(
                    value: 'logout',
                    child: Text(
                      'Logout',
                      style: TextStyle(
                        color: Colors.red, 
                        fontWeight: FontWeight.w600
                      ),
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

  // Helper per costruire gli elementi della notifica
  PopupMenuItem<String> _buildNotificationItem({
    required String title,
    required String subtitle,
    required String time,
  }) {
    return PopupMenuItem<String>(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      height: 0, // Permette al contenuto di definire l'altezza
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Pallino blu
          Container(
            margin: const EdgeInsets.only(top: 6),
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: Color(0xFF1E66F5),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          // Testi
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Colors.black87),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  time,
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                ),
                const SizedBox(height: 8), // Spaziatore tra le notifiche
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/* ---------------- ACTIVE USERS ---------------- */

class _ActiveUsersCard extends StatelessWidget {
  const _ActiveUsersCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24),
      decoration: BoxDecoration(
        color: const Color(0xFF00C853),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: const [
          Icon(Icons.groups, color: Colors.white, size: 28),
          SizedBox(height: 6),
          Text(
            'UTENTI ATTIVI',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8),
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
            style: TextStyle(
              color: Colors.white70,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

/* ---------------- USER MANAGEMENT ---------------- */

class _UserManagementCard extends StatelessWidget {
  const _UserManagementCard();

  @override
  Widget build(BuildContext context) {
    return _WhiteCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.group_outlined, color: Color(0xFF1E66F5)),
              SizedBox(width: 8),
              Text(
                'Gestione Utenti',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          /// 🔵 BOTTONE CHE APRE newaccount.dart
          _ActionButton(
            'Crea Nuovo Account',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const NewAccountPage(),
                ),
              );
            },
          ),

          const SizedBox(height: 10),
          _ActionButton('Gestisci Ruoli Utenti'),
          const SizedBox(height: 10),
          _ActionButton('Visualizza Elenco'),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;

  const _ActionButton(this.label, {this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 46,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1E66F5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        onPressed: onTap,
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

/* ---------------- ROLE STATISTICS ---------------- */

class _RoleStatisticsCard extends StatelessWidget {
  const _RoleStatisticsCard();

  @override
  Widget build(BuildContext context) {
    return _WhiteCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.grid_view, color: Color(0xFF1E66F5)),
              SizedBox(width: 8),
              Text(
                'Statistica Ruoli',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _row('Perito', '24'),
          _row('Admin', '5'),
          _row('Soccorso', '18'),
          _row('Officina', '12'),
          _row('Automobilista', '253'),
        ],
      ),
    );
  }

  Widget _row(String role, String total) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Text(role),
          const Spacer(),
          Text(
            total,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

/* ---------------- GENERIC WHITE CARD ---------------- */

class _WhiteCard extends StatelessWidget {
  final Widget child;

  const _WhiteCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: child,
    );
  }
}