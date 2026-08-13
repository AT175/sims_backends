import 'package:flutter/foundation.dart';

// ── Constants ──

const bookCategories = ['Mathematics', 'Science', 'Literature', 'Business', 'History', 'Geography', 'Religious Studies', 'Languages', 'ICT', 'Arts', 'Reference'];
const labs = ['ICT Lab 1', 'ICT Lab 2', 'Library Computer Room'];
const timeSlotsLib = ['08:00 - 09:20', '09:20 - 10:40', '11:00 - 12:20', '13:00 - 14:20', '14:20 - 15:40'];
const equipmentConditions = ['Good', 'Fair', 'Poor', 'Needs Repair'];
const digitalResourceTypes = ['E-Book', 'Past Questions', 'Video Tutorial', 'Software', 'Audio Book'];
const accessRoles = ['Librarian', 'ICT Coordinator', 'Teacher', 'Student', 'Admin Staff'];
const accessLevels = ['Full', 'Read Only', 'Restricted', 'No Access'];
const accessResources = ['Library Catalogue', 'ICT Lab Bookings', 'Equipment Inventory', 'Digital Resources', 'Circulation Records'];

String _todayISO() => DateTime.now().toIso8601String().substring(0, 10);

// ── Models ──

class Book {
  final String id, title, author, category;
  final String? isbn;
  final int totalCopies, availableCopies;
  const Book({required this.id, required this.title, required this.author, required this.category, this.isbn, required this.totalCopies, required this.availableCopies});

  Book copyWith({int? availableCopies, int? totalCopies, String? title, String? author, String? category, String? isbn}) =>
    Book(id: id, title: title ?? this.title, author: author ?? this.author, category: category ?? this.category, isbn: isbn ?? this.isbn, totalCopies: totalCopies ?? this.totalCopies, availableCopies: availableCopies ?? this.availableCopies);
}

class CirculationRecord {
  final String id, date, bookId, bookTitle, borrowerName, borrowerClass, dueDate;
  final String? returnDate;
  final String status;
  const CirculationRecord({required this.id, required this.date, required this.bookId, required this.bookTitle, required this.borrowerName, required this.borrowerClass, required this.dueDate, this.returnDate, required this.status});

  CirculationRecord copyWith({String? status, String? returnDate}) =>
    CirculationRecord(id: id, date: date, bookId: bookId, bookTitle: bookTitle, borrowerName: borrowerName, borrowerClass: borrowerClass, dueDate: dueDate, returnDate: returnDate ?? this.returnDate, status: status ?? this.status);
}

class ICTBooking {
  final String id, date, timeSlot, className, teacherName, lab, purpose, status;
  const ICTBooking({required this.id, required this.date, required this.timeSlot, required this.className, required this.teacherName, required this.lab, required this.purpose, required this.status});

  ICTBooking copyWith({String? status}) =>
    ICTBooking(id: id, date: date, timeSlot: timeSlot, className: className, teacherName: teacherName, lab: lab, purpose: purpose, status: status ?? this.status);
}

class LibraryEquipment {
  final String id, item, condition, location, lastServiceDate;
  final int quantity;
  final String? notes;
  const LibraryEquipment({required this.id, required this.item, required this.quantity, required this.condition, required this.location, required this.lastServiceDate, this.notes});
}

class DigitalResource {
  final String id, title, type, uploadDate, fileSize;
  final int downloads;
  const DigitalResource({required this.id, required this.title, required this.type, required this.downloads, required this.uploadDate, required this.fileSize});

  DigitalResource copyWith({int? downloads}) =>
    DigitalResource(id: id, title: title, type: type, downloads: downloads ?? this.downloads, uploadDate: uploadDate, fileSize: fileSize);
}

class LibraryAccessRecord {
  final String id, personName, role, resource, accessLevel, grantedDate, grantedBy;
  final String? notes;
  const LibraryAccessRecord({required this.id, required this.personName, required this.role, required this.resource, required this.accessLevel, required this.grantedDate, required this.grantedBy, this.notes});
}

// ── Provider ──

class LibraryProvider extends ChangeNotifier {
  final List<Book> _books = [
    Book(id: '1', title: 'Advanced Mathematics', author: 'K.A. Stroud', category: 'Mathematics', isbn: '9781352005981', totalCopies: 5, availableCopies: 3),
    Book(id: '2', title: 'Organic Chemistry', author: 'Morrison & Boyd', category: 'Science', isbn: '9780136436690', totalCopies: 3, availableCopies: 1),
    Book(id: '3', title: 'Things Fall Apart', author: 'Chinua Achebe', category: 'Literature', isbn: '9780385474542', totalCopies: 10, availableCopies: 8),
    Book(id: '4', title: 'Economics for SHS', author: 'G. Antwi', category: 'Business', totalCopies: 8, availableCopies: 5),
    Book(id: '5', title: 'A History of Ghana', author: 'F.K. Buah', category: 'History', totalCopies: 6, availableCopies: 6),
    Book(id: '6', title: 'Senior High Physics', author: 'A.A. Adjei', category: 'Science', totalCopies: 4, availableCopies: 2),
  ];
  List<Book> get books => _books;

  final List<CirculationRecord> _circulation = [
    CirculationRecord(id: '1', date: '2026-07-06', bookId: '1', bookTitle: 'Advanced Mathematics', borrowerName: 'K. Asante', borrowerClass: 'SHS2 Sci A', dueDate: '2026-07-20', status: 'Borrowed'),
    CirculationRecord(id: '2', date: '2026-07-05', bookId: '2', bookTitle: 'Organic Chemistry', borrowerName: 'G. Opoku', borrowerClass: 'SHS2 Sci B', dueDate: '2026-07-19', status: 'Borrowed'),
    CirculationRecord(id: '3', date: '2026-07-03', bookId: '3', bookTitle: 'Things Fall Apart', borrowerName: 'A. Owusu', borrowerClass: 'SHS1 Arts A', dueDate: '2026-07-17', returnDate: '2026-07-10', status: 'Returned'),
    CirculationRecord(id: '4', date: '2026-06-28', bookId: '6', bookTitle: 'Senior High Physics', borrowerName: 'M. Tetteh', borrowerClass: 'SHS3 Sci A', dueDate: '2026-07-12', status: 'Overdue'),
  ];
  List<CirculationRecord> get circulation => _circulation;

  final List<ICTBooking> _bookings = [
    ICTBooking(id: '1', date: '2026-07-08', timeSlot: '08:00 - 09:20', className: 'SHS2 Sci A', teacherName: 'Mr. Adjei', lab: 'ICT Lab 1', purpose: 'Practical: Spreadsheets', status: 'Booked'),
    ICTBooking(id: '2', date: '2026-07-08', timeSlot: '10:00 - 11:20', className: 'SHS1 Arts B', teacherName: 'Mrs. Boateng', lab: 'ICT Lab 1', purpose: 'Intro to Word Processing', status: 'Booked'),
    ICTBooking(id: '3', date: '2026-07-09', timeSlot: '08:00 - 09:20', className: 'SHS3 Sci A', teacherName: 'Mr. Owusu', lab: 'ICT Lab 2', purpose: 'Online Research', status: 'Booked'),
  ];
  List<ICTBooking> get bookings => _bookings;

  final List<LibraryEquipment> _equipment = [
    LibraryEquipment(id: '1', item: 'Desktop PCs (Lab 1)', quantity: 30, condition: 'Good', location: 'ICT Lab 1', lastServiceDate: '2026-05-15'),
    LibraryEquipment(id: '2', item: 'Desktop PCs (Lab 2)', quantity: 25, condition: 'Fair', location: 'ICT Lab 2', lastServiceDate: '2026-03-20'),
    LibraryEquipment(id: '3', item: 'Projectors', quantity: 4, condition: 'Good', location: 'Store Room A', lastServiceDate: '2026-06-10'),
    LibraryEquipment(id: '4', item: 'Printers', quantity: 3, condition: 'Needs Repair', location: 'Library Office', lastServiceDate: '2026-06-05', notes: '1 unit needs drum replacement'),
    LibraryEquipment(id: '5', item: 'Library Scanner', quantity: 2, condition: 'Good', location: 'Library Front Desk', lastServiceDate: '2026-04-12'),
  ];
  List<LibraryEquipment> get equipment => _equipment;

  final List<DigitalResource> _digitalResources = [
    DigitalResource(id: '1', title: 'Core Math Past Questions (2015-2025)', type: 'Past Questions', downloads: 342, uploadDate: '2026-01-15', fileSize: '12.4 MB'),
    DigitalResource(id: '2', title: 'Chemistry E-Book (SHS)', type: 'E-Book', downloads: 218, uploadDate: '2026-02-01', fileSize: '8.7 MB'),
    DigitalResource(id: '3', title: 'English Literature Anthology', type: 'E-Book', downloads: 156, uploadDate: '2026-02-10', fileSize: '5.2 MB'),
    DigitalResource(id: '4', title: 'Physics Past Questions (2018-2025)', type: 'Past Questions', downloads: 289, uploadDate: '2026-01-20', fileSize: '10.1 MB'),
    DigitalResource(id: '5', title: 'ICT Practical Video Series', type: 'Video Tutorial', downloads: 97, uploadDate: '2026-03-05', fileSize: '245 MB'),
  ];
  List<DigitalResource> get digitalResources => _digitalResources;

  final List<LibraryAccessRecord> _accessRecords = [
    LibraryAccessRecord(id: '1', personName: 'Mrs. Asante', role: 'Librarian', resource: 'Library Catalogue', accessLevel: 'Full', grantedDate: '2026-01-05', grantedBy: 'Headmaster'),
    LibraryAccessRecord(id: '2', personName: 'Mr. Adjei', role: 'ICT Coordinator', resource: 'ICT Lab Bookings', accessLevel: 'Full', grantedDate: '2026-01-05', grantedBy: 'Headmaster'),
    LibraryAccessRecord(id: '3', personName: 'Mr. Adjei', role: 'ICT Coordinator', resource: 'Equipment Inventory', accessLevel: 'Full', grantedDate: '2026-01-05', grantedBy: 'Headmaster'),
    LibraryAccessRecord(id: '4', personName: 'Mrs. Asante', role: 'Librarian', resource: 'Digital Resources', accessLevel: 'Full', grantedDate: '2026-01-05', grantedBy: 'Headmaster'),
    LibraryAccessRecord(id: '5', personName: 'All Teaching Staff', role: 'Teacher', resource: 'ICT Lab Bookings', accessLevel: 'Read Only', grantedDate: '2026-01-10', grantedBy: 'ICT Coordinator'),
    LibraryAccessRecord(id: '6', personName: 'All Students', role: 'Student', resource: 'Digital Resources', accessLevel: 'Read Only', grantedDate: '2026-01-10', grantedBy: 'Librarian'),
    LibraryAccessRecord(id: '7', personName: 'All Students', role: 'Student', resource: 'Equipment Inventory', accessLevel: 'No Access', grantedDate: '2026-01-10', grantedBy: 'ICT Coordinator'),
  ];
  List<LibraryAccessRecord> get accessRecords => _accessRecords;

  int _idCounter = 200;
  String _nextId() => (++_idCounter).toString();

  // ── Computed getters ──
  int get borrowedBooks => _circulation.where((c) => c.status == 'Borrowed').length;
  int get overdueBooks => _circulation.where((c) => c.status == 'Overdue').length;
  int get totalBooks => _books.fold(0, (s, b) => s + b.totalCopies);
  int get availableBooks => _books.fold(0, (s, b) => s + b.availableCopies);
  int get totalDownloads => _digitalResources.fold(0, (s, r) => s + r.downloads);
  List<Book> get availableBookList => _books.where((b) => b.availableCopies > 0).toList();
  List<CirculationRecord> get overdueList => _circulation.where((c) => c.status == 'Overdue').toList();

  // ── Book CRUD ──
  void addBook({required String title, required String author, required String category, String? isbn, required int totalCopies}) {
    _books.insert(0, Book(id: _nextId(), title: title, author: author, category: category, isbn: isbn, totalCopies: totalCopies, availableCopies: totalCopies));
    notifyListeners();
  }

  void deleteBook(String id) {
    _books.removeWhere((b) => b.id == id);
    notifyListeners();
  }

  // ── Circulation ──
  void borrowBook({required String bookId, required String borrowerName, required String borrowerClass, required String dueDate}) {
    final book = _books.where((b) => b.id == bookId).firstOrNull;
    if (book == null || book.availableCopies <= 0) return;
    _circulation.insert(0, CirculationRecord(
      id: _nextId(), date: _todayISO(), bookId: bookId, bookTitle: book.title,
      borrowerName: borrowerName, borrowerClass: borrowerClass, dueDate: dueDate, status: 'Borrowed',
    ));
    final idx = _books.indexWhere((b) => b.id == bookId);
    _books[idx] = _books[idx].copyWith(availableCopies: _books[idx].availableCopies - 1);
    notifyListeners();
  }

  void returnBook(String circulationId) {
    final record = _circulation.where((c) => c.id == circulationId).firstOrNull;
    if (record == null || record.status == 'Returned') return;
    final cIdx = _circulation.indexWhere((c) => c.id == circulationId);
    _circulation[cIdx] = _circulation[cIdx].copyWith(status: 'Returned', returnDate: _todayISO());
    final bIdx = _books.indexWhere((b) => b.id == record.bookId);
    if (bIdx >= 0) _books[bIdx] = _books[bIdx].copyWith(availableCopies: _books[bIdx].availableCopies + 1);
    notifyListeners();
  }

  // ── ICT Booking ──
  void addBooking({required String date, required String timeSlot, required String className, required String teacherName, required String lab, String purpose = ''}) {
    _bookings.insert(0, ICTBooking(id: _nextId(), date: date, timeSlot: timeSlot, className: className, teacherName: teacherName, lab: lab, purpose: purpose, status: 'Booked'));
    notifyListeners();
  }

  void cancelBooking(String id) {
    final idx = _bookings.indexWhere((b) => b.id == id);
    if (idx >= 0) { _bookings[idx] = _bookings[idx].copyWith(status: 'Cancelled'); notifyListeners(); }
  }

  void completeBooking(String id) {
    final idx = _bookings.indexWhere((b) => b.id == id);
    if (idx >= 0) { _bookings[idx] = _bookings[idx].copyWith(status: 'Completed'); notifyListeners(); }
  }

  // ── Equipment CRUD ──
  void addEquipment({required String item, required int quantity, required String condition, required String location, String lastServiceDate = '', String? notes}) {
    _equipment.insert(0, LibraryEquipment(
      id: _nextId(), item: item, quantity: quantity, condition: condition,
      location: location, lastServiceDate: lastServiceDate.isEmpty ? _todayISO() : lastServiceDate, notes: notes,
    ));
    notifyListeners();
  }

  void deleteEquipment(String id) {
    _equipment.removeWhere((e) => e.id == id);
    notifyListeners();
  }

  // ── Digital Resource CRUD ──
  void addDigitalResource({required String title, required String type, String fileSize = 'Unknown', String uploadDate = ''}) {
    _digitalResources.insert(0, DigitalResource(
      id: _nextId(), title: title, type: type, downloads: 0,
      uploadDate: uploadDate.isEmpty ? _todayISO() : uploadDate, fileSize: fileSize,
    ));
    notifyListeners();
  }

  void deleteDigitalResource(String id) {
    _digitalResources.removeWhere((r) => r.id == id);
    notifyListeners();
  }

  void incrementDownload(String id) {
    final idx = _digitalResources.indexWhere((r) => r.id == id);
    if (idx >= 0) { _digitalResources[idx] = _digitalResources[idx].copyWith(downloads: _digitalResources[idx].downloads + 1); notifyListeners(); }
  }

  // ── Access Control ──
  void grantAccess({required String personName, required String role, required String resource, required String accessLevel, required String grantedBy, String? notes}) {
    _accessRecords.insert(0, LibraryAccessRecord(
      id: _nextId(), personName: personName, role: role, resource: resource,
      accessLevel: accessLevel, grantedDate: _todayISO(), grantedBy: grantedBy, notes: notes,
    ));
    notifyListeners();
  }

  void revokeAccess(String id) {
    _accessRecords.removeWhere((a) => a.id == id);
    notifyListeners();
  }
}
