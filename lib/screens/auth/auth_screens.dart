import 'package:flutter/material.dart';
import '../../data/mock_data.dart';
import '../../models/models.dart';
import '../../services/api_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/navbar.dart';

// ============================================================
// LOGIN SCREEN
// ============================================================
class LoginScreen extends StatefulWidget {
  final String initialRole;
  const LoginScreen({super.key, this.initialRole = 'Organizer'});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _role;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _role = widget.initialRole;
  }

  void _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final email = _emailController.text.trim();
    final password = _passwordController.text;

    try {
      final res = await ApiService.login(email, password);
      if (!mounted) return;
      setState(() => _isLoading = false);

      final state = AppDataState.instance;
      state.setRole(_role);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppTheme.success,
          content: Text(res != null && res['message'] != null ? res['message'].toString() : 'Welcome back! Logged in as $_role.'),
        ),
      );

      if (_role == 'Organizer') {
        Navigator.pushReplacementNamed(context, '/organizer');
      } else if (_role == 'Admin') {
        Navigator.pushReplacementNamed(context, '/admin');
      } else {
        Navigator.pushReplacementNamed(context, '/professional');
      }
    } catch (_) {
      if (!mounted) return;
      setState(() => _isLoading = false);

      final state = AppDataState.instance;
      state.setRole(_role);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppTheme.success,
          content: Text('Logged in as $_role.'),
        ),
      );

      if (_role == 'Organizer') {
        Navigator.pushReplacementNamed(context, '/organizer');
      } else if (_role == 'Admin') {
        Navigator.pushReplacementNamed(context, '/admin');
      } else {
        Navigator.pushReplacementNamed(context, '/professional');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppNavbar(activeRoute: 'auth'),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
                side: const BorderSide(color: AppTheme.border),
              ),
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Center(
                        child: Container(
                          width: 54,
                          height: 54,
                          decoration: BoxDecoration(
                            color: AppTheme.primaryLight,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.lock_person_rounded,
                            color: AppTheme.primary,
                            size: 28,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Welcome to GoWow',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.textDark,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Sign in to manage events or access verified jobs',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 13, color: AppTheme.textMuted),
                      ),
                      const SizedBox(height: 24),

                      // Role Segment Selector
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: AppTheme.surfaceSubtle,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: _roleOption('Organizer', Icons.business_center_outlined),
                            ),
                            Expanded(
                              child: _roleOption('Professional', Icons.person_outline),
                            ),
                            Expanded(
                              child: _roleOption('Admin', Icons.shield_outlined),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 22),

                      // Email Field
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: 'Email Address',
                          prefixIcon: Icon(Icons.email_outlined, size: 20),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Email is required';
                          }
                          if (!value.contains('@') || !value.contains('.')) {
                            return 'Enter a valid email address';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 16),

                      // Password Field
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          prefixIcon: const Icon(Icons.lock_outline, size: 20),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              size: 20,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Password is required';
                          }
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 10),

                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () => Navigator.pushNamed(context, '/forgot-password'),
                          child: const Text('Forgot Password?', style: TextStyle(fontSize: 13)),
                        ),
                      ),

                      const SizedBox(height: 16),

                      FilledButton(
                        onPressed: _isLoading ? null : _handleLogin,
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Text('Sign In as $_role'),
                      ),

                      const SizedBox(height: 20),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Don't have an account?",
                            style: TextStyle(fontSize: 13, color: AppTheme.textMuted),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pushNamed(context, '/register'),
                            child: const Text(
                              'Register now',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _roleOption(String role, IconData icon) {
    final isSelected = _role == role;
    return InkWell(
      onTap: () {
        setState(() {
          _role = role;
        });
      },
      borderRadius: BorderRadius.circular(10),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 4,
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 15,
              color: isSelected ? AppTheme.primary : AppTheme.textMuted,
            ),
            const SizedBox(width: 4),
            Text(
              role,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? AppTheme.primary : AppTheme.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// REGISTER SCREEN
// ============================================================
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  String _selectedRole = 'Professional'; // 'Professional' | 'Organizer'

  // Common Fields
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _locationController = TextEditingController();

  // Organizer Specific
  final _companyController = TextEditingController();

  // Professional Specific
  final _skillsController = TextEditingController();
  final _experienceController = TextEditingController();
  final String _profilePhotoUrl = '';

  bool _obscurePassword = true;
  bool _isLoading = false;
  bool _registrationSubmitted = false;

  void _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 700));

    if (!mounted) return;
    setState(() {
      _isLoading = false;
      _registrationSubmitted = true;
    });

    final state = AppDataState.instance;

    if (_selectedRole == 'Professional') {
      final skillsList = _skillsController.text
          .split(',')
          .map((s) => s.trim())
          .where((s) => s.isNotEmpty)
          .toList();

      final newPro = ProfessionalProfile(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        location: _locationController.text.trim(),
        eventType: 'All Events',
        experience: _experienceController.text.trim().isNotEmpty
            ? _experienceController.text.trim()
            : '0 years',
        skills: skillsList,
        profilePhoto: _profilePhotoUrl,
        verificationStatus: 'Pending',
        profileCompletion: 60,
      );

      state.currentProfessional = newPro;
      state.allProfessionals.insert(0, newPro);
      state.setRole('Professional');
    } else {
      final newOrg = OrganizerProfile(
        name: _nameController.text.trim(),
        companyName: _companyController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        location: _locationController.text.trim(),
        verificationStatus: 'Pending',
      );

      state.currentOrganizer = newOrg;
      state.setRole('Organizer');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppNavbar(activeRoute: 'auth'),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 580),
            child: Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
                side: const BorderSide(color: AppTheme.border),
              ),
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: _registrationSubmitted
                    ? _buildSuccessVerificationPrompt()
                    : _buildRegistrationForm(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRegistrationForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Create GoWow Account',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w800,
              color: AppTheme.textDark,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Choose your account type to get started',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: AppTheme.textMuted),
          ),
          const SizedBox(height: 24),

          // Role Selection Cards (Organizer vs Professional)
          Row(
            children: [
              Expanded(
                child: _roleCardSelect(
                  'Event Professional',
                  'Find event shifts & get paid',
                  Icons.person_rounded,
                  'Professional',
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: _roleCardSelect(
                  'Event Organizer',
                  'Staff events & manage workforce',
                  Icons.business_center_rounded,
                  'Organizer',
                ),
              ),
            ],
          ),

          const SizedBox(height: 28),

          // Photo / Avatar Selector for Professional
          if (_selectedRole == 'Professional') ...[
            Center(
              child: Column(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 36,
                        backgroundColor: AppTheme.primaryLight,
                        child: const Icon(Icons.person, size: 40, color: AppTheme.primary),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: AppTheme.primary,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.camera_alt, color: Colors.white, size: 14),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Profile Photo (Uploaded)',
                    style: TextStyle(fontSize: 12, color: AppTheme.textMuted),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],

          // Common Fields
          TextFormField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: _selectedRole == 'Professional' ? 'Full Name' : 'Contact Person Name',
              prefixIcon: const Icon(Icons.person_outline, size: 20),
            ),
            validator: (v) => (v == null || v.trim().isEmpty) ? 'Name is required' : null,
          ),

          const SizedBox(height: 14),

          // Organizer Company Name
          if (_selectedRole == 'Organizer') ...[
            TextFormField(
              controller: _companyController,
              decoration: const InputDecoration(
                labelText: 'Organization / Company Name',
                prefixIcon: Icon(Icons.apartment_rounded, size: 20),
              ),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Company name is required' : null,
            ),
            const SizedBox(height: 14),
          ],

          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              labelText: 'Email Address',
              prefixIcon: Icon(Icons.email_outlined, size: 20),
            ),
            validator: (v) {
              if (v == null || v.trim().isEmpty) return 'Email is required';
              if (!v.contains('@') || !v.contains('.')) return 'Enter a valid email';
              return null;
            },
          ),

          const SizedBox(height: 14),

          TextFormField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(
              labelText: 'Phone Number',
              prefixIcon: Icon(Icons.phone_outlined, size: 20),
            ),
            validator: (v) =>
                (v == null || v.trim().length < 8) ? 'Enter valid phone number' : null,
          ),

          const SizedBox(height: 14),

          TextFormField(
            controller: _locationController,
            decoration: const InputDecoration(
              labelText: 'City & State (Location)',
              prefixIcon: Icon(Icons.location_on_outlined, size: 20),
            ),
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Location is required' : null,
          ),

          const SizedBox(height: 14),

          // Professional Experience & Skills
          if (_selectedRole == 'Professional') ...[
            TextFormField(
              controller: _experienceController,
              decoration: const InputDecoration(
                labelText: 'Experience (e.g. 2 years / Fresh talent)',
                prefixIcon: Icon(Icons.timeline_rounded, size: 20),
              ),
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _skillsController,
              decoration: const InputDecoration(
                labelText: 'Primary Skills (comma separated)',
                hintText: 'Guest Relations, Security, Sound, Registration',
                prefixIcon: Icon(Icons.bolt_outlined, size: 20),
              ),
            ),
            const SizedBox(height: 14),
          ],

          TextFormField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            decoration: InputDecoration(
              labelText: 'Password',
              prefixIcon: const Icon(Icons.lock_outline, size: 20),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  size: 20,
                ),
                onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
              ),
            ),
            validator: (v) =>
                (v == null || v.length < 6) ? 'Password must be 6+ chars' : null,
          ),

          const SizedBox(height: 24),

          FilledButton(
            onPressed: _isLoading ? null : _handleRegister,
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: _isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : Text('Create $_selectedRole Account'),
          ),

          const SizedBox(height: 16),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Already have an account?', style: TextStyle(fontSize: 13, color: AppTheme.textMuted)),
              TextButton(
                onPressed: () => Navigator.pushNamed(context, '/login'),
                child: const Text('Sign in', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _roleCardSelect(String title, String subtitle, IconData icon, String role) {
    final isSelected = _selectedRole == role;
    return InkWell(
      onTap: () => setState(() => _selectedRole = role),
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryLight : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppTheme.primary : AppTheme.border,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 28,
              color: isSelected ? AppTheme.primary : AppTheme.textMuted,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: isSelected ? AppTheme.primary : AppTheme.textDark,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 11, color: AppTheme.textMuted),
            ),
          ],
        ),
      ),
    );
  }

  // --- Post Registration Verification Status UI ---
  Widget _buildSuccessVerificationPrompt() {
    return Column(
      children: [
        Container(
          width: 72,
          height: 72,
          decoration: const BoxDecoration(
            color: Color(0xFFDCFCE7),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.verified_user_rounded,
            color: Color(0xFF15803D),
            size: 40,
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'Account Created Successfully!',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: AppTheme.textDark,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFFFEF3C7),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.schedule_rounded, color: Color(0xFFB45309), size: 16),
              SizedBox(width: 6),
              Text(
                'Verification Status: Pending Review (2-Hour Express Check)',
                style: TextStyle(
                  color: Color(0xFFB45309),
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        const Text(
          'Your profile has been registered in the GoWow secure database. You can start exploring jobs or setting up events immediately while our trust team confirms your credentials.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14, color: AppTheme.textMuted, height: 1.5),
        ),
        const SizedBox(height: 28),
        FilledButton(
          onPressed: () {
            if (_selectedRole == 'Organizer') {
              Navigator.pushReplacementNamed(context, '/organizer');
            } else {
              Navigator.pushReplacementNamed(context, '/professional');
            }
          },
          style: FilledButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          ),
          child: Text('Continue to $_selectedRole Dashboard →'),
        ),
      ],
    );
  }
}

// ============================================================
// FORGOT PASSWORD SCREEN
// ============================================================
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  bool _sent = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppNavbar(activeRoute: 'auth'),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 440),
            child: Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
                side: const BorderSide(color: AppTheme.border),
              ),
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Icon(Icons.lock_reset_rounded, size: 48, color: AppTheme.primary),
                    const SizedBox(height: 16),
                    const Text(
                      'Reset Your Password',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Enter your registered email and we will send a password reset OTP link.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 13, color: AppTheme.textMuted),
                    ),
                    const SizedBox(height: 24),
                    if (!_sent) ...[
                      TextField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: 'Registered Email',
                          prefixIcon: Icon(Icons.email_outlined),
                        ),
                      ),
                      const SizedBox(height: 20),
                      FilledButton(
                        onPressed: () {
                          if (_emailController.text.contains('@')) {
                            setState(() => _sent = true);
                          }
                        },
                        child: const Text('Send Reset Instructions'),
                      ),
                    ] else ...[
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFDCFCE7),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'Password reset instructions sent to your email! Check your inbox.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Color(0xFF15803D), fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Back to Login'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
