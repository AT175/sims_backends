import 'package:flutter/foundation.dart';

class Vehicle {
  final String id, plate, type, insuranceExpiry, roadworthinessExpiry, status;
  final String? assignedDriver, notes;
  const Vehicle({required this.id, required this.plate, required this.type, required this.insuranceExpiry, required this.roadworthinessExpiry, required this.status, this.assignedDriver, this.notes});
}

class TripLog {
  final String id, date, vehiclePlate, driverName, route, purpose, departureTime;
  final String? returnTime;
  final int mileage;
  const TripLog({required this.id, required this.date, required this.vehiclePlate, required this.driverName, required this.route, required this.mileage, required this.purpose, required this.departureTime, this.returnTime});
}

class MaintenanceRecord {
  final String id, vehiclePlate, type, dueDate, status;
  final double? cost;
  final String? notes, completedDate;
  const MaintenanceRecord({required this.id, required this.vehiclePlate, required this.type, required this.dueDate, required this.status, this.cost, this.notes, this.completedDate});
}

class FuelLog {
  final String id, date, vehiclePlate, filledBy;
  final int litres, odometer;
  final double costPerLitre, totalCost;
  const FuelLog({required this.id, required this.date, required this.vehiclePlate, required this.litres, required this.costPerLitre, required this.totalCost, required this.filledBy, required this.odometer});
}

class Driver {
  final String id, name, phone, license, licenseExpiry, assignedVehicle, status;
  final String? dutyStart, dutyEnd;
  const Driver({required this.id, required this.name, required this.phone, required this.license, required this.licenseExpiry, required this.assignedVehicle, required this.status, this.dutyStart, this.dutyEnd});
}

class TransportProvider extends ChangeNotifier {
  final List<Vehicle> _vehicles = [
    Vehicle(id: 'v1', plate: 'GV-1122-1', type: 'Coaster Bus (30-seater)', insuranceExpiry: '2026-12-31', roadworthinessExpiry: '2026-09-30', status: 'Active', assignedDriver: 'Mr. Kwabena'),
    Vehicle(id: 'v2', plate: 'GV-2233-1', type: 'Mini Bus (15-seater)', insuranceExpiry: '2026-08-31', roadworthinessExpiry: '2026-07-15', status: 'Active', assignedDriver: 'Mr. Fiifi'),
    Vehicle(id: 'v3', plate: 'GV-3344-1', type: 'Pickup Truck', insuranceExpiry: '2027-01-31', roadworthinessExpiry: '2026-11-30', status: 'Active', assignedDriver: 'Mr. Emma'),
    Vehicle(id: 'v4', plate: 'GV-4455-1', type: 'Coaster Bus (30-seater)', insuranceExpiry: '2026-10-31', roadworthinessExpiry: '2026-08-20', status: 'Maintenance', notes: 'Engine overhaul in progress'),
    Vehicle(id: 'v5', plate: 'GV-5566-1', type: 'Saloon Car', insuranceExpiry: '2026-09-30', roadworthinessExpiry: '2026-10-15', status: 'Active', assignedDriver: 'Mr. Kojo'),
  ];

  final List<TripLog> _trips = [
    TripLog(id: 't1', date: '2026-07-06', vehiclePlate: 'GV-1122-1', driverName: 'Mr. Kwabena', route: 'Campus -> Kumasi', mileage: 85, purpose: 'Stores procurement', departureTime: '08:00', returnTime: '14:30'),
    TripLog(id: 't2', date: '2026-07-05', vehiclePlate: 'GV-2233-1', driverName: 'Mr. Fiifi', route: 'Campus -> Ejisu', mileage: 42, purpose: 'Sports event', departureTime: '09:00', returnTime: '13:00'),
    TripLog(id: 't3', date: '2026-07-04', vehiclePlate: 'GV-3344-1', driverName: 'Mr. Emma', route: 'Campus -> KATH', mileage: 88, purpose: 'Student referral', departureTime: '10:00', returnTime: '16:00'),
  ];

  final List<MaintenanceRecord> _maintenance = [
    MaintenanceRecord(id: 'm1', vehiclePlate: 'GV-1122-1', type: 'Oil Change', dueDate: '2026-07-15', status: 'Upcoming'),
    MaintenanceRecord(id: 'm2', vehiclePlate: 'GV-4455-1', type: 'Engine Repair', dueDate: '2026-07-10', status: 'In Progress', notes: 'Engine overhaul \u2014 parts ordered', cost: 3500),
    MaintenanceRecord(id: 'm3', vehiclePlate: 'GV-2233-1', type: 'Tire Replacement', dueDate: '2026-08-01', status: 'Scheduled', cost: 1200),
    MaintenanceRecord(id: 'm4', vehiclePlate: 'GV-3344-1', type: 'General Service', dueDate: '2026-07-20', status: 'Upcoming'),
  ];

  final List<FuelLog> _fuelLogs = [
    FuelLog(id: 'f1', date: '2026-07-06', vehiclePlate: 'GV-1122-1', litres: 60, costPerLitre: 14, totalCost: 840, odometer: 45200, filledBy: 'Mr. Kwabena'),
    FuelLog(id: 'f2', date: '2026-07-05', vehiclePlate: 'GV-2233-1', litres: 40, costPerLitre: 14, totalCost: 560, odometer: 32100, filledBy: 'Mr. Fiifi'),
    FuelLog(id: 'f3', date: '2026-07-03', vehiclePlate: 'GV-3344-1', litres: 35, costPerLitre: 14, totalCost: 490, odometer: 28500, filledBy: 'Mr. Emma'),
  ];

  final List<Driver> _drivers = [
    Driver(id: 'd1', name: 'Mr. Kwabena', phone: '024 111 2222', license: 'C', licenseExpiry: '2027-06-30', assignedVehicle: 'GV-1122-1', status: 'On Duty', dutyStart: '08:00', dutyEnd: '16:00'),
    Driver(id: 'd2', name: 'Mr. Fiifi', phone: '024 333 4444', license: 'C', licenseExpiry: '2026-11-30', assignedVehicle: 'GV-2233-1', status: 'Off Duty'),
    Driver(id: 'd3', name: 'Mr. Emma', phone: '024 555 6666', license: 'B', licenseExpiry: '2027-03-31', assignedVehicle: 'GV-3344-1', status: 'On Duty', dutyStart: '10:00', dutyEnd: '18:00'),
    Driver(id: 'd4', name: 'Mr. Kojo', phone: '024 777 8888', license: 'C', licenseExpiry: '2026-09-30', assignedVehicle: 'GV-5566-1', status: 'On Duty', dutyStart: '07:00', dutyEnd: '15:00'),
  ];

  List<Vehicle> get vehicles => List.unmodifiable(_vehicles);
  List<TripLog> get trips => List.unmodifiable(_trips);
  List<MaintenanceRecord> get maintenance => List.unmodifiable(_maintenance);
  List<FuelLog> get fuelLogs => List.unmodifiable(_fuelLogs);
  List<Driver> get drivers => List.unmodifiable(_drivers);

  int get activeVehicles => _vehicles.where((v) => v.status == 'Active').length;
  int get maintenanceVehicles => _vehicles.where((v) => v.status == 'Maintenance').length;
  int get onDutyDrivers => _drivers.where((d) => d.status == 'On Duty').length;
  double get totalFuelCost => _fuelLogs.fold(0, (s, f) => s + f.totalCost);
  int get totalFuelLitres => _fuelLogs.fold(0, (s, f) => s + f.litres);
  int get totalMileage => _trips.fold(0, (s, t) => s + t.mileage);
  double get totalMaintenanceCost => _maintenance.fold(0.0, (s, m) => s + (m.cost ?? 0));

  List<Vehicle> get activeVehiclesList => _vehicles.where((v) => v.status == 'Active').toList();
  List<Vehicle> get maintenanceVehiclesList => _vehicles.where((v) => v.status == 'Maintenance').toList();
  List<Driver> get onDutyDriversList => _drivers.where((d) => d.status == 'On Duty').toList();
  List<Vehicle> get expiringInsurance {
    final now = DateTime.now();
    final threshold = now.add(const Duration(days: 90));
    return _vehicles.where((v) {
      final d = DateTime.tryParse(v.insuranceExpiry);
      return d != null && d.isBefore(threshold);
    }).toList();
  }
  List<MaintenanceRecord> get upcomingMaintenance => _maintenance.where((m) => m.status == 'Upcoming' || m.status == 'Scheduled').toList();
  List<MaintenanceRecord> get inProgressMaintenance => _maintenance.where((m) => m.status == 'In Progress').toList();

  static int _idCounter = 100;
  String _nextId() => (++_idCounter).toString();
  String _today() => DateTime.now().toIso8601String().substring(0, 10);

  // ── Vehicles ──
  void addVehicle({required String plate, required String type, required String insuranceExpiry, required String roadworthinessExpiry, required String status, String? assignedDriver, String? notes}) {
    _vehicles.add(Vehicle(id: _nextId(), plate: plate, type: type, insuranceExpiry: insuranceExpiry, roadworthinessExpiry: roadworthinessExpiry, status: status, assignedDriver: assignedDriver, notes: notes));
    notifyListeners();
  }

  void updateVehicleStatus(String id, String newStatus) {
    final idx = _vehicles.indexWhere((v) => v.id == id);
    if (idx < 0) return;
    final v = _vehicles[idx];
    _vehicles[idx] = Vehicle(id: v.id, plate: v.plate, type: v.type, insuranceExpiry: v.insuranceExpiry, roadworthinessExpiry: v.roadworthinessExpiry, status: newStatus, assignedDriver: v.assignedDriver, notes: v.notes);
    notifyListeners();
  }

  void deleteVehicle(String id) {
    _vehicles.removeWhere((v) => v.id == id);
    notifyListeners();
  }

  // ── Trips ──
  void addTrip({required String vehiclePlate, required String driverName, required String route, required int mileage, required String purpose, required String departureTime, String? returnTime}) {
    _trips.insert(0, TripLog(id: _nextId(), date: _today(), vehiclePlate: vehiclePlate, driverName: driverName, route: route, mileage: mileage, purpose: purpose, departureTime: departureTime, returnTime: returnTime));
    notifyListeners();
  }

  void deleteTrip(String id) {
    _trips.removeWhere((t) => t.id == id);
    notifyListeners();
  }

  // ── Maintenance ──
  void addMaintenance({required String vehiclePlate, required String type, required String dueDate, double? cost, String? notes}) {
    _maintenance.add(MaintenanceRecord(id: _nextId(), vehiclePlate: vehiclePlate, type: type, dueDate: dueDate, status: 'Upcoming', cost: cost, notes: notes));
    notifyListeners();
  }

  void updateMaintenanceStatus(String id, String newStatus) {
    final idx = _maintenance.indexWhere((m) => m.id == id);
    if (idx < 0) return;
    final m = _maintenance[idx];
    _maintenance[idx] = MaintenanceRecord(id: m.id, vehiclePlate: m.vehiclePlate, type: m.type, dueDate: m.dueDate, status: newStatus, cost: m.cost, notes: m.notes, completedDate: newStatus == 'Completed' ? _today() : m.completedDate);
    notifyListeners();
  }

  void deleteMaintenance(String id) {
    _maintenance.removeWhere((m) => m.id == id);
    notifyListeners();
  }

  // ── Fuel ──
  void addFuelLog({required String vehiclePlate, required int litres, required double costPerLitre, int? odometer, required String filledBy}) {
    _fuelLogs.insert(0, FuelLog(id: _nextId(), date: _today(), vehiclePlate: vehiclePlate, litres: litres, costPerLitre: costPerLitre, totalCost: litres * costPerLitre, odometer: odometer ?? 0, filledBy: filledBy));
    notifyListeners();
  }

  void deleteFuelLog(String id) {
    _fuelLogs.removeWhere((f) => f.id == id);
    notifyListeners();
  }

  // ── Drivers ──
  void addDriver({required String name, required String phone, required String license, required String licenseExpiry, required String assignedVehicle, required String status, String? dutyStart, String? dutyEnd}) {
    _drivers.add(Driver(id: _nextId(), name: name, phone: phone, license: license, licenseExpiry: licenseExpiry, assignedVehicle: assignedVehicle, status: status, dutyStart: dutyStart, dutyEnd: dutyEnd));
    notifyListeners();
  }

  void updateDriverStatus(String id, String newStatus) {
    final idx = _drivers.indexWhere((d) => d.id == id);
    if (idx < 0) return;
    final d = _drivers[idx];
    _drivers[idx] = Driver(id: d.id, name: d.name, phone: d.phone, license: d.license, licenseExpiry: d.licenseExpiry, assignedVehicle: d.assignedVehicle, status: newStatus, dutyStart: d.dutyStart, dutyEnd: d.dutyEnd);
    notifyListeners();
  }

  void deleteDriver(String id) {
    _drivers.removeWhere((d) => d.id == id);
    notifyListeners();
  }
}
