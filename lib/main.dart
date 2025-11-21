import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
//import 'package:flutter_sound/flutter_sound.dart'; // REMOVE flutter_sound
import 'dart:async';
import 'dart:math';
import 'dart:io' show Platform; // Import dart:io
import 'package:audioplayers/audioplayers.dart'; // ADD audioplayers

final AudioPlayer _player = AudioPlayer(); // ADD audioplayers

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyBGIDsURC_bD9LVz6o3E6ldAt9e8ZgGe_A",
        authDomain: "iot-health-monitoring-sy-b19b8.firebaseapp.com",
        databaseURL:
            "https://iot-health-monitoring-sy-b19b8-default-rtdb.firebaseio.com",
        projectId: "iot-health-monitoring-sy-b19b8",
        storageBucket: "iot-health-monitoring-sy-b19b8.firebasestorage.app",
        messagingSenderId: "790006353463",
        appId: "1:790006353463:web:18e0c68764041a75b979b2",
        measurementId: "G-BGEX7W9H8J",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }

  runApp(const HealthMonitoringApp());
}

class HealthMonitoringApp extends StatelessWidget {
  const HealthMonitoringApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'IoT Health Monitor',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: Colors.grey[50],
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.blue[800],
            foregroundColor: Colors.white,
            elevation: 0,
          ),
        ),
        home: const LoginScreen(),
        routes: {
          '/login': (context) => const LoginScreen(),
          '/signup': (context) => const SignUpScreen(),
          '/dashboard': (context) => const DashboardScreen(),
          '/patients': (context) => const PatientListScreen(),
          '/alerts': (context) => AlertsScreen(),
          '/patient-detail': (context) => const PatientDetailScreen(),
        });
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  void _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      await Future.delayed(const Duration(seconds: 2));
      setState(() => _isLoading = false);
      Navigator.pushReplacementNamed(context, '/dashboard');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.health_and_safety, size: 80, color: Colors.blue[800]),
              const SizedBox(height: 24),
              Text(
                'IoT Health Monitor',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[800],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Remote Patient Monitoring System',
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
              const SizedBox(height: 48),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        prefixIcon: const Icon(Icons.email),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                            .hasMatch(value)) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[800],
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: _isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white)
                            : const Text('Login',
                                style: TextStyle(fontSize: 16)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _licenseController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _agreeToTerms = false;
  String _selectedRole = 'Doctor';

  final List<String> _roles = [
    'Doctor',
    'Nurse',
    'Administrator',
    'Technician'
  ];

  void _signUp() async {
    if (_formKey.currentState!.validate() && _agreeToTerms) {
      setState(() => _isLoading = true);
      await Future.delayed(const Duration(seconds: 2));
      setState(() => _isLoading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Account created successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pushReplacementNamed(context, '/login');
    } else if (!_agreeToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please agree to Terms and Conditions'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Create Account',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[800],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Join our healthcare monitoring system',
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
                const SizedBox(height: 32),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _firstNameController,
                              decoration: InputDecoration(
                                labelText: 'First Name',
                                prefixIcon: const Icon(Icons.person),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Required';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextFormField(
                              controller: _lastNameController,
                              decoration: InputDecoration(
                                labelText: 'Last Name',
                                prefixIcon: const Icon(Icons.person),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Required';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          prefixIcon: const Icon(Icons.email),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                              .hasMatch(value)) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          labelText: 'Phone Number',
                          prefixIcon: const Icon(Icons.phone),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your phone number';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: _selectedRole,
                        decoration: InputDecoration(
                          labelText: 'Role',
                          prefixIcon: const Icon(Icons.work),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        items: _roles.map((String role) {
                          return DropdownMenuItem<String>(
                            value: role,
                            child: Text(role),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedRole = newValue!;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _licenseController,
                        decoration: InputDecoration(
                          labelText: 'License Number',
                          prefixIcon: const Icon(Icons.badge),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your license number';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          prefixIcon: const Icon(Icons.lock),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a password';
                          }
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _confirmPasswordController,
                        obscureText: _obscureConfirmPassword,
                        decoration: InputDecoration(
                          labelText: 'Confirm Password',
                          prefixIcon: const Icon(Icons.lock),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureConfirmPassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureConfirmPassword =
                                    !_obscureConfirmPassword;
                              });
                            },
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please confirm your password';
                          }
                          if (value != _passwordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Checkbox(
                            value: _agreeToTerms,
                            onChanged: (bool? value) {
                              setState(() {
                                _agreeToTerms = value!;
                              });
                            },
                            activeColor: Colors.blue[800],
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _agreeToTerms = !_agreeToTerms;
                                });
                              },
                              child: const Text(
                                'I agree to the Terms and Conditions and Privacy Policy',
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _signUp,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[800],
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: _isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white)
                              : const Text('Create Account',
                                  style: TextStyle(fontSize: 16)),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Already have an account? ",
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              'Login',
                              style: TextStyle(
                                color: Colors.blue[800],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
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
    );
  }
}

// Duplicate DashboardScreen class removed to fix the error.

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const DashboardContent(),
    const PatientListScreen(),
    AlertsScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        selectedItemColor: Colors.blue[800],
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.dashboard), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Patients'),
          BottomNavigationBarItem(icon: Icon(Icons.warning), label: 'Alerts'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

class DashboardContent extends StatelessWidget {
  const DashboardContent({super.key});

  @override
  Widget build(BuildContext context) {
    final DatabaseReference patientsRef = FirebaseDatabase.instance.ref();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () => Navigator.pushNamed(context, '/alerts'),
          ),
        ],
      ),
      body: StreamBuilder<DatabaseEvent>(
        stream: patientsRef.onValue,
        builder: (context, snapshot) {
          int totalBeds = 10;
          int occupiedBeds = 0;
          int criticalPatients = 0;
          List<AlertItem> recentAlerts = [];

          if (snapshot.hasData && snapshot.data?.snapshot.value != null) {
            Map<dynamic, dynamic> data = snapshot.data!.snapshot.value as Map;

            occupiedBeds = data.length;

            data.forEach((key, value) {
              final valueMap = value as Map?;
              if (valueMap != null) {
                final status = valueMap['Status']?.toString() ?? 'Unknown';
                final heartRate = (valueMap['HeartRate'] ?? 0).round();
                final temp = (valueMap['Temp'] ?? 0).toDouble();

                if (status.toLowerCase() == 'critical') {
                  criticalPatients++;
                }

                // Create recent alerts based on thresholds
                if (heartRate > 120 || temp > 38.5) {
                  String alertMessage = '';
                  String severity = 'Warning';
                  Color color = Colors.orange;

                  if (heartRate > 140) {
                    alertMessage = 'Critical Heart Rate: $heartRate BPM';
                    severity = 'Critical';
                    color = Colors.red;
                  } else if (heartRate > 120) {
                    alertMessage = 'High Heart Rate: $heartRate BPM';
                  }

                  if (temp > 39.0) {
                    alertMessage =
                        'High Temperature: ${temp.toStringAsFixed(1)}°C';
                    severity = 'Critical';
                    color = Colors.red;
                  } else if (temp > 38.5) {
                    alertMessage =
                        'Elevated Temperature: ${temp.toStringAsFixed(1)}°C';
                  }

                  if (alertMessage.isNotEmpty) {
                    recentAlerts.add(AlertItem(
                      key,
                      alertMessage,
                      severity,
                      color,
                      '${Random().nextInt(30) + 1} min ago',
                    ));
                  }
                }
              }
            });
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'System Overview',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildStatusCard(
                        'Total Beds',
                        '$totalBeds',
                        Colors.blue,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatusCard(
                        'Occupied',
                        '$occupiedBeds',
                        Colors.green,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildStatusCard(
                        'Critical Beds',
                        '$criticalPatients',
                        Colors.red,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatusCard(
                        'Available',
                        '${totalBeds - occupiedBeds}',
                        Colors.grey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const Text(
                  'Recent Alerts',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: recentAlerts.isEmpty
                      ? Center(
                          child: Text(
                            'No recent alerts',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        )
                      : ListView.builder(
                          itemCount: recentAlerts.length,
                          itemBuilder: (context, index) {
                            final alert = recentAlerts[index];
                            return _buildAlertTile(
                              alert.patientName,
                              alert.message,
                              alert.color,
                              alert.time,
                            );
                          },
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatusCard(String title, String value, Color color) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAlertTile(String name, String alert, Color color, String time) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color,
          child: const Icon(Icons.warning, color: Colors.white),
        ),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(alert),
        trailing: Text(time, style: const TextStyle(color: Colors.grey)),
      ),
    );
  }
}

class PatientListScreen extends StatefulWidget {
  const PatientListScreen({super.key});

  @override
  _PatientListScreenState createState() => _PatientListScreenState();
}

class _PatientListScreenState extends State<PatientListScreen> {
  final DatabaseReference _patientsRef = FirebaseDatabase.instance.ref();
  final List<HospitalBed> hospitalBeds = List.generate(10, (index) {
    return HospitalBed(
      bedNumber: index + 1,
      patientId: null,
      patientName: null,
      isOccupied: false,
      status: 'Available',
      heartRate: 0,
      temp: 0.0,
      spo2: 0,
      statusColor: Colors.grey[300]!,
    );
  });

  //final _audioPlayer = FlutterSoundPlayer(); // REMOVE flutter_sound
  bool _isAlarmPlaying = false;

  @override
  void initState() {
    super.initState();
    //_initAudioPlayer(); // REMOVE flutter_sound
  }

  /*Future<void> _initAudioPlayer() async { // REMOVE flutter_sound
    await _audioPlayer.openPlayer();
  }*/

  @override
  void dispose() {
    //_audioPlayer.closePlayer(); // REMOVE flutter_sound
    super.dispose();
  }

  /*Future<void> _playAlarm() async { // REMOVE flutter_sound
    if (!_isAlarmPlaying) {
      String alarmSound;
      if (kIsWeb) {
        alarmSound = 'assets/ambulance.mp3'; // Web asset path
      } else {
        alarmSound = 'assets/ambulance.mp3'; // Native asset path
      }

      try {
        await _audioPlayer.startPlayer(
            fromURI: alarmSound,
            codec: Codec.mp3,
            whenFinished: () {
              setState(() {
                _isAlarmPlaying = false;
              });
            });
        setState(() {
          _isAlarmPlaying = true;
        });
      } catch (e) {
        print('Error playing alarm: $e');
      }
    }
  }

  Future<void> _stopAlarm() async { // REMOVE flutter_sound
    if (_isAlarmPlaying) {
      await _audioPlayer.stopPlayer();
      setState(() {
        _isAlarmPlaying = false;
      });
    }
  }*/

  Future<void> _playAlarm() async {
    // ADD audioplayers
    String audioPath = 'assets/ambulance.mp3';
    if (kIsWeb) {
      audioPath = 'assets/ambulance.wav'; // Use WAV for web
    }
    await _player.play(AssetSource(audioPath));
    _isAlarmPlaying = true;
  }

  Future<void> _stopAlarm() async {
    // ADD audioplayers
    await _player.stop();
    _isAlarmPlaying = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hospital Beds (ICU Ward)'),
        automaticallyImplyLeading: false,
      ),
      body: StreamBuilder<DatabaseEvent>(
        stream: _patientsRef.onValue,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // Reset all beds
          for (var bed in hospitalBeds) {
            bed.isOccupied = false;
            bed.patientId = null;
            bed.patientName = null;
            bed.status = 'Available';
            bed.heartRate = 0;
            bed.temp = 0.0;
            bed.spo2 = 0;
            bed.statusColor = Colors.grey[300]!;
          }

          if (snapshot.hasData && snapshot.data?.snapshot.value != null) {
            Map<dynamic, dynamic> data = snapshot.data!.snapshot.value as Map;
            int bedIndex = 0;
            data.forEach((key, value) {
              if (bedIndex < hospitalBeds.length) {
                final valueMap = value as Map?;
                if (valueMap != null) {
                  final status = valueMap['Status']?.toString() ?? 'Unknown';
                  final heartRate = (valueMap['HeartRate'] ?? 0).round();
                  final temp = (valueMap['Temp'] ?? 0).toDouble();
                  final spo2 = (valueMap['SPO2'] ?? 98)
                      .round(); // Add SPO2 from Firebase

                  hospitalBeds[bedIndex].isOccupied = true;
                  hospitalBeds[bedIndex].patientId = key;
                  hospitalBeds[bedIndex].patientName = key;
                  hospitalBeds[bedIndex].status = status;
                  hospitalBeds[bedIndex].heartRate = heartRate;
                  hospitalBeds[bedIndex].temp = temp;
                  hospitalBeds[bedIndex].spo2 = spo2;
                  hospitalBeds[bedIndex].statusColor = _getStatusColor(status);
                  bedIndex++;
                }
              }
            });
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue[200]!),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Intensive Care Unit - Ward A',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[800],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildOccupancyInfo('Total Beds', '10', Colors.blue),
                          _buildOccupancyInfo(
                              'Occupied',
                              '${hospitalBeds.where((bed) => bed.isOccupied).length}',
                              Colors.green),
                          _buildOccupancyInfo(
                              'Available',
                              '${hospitalBeds.where((bed) => !bed.isOccupied).length}',
                              Colors.grey),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.95,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: hospitalBeds.length,
                    itemBuilder: (context, index) {
                      final bed = hospitalBeds[index];
                      return _buildBedCard(bed, context);
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildOccupancyInfo(String label, String count, Color color) {
    return Column(
      children: [
        Text(
          count,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildBedCard(HospitalBed bed, BuildContext context) {
    // Define color variables for vitals
    Color hrColor = Colors.grey[600]!;
    Color tempColor = Colors.grey[600]!;
    Color spo2Color = Colors.grey[600]!;

    // Determine colors based on vital ranges
    if (bed.heartRate < 60 || bed.heartRate > 100) {
      hrColor = (bed.heartRate < 40 || bed.heartRate > 120)
          ? Colors.red
          : Colors.orange;
    } else {
      hrColor = Colors.green;
    }

    if (bed.temp < 36.5 || bed.temp > 37.5) {
      tempColor = (bed.temp < 35 || bed.temp > 39) ? Colors.red : Colors.orange;
    } else {
      tempColor = Colors.green;
    }

    if (bed.spo2 < 95) {
      spo2Color = (bed.spo2 < 90) ? Colors.red : Colors.orange;
    } else {
      spo2Color = Colors.green;
    }

    // Play alarm only if status is critical AND the alarm is not already playing
    if (bed.status.toLowerCase() == 'critical' && !_isAlarmPlaying) {
      _playAlarm();
    }
    // Stop the alarm if the status is no longer critical AND the alarm is playing
    else if (bed.status.toLowerCase() != 'critical' && _isAlarmPlaying) {
      _stopAlarm();
    }

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: bed.isOccupied ? bed.statusColor : Colors.grey[300]!,
          width: 2,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: bed.isOccupied
            ? () {
                final patient = Patient(
                  bed.patientId!,
                  bed.patientName!,
                  bed.heartRate,
                  bed.spo2,
                  bed.temp,
                  bed.status,
                  bed.statusColor,
                );
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PatientDetailScreen(patient: patient),
                  ),
                );
              }
            : null,
        child: Container(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Bed ${bed.bedNumber}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color:
                          bed.isOccupied ? bed.statusColor : Colors.grey[300],
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Icon(
                Icons.bed,
                size: 40,
                color: bed.isOccupied ? bed.statusColor : Colors.grey[400],
              ),
              const SizedBox(height: 8),
              if (bed.isOccupied) ...[
                Text(
                  bed.patientName!,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                RichText(
                  text: TextSpan(
                    style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                    children: [
                      const TextSpan(text: 'HR: '),
                      TextSpan(
                        text: '${bed.heartRate} BPM',
                        style: TextStyle(color: hrColor),
                      ),
                    ],
                  ),
                ),
                RichText(
                  text: TextSpan(
                    style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                    children: [
                      const TextSpan(text: 'Temp: '),
                      TextSpan(
                        text: '${bed.temp}°C',
                        style: TextStyle(color: tempColor),
                      ),
                    ],
                  ),
                ),
                RichText(
                  text: TextSpan(
                    style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                    children: [
                      const TextSpan(text: 'SpO2: '),
                      TextSpan(
                        text: '${bed.spo2}%',
                        style: TextStyle(color: spo2Color),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: bed.statusColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    bed.status,
                    style: TextStyle(
                      fontSize: 10,
                      color: bed.statusColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ] else ...[
                Text(
                  'Available',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[500],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Ready for patient',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[400],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'critical':
        return Colors.red;
      case 'warning':
        return Colors.orange;
      case 'good':
      case 'normal':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}

class HospitalBed {
  final int bedNumber;
  String? patientId;
  String? patientName;
  bool isOccupied;
  String status;
  int heartRate;
  double temp;
  int spo2;
  Color statusColor;

  HospitalBed({
    required this.bedNumber,
    this.patientId,
    this.patientName,
    required this.isOccupied,
    required this.status,
    required this.heartRate,
    required this.temp,
    required this.spo2,
    required this.statusColor,
  });
}

class PatientDetailScreen extends StatefulWidget {
  final Patient? patient;

  const PatientDetailScreen({super.key, this.patient});

  @override
  _PatientDetailScreenState createState() => _PatientDetailScreenState();
}

class _PatientDetailScreenState extends State<PatientDetailScreen> {
  late DatabaseReference _patientRef;
  List<VitalData> heartRateData = [];
  List<VitalData> temperatureData = [];
  List<VitalData> spo2Data = [];
  List<EcgData> ecgData = [];
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    String id = widget.patient?.id ?? 'Patient01';
    _patientRef = FirebaseDatabase.instance.ref().child(id);

    // Initialize sample data
    _initializeSampleData();

    // Start real-time updates
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateChartData();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _initializeSampleData() {
    final now = DateTime.now();
    for (int i = 0; i < 50; i++) {
      final time = now.subtract(Duration(seconds: 50 - i));
      heartRateData.add(VitalData(time, 70 + Random().nextInt(30).toDouble()));
      temperatureData.add(VitalData(time, 36.5 + Random().nextDouble() * 2));
      spo2Data.add(VitalData(time, 95 + Random().nextInt(5).toDouble()));

      // Generate ECG-like waveform
      double ecgValue = _generateEcgValue(i);
      ecgData.add(EcgData(time, ecgValue));
    }
  }

  double _generateEcgValue(int index) {
    // Simple ECG waveform simulation
    double baseValue = 0;
    int cycle = index % 100;

    if (cycle < 10) {
      baseValue = 0.1 * sin(cycle * pi / 5);
    } else if (cycle < 15) {
      baseValue = -0.2;
    } else if (cycle < 20) {
      baseValue = 1.0;
    } else if (cycle < 25) {
      baseValue = -0.5;
    } else if (cycle < 35) {
      baseValue = 0.3;
    } else {
      baseValue = 0.05 * sin(cycle * pi / 10);
    }

    return baseValue + Random().nextDouble() * 0.1 - 0.05;
  }

  void _updateChartData() {
    setState(() {
      final now = DateTime.now();

      // Remove old data and add new data
      if (heartRateData.length >= 50) {
        heartRateData.removeAt(0);
        temperatureData.removeAt(0);
        spo2Data.removeAt(0);
        ecgData.removeAt(0);
      }

      // Add new data points
      heartRateData.add(VitalData(now, 70 + Random().nextInt(30).toDouble()));
      temperatureData.add(VitalData(now, 36.5 + Random().nextDouble() * 2));
      spo2Data.add(VitalData(now, 95 + Random().nextInt(5).toDouble()));
      ecgData.add(EcgData(now, _generateEcgValue(ecgData.length)));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.patient?.name ?? 'Patient Detail'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {},
          ),
        ],
      ),
      body: StreamBuilder<DatabaseEvent>(
        stream: _patientRef.onValue,
        builder: (context, snapshot) {
          int hr = widget.patient?.heartRate ?? 75;
          double temp = widget.patient?.temp ?? 37.0;
          int spo2 = widget.patient?.spo2 ?? 98;
          String status = widget.patient?.status ?? 'Normal';

          if (snapshot.hasData && snapshot.data?.snapshot.value != null) {
            final data = snapshot.data!.snapshot.value as Map;
            hr = (data['HeartRate'] ?? hr).round();
            temp = (data['Temp'] ?? temp).toDouble();
            spo2 = (data['SPO2'] ?? spo2).round();
            status = data['Status'] ?? status;
          }

          final Color statusColor = _getStatusColor(status);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Patient Info Card
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: statusColor,
                          child: Text(
                            widget.patient?.name
                                    .substring(0, 2)
                                    .toUpperCase() ??
                                'PT',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.patient?.name ?? 'Patient',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Patient ID: ${widget.patient?.id ?? 'Unknown'}',
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 4),
                                decoration: BoxDecoration(
                                  color: statusColor,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  status,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Vital Signs Cards
                Row(
                  children: [
                    Expanded(
                      child: _buildVitalCard(
                        'Heart Rate',
                        '$hr',
                        'BPM',
                        Icons.favorite,
                        Colors.red,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildVitalCard(
                        'Temperature',
                        temp.toStringAsFixed(1),
                        '°C',
                        Icons.thermostat,
                        Colors.orange,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildVitalCard(
                        'SpO2',
                        '$spo2',
                        '%',
                        Icons.opacity,
                        Colors.blue,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildVitalCard(
                        'Blood Pressure',
                        '120/80',
                        'mmHg',
                        Icons.monitor_heart,
                        Colors.purple,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Heart Rate Chart
                _buildChartCard(
                  'Heart Rate Trend',
                  heartRateData,
                  Colors.red,
                  'BPM',
                ),
                const SizedBox(height: 16),

                // Temperature Chart
                _buildChartCard(
                  'Temperature Trend',
                  temperatureData,
                  Colors.orange,
                  '°C',
                ),
                const SizedBox(height: 16),

                // SpO2 Chart
                _buildChartCard(
                  'SpO2 Trend',
                  spo2Data,
                  Colors.blue,
                  '%',
                ),
                const SizedBox(height: 16),

                // ECG Chart
                _buildEcgCard(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildVitalCard(
      String title, String value, String unit, IconData icon, Color color) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 4),
            RichText(
              text: TextSpan(
                style: const TextStyle(color: Colors.black),
                children: [
                  TextSpan(
                    text: value,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                  TextSpan(
                    text: ' $unit',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChartCard(
      String title, List<VitalData> data, Color color, String unit) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: CustomPaint(
                size: Size.infinite,
                painter: ChartPainter(data, color, unit),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEcgCard() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.monitor_heart, color: Colors.green),
                SizedBox(width: 8),
                Text(
                  'ECG Waveform',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              height: 150,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(8),
              ),
              child: CustomPaint(
                size: Size.infinite,
                painter: EcgPainter(ecgData),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Live ECG monitoring - Normal sinus rhythm',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'critical':
        return Colors.red;
      case 'warning':
        return Colors.orange;
      case 'good':
      case 'normal':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}

class VitalData {
  final DateTime time;
  final double value;

  VitalData(this.time, this.value);
}

class EcgData {
  final DateTime time;
  final double value;

  EcgData(this.time, this.value);
}

class ChartPainter extends CustomPainter {
  final List<VitalData> data;
  final Color color;
  final String unit;

  ChartPainter(this.data, this.color, this.unit);

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final backgroundPaint = Paint()
      ..color = Colors.grey[200]!
      ..style = PaintingStyle.fill;

    // Draw background
    canvas.drawRect(
        Rect.fromLTWH(0, 0, size.width, size.height), backgroundPaint);

    // Find min and max values
    double minValue = data.map((d) => d.value).reduce((a, b) => a < b ? a : b);
    double maxValue = data.map((d) => d.value).reduce((a, b) => a > b ? a : b);

    if (minValue == maxValue) {
      maxValue = minValue + 1;
    }

    final path = Path();
    bool isFirst = true;

    for (int i = 0; i < data.length; i++) {
      final x = (i / (data.length - 1)) * size.width;
      final y = size.height -
          ((data[i].value - minValue) / (maxValue - minValue)) * size.height;

      if (isFirst) {
        path.moveTo(x, y);
        isFirst = false;
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(path, paint);

    // Draw grid lines
    final gridPaint = Paint()
      ..color = Colors.grey[300]!
      ..strokeWidth = 0.5;

    for (int i = 0; i <= 5; i++) {
      final y = (i / 5) * size.height;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // Draw value labels
    final textPainter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    // Max value label
    textPainter.text = TextSpan(
      text: '${maxValue.toStringAsFixed(1)} $unit',
      style: const TextStyle(
        color: Colors.black54,
        fontSize: 10,
      ),
    );
    textPainter.layout();
    textPainter.paint(canvas, const Offset(5, 5));

    // Min value label
    textPainter.text = TextSpan(
      text: '${minValue.toStringAsFixed(1)} $unit',
      style: const TextStyle(
        color: Colors.black54,
        fontSize: 10,
      ),
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(5, size.height - 15));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class EcgPainter extends CustomPainter {
  final List<EcgData> data;

  EcgPainter(this.data);

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final paint = Paint()
      ..color = Colors.green
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    // Draw grid
    final gridPaint = Paint()
      ..color = Colors.green[900]!.withOpacity(0.3)
      ..strokeWidth = 0.5;

    // Vertical grid lines
    for (int i = 0; i <= 10; i++) {
      final x = (i / 10) * size.width;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }

    // Horizontal grid lines
    for (int i = 0; i <= 6; i++) {
      final y = (i / 6) * size.height;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    final path = Path();
    bool isFirst = true;

    for (int i = 0; i < data.length; i++) {
      final x = (i / (data.length - 1)) * size.width;
      final y = size.height / 2 + (data[i].value * size.height / 4);

      if (isFirst) {
        path.moveTo(x, y);
        isFirst = false;
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class AlertsScreen extends StatelessWidget {
  const AlertsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final DatabaseReference patientsRef = FirebaseDatabase.instance.ref();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Alerts'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.clear_all),
            onPressed: () {},
          ),
        ],
      ),
      body: StreamBuilder<DatabaseEvent>(
        stream: patientsRef.onValue,
        builder: (context, snapshot) {
          List<AlertItem> alerts = [];

          if (snapshot.hasData && snapshot.data?.snapshot.value != null) {
            Map<dynamic, dynamic> data = snapshot.data!.snapshot.value as Map;

            data.forEach((key, value) {
              final valueMap = value as Map?;
              if (valueMap != null) {
                final heartRate = (valueMap['HeartRate'] ?? 0).round();
                final temp = (valueMap['Temp'] ?? 0).toDouble();
                final status = valueMap['Status']?.toString() ?? 'Unknown';

                if (heartRate > 120 ||
                    temp > 38.5 ||
                    status.toLowerCase() == 'critical') {
                  String alertMessage = '';
                  String severity = 'Warning';
                  Color color = Colors.orange;

                  if (status.toLowerCase() == 'critical') {
                    alertMessage = 'Patient in critical condition';
                    severity = 'Critical';
                    color = Colors.red;
                  } else if (heartRate > 140) {
                    alertMessage = 'Critical Heart Rate: $heartRate BPM';
                    severity = 'Critical';
                    color = Colors.red;
                  } else if (heartRate > 120) {
                    alertMessage = 'High Heart Rate: $heartRate BPM';
                  } else if (temp > 39.0) {
                    alertMessage =
                        'High Temperature: ${temp.toStringAsFixed(1)}°C';
                    severity = 'Critical';
                    color = Colors.red;
                  } else if (temp > 38.5) {
                    alertMessage =
                        'Elevated Temperature: ${temp.toStringAsFixed(1)}°C';
                  }

                  alerts.add(AlertItem(
                    key,
                    alertMessage,
                    severity,
                    color,
                    '${Random().nextInt(30) + 1} min ago',
                  ));
                }
              }
            });
          }

          return alerts.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.check_circle,
                        size: 64,
                        color: Colors.green,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'No Active Alerts',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'All patients are stable',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: alerts.length,
                  itemBuilder: (context, index) {
                    final alert = alerts[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 4),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: alert.color,
                          child: const Icon(Icons.warning, color: Colors.white),
                        ),
                        title: Text(
                          alert.patientName,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(alert.message),
                            Text(
                              alert.time,
                              style: const TextStyle(
                                  color: Colors.grey, fontSize: 12),
                            ),
                          ],
                        ),
                        trailing: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: alert.color,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            alert.severity,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 12),
                          ),
                        ),
                      ),
                    );
                  },
                );
        },
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Profile'), automaticallyImplyLeading: false),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.blue[800],
              child: const Text(
                'DR',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Dr. Healthcare Professional',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text('Senior Physician', style: TextStyle(color: Colors.grey[600])),
            const SizedBox(height: 32),
            _buildProfileOption(Icons.person, 'Personal Information'),
            _buildProfileOption(Icons.notifications, 'Notification Settings'),
            _buildProfileOption(Icons.security, 'Security'),
            _buildProfileOption(Icons.help, 'Help & Support'),
            _buildProfileOption(Icons.info, 'About'),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/login');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Logout'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileOption(IconData icon, String title) {
    return Card(
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {},
      ),
    );
  }
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class Patient {
  final String id;
  final String name;
  final int heartRate;
  final int spo2;
  final double temp;
  final String status;
  final Color statusColor;

  Patient(
    this.id,
    this.name,
    this.heartRate,
    this.spo2,
    this.temp,
    this.status,
    this.statusColor,
  );
}

class AlertItem {
  final String patientName;
  final String message;
  final String severity;
  final Color color;
  final String time;

  AlertItem(
    this.patientName,
    this.message,
    this.severity,
    this.color,
    this.time,
  );
}
