import 'package:flutter/material.dart';
import '../../models/doctor_model.dart';
import '../../services/doctor_service.dart';

class ClinicalSupportScreen extends StatefulWidget {
  const ClinicalSupportScreen({super.key});

  @override
  State<ClinicalSupportScreen> createState() => _ClinicalSupportScreenState();
}

class _ClinicalSupportScreenState extends State<ClinicalSupportScreen> {
  final DoctorService _doctorService = DoctorService();

  List<DoctorModel> _doctors = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadDoctors();
  }

  Future<void> _loadDoctors() async {
    try {
      final doctors = await _doctorService.getDoctors();

      if (mounted) {
        setState(() {
          _doctors = doctors;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Failed to load doctors';
          _isLoading = false;
        });
      }
    }
  }

  void _showDoctorDetails(DoctorModel doctor) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: doctor.photoUrl.isNotEmpty
                        ? Image.network(
                            doctor.photoUrl,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: 100,
                                height: 100,
                                color: Colors.grey.shade300,
                                child: const Icon(Icons.person, size: 50),
                              );
                            },
                          )
                        : Container(
                            width: 100,
                            height: 100,
                            color: Colors.grey.shade300,
                            child: const Icon(Icons.person, size: 50),
                          ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    doctor.name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    doctor.role,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 15,
                      color: Color(0xFF2F7CF6),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 18),
                      const SizedBox(width: 4),
                      Text(
                        doctor.rating.toString(),
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  _detailRow(
                    icon: Icons.psychology,
                    title: 'Specialized Area',
                    value: doctor.specializedArea,
                  ),
                  const SizedBox(height: 14),
                  _detailRow(
                    icon: Icons.phone,
                    title: 'Contact Number',
                    value: doctor.contactNumber,
                  ),
                  const SizedBox(height: 14),
                  _detailRow(
                    icon: Icons.email,
                    title: 'Email',
                    value: doctor.email,
                  ),

                  const SizedBox(height: 22),
                  SizedBox(
                    width: double.infinity,
                    height: 46,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2F7CF6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Close',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _detailRow({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF6F8FC),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFF2F7CF6), size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black54,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value.isEmpty ? '-' : value,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  const Icon(Icons.menu, color: Color(0xFF4A6CF7)),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Text(
                      'Clinical Support',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: Colors.teal.shade100,
                    child: const Icon(Icons.person, color: Colors.teal),
                  ),
                ],
              ),
            ),
            Expanded(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF2F7CF6),
                      ),
                    )
                  : _errorMessage.isNotEmpty
                      ? Center(
                          child: Text(
                            _errorMessage,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.red,
                            ),
                          ),
                        )
                      : SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 8),
                              const Text(
                                'VERIFIED PROFESSIONALS',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF5D8CFF),
                                  letterSpacing: 0.7,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Find your specialist',
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Connect with world-class clinical support tailored to your cognitive wellness journey.',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black54,
                                  height: 1.4,
                                ),
                              ),
                              const SizedBox(height: 20),

                              ..._doctors.map((doctor) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 14),
                                  child: _buildDoctorCard(doctor),
                                );
                              }),

                              const SizedBox(height: 10),

                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 24,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEFF4FF),
                                  borderRadius: BorderRadius.circular(18),
                                  border: Border.all(
                                    color: const Color(0xFFD5E4FF),
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    const CircleAvatar(
                                      radius: 22,
                                      backgroundColor: Color(0xFFDCE8FF),
                                      child: Icon(
                                        Icons.support_agent,
                                        color: Color(0xFF2F7CF6),
                                        size: 24,
                                      ),
                                    ),
                                    const SizedBox(height: 14),
                                    const Text(
                                      'Need immediate assistance?',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFF2458C6),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    const Text(
                                      'Our emergency clinical hotline is available 24/7 for Mind Guard Premium members.',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.black54,
                                        height: 1.5,
                                      ),
                                    ),
                                    const SizedBox(height: 18),
                                    SizedBox(
                                      width: 180,
                                      height: 44,
                                      child: ElevatedButton(
                                        onPressed: () {},
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              const Color(0xFF2F7CF6),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(24),
                                          ),
                                          elevation: 0,
                                        ),
                                        child: const Text(
                                          'CONTACT HOTLINE',
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 100),
                            ],
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDoctorCard(DoctorModel doctor) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: doctor.photoUrl.isNotEmpty
                ? Image.network(
                    doctor.photoUrl,
                    width: 58,
                    height: 58,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 58,
                        height: 58,
                        color: Colors.grey.shade300,
                        child: const Icon(Icons.person, size: 30),
                      );
                    },
                  )
                : Container(
                    width: 58,
                    height: 58,
                    color: Colors.grey.shade300,
                    child: const Icon(Icons.person, size: 30),
                  ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  doctor.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  doctor.role,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF2F7CF6),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        doctor.tag,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF5D8CFF),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.star, size: 14, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      doctor.rating.toString(),
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => _showDoctorDetails(doctor),
            icon: const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Color(0xFF2F7CF6),
            ),
          ),
        ],
      ),
    );
  }
}