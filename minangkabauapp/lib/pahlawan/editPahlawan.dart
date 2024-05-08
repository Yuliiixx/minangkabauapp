import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:minangkabauapp/apiUrl.dart';
import 'package:minangkabauapp/bottomNavBar.dart';
import 'package:minangkabauapp/model/modelPahlawan.dart';

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

  final _formKey = GlobalKey<FormState>();

  Future<void> _editDataPahlawan() async {
    String jenisKelamin = _selectedJenisKelamin.toString().split('.').last;

    if (_formKey.currentState!.validate()) {
      final String apiUrl = '${ApiUrl().baseUrl}pahlawan.php';
      Map<String, dynamic> requestBody = {
        'id_pahlawan': idPahlawan,
        'nama': controllerNama.text,
        'tanggal_lahir': controllerTanggalLahir.text,
        'asal': controllerAsal.text,
        'jenis_kelamin': jenisKelamin,
        'deskripsi': controllerDeskripsi.text,
        'action': 'edit',
      };

      if (_imageFile != null) {
        List<int> imageBytes = await _imageFile!.readAsBytes();
        String base64Image = base64Encode(imageBytes);
        requestBody['foto'] = base64Image;
      }

      final response = await http.post(Uri.parse(apiUrl), body: requestBody);

      if (response.statusCode == 200) {
        controllerNama.clear();
        controllerTanggalLahir.clear();
        controllerAsal.clear();
        controllerDeskripsi.clear();
        setState(() {
          _imageFile = null; // Menghapus gambar lama setelah berhasil menyimpan perubahan
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
          print("pickedFile : $pickedFile");
        }
      });
    } catch (e) {
      print('Error picking image: $e');
    }
  }


  @override
  void initState() {
    super.initState();
    if (widget.data != null) {
      idPahlawan = widget.data!.idPahlawan;
      controllerNama.text = widget.data!.nama ?? "";
      controllerTanggalLahir.text = widget.data!.tanggalLahir != null
          ? DateFormat('yyyy-MM-dd').format(widget.data!.tanggalLahir!)
          : "";
      controllerAsal.text = widget.data!.asal ?? "";
      controllerDeskripsi.text = widget.data!.deskripsi ?? "";

      _selectedJenisKelamin = parseJenisKelamin(widget.data!.jenisKelamin ?? 'Lakilaki');
    }
  }

  JenisKelamin parseJenisKelamin(String value) {
    return value.toLowerCase() == 'perempuan' ? JenisKelamin.Perempuan : JenisKelamin.Lakilaki;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Data Pahlawan',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.green[900],
      ),
      backgroundColor: Color(0xFFF5F9FF),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
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
      ),
    );
  }
}

enum JenisKelamin { Perempuan, Lakilaki }
