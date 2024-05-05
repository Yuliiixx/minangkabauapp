import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:minangkabauapp/apiUrl.dart';
import 'package:minangkabauapp/bottomNavBar.dart';
import 'package:minangkabauapp/model/modelPahlawan.dart';
import 'package:intl/intl.dart'; // Untuk mengonversi tanggal
import 'package:minangkabauapp/pahlawan/addPahlawan.dart';

class EditPahlawan extends StatefulWidget {
  final String id;
  final Datum? data;
  const EditPahlawan(this.id, this.data, {Key? key}) : super(key: key);
  @override
  _EditPahlawanState createState() => _EditPahlawanState();
}

class _EditPahlawanState extends State<EditPahlawan> {
  String idPahlawan = "";
  TextEditingController controllerNama = TextEditingController();
  TextEditingController controllerTanggalLahir = TextEditingController();
  TextEditingController controllerAsal = TextEditingController();
  TextEditingController controllerDeskripsi = TextEditingController();

  File? _imageFile;
  JenisKelamin? _selectedJenisKelamin;

  final _formKey = GlobalKey<FormState>(); // GlobalKey untuk Form

  Future<void> _editDataPahlawan() async {
    String jenisKelamin = _selectedJenisKelamin.toString().split('.').last;

    // Pemeriksaan validitas Form
    if (_formKey.currentState!.validate()) {
      if (_imageFile != null) {
        List<int> imageBytes = await _imageFile!.readAsBytes();
        String base64Image = base64Encode(imageBytes);
        // Menghapus requestBody karena tidak terlihat digunakan
        // requestBody['foto'] = base64Image;
      }
      final String apiUrl = '${ApiUrl().baseUrl}pahlawan.php'; // Ganti dengan URL backend Anda
      final response = await http.post(Uri.parse(apiUrl), body: {
        'id_pahlawan': idPahlawan,
        'nama': controllerNama.text,
        'tanggal_lahir': controllerTanggalLahir.text,
        'asal': controllerAsal.text,
        'jenis_kelamin': jenisKelamin,
        'deskripsi': controllerDeskripsi.text,
        'action': 'edit',
      });

      if (response.statusCode == 200) {
        // Jika permintaan berhasil, bersihkan input dan tampilkan pesan sukses

        controllerNama.clear();
        controllerTanggalLahir.clear();
        controllerAsal.clear();
        controllerDeskripsi.clear();
        setState(() {
          _imageFile = null;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Data pahlawan berhasil diupdate')),
        );
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => BottomNavigation("pahlawan")),
                (route) => false
        );

      } else {
        // Jika permintaan gagal, tampilkan pesan error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menambahkan data pahlawan')),
        );
      }
    }
  }

  Future<void> _getImage() async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
      setState(() {
        if (pickedFile != null) {
          _imageFile = File(pickedFile.path);
        }
      });
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    // Memeriksa apakah data tidak null
    if (widget.data != null) {
      idPahlawan = widget.data!.idPahlawan;
      // Mengisi nilai awal dari TextEditingController dengan data dari objek Datum
      controllerNama.text = widget.data!.namaPahlawan ?? "";
      // Mengonversi tanggal lahir ke dalam format yang sesuai
      controllerTanggalLahir.text = widget.data!.tanggalLahir != null
          ? DateFormat('yyyy-MM-dd').format(widget.data!.tanggalLahir!)
          : "";
      controllerAsal.text = widget.data!.asal ?? "";
      controllerDeskripsi.text = widget.data!.deskripsi ?? "";
      // controllerDeskripsi.enum = widget.data!.jenisKelamin ?? "";
      // Mengatur jenis kelamin, jika null, maka gunakan JenisKelamin.lakiLaki
      _selectedJenisKelamin = (widget.data!.jenisKelamin ?? JenisKelamin.lakiLaki) as JenisKelamin?;
      String jenisKelamin = _selectedJenisKelamin.toString().split('.').last;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Data Pahlawan'),
        backgroundColor: Colors.green[900],
      ),
      backgroundColor: Color(0xFFF5F9FF),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form( // Wrap Column dengan Form
          key: _formKey, // Assign GlobalKey<Form>
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField( // Menggunakan TextFormField untuk validasi
                controller: controllerNama,
                decoration: InputDecoration(labelText: 'Nama Pahlawan'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama pahlawan tidak boleh kosong';
                  }
                  return null;
                },
              ),
              SizedBox(height: 12.0),
              TextFormField(
                controller: controllerTanggalLahir,
                decoration: InputDecoration(labelText: 'Tanggal Lahir'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Tanggal lahir tidak boleh kosong';
                  }
                  return null;
                },
              ),
              SizedBox(height: 12.0),
              DropdownButtonFormField<JenisKelamin>(
                value: _selectedJenisKelamin,
                onChanged: (JenisKelamin? value) {
                  setState(() {
                    _selectedJenisKelamin = value;
                  });
                },
                items: JenisKelamin.values.map((JenisKelamin jenisKelamin) {
                  return DropdownMenuItem<JenisKelamin>(
                    value: jenisKelamin,
                    child: Text(jenisKelamin.toString().split('.').last),
                  );
                }).toList(),
                decoration: InputDecoration(labelText: 'Jenis Kelamin'),
                validator: (value) {
                  if (value == null) {
                    return 'Pilih jenis kelamin';
                  }
                  return null;
                },
              ),
              SizedBox(height: 12.0),
              TextFormField(
                controller: controllerAsal,
                decoration: InputDecoration(labelText: 'Asal'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Asal tidak boleh kosong';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: controllerDeskripsi,
                decoration: InputDecoration(labelText: 'Deskripsi'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Deskripsi tidak boleh kosong';
                  }
                  return null;
                },
              ),
              SizedBox(height: 12.0),
              GestureDetector(
                onTap: _getImage,
                child: _imageFile == null
                    ? Text('Tambahkan Foto')
                    : Image.file(_imageFile!, width: 100, height: 100),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _editDataPahlawan,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.green[900],
                ),
                child: Text('Simpan Perubahan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


enum JenisKelamin { perempuan, lakiLaki }