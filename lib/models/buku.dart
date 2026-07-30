import 'koleksi.dart';

// Buku - turunan dari Koleksi (Inheritance)
class Buku extends Koleksi {
  final String penulis;

  Buku(String judul, String id, this.penulis) : super(judul, id);

  // Polymorphism: aturan masa pinjam & denda beda dari Majalah/E-book
  @override
  int get masaPinjamHari => 14; // Buku boleh dipinjam 14 hari

  @override
  int hitungDenda(int hariTelat) {
    if (hariTelat <= 0) return 0;
    return hariTelat * 1000; // Denda Rp1.000/hari
  }

  @override
  String toString() => '${super.toString()} - Penulis: $penulis';
}