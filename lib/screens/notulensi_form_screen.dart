import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/notulensi.dart';
import '../services/storage_service.dart';
import '../utils/theme.dart';

class NotulensiFormScreen extends StatefulWidget {
  final Notulensi? notulensi;

  const NotulensiFormScreen({super.key, this.notulensi});

  @override
  State<NotulensiFormScreen> createState() => _NotulensiFormScreenState();
}

class _NotulensiFormScreenState extends State<NotulensiFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _storageService = StorageService();

  late TextEditingController _judulController;
  late TextEditingController _tempatController;
  late TextEditingController _pesertaController;
  late TextEditingController _hasilRapatController;

  DateTime _selectedDate = DateTime.now();
  DateTime? _reminderDate;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _judulController = TextEditingController(
      text: widget.notulensi?.judul ?? '',
    );
    _tempatController = TextEditingController(
      text: widget.notulensi?.tempat ?? '',
    );
    _pesertaController = TextEditingController(
      text: widget.notulensi?.peserta ?? '',
    );
    _hasilRapatController = TextEditingController(
      text: widget.notulensi?.hasilRapat ?? '',
    );

    if (widget.notulensi != null) {
      _selectedDate = widget.notulensi!.tanggal;
      _reminderDate = widget.notulensi!.reminderDate;
    }
  }

  @override
  void dispose() {
    _judulController.dispose();
    _tempatController.dispose();
    _pesertaController.dispose();
    _hasilRapatController.dispose();
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

  Future<void> _saveNotulensi() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      final notulensi = Notulensi(
        id:
            widget.notulensi?.id ??
            DateTime.now().millisecondsSinceEpoch.toString(),
        judul: _judulController.text,
        tanggal: _selectedDate,
        tempat: _tempatController.text,
        peserta: _pesertaController.text,
        hasilRapat: _hasilRapatController.text,
        reminderDate: _reminderDate,
      );

      await _storageService.saveNotulensi(notulensi);

      if (!mounted) return;

      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.notulensi == null
                ? 'Notulensi berhasil ditambahkan'
                : 'Notulensi berhasil diperbarui',
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
        title: Text(
          widget.notulensi == null ? 'Tambah Notulensi' : 'Edit Notulensi',
        ),
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
                labelText: 'Judul Rapat',
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
                  labelText: 'Tanggal Rapat',
                  prefixIcon: Icon(Icons.calendar_today),
                ),
                child: Text(
                  DateFormat('dd MMMM yyyy').format(_selectedDate),
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Tempat
            TextFormField(
              controller: _tempatController,
              decoration: const InputDecoration(
                labelText: 'Tempat',
                prefixIcon: Icon(Icons.location_on),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Tempat tidak boleh kosong';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Peserta
            TextFormField(
              controller: _pesertaController,
              decoration: const InputDecoration(
                labelText: 'Peserta',
                prefixIcon: Icon(Icons.people),
                hintText: 'Pisahkan dengan koma',
              ),
              maxLines: 3,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Peserta tidak boleh kosong';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Hasil Rapat
            TextFormField(
              controller: _hasilRapatController,
              decoration: const InputDecoration(
                labelText: 'Hasil Rapat',
                prefixIcon: Icon(Icons.assignment),
                hintText: 'Tulis hasil rapat secara detail',
              ),
              maxLines: 5,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Hasil rapat tidak boleh kosong';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Save Button
            ElevatedButton(
              onPressed: _isLoading ? null : _saveNotulensi,
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
