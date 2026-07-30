// Base class (abstract) untuk semua jenis koleksi perpustakaan
// Abstraction: class ini gak akan pernah dibuat objeknya langsung,
// cuma jadi "cetakan" untuk Buku, Majalah, dan E-book
abstract class Koleksi {
  // Encapsulation: properti dibuat private (pakai _) supaya cuma bisa
  // diakses/diubah lewat method atau getter yang disediakan class ini
  final String _judul;
  final String _id;
  DateTime? _tanggalPinjam;
  bool _sedangDipinjam = false;

  Koleksi(this._judul, this._id);

  // Getter publik untuk baca data private dari luar class
  String get judul => _judul;
  String get id => _id;
  bool get sedangDipinjam => _sedangDipinjam;
  DateTime? get tanggalPinjam => _tanggalPinjam;

  // Setiap turunan (Buku, Majalah, E-book) WAJIB isi method ini
  // sendiri-sendiri, sesuai aturan masing-masing jenis koleksi.
  // Ini dasar dari polymorphism: method sama, hasil beda tergantung objeknya.
  int get masaPinjamHari;
  int hitungDenda(int hariTelat);

  // Method umum yang sama untuk semua jenis koleksi
  void pinjam() {
    if (_sedangDipinjam) {
      print('$_judul sedang dipinjam, belum bisa dipinjam lagi.');
      return;
    }
    _sedangDipinjam = true;
    _tanggalPinjam = DateTime.now();
    print('$_judul berhasil dipinjam. Batas waktu: $masaPinjamHari hari.');
  }

  void kembalikan() {
    if (!_sedangDipinjam) {
      print('$_judul tidak sedang dipinjam.');
      return;
    }
    _sedangDipinjam = false;
    _tanggalPinjam = null;
    print('$_judul berhasil dikembalikan.');
  }

  @override
  String toString() => '$runtimeType: $_judul (ID: $_id)';
}