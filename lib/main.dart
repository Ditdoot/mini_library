import 'models/koleksi.dart';
import 'models/buku.dart';
import 'models/majalah.dart';
import 'models/ebook.dart';

void main() {
  print('=== Tugas 2 Bootcamp Flutter - Perpustakaan Mini ===\n');

  // Bikin objek dari masing-masing turunan Koleksi
  List<Koleksi> daftarKoleksi = [
    Buku('Laskar Pelangi', 'B001', 'Andrea Hirata'),
    Majalah('National Geographic', 'M001', 245),
    Ebook('Atomic Habits', 'E001', 4.2),
  ];

  // Polymorphism: loop yang sama, tapi tiap objek jalanin
  // method (pinjam, hitungDenda) sesuai aturannya sendiri-sendiri
  for (var koleksi in daftarKoleksi) {
    print(koleksi); // manggil toString() masing-masing class
    koleksi.pinjam();
    print('Denda kalau telat 5 hari: Rp${koleksi.hitungDenda(5)}');
    koleksi.kembalikan();
    print(''); // baris kosong pemisah
  }
}