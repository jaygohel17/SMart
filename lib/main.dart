import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

// Enums
enum UserRole { admin, operator }

// Models
class User {
  final String id;
  final String name;
  final UserRole role;
  final String email;

  User({
    required this.id,
    required this.name,
    required this.role,
    required this.email,
  });
}

class Material {
  final String id;
  final String name;
  final String description;
  final double quantity;
  final String unit;
  final double costPerUnit;
  final String qrCode;

  Material({
    required this.id,
    required this.name,
    required this.description,
    required this.quantity,
    required this.unit,
    required this.costPerUnit,
    required this.qrCode,
  });
}

class MaterialUsage {
  final String id;
  final String materialId;
  final double quantityUsed;
  final DateTime timestamp;
  final String operatorId;
  final String? notes;

  MaterialUsage({
    required this.id,
    required this.materialId,
    required this.quantityUsed,
    required this.timestamp,
    required this.operatorId,
    this.notes,
  });
}

// State Management
class AppState extends ChangeNotifier {
  User? _currentUser;
  List<Material> _materials = [];
  List<MaterialUsage> _materialUsages = [];

  AppState() {
    // Initialize with mock data
    _materials = [
      Material(
        id: '1',
        name: 'Steel Sheet',
        description: '1mm thick steel sheet',
        quantity: 100,
        unit: 'sheets',
        costPerUnit: 25.50,
        qrCode: 'STEEL001',
      ),
      Material(
        id: '2',
        name: 'Aluminum Bar',
        description: '2x4 inch aluminum bar',
        quantity: 50,
        unit: 'bars',
        costPerUnit: 15.75,
        qrCode: 'ALUM001',
      ),
      Material(
        id: '3',
        name: 'Copper Wire',
        description: '16 gauge copper wire',
        quantity: 200,
        unit: 'meters',
        costPerUnit: 8.25,
        qrCode: 'COPP001',
      ),
    ];

    _materialUsages = [
      MaterialUsage(
        id: '1',
        materialId: '1',
        quantityUsed: 5,
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        operatorId: 'op1',
        notes: 'Used in production line A',
      ),
      MaterialUsage(
        id: '2',
        materialId: '2',
        quantityUsed: 3,
        timestamp: DateTime.now().subtract(const Duration(hours: 12)),
        operatorId: 'op2',
        notes: 'Used in production line B',
      ),
    ];
  }

  User? get currentUser => _currentUser;
  List<Material> get materials => _materials;
  List<MaterialUsage> get materialUsages => _materialUsages;

  void setUser(User? user) {
    _currentUser = user;
    notifyListeners();
  }

  void addMaterial(Material material) {
    _materials.add(material);
    notifyListeners();
  }

  void recordMaterialUsage(MaterialUsage usage) {
    _materialUsages.add(usage);
    notifyListeners();
  }

  void updateMaterialQuantity(String materialId, double newQuantity) {
    final index = _materials.indexWhere((m) => m.id == materialId);
    if (index != -1) {
      _materials[index] = Material(
        id: _materials[index].id,
        name: _materials[index].name,
        description: _materials[index].description,
        quantity: newQuantity,
        unit: _materials[index].unit,
        costPerUnit: _materials[index].costPerUnit,
        qrCode: _materials[index].qrCode,
      );
      notifyListeners();
    }
  }
}

// Custom Widgets
class GradientButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final List<Color> gradientColors;

  const GradientButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.gradientColors = const [Color(0xFF1E88E5), Color(0xFF1565C0)],
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: gradientColors.last.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class MaterialCard extends StatelessWidget {
  final Material material;
  final VoidCallback? onLogUsage;

  const MaterialCard({
    Key? key,
    required this.material,
    this.onLogUsage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blue.shade50,
              Colors.white,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      material.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: material.quantity < 20
                          ? Colors.red.shade100
                          : Colors.green.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${material.quantity} ${material.unit}',
                      style: TextStyle(
                        color: material.quantity < 20
                            ? Colors.red.shade900
                            : Colors.green.shade900,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                material.description,
                style: TextStyle(
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '\$${material.costPerUnit.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  if (onLogUsage != null)
                    GradientButton(
                      text: 'Log Usage',
                      onPressed: onLogUsage!,
                      gradientColors: const [
                        Color(0xFF4CAF50),
                        Color(0xFF2E7D32),
                      ],
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Screens
class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blue.shade900,
              Colors.blue.shade700,
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.factory_rounded,
                    size: 80,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'SmartFab',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Material Tracking System',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 48),
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        TextField(
                          decoration: InputDecoration(
                            labelText: 'Email',
                            prefixIcon: const Icon(Icons.email),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            prefixIcon: const Icon(Icons.lock),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            GradientButton(
                              text: 'Admin',
                              onPressed: () {
                                final appState = Provider.of<AppState>(
                                  context,
                                  listen: false,
                                );
                                appState.setUser(User(
                                  id: '1',
                                  name: 'Admin User',
                                  role: UserRole.admin,
                                  email: 'admin@smartfab.com',
                                ));
                              },
                            ),
                            GradientButton(
                              text: 'Operator',
                              onPressed: () {
                                final appState = Provider.of<AppState>(
                                  context,
                                  listen: false,
                                );
                                appState.setUser(User(
                                  id: '2',
                                  name: 'Operator User',
                                  role: UserRole.operator,
                                  email: 'operator@smartfab.com',
                                ));
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final user = appState.currentUser!;
    final materials = appState.materials;
    final usages = appState.materialUsages;

    return Scaffold(
      appBar: AppBar(
        title: const Text('SmartFab Dashboard'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              appState.setUser(null);
            },
          ),
        ],
      ),
      body: user.role == UserRole.admin
          ? AdminDashboard(materials: materials, usages: usages)
          : OperatorDashboard(materials: materials),
    );
  }
}

class AdminDashboard extends StatelessWidget {
  final List<Material> materials;
  final List<MaterialUsage> usages;

  const AdminDashboard({
    Key? key,
    required this.materials,
    required this.usages,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Material Inventory',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: materials.length,
            itemBuilder: (context, index) {
              final material = materials[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: MaterialCard(material: material),
              );
            },
          ),
          const SizedBox(height: 24),
          const Text(
            'Recent Usage',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: usages.length,
            itemBuilder: (context, index) {
              final usage = usages[index];
              final material = materials.firstWhere(
                (m) => m.id == usage.materialId,
                orElse: () => Material(
                  id: '',
                  name: 'Unknown',
                  description: '',
                  quantity: 0,
                  unit: '',
                  costPerUnit: 0,
                  qrCode: '',
                ),
              );
              return Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            material.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade100,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '${usage.quantityUsed} ${material.unit}',
                              style: TextStyle(
                                color: Colors.blue.shade900,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        usage.notes ?? 'No notes provided',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        usage.timestamp.toString().split('.')[0],
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class OperatorDashboard extends StatelessWidget {
  final List<Material> materials;

  const OperatorDashboard({
    Key? key,
    required this.materials,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          GradientButton(
            text: 'Scan Material',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('QR Scanning functionality coming soon!'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            gradientColors: const [
              Color(0xFF2196F3),
              Color(0xFF1976D2),
            ],
          ),
          const SizedBox(height: 24),
          const Text(
            'Available Materials',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: materials.length,
            itemBuilder: (context, index) {
              final material = materials[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: MaterialCard(
                  material: material,
                  onLogUsage: () => _showLogUsageDialog(context, material),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _showLogUsageDialog(BuildContext context, Material material) {
    final quantityController = TextEditingController();
    final notesController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Log Usage - ${material.name}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: quantityController,
              decoration: InputDecoration(
                labelText: 'Quantity (${material.unit})',
                hintText: 'Enter quantity used',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: notesController,
              decoration: InputDecoration(
                labelText: 'Notes',
                hintText: 'Add any notes about the usage',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          GradientButton(
            text: 'Log',
            onPressed: () {
              final quantity = double.tryParse(quantityController.text);
              if (quantity != null && quantity > 0) {
                final appState = Provider.of<AppState>(context, listen: false);
                appState.recordMaterialUsage(MaterialUsage(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  materialId: material.id,
                  quantityUsed: quantity,
                  timestamp: DateTime.now(),
                  operatorId: appState.currentUser!.id,
                  notes: notesController.text,
                ));
                appState.updateMaterialQuantity(
                  material.id,
                  material.quantity - quantity,
                );
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Usage logged successfully'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please enter a valid quantity'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

// Main App
void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => AppState(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SmartFab Material Tracker',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1E88E5),
          brightness: Brightness.light,
        ),
        textTheme: GoogleFonts.poppinsTextTheme(),
        appBarTheme: const AppBarTheme(
          elevation: 0,
          centerTitle: true,
        ),
      ),
      home: Consumer<AppState>(
        builder: (context, appState, _) {
          return appState.currentUser == null
              ? const LoginScreen()
              : const DashboardScreen();
        },
      ),
    );
  }
}
