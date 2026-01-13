import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/dokumen.dart';
import '../services/storage_service.dart';
import '../utils/theme.dart';

class DokumenFormScreen extends StatefulWidget {
  final Dokumen? dokumen;

  const DokumenFormScreen({super.key, this.dokumen});

  @override
  State<DokumenFormScreen> createState() => _DokumenFormScreenState();
}

class _DokumenFormScreenState extends State<DokumenFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _storageService = StorageService();

  late TextEditingController _judulController;
  late TextEditingController _keteranganController;

  DateTime _selectedDate = DateTime.now();
  JenisDokumen _selectedJenis = JenisDokumen.proposal;
  StatusDokumen _selectedStatus = StatusDokumen.proses;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _judulController = TextEditingController(text: widget.dokumen?.judul ?? '');
    _keteranganController = TextEditingController(
      text: widget.dokumen?.keterangan ?? '',
    );

    if (widget.dokumen != null) {
      _selectedDate = widget.dokumen!.tanggal;
      _selectedJenis = widget.dokumen!.jenis;
      _selectedStatus = widget.dokumen!.status;
    }
  }

  @override
  void dispose() {
    _judulController.dispose();
    _keteranganController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _saveDokumen() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      final dokumen = Dokumen(
        id:
            widget.dokumen?.id ??
            DateTime.now().millisecondsSinceEpoch.toString(),
        judul: _judulController.text,
        tanggal: _selectedDate,
        jenis: _selectedJenis,
        status: _selectedStatus,
        keterangan: _keteranganController.text,
      );

      await _storageService.saveDokumen(dokumen);

      if (!mounted) return;

      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.dokumen == null
                ? 'Dokumen berhasil ditambahkan'
                : 'Dokumen berhasil diperbarui',
          ),
          backgroundColor: AppTheme.successColor,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.dokumen == null ? 'Tambah Dokumen' : 'Edit Dokumen'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Judul
            TextFormField(
              controller: _judulController,
              decoration: const InputDecoration(
                labelText: 'Judul Dokumen',
                prefixIcon: Icon(Icons.title),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Judul tidak boleh kosong';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Tanggal
            InkWell(
              onTap: _selectDate,
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Tanggal',
                  prefixIcon: Icon(Icons.calendar_today),
                ),
                child: Text(
                  DateFormat('dd MMMM yyyy').format(_selectedDate),
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Jenis Dokumen
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Jenis Dokumen',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: RadioListTile<JenisDokumen>(
                            title: const Text('Proposal'),
                            value: JenisDokumen.proposal,
                            groupValue: _selectedJenis,
                            onChanged: (value) {
                              setState(() => _selectedJenis = value!);
                            },
                            contentPadding: EdgeInsets.zero,
                            activeColor: AppTheme.secondaryColor,
                          ),
                        ),
                        Expanded(
                          child: RadioListTile<JenisDokumen>(
                            title: const Text('LPJ'),
                            value: JenisDokumen.lpj,
                            groupValue: _selectedJenis,
                            onChanged: (value) {
                              setState(() => _selectedJenis = value!);
                            },
                            contentPadding: EdgeInsets.zero,
                            activeColor: AppTheme.accentColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Status Dokumen
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Status Dokumen',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    RadioListTile<StatusDokumen>(
                      title: const Row(
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: AppTheme.successColor,
                            size: 20,
                          ),
                          SizedBox(width: 8),
                          Text('Selesai'),
                        ],
                      ),
                      value: StatusDokumen.selesai,
                      groupValue: _selectedStatus,
                      onChanged: (value) {
                        setState(() => _selectedStatus = value!);
                      },
                      contentPadding: EdgeInsets.zero,
                      activeColor: AppTheme.successColor,
                    ),
                    RadioListTile<StatusDokumen>(
                      title: const Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            color: AppTheme.warningColor,
                            size: 20,
                          ),
                          SizedBox(width: 8),
                          Text('Proses'),
                        ],
                      ),
                      value: StatusDokumen.proses,
                      groupValue: _selectedStatus,
                      onChanged: (value) {
                        setState(() => _selectedStatus = value!);
                      },
                      contentPadding: EdgeInsets.zero,
                      activeColor: AppTheme.warningColor,
                    ),
                    RadioListTile<StatusDokumen>(
                      title: const Row(
                        children: [
                          Icon(
                            Icons.warning,
                            color: AppTheme.errorColor,
                            size: 20,
                          ),
                          SizedBox(width: 8),
                          Text('Kendala'),
                        ],
                      ),
                      value: StatusDokumen.kendala,
                      groupValue: _selectedStatus,
                      onChanged: (value) {
                        setState(() => _selectedStatus = value!);
                      },
                      contentPadding: EdgeInsets.zero,
                      activeColor: AppTheme.errorColor,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Keterangan
            TextFormField(
              controller: _keteranganController,
              decoration: const InputDecoration(
                labelText: 'Keterangan',
                prefixIcon: Icon(Icons.notes),
                hintText: 'Tambahkan keterangan atau catatan',
              ),
              maxLines: 5,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Keterangan tidak boleh kosong';
                }
                return null;
              },
            ),
            const SizedBox(height: 32),

            // Save Button
            ElevatedButton(
              onPressed: _isLoading ? null : _saveDokumen,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }
}
