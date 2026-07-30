import 'koleksi.dart';

// E-book - turunan dari Koleksi (Inheritance)
class Ebook extends Koleksi {
  final double ukuranFileMb;

  Ebook(String judul, String id, this.ukuranFileMb) : super(judul, id);

  // Polymorphism: E-book gak ada denda telat (soalnya digital,
  // otomatis "ditarik" akses-nya kalau lewat masa pinjam)
  @override
  int get masaPinjamHari => 21; // E-book boleh dipinjam paling lama, 21 hari

  @override
  int hitungDenda(int hariTelat) {
    return 0; // E-book tidak pernah kena denda
  }

  @override
  String toString() =>
      '${super.toString()} - Ukuran: ${ukuranFileMb}MB';
}