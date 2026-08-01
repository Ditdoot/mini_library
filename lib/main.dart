import 'package:flutter/material.dart';
import 'models/koleksi.dart';
import 'models/buku.dart';
import 'models/majalah.dart';
import 'models/ebook.dart';

void main() {
  runApp(const PerpustakaanApp());
}

class PerpustakaanApp extends StatelessWidget {
  const PerpustakaanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Perpustakaan Mini',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.teal,
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Koleksi> daftarKoleksi = [
    Buku('Laskar Pelangi', 'B001', 'Andrea Hirata'),
    Majalah('National Geographic', 'M001', 245),
    Ebook('Atomic Habits', 'E001', 4.2),
  ];

  // Warna badge berbeda tiap jenis koleksi (visualisasi polymorphism)
  Color _warnaJenis(Koleksi k) {
    if (k is Buku) return Colors.blue;
    if (k is Majalah) return Colors.orange;
    if (k is Ebook) return Colors.purple;
    return Colors.grey;
  }

  String _labelJenis(Koleksi k) {
    if (k is Buku) return 'Buku';
    if (k is Majalah) return 'Majalah';
    if (k is Ebook) return 'E-book';
    return 'Koleksi';
  }

  String _subtitle(Koleksi k) {
    if (k is Buku) return 'Penulis: ${k.penulis}';
    if (k is Majalah) return 'Edisi: ${k.edisi}';
    if (k is Ebook) return 'Ukuran: ${k.ukuranFileMb} MB';
    return '';
  }

  void _toggle(Koleksi k) {
    setState(() {
      if (k.sedangDipinjam) {
        k.kembalikan();
      } else {
        k.pinjam();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perpustakaan Mini'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: daftarKoleksi.length,
        itemBuilder: (context, index) {
          final koleksi = daftarKoleksi[index];
          final warna = _warnaJenis(koleksi);

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: warna.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          _labelJenis(koleksi),
                          style: TextStyle(
                            color: warna,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Icon(
                        koleksi.sedangDipinjam
                            ? Icons.lock_outline
                            : Icons.check_circle_outline,
                        color: koleksi.sedangDipinjam
                            ? Colors.red
                            : Colors.green,
                        size: 18,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        koleksi.sedangDipinjam ? 'Dipinjam' : 'Tersedia',
                        style: TextStyle(
                          color: koleksi.sedangDipinjam
                              ? Colors.red
                              : Colors.green,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    koleksi.judul,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(_subtitle(koleksi)),
                  const SizedBox(height: 4),
                  Text(
                    'Masa pinjam: ${koleksi.masaPinjamHari} hari  •  '
                    'Denda telat 5 hari: Rp${koleksi.hitungDenda(5)}',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () => _toggle(koleksi),
                      style: FilledButton.styleFrom(
                        backgroundColor:
                            koleksi.sedangDipinjam ? Colors.grey : warna,
                      ),
                      child: Text(
                        koleksi.sedangDipinjam ? 'Kembalikan' : 'Pinjam',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}