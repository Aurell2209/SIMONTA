import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/dokumen.dart';
import '../services/storage_service.dart';
import '../utils/theme.dart';
import 'dokumen_form_screen.dart';
import 'dokumen_detail_screen.dart';

class DokumenListScreen extends StatefulWidget {
  const DokumenListScreen({super.key});

  @override
  State<DokumenListScreen> createState() => _DokumenListScreenState();
}

class _DokumenListScreenState extends State<DokumenListScreen> {
  final _storageService = StorageService();
  List<Dokumen> _dokumenList = [];
  bool _isLoading = true;
  JenisDokumen? _filterJenis;
  StatusDokumen? _filterStatus;

  @override
  void initState() {
    super.initState();
    _loadDokumen();
  }

  Future<void> _loadDokumen() async {
    setState(() => _isLoading = true);
    final list = await _storageService.getDokumenList();
    setState(() {
      _dokumenList = list..sort((a, b) => b.tanggal.compareTo(a.tanggal));
      _isLoading = false;
    });
  }

  List<Dokumen> get _filteredDokumen {
    return _dokumenList.where((dokumen) {
      if (_filterJenis != null && dokumen.jenis != _filterJenis) {
        return false;
      }
      if (_filterStatus != null && dokumen.status != _filterStatus) {
        return false;
      }
      return true;
    }).toList();
  }

  Future<void> _deleteDokumen(String id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Hapus'),
        content: const Text('Apakah Anda yakin ingin menghapus dokumen ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorColor,
            ),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _storageService.deleteDokumen(id);
      _loadDokumen();
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Dokumen berhasil dihapus')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredList = _filteredDokumen;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Arsip Dokumen'),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.filter_list),
            itemBuilder: (context) => [
              const PopupMenuItem(
                enabled: false,
                child: Text(
                  'Filter Jenis',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              PopupMenuItem(
                value: 'jenis_all',
                child: Row(
                  children: [
                    Icon(
                      _filterJenis == null
                          ? Icons.check_box
                          : Icons.check_box_outline_blank,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    const Text('Semua'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'jenis_proposal',
                child: Row(
                  children: [
                    Icon(
                      _filterJenis == JenisDokumen.proposal
                          ? Icons.check_box
                          : Icons.check_box_outline_blank,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    const Text('Proposal'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'jenis_lpj',
                child: Row(
                  children: [
                    Icon(
                      _filterJenis == JenisDokumen.lpj
                          ? Icons.check_box
                          : Icons.check_box_outline_blank,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    const Text('LPJ'),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem(
                enabled: false,
                child: Text(
                  'Filter Status',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              PopupMenuItem(
                value: 'status_all',
                child: Row(
                  children: [
                    Icon(
                      _filterStatus == null
                          ? Icons.check_box
                          : Icons.check_box_outline_blank,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    const Text('Semua'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'status_selesai',
                child: Row(
                  children: [
                    Icon(
                      _filterStatus == StatusDokumen.selesai
                          ? Icons.check_box
                          : Icons.check_box_outline_blank,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    const Text('Selesai'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'status_proses',
                child: Row(
                  children: [
                    Icon(
                      _filterStatus == StatusDokumen.proses
                          ? Icons.check_box
                          : Icons.check_box_outline_blank,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    const Text('Proses'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'status_kendala',
                child: Row(
                  children: [
                    Icon(
                      _filterStatus == StatusDokumen.kendala
                          ? Icons.check_box
                          : Icons.check_box_outline_blank,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    const Text('Kendala'),
                  ],
                ),
              ),
            ],
            onSelected: (value) {
              setState(() {
                switch (value) {
                  case 'jenis_all':
                    _filterJenis = null;
                    break;
                  case 'jenis_proposal':
                    _filterJenis = JenisDokumen.proposal;
                    break;
                  case 'jenis_lpj':
                    _filterJenis = JenisDokumen.lpj;
                    break;
                  case 'status_all':
                    _filterStatus = null;
                    break;
                  case 'status_selesai':
                    _filterStatus = StatusDokumen.selesai;
                    break;
                  case 'status_proses':
                    _filterStatus = StatusDokumen.proses;
                    break;
                  case 'status_kendala':
                    _filterStatus = StatusDokumen.kendala;
                    break;
                }
              });
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : filteredList.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.folder_outlined,
                    size: 80,
                    color: Colors.grey.shade300,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _filterJenis != null || _filterStatus != null
                        ? 'Tidak ada dokumen dengan filter ini'
                        : 'Belum ada dokumen',
                    style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap tombol + untuk menambah dokumen',
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: _loadDokumen,
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: filteredList.length,
                itemBuilder: (context, index) {
                  final dokumen = filteredList[index];
                  return _DokumenCard(
                    dokumen: dokumen,
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              DokumenDetailScreen(dokumen: dokumen),
                        ),
                      );
                      _loadDokumen();
                    },
                    onEdit: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              DokumenFormScreen(dokumen: dokumen),
                        ),
                      );
                      _loadDokumen();
                    },
                    onDelete: () => _deleteDokumen(dokumen.id),
                  );
                },
              ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const DokumenFormScreen()),
          );
          _loadDokumen();
        },
        icon: const Icon(Icons.add),
        label: const Text('Tambah'),
      ),
    );
  }
}

class _DokumenCard extends StatelessWidget {
  final Dokumen dokumen;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _DokumenCard({
    required this.dokumen,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

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

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
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
                      color: _getJenisColor().withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.folder_rounded,
                      color: _getJenisColor(),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          dokumen.judul,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.calendar_today,
                              size: 14,
                              color: Colors.grey.shade600,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              DateFormat('dd MMM yyyy').format(dokumen.tanggal),
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert),
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit, size: 20),
                            SizedBox(width: 8),
                            Text('Edit'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(
                              Icons.delete,
                              size: 20,
                              color: AppTheme.errorColor,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Hapus',
                              style: TextStyle(color: AppTheme.errorColor),
                            ),
                          ],
                        ),
                      ),
                    ],
                    onSelected: (value) {
                      if (value == 'edit') {
                        onEdit();
                      } else if (value == 'delete') {
                        onDelete();
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _getJenisColor().withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      dokumen.jenisString,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: _getJenisColor(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
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
                          size: 14,
                          color: _getStatusColor(),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          dokumen.statusString,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: _getStatusColor(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
