import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_card.dart';

class UserTypeSelectionPage extends StatefulWidget {
  const UserTypeSelectionPage({super.key});

  @override
  State<UserTypeSelectionPage> createState() => _UserTypeSelectionPageState();
}

class _UserTypeSelectionPageState extends State<UserTypeSelectionPage>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  String? _selectedUserType;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  _buildHeader(),
                  const SizedBox(height: 60),
                  Expanded(
                    child: _buildUserTypeCards(),
                  ),
                  const SizedBox(height: 40),
                  _buildContinueButton(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppTheme.primaryColor,
                AppTheme.primaryColor.withOpacity(0.8),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(50),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primaryColor.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: const Icon(
            Icons.person_outline,
            size: 50,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Pilih Jenis Akun',
          style: AppTheme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppTheme.textColor,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Silakan pilih jenis akun yang sesuai dengan kebutuhan Anda',
          style: AppTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.textColor.withOpacity(0.7),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildUserTypeCards() {
    return Column(
      children: [
        _buildUserTypeCard(
          type: 'customer',
          title: 'Pelanggan',
          subtitle: 'Saya ingin memperbaiki perangkat elektronik',
          icon: Icons.smartphone,
          features: [
            'Booking layanan perbaikan',
            'Tracking status perbaikan',
            'Chat dengan teknisi',
            'Riwayat perbaikan',
          ],
        ),
        const SizedBox(height: 20),
        _buildUserTypeCard(
          type: 'technician',
          title: 'Teknisi',
          subtitle: 'Saya adalah teknisi yang ingin menawarkan layanan',
          icon: Icons.build,
          features: [
            'Terima permintaan perbaikan',
            'Kelola jadwal kerja',
            'Chat dengan pelanggan',
            'Laporan pendapatan',
          ],
        ),
      ],
    );
  }

  Widget _buildUserTypeCard({
    required String type,
    required String title,
    required String subtitle,
    required IconData icon,
    required List<String> features,
  }) {
    final isSelected = _selectedUserType == type;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedUserType = type;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        child: CustomCard(
          padding: EdgeInsets.zero,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected
                    ? AppTheme.primaryColor
                    : Colors.grey.withOpacity(0.2),
                width: isSelected ? 2 : 1,
              ),
              gradient: isSelected
                  ? LinearGradient(
                      colors: [
                        AppTheme.primaryColor.withOpacity(0.05),
                        AppTheme.primaryColor.withOpacity(0.02),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : null,
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppTheme.primaryColor
                              : Colors.grey.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Icon(
                          icon,
                          size: 30,
                          color: isSelected ? Colors.white : Colors.grey,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: AppTheme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: isSelected
                                    ? AppTheme.primaryColor
                                    : AppTheme.textColor,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              subtitle,
                              style: AppTheme.textTheme.bodyMedium?.copyWith(
                                color: AppTheme.textColor.withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (isSelected)
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.check,
                            size: 16,
                            color: Colors.white,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Fitur yang tersedia:',
                    style: AppTheme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textColor.withOpacity(0.8),
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...features.map((feature) => Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Row(
                          children: [
                            Icon(
                              Icons.check_circle,
                              size: 16,
                              color: isSelected
                                  ? AppTheme.primaryColor
                                  : Colors.grey,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              feature,
                              style: AppTheme.textTheme.bodySmall?.copyWith(
                                color: AppTheme.textColor.withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                      )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContinueButton() {
    return CustomButton(
      text: 'Lanjutkan',
      onPressed: _selectedUserType != null ? _handleContinue : null,
      width: double.infinity,
    );
  }

  void _handleContinue() {
    if (_selectedUserType == null) return;

    // Navigate based on user type
    if (_selectedUserType == 'customer') {
      context.go('/dashboard');
    } else if (_selectedUserType == 'technician') {
      context.go('/technician/dashboard');
    }
  }
}