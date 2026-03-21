import 'package:flutter/material.dart';
import '../home/home_screen.dart';
import '../../services/auth_service.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _occupationController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _occupationController.dispose();
    super.dispose();
  }

  void _handleSave() async {
    if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your name')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await AuthService().saveProfile(
        name: _nameController.text.trim(),
        age: int.tryParse(_ageController.text.trim()) ?? 0,
        occupation: _occupationController.text.trim(),
      );

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFF6FF),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),

              // Top bar
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        'Complete Your Profile',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),

              const SizedBox(height: 24),

              // Progress bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Profile Completion',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  Text(
                    'Step 2 of 8',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: 2 / 8,
                  minHeight: 8,
                  backgroundColor: const Color(0xFFE2E8F0),
                  valueColor: const AlwaysStoppedAnimation(Color(0xFF2563EB)),
                ),
              ),

              const SizedBox(height: 32),

              // Title
              const Text(
                'Tell us about yourself',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'To provide the best mental wellness insights, we need a few basic details to get started.',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF64748B),
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 32),

              // Full Name
              _buildLabel('Full Name'),
              const SizedBox(height: 8),
              TextField(
                controller: _nameController,
                decoration: _inputDecoration('John Doe', Icons.person_outline),
              ),

              const SizedBox(height: 20),

              // Age
              _buildLabel('Age'),
              const SizedBox(height: 8),
              TextField(
                controller: _ageController,
                keyboardType: TextInputType.number,
                decoration: _inputDecoration('25', Icons.cake_outlined),
              ),

              const SizedBox(height: 20),

              // Occupation
              _buildLabel('Occupation'),
              const SizedBox(height: 8),
              TextField(
                controller: _occupationController,
                decoration: _inputDecoration(
                  'e.g. Software Engineer',
                  Icons.work_outline,
                ),
              ),

              const SizedBox(height: 40),

              // Save Profile button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleSave,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2563EB),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.5,
                          ),
                        )
                      : const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Save Profile',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(Icons.arrow_forward,
                                color: Colors.white, size: 18),
                          ],
                        ),
                ),
              ),

              const SizedBox(height: 16),
              const Center(
                child: Text(
                  'Step 2 of 8: Basic Information',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF94A3B8),
                  ),
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Color(0xFF0F172A),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, color: const Color(0xFF94A3B8)),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF2563EB), width: 1.5),
      ),
    );
  }
}
