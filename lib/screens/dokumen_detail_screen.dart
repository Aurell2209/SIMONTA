import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/dokumen.dart';
import '../utils/theme.dart';
import 'dokumen_form_screen.dart';

class DokumenDetailScreen extends StatelessWidget {
  final Dokumen dokumen;

  const DokumenDetailScreen({super.key, required this.dokumen});

  Color _getStatusColor() {
    switch (dokumen.status) {
      case StatusDokumen.selesai:
        return AppTheme.successColor;
      case StatusDokumen.proses:
        return AppTheme.warningColor;
      case StatusDokumen.kendala:
        return AppTheme.errorColor;
    }
  }

  Color _getJenisColor() {
    switch (dokumen.jenis) {
      case JenisDokumen.proposal:
        return AppTheme.secondaryColor;
      case JenisDokumen.lpj:
        return AppTheme.accentColor;
    }
  }

  Future<void> _shareViaWhatsApp() async {
    final text =
        '''
*DOKUMEN ${dokumen.jenisString.toUpperCase()}*

Judul: ${dokumen.judul}
Tanggal: ${DateFormat('dd MMMM yyyy').format(dokumen.tanggal)}
Jenis: ${dokumen.jenisString}
Status: ${dokumen.statusString}

Keterangan:
${dokumen.keterangan}
''';

    final url = Uri.parse('https://wa.me/?text=${Uri.encodeComponent(text)}');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _shareViaEmail() async {
    final subject = 'Dokumen ${dokumen.jenisString}: ${dokumen.judul}';
    final body =
        '''
DOKUMEN ${dokumen.jenisString.toUpperCase()}

Judul: ${dokumen.judul}
Tanggal: ${DateFormat('dd MMMM yyyy').format(dokumen.tanggal)}
Jenis: ${dokumen.jenisString}
Status: ${dokumen.statusString}

Keterangan:
${dokumen.keterangan}
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
        title: const Text('Detail Dokumen'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DokumenFormScreen(dokumen: dokumen),
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
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [_getJenisColor(), _getJenisColor().withOpacity(0.7)],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.folder_rounded,
                        size: 48,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          dokumen.jenisString,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    dokumen.judul,
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
                    content: DateFormat('dd MMMM yyyy').format(dokumen.tanggal),
                    color: AppTheme.primaryColor,
                  ),
                  const SizedBox(height: 12),

                  // Status Card
                  Card(
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
                                  color: _getStatusColor().withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  dokumen.status == StatusDokumen.selesai
                                      ? Icons.check_circle
                                      : dokumen.status == StatusDokumen.proses
                                      ? Icons.access_time
                                      : Icons.warning,
                                  color: _getStatusColor(),
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Text(
                                'Status',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.textSecondary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: _getStatusColor().withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  dokumen.status == StatusDokumen.selesai
                                      ? Icons.check_circle
                                      : dokumen.status == StatusDokumen.proses
                                      ? Icons.access_time
                                      : Icons.warning,
                                  color: _getStatusColor(),
                                  size: 18,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  dokumen.statusString,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: _getStatusColor(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  _DetailCard(
                    icon: Icons.notes,
                    title: 'Keterangan',
                    content: dokumen.keterangan,
                    color: AppTheme.accentColor,
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
