import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/custom_card.dart';

class RequestItemCard extends StatelessWidget {
  final Map<String, dynamic> request;
  final VoidCallback onTap;
  final VoidCallback? onAccept;
  final VoidCallback? onReject;
  final Function(String)? onUpdateStatus;

  const RequestItemCard({
    super.key,
    required this.request,
    required this.onTap,
    this.onAccept,
    this.onReject,
    this.onUpdateStatus,
  });

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 12),
              _buildDeviceInfo(),
              const SizedBox(height: 12),
              _buildProblemDescription(),
              const SizedBox(height: 12),
              _buildCustomerInfo(),
              const SizedBox(height: 16),
              _buildFooter(),
              if (_shouldShowActions()) ...[
                const SizedBox(height: 16),
                _buildActionButtons(),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: _getStatusColor().withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: _getStatusColor().withOpacity(0.3),
            ),
          ),
          child: Text(
            request['status'],
            style: AppTheme.textTheme.bodySmall?.copyWith(
              color: _getStatusColor(),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _getPriorityColor().withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                request['priority'],
                style: AppTheme.textTheme.bodySmall?.copyWith(
                  color: _getPriorityColor(),
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.access_time,
              size: 14,
              color: Colors.grey,
            ),
            const SizedBox(width: 4),
            Text(
              _getTimeAgo(),
              style: AppTheme.textTheme.bodySmall?.copyWith(
                color: Colors.grey,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDeviceInfo() {
    return Row(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            _getDeviceIcon(),
            color: AppTheme.primaryColor,
            size: 24,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${request['deviceBrand']} ${request['deviceModel']}',
                style: AppTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                request['deviceType'],
                style: AppTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.textColor.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              request['estimatedPrice'],
              style: AppTheme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 2),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.location_on,
                  size: 12,
                  color: Colors.grey,
                ),
                const SizedBox(width: 2),
                Text(
                  request['location'],
                  style: AppTheme.textTheme.bodySmall?.copyWith(
                    color: Colors.grey,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProblemDescription() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.grey.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Deskripsi Masalah:',
            style: AppTheme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.textColor.withOpacity(0.8),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            request['problem'],
            style: AppTheme.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerInfo() {
    return Row(
      children: [
        CircleAvatar(
          radius: 16,
          backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
          child: Text(
            request['customerName'][0].toUpperCase(),
            style: AppTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                request['customerName'],
                style: AppTheme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                request['customerPhone'],
                style: AppTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.textColor.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ),
        IconButton(
          icon: const Icon(Icons.phone, color: Colors.green),
          onPressed: () {
            // Call customer
          },
          iconSize: 20,
        ),
        IconButton(
          icon: const Icon(Icons.message, color: Colors.blue),
          onPressed: () {
            // Message customer
          },
          iconSize: 20,
        ),
      ],
    );
  }

  Widget _buildFooter() {
    final hasImages = request['images'] != null && request['images'].isNotEmpty;
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (hasImages)
          Row(
            children: [
              Icon(
                Icons.image,
                size: 16,
                color: Colors.grey,
              ),
              const SizedBox(width: 4),
              Text(
                '${request['images'].length} foto',
                style: AppTheme.textTheme.bodySmall?.copyWith(
                  color: Colors.grey,
                ),
              ),
            ],
          )
        else
          const SizedBox(),
        Text(
          'ID: ${request['id']}',
          style: AppTheme.textTheme.bodySmall?.copyWith(
            color: Colors.grey,
            fontFamily: 'monospace',
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    final status = request['status'];
    
    if (status == 'Baru') {
      return Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: onReject,
              icon: const Icon(Icons.close, size: 16),
              label: const Text('Tolak'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
                side: const BorderSide(color: Colors.red),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: onAccept,
              icon: const Icon(Icons.check, size: 16),
              label: const Text('Terima'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
            ),
          ),
        ],
      );
    } else if (status == 'Proses') {
      return Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () => onUpdateStatus?.call('Menunggu Spare Part'),
              icon: const Icon(Icons.schedule, size: 16),
              label: const Text('Tunggu Part'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () => onUpdateStatus?.call('Selesai'),
              icon: const Icon(Icons.check_circle, size: 16),
              label: const Text('Selesai'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
            ),
          ),
        ],
      );
    }
    
    return const SizedBox();
  }

  bool _shouldShowActions() {
    final status = request['status'];
    return status == 'Baru' || status == 'Proses';
  }

  Color _getStatusColor() {
    switch (request['status'].toLowerCase()) {
      case 'baru':
        return Colors.blue;
      case 'proses':
        return Colors.orange;
      case 'selesai':
        return Colors.green;
      case 'batal':
        return Colors.red;
      case 'menunggu spare part':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  Color _getPriorityColor() {
    switch (request['priority'].toLowerCase()) {
      case 'tinggi':
        return Colors.red;
      case 'sedang':
        return Colors.orange;
      case 'rendah':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  IconData _getDeviceIcon() {
    switch (request['deviceType'].toLowerCase()) {
      case 'smartphone':
        return Icons.smartphone;
      case 'laptop':
        return Icons.laptop;
      case 'tablet':
        return Icons.tablet;
      case 'gaming console':
        return Icons.games;
      case 'tv':
        return Icons.tv;
      case 'ac':
        return Icons.ac_unit;
      default:
        return Icons.devices;
    }
  }

  String _getTimeAgo() {
    // Simple time ago calculation
    final createdAt = DateTime.parse(request['createdAt'].replaceAll(' ', 'T'));
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inDays > 0) {
      return '${difference.inDays}h lalu';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}j lalu';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m lalu';
    } else {
      return 'Baru saja';
    }
  }
}