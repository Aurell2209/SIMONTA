import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/notulensi.dart';
import '../utils/theme.dart';
import 'notulensi_form_screen.dart';

class NotulensiDetailScreen extends StatelessWidget {
  final Notulensi notulensi;

  const NotulensiDetailScreen({super.key, required this.notulensi});

  Future<void> _shareViaWhatsApp() async {
    final text =
        '''
*NOTULENSI RAPAT*

Judul: ${notulensi.judul}
Tanggal: ${DateFormat('dd MMMM yyyy').format(notulensi.tanggal)}
Tempat: ${notulensi.tempat}

Peserta:
${notulensi.peserta}

Hasil Rapat:
${notulensi.hasilRapat}
''';

    final url = Uri.parse('https://wa.me/?text=${Uri.encodeComponent(text)}');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _shareViaEmail() async {
    final subject = 'Notulensi: ${notulensi.judul}';
    final body =
        '''
NOTULENSI RAPAT

Judul: ${notulensi.judul}
Tanggal: ${DateFormat('dd MMMM yyyy').format(notulensi.tanggal)}
Tempat: ${notulensi.tempat}

Peserta:
${notulensi.peserta}

Hasil Rapat:
${notulensi.hasilRapat}
''';

    final url = Uri.parse(
      'mailto:?subject=${Uri.encodeComponent(subject)}&body=${Uri.encodeComponent(body)}',
    );
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Notulensi'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      NotulensiFormScreen(notulensi: notulensi),
                ),
              );
            },
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.share),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'whatsapp',
                child: Row(
                  children: [
                    Icon(Icons.chat, color: Color(0xFF25D366)),
                    SizedBox(width: 8),
                    Text('WhatsApp'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'email',
                child: Row(
                  children: [
                    Icon(Icons.email, color: AppTheme.secondaryColor),
                    SizedBox(width: 8),
                    Text('Email'),
                  ],
                ),
              ),
            ],
            onSelected: (value) {
              if (value == 'whatsapp') {
                _shareViaWhatsApp();
              } else if (value == 'email') {
                _shareViaEmail();
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppTheme.primaryColor, AppTheme.secondaryColor],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notulensi.judul,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _DetailCard(
                    icon: Icons.calendar_today,
                    title: 'Tanggal',
                    content: DateFormat(
                      'dd MMMM yyyy',
                    ).format(notulensi.tanggal),
                    color: AppTheme.primaryColor,
                  ),
                  const SizedBox(height: 12),
                  _DetailCard(
                    icon: Icons.location_on,
                    title: 'Tempat',
                    content: notulensi.tempat,
                    color: AppTheme.secondaryColor,
                  ),
                  const SizedBox(height: 12),
                  _DetailCard(
                    icon: Icons.people,
                    title: 'Peserta',
                    content: notulensi.peserta,
                    color: AppTheme.accentColor,
                  ),
                  const SizedBox(height: 12),
                  _DetailCard(
                    icon: Icons.assignment,
                    title: 'Hasil Rapat',
                    content: notulensi.hasilRapat,
                    color: AppTheme.successColor,
                  ),

                  if (notulensi.reminderDate != null) ...[
                    const SizedBox(height: 12),
                    _DetailCard(
                      icon: Icons.notifications_active,
                      title: 'Reminder',
                      content: DateFormat(
                        'dd MMMM yyyy',
                      ).format(notulensi.reminderDate!),
                      color: AppTheme.warningColor,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String content;
  final Color color;

  const _DetailCard({
    required this.icon,
    required this.title,
    required this.content,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: color, size: 20),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              content,
              style: const TextStyle(fontSize: 16, color: AppTheme.textPrimary),
            ),
          ],
        ),
      ),
    );
  }
}
