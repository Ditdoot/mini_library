import 'koleksi.dart';

// Majalah - turunan dari Koleksi (Inheritance)
class Majalah extends Koleksi {
  final int edisi;

  Majalah(String judul, String id, this.edisi) : super(judul, id);

  // Polymorphism: masa pinjam lebih singkat, denda per hari lebih murah
  @override
  int get masaPinjamHari => 7; // Majalah cuma boleh dipinjam 7 hari

  @override
  int hitungDenda(int hariTelat) {
    if (hariTelat <= 0) return 0;
    return hariTelat * 500; // Denda Rp500/hari
  }

  @override
  String toString() => '${super.toString()} - Edisi: $edisi';
}