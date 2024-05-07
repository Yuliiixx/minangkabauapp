import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:minangkabauapp/apiUrl.dart';
import 'package:minangkabauapp/bottomNavBar.dart';

class TambahDataPahlawan extends StatefulWidget {
  @override
  _TambahDataPahlawanState createState() => _TambahDataPahlawanState();
}

class _TambahDataPahlawanState extends State<TambahDataPahlawan> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController _controllerNama = TextEditingController();
  TextEditingController _controllerTanggalLahir = TextEditingController();
  TextEditingController _controllerAsal = TextEditingController();
  TextEditingController _controllerDeskripsi = TextEditingController();

  File? _imageFile;
  JenisKelamin? _selectedJenisKelamin;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Tambah Data Pahlawan',
          style: TextStyle(
            color: Colors.white,
            
          ),
        ),
        backgroundColor: Colors.green[900],
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      backgroundColor: Color(0xFFF5F9FF),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView( // Tambahkan SingleChildScrollView di sini
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _controllerNama,
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
                  controller: _controllerTanggalLahir,
                  readOnly: true, 
                  onTap: () async {
                    final DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(), 
                      firstDate: DateTime(1900), 
                      lastDate: DateTime.now(), 
                    );
                    if (pickedDate != null) {
                      _controllerTanggalLahir.text =
                          DateFormat('yyyy-MM-dd').format(pickedDate);
                    }
                  },
                  decoration: InputDecoration(
                    labelText: 'Tanggal Lahir',
                    prefixIcon: Icon(Icons.calendar_today),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Tanggal lahir tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 12.0),
                TextFormField(
                  controller: _controllerAsal,
                  decoration: InputDecoration(labelText: 'Asal'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Asal tidak boleh kosong';
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
                  controller: _controllerDeskripsi,
                  decoration: InputDecoration(labelText: 'Deskripsi'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Deskripsi tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 12.0),
                // GestureDetector(
                //   onTap: _getImage,
                //   child: Row(
                //     children: [
                //       Icon(Icons.add_a_photo),
                //       SizedBox(width: 8), 
                //       Text(_imageFile == null
                //           ? 'Pilih Gambar'
                //           : 'Ganti Gambar'),
                //     ],
                //   ),
                // ),
                GestureDetector(
  onTap: _getImage,
  child: Row(
    children: [
      Icon(Icons.add_a_photo),
      SizedBox(width: 8), 
      _imageFile == null
          ? Text('Pilih Gambar')
          : Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(
                  _imageFile!,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
            ),
    ],
  ),
),

                SizedBox(height: 15.0),
                ElevatedButton(
                  onPressed: _tambahDataPahlawan,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.green[900],
                  ),
                  child: Text('Simpan'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _tambahDataPahlawan() async {
    if (_formKey.currentState!.validate()) {
      final String apiUrl = '${ApiUrl().baseUrl}pahlawan.php';

      String jenisKelamin = _selectedJenisKelamin.toString().split('.').last;

      Map<String, dynamic> requestBody = {
        'action': "tambah",
        'nama': _controllerNama.text,
        'tanggal_lahir': _controllerTanggalLahir.text,
        'asal': _controllerAsal.text,
        'jenis_kelamin': jenisKelamin,
        'deskripsi': _controllerDeskripsi.text,
      };

      if (_imageFile != null) {
        List<int> imageBytes = await _imageFile!.readAsBytes();
        String base64Image = base64Encode(imageBytes);
        requestBody['foto'] = base64Image;
      }

      final response = await http.post(Uri.parse(apiUrl), body: requestBody);

      if (response.statusCode == 200) {
        _controllerNama.clear();
        _controllerTanggalLahir.clear();
        _controllerAsal.clear();
        _controllerDeskripsi.clear();
        setState(() {
          _imageFile = null;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Data pahlawan berhasil ditambahkan')),
        );
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => BottomNavigation("pahlawan")),
          (route) => false,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menambahkan data pahlawan')),
        );
      }
    }
  }

  Future<void> _getImage() async {
    try {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      setState(() {
        if (pickedFile != null) {
          _imageFile = File(pickedFile.path);
        }
      });
    } catch (e) {
      print('Error picking image: $e');
    }
  }
}

enum JenisKelamin {  Perempuan, Lakilaki }
