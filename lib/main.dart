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

  // Filter aktif: null = tampilkan semua
  String? filterJenis;

  List<Koleksi> get daftarTertampil {
    if (filterJenis == null) return daftarKoleksi;
    return daftarKoleksi.where((k) => _labelJenis(k) == filterJenis).toList();
  }

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

  void _toggle(Koleksi k) async {
  if (k.sedangDipinjam) {
    final hariTelat = await _tanyaHariTelat();
    if (hariTelat == null) return; // user batal

    final denda = k.hitungDenda(hariTelat);
    setState(() {
      k.kembalikan();
    });

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          denda > 0
              ? '${k.judul} dikembalikan. Denda: Rp$denda ($hariTelat hari telat)'
              : '${k.judul} dikembalikan tepat waktu. Tidak ada denda.',
        ),
        backgroundColor: denda > 0 ? Colors.red : Colors.green,
      ),
    );
  } else {
    setState(() {
      k.pinjam();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${k.judul} berhasil dipinjam.')),
    );
  }
}

Future<int?> _tanyaHariTelat() {
  final controller = TextEditingController(text: '0');
  return showDialog<int>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Konfirmasi Pengembalian'),
      content: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(
          labelText: 'Berapa hari telat? (0 jika tepat waktu)',
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Batal'),
        ),
        FilledButton(
          onPressed: () {
            final hari = int.tryParse(controller.text) ?? 0;
            Navigator.pop(context, hari < 0 ? 0 : hari);
          },
          child: const Text('Konfirmasi'),
        ),
      ],
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perpustakaan Mini'),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.filter_list),
            onSelected: (value) {
              setState(() {
                filterJenis = value == 'Semua' ? null : value;
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'Semua', child: Text('Semua')),
              const PopupMenuItem(value: 'Buku', child: Text('Buku')),
              const PopupMenuItem(value: 'Majalah', child: Text('Majalah')),
              const PopupMenuItem(value: 'E-book', child: Text('E-book')),
            ],
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: daftarTertampil.length,
        itemBuilder: (context, index) {
          final koleksi = daftarTertampil[index];
          final warna = _warnaJenis(koleksi);

          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.only(bottom: 12),
            child: Card(
              margin: EdgeInsets.zero,
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
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        transitionBuilder: (child, animation) =>
                            ScaleTransition(scale: animation, child: child),
                        child: Icon(
                          koleksi.sedangDipinjam
                              ? Icons.lock_outline
                              : Icons.check_circle_outline,
                          key: ValueKey(koleksi.sedangDipinjam),
                          color: koleksi.sedangDipinjam ? Colors.red : Colors.green,
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 4),
                      AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 300),
                        style: TextStyle(
                          color: koleksi.sedangDipinjam ? Colors.red : Colors.green,
                          fontSize: 12,
                        ),
                        child: Text(koleksi.sedangDipinjam ? 'Dipinjam' : 'Tersedia'),
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
          ),
          );
        },
      ),
    );
  }
}