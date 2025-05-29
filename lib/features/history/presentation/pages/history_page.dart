import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/models/repair_model.dart';
import '../../../../core/services/firebase_service.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/app_router.dart';

// Providers
final repairHistoryProvider = FutureProvider<List<RepairModel>>((ref) async {
  final userId = FirebaseService.currentUserId;
  if (userId == null) return [];
  return FirebaseService.getUserRepairs(userId);
});

final selectedStatusProvider = StateProvider<RepairStatus?>((ref) => null);

final filteredRepairsProvider = Provider<AsyncValue<List<RepairModel>>>((ref) {
  final repairsAsync = ref.watch(repairHistoryProvider);
  final selectedStatus = ref.watch(selectedStatusProvider);

  return repairsAsync.when(
    data: (repairs) {
      if (selectedStatus == null) {
        return AsyncValue.data(repairs);
      }
      final filtered = repairs.where((repair) => repair.status == selectedStatus).toList();
      return AsyncValue.data(filtered);
    },
    loading: () => const AsyncValue.loading(),
    error: AsyncValue.error,
  );
});

class HistoryPage extends ConsumerWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filteredRepairsAsync = ref.watch(filteredRepairsProvider);
    final selectedStatus = ref.watch(selectedStatusProvider);

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(repairHistoryProvider);
          },
          child: CustomScrollView(
            slivers: [
              // App Bar
              SliverAppBar(
                expandedHeight: 120,
                floating: false,
                pinned: true,
                backgroundColor: AppTheme.primaryColor,
                flexibleSpace: FlexibleSpaceBar(
                  title: const Text(
                    'Repair History',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: AppTheme.primaryGradient,
                    ),
                  ),
                ),
              ),
              
              // Status Filter
              SliverToBoxAdapter(
                child: _buildStatusFilter(context, ref, selectedStatus),
              ),
              
              // Repairs List
              SliverPadding(
                padding: const EdgeInsets.all(AppConstants.defaultPadding),
                sliver: filteredRepairsAsync.when(
                  data: (repairs) {
                    if (repairs.isEmpty) {
                      return SliverToBoxAdapter(
                        child: _buildEmptyState(context, selectedStatus),
                      );
                    }
                    
                    return SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          return AnimationConfiguration.staggeredList(
                            position: index,
                            duration: AppConstants.mediumAnimation,
                            child: SlideAnimation(
                              verticalOffset: 50.0,
                              child: FadeInAnimation(
                                child: _buildRepairCard(context, repairs[index]),
                              ),
                            ),
                          );
                        },
                        childCount: repairs.length,
                      ),
                    );
                  },
                  loading: () => SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => _buildRepairCardSkeleton(),
                      childCount: 5,
                    ),
                  ),
                  error: (error, stack) => SliverToBoxAdapter(
                    child: _buildErrorState(context, error.toString()),
                  ),
                ),
              ),
              
              // Bottom padding
              const SliverToBoxAdapter(
                child: SizedBox(height: 100),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.go(AppRoutes.services),
        icon: const Icon(Icons.add),
        label: const Text('New Repair'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
      ),
    );
  }

  Widget _buildStatusFilter(BuildContext context, WidgetRef ref, RepairStatus? selectedStatus) {
    final statuses = [null, ...RepairStatus.values];
    
    return Container(
      height: 60,
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppConstants.defaultPadding),
        itemCount: statuses.length,
        itemBuilder: (context, index) {
          final status = statuses[index];
          final isSelected = selectedStatus == status;
          
          return Container(
            margin: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(status?.displayName ?? 'All'),
              selected: isSelected,
              onSelected: (selected) {
                ref.read(selectedStatusProvider.notifier).state = selected ? status : null;
              },
              backgroundColor: AppTheme.surfaceColor,
              selectedColor: status != null
                  ? Color(int.parse(status.statusColor.replaceFirst('#', '0xFF'))).withOpacity(0.2)
                  : AppTheme.primaryColor.withOpacity(0.2),
              checkmarkColor: status != null
                  ? Color(int.parse(status.statusColor.replaceFirst('#', '0xFF')))
                  : AppTheme.primaryColor,
              labelStyle: TextStyle(
                color: isSelected
                    ? (status != null
                        ? Color(int.parse(status.statusColor.replaceFirst('#', '0xFF')))
                        : AppTheme.primaryColor)
                    : AppTheme.textSecondaryColor,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
              side: BorderSide(
                color: isSelected
                    ? (status != null
                        ? Color(int.parse(status.statusColor.replaceFirst('#', '0xFF')))
                        : AppTheme.primaryColor)
                    : AppTheme.textLightColor.withOpacity(0.3),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildRepairCard(BuildContext context, RepairModel repair) {
    final statusColor = Color(int.parse(repair.statusColor.replaceFirst('#', '0xFF')));
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () => context.go('${AppRoutes.repairDetail}?id=${repair.id}'),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      _getDeviceIcon(repair.deviceType),
                      color: statusColor,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          repair.deviceDisplayName,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'ID: ${repair.id.substring(0, 8).toUpperCase()}',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme.textLightColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      repair.status.displayName,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: statusColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // Issue Description
              Text(
                repair.issueDescription,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textSecondaryColor,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              
              const SizedBox(height: 12),
              
              // Footer
              Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 16,
                    color: AppTheme.textLightColor,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _formatDate(repair.createdAt),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.textLightColor,
                    ),
                  ),
                  const Spacer(),
                  if (repair.estimatedCost != null && repair.estimatedCost! > 0)
                    Text(
                      repair.formattedCost,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  const SizedBox(width: 8),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: AppTheme.textLightColor,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRepairCardSkeleton() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppTheme.textLightColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 16,
                        decoration: BoxDecoration(
                          color: AppTheme.textLightColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: 80,
                        height: 12,
                        decoration: BoxDecoration(
                          color: AppTheme.textLightColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 60,
                  height: 24,
                  decoration: BoxDecoration(
                    color: AppTheme.textLightColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              height: 16,
              decoration: BoxDecoration(
                color: AppTheme.textLightColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: 200,
              height: 16,
              decoration: BoxDecoration(
                color: AppTheme.textLightColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Container(
                  width: 80,
                  height: 12,
                  decoration: BoxDecoration(
                    color: AppTheme.textLightColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const Spacer(),
                Container(
                  width: 60,
                  height: 16,
                  decoration: BoxDecoration(
                    color: AppTheme.textLightColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, RepairStatus? selectedStatus) {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          Icon(
            selectedStatus != null ? Icons.filter_list_off : Icons.history,
            size: 64,
            color: AppTheme.textLightColor,
          ),
          const SizedBox(height: 16),
          Text(
            selectedStatus != null
                ? 'No ${selectedStatus.displayName.toLowerCase()} repairs'
                : 'No repair history',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppTheme.textSecondaryColor,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            selectedStatus != null
                ? 'Try selecting a different status or create a new repair request'
                : 'Start by booking your first repair service',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppTheme.textLightColor,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => context.go(AppRoutes.services),
            icon: const Icon(Icons.add),
            label: const Text('Book Repair Service'),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String error) {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: AppTheme.errorColor,
          ),
          const SizedBox(height: 16),
          Text(
            'Failed to load repair history',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppTheme.errorColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Please check your internet connection and try again',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppTheme.textSecondaryColor,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              // Retry loading
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  IconData _getDeviceIcon(String deviceType) {
    switch (deviceType.toLowerCase()) {
      case 'smartphone':
      case 'phone':
        return Icons.smartphone;
      case 'laptop':
      case 'computer':
        return Icons.laptop;
      case 'tv':
      case 'television':
        return Icons.tv;
      case 'tablet':
        return Icons.tablet;
      case 'watch':
        return Icons.watch;
      case 'headphones':
      case 'audio':
        return Icons.headphones;
      case 'camera':
        return Icons.camera_alt;
      case 'gaming':
      case 'console':
        return Icons.sports_esports;
      default:
        return Icons.devices;
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Unknown';
    
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks week${weeks > 1 ? 's' : ''} ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}