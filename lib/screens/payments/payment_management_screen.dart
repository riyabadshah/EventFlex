import 'package:flutter/material.dart';
import '../../data/mock_data.dart';
import '../../models/models.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/navbar.dart';

class PaymentManagementScreen extends StatefulWidget {
  const PaymentManagementScreen({super.key});

  @override
  State<PaymentManagementScreen> createState() =>
      _PaymentManagementScreenState();
}

class _PaymentManagementScreenState extends State<PaymentManagementScreen> {
  late String _viewMode; // 'Organizer' or 'Professional'

  @override
  void initState() {
    super.initState();
    _viewMode = AppDataState.instance.currentRole == 'Professional'
        ? 'Professional'
        : 'Organizer';
  }

  @override
  Widget build(BuildContext context) {
    final state = AppDataState.instance;
    final isDesktop = Responsive.isDesktop(context);

    return ListenableBuilder(
      listenable: state,
      builder: (context, _) {
        final payments = state.payments;

        // Statistics
        final totalEarned = payments
            .where((p) => p.status == 'Paid')
            .fold<double>(0, (sum, p) => sum + p.amount);

        final pendingTotal = payments
            .where((p) => p.status == 'Pending' || p.status == 'Processing')
            .fold<double>(0, (sum, p) => sum + p.amount);

        final completedCount =
            payments.where((p) => p.status == 'Paid').length;

        return Scaffold(
          appBar: const AppNavbar(activeRoute: 'payments'),
          endDrawer: const AppDrawer(),
          body: SingleChildScrollView(
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: Responsive.contentMaxWidth(context)),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isDesktop ? 40 : 16,
                    vertical: 36,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'Payment & Escrow Hub',
                                style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.w900,
                                  color: AppTheme.textDark,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Transparent milestone payouts with bank-grade security and instant bank transfers.',
                                style: TextStyle(fontSize: 13, color: AppTheme.textMuted),
                              ),
                            ],
                          ),
                          // View Switcher (Organizer vs Professional)
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: AppTheme.surfaceSubtle,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                _modeBtn('Organizer View', 'Organizer'),
                                _modeBtn('Professional View', 'Professional'),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 28),

                      // Summary Stat Cards
                      _viewMode == 'Professional'
                          ? _buildProfessionalStats(totalEarned, pendingTotal, completedCount)
                          : _buildOrganizerStats(totalEarned, pendingTotal, completedCount),

                      const SizedBox(height: 28),

                      // Escrow Guarantee Banner
                      _buildEscrowSecurityBanner(context),

                      const SizedBox(height: 28),

                      // Transaction History Table / Cards
                      Text(
                        _viewMode == 'Professional'
                            ? 'Earnings & Payout Transactions'
                            : 'Workforce Disbursements & Escrow Ledger',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.textDark,
                        ),
                      ),
                      const SizedBox(height: 14),

                      if (payments.isEmpty)
                        const EmptyStateWidget(
                          title: 'No Transactions Yet',
                          subtitle: 'All disbursements and earnings will be recorded transparently here.',
                        )
                      else
                        ...payments.map((p) => _buildTransactionCard(context, p)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _modeBtn(String label, String mode) {
    final isSelected = _viewMode == mode;
    return InkWell(
      onTap: () => setState(() => _viewMode = mode),
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
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
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected ? AppTheme.primary : AppTheme.textMuted,
          ),
        ),
      ),
    );
  }

  Widget _buildProfessionalStats(double totalEarned, double pendingTotal, int count) {
    return Row(
      children: [
        Expanded(
          child: StatCard(
            title: 'Total Earnings',
            value: '₹${totalEarned.toStringAsFixed(0)}',
            subtitle: 'Deposited to verified account',
            icon: Icons.account_balance_wallet_rounded,
            iconColor: AppTheme.success,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: StatCard(
            title: 'Pending / In-Escrow',
            value: '₹${pendingTotal.toStringAsFixed(0)}',
            subtitle: 'Awaiting shift sign-off',
            icon: Icons.hourglass_top_rounded,
            iconColor: AppTheme.accent,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: StatCard(
            title: 'Completed Payouts',
            value: '$count Paid',
            subtitle: '100% On-time guarantee',
            icon: Icons.verified_rounded,
            iconColor: AppTheme.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildOrganizerStats(double totalSpent, double pendingEscrow, int count) {
    return Row(
      children: [
        Expanded(
          child: StatCard(
            title: 'Total Workforce Cost',
            value: '₹${(totalSpent + pendingEscrow).toStringAsFixed(0)}',
            subtitle: 'Allocated across events',
            icon: Icons.payments_rounded,
            iconColor: AppTheme.primary,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: StatCard(
            title: 'Pending Escrow Releases',
            value: '₹${pendingEscrow.toStringAsFixed(0)}',
            subtitle: 'Under attendance sign-off',
            icon: Icons.security_rounded,
            iconColor: AppTheme.accent,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: StatCard(
            title: 'Disbursed to Staff',
            value: '₹${totalSpent.toStringAsFixed(0)}',
            subtitle: '$count Staff payouts settled',
            icon: Icons.check_circle_rounded,
            iconColor: AppTheme.success,
          ),
        ),
      ],
    );
  }

  Widget _buildEscrowSecurityBanner(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF0FDF4),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFBBF7D0)),
      ),
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              color: Color(0xFFDCFCE7),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.shield_rounded, color: Color(0xFF15803D), size: 24),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'GoWow Escrow Protection Guarantee',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF14532D),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Funds are safely held until shift attendance is validated. Organizers are protected from no-shows, while professionals receive guaranteed payouts within 24 hours of event completion.',
                  style: TextStyle(fontSize: 12, color: Color(0xFF166534), height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionCard(BuildContext context, PaymentRecord record) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: const BorderSide(color: AppTheme.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: record.status == 'Paid' ? const Color(0xFFDCFCE7) : AppTheme.surfaceSubtle,
                shape: BoxShape.circle,
              ),
              child: Icon(
                record.status == 'Paid' ? Icons.check_circle_outline : Icons.schedule,
                color: record.status == 'Paid' ? const Color(0xFF15803D) : AppTheme.textMuted,
                size: 22,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    record.eventName,
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${record.role} • ${record.professionalName}',
                    style: const TextStyle(fontSize: 13, color: AppTheme.primaryDark),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Txn: ${record.transactionId} • ${record.date} • ${record.paymentMethod}',
                    style: const TextStyle(fontSize: 11, color: AppTheme.textMuted),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '₹${record.amount.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: AppTheme.textDark,
                  ),
                ),
                const SizedBox(height: 4),
                StatusBadge(status: record.status, isSmall: true),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
