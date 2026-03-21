import 'package:flutter/material.dart';
import '../onboarding/profile_setup_screen.dart';

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({super.key});

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;
  bool _resendPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _scaleAnim = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleResend() {
    setState(() => _resendPressed = true);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Verification link resent!'),
        backgroundColor: Color(0xFF22C55E),
      ),
    );
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) setState(() => _resendPressed = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFF6FF),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
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
                        'Email Verification',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 48), // balance the back button
                ],
              ),

              const Spacer(),

              // Animated envelope icon
              ScaleTransition(
                scale: _scaleAnim,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 110,
                      height: 110,
                      decoration: const BoxDecoration(
                        color: Color(0xFFDCF5EC),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.mark_email_read_outlined,
                        size: 54,
                        color: Color(0xFF2563EB),
                      ),
                    ),
                    // Green check badge
                    Positioned(
                      top: -4,
                      right: -4,
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: const BoxDecoration(
                          color: Color(0xFF22C55E),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 36),

              // Title
              const Text(
                'Verify Your Email',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),

              const SizedBox(height: 14),

              // Description
              const Text(
                "We've sent a verification link to your email address. Please check your inbox and click the link to continue your journey to wellness.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: Color(0xFF64748B),
                  height: 1.6,
                ),
              ),

              const SizedBox(height: 40),

              // Resend button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _resendPressed ? null : _handleResend,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2563EB),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Text(
                    _resendPressed ? 'Link Sent!' : 'Resend Verification Link',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Continue button (for demo — skips email check)
              SizedBox(
                width: double.infinity,
                height: 56,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ProfileSetupScreen(),
                      ),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    side: const BorderSide(color: Color(0xFF2563EB)),
                  ),
                  child: const Text(
                    'Continue to Setup →',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2563EB),
                    ),
                  ),
                ),
              ),

              const Spacer(),

              // Bottom links
              TextButton(
                onPressed: () {},
                child: const Text(
                  'Wrong email address? Change email',
                  style: TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 13,
                  ),
                ),
              ),

              TextButton.icon(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const Scaffold(
                        body: Center(child: Text('Login')),
                      ),
                    ),
                    (route) => false,
                  );
                },
                icon: const Icon(
                  Icons.logout,
                  size: 16,
                  color: Color(0xFF64748B),
                ),
                label: const Text(
                  'Back to Login',
                  style: TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 13,
                  ),
                ),
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
