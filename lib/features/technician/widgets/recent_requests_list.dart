import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class RecentRequestsList extends StatelessWidget {
  const RecentRequestsList({super.key});

  @override
  Widget build(BuildContext context) {
    final requests = _getMockRequests();

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: requests.length,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final request = requests[index];
        return _buildRequestItem(request);
      },
    );
  }

  Widget _buildRequestItem(Map<String, dynamic> request) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: _getStatusColor(request['status']).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              _getDeviceIcon(request['deviceType']),
              color: _getStatusColor(request['status']),
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
                  style: AppTheme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  request['customerName'],
                  style: AppTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.textColor.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  request['problem'],
                  style: AppTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.textColor.withOpacity(0.6),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getStatusColor(request['status']),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  request['status'],
                  style: AppTheme.textTheme.bodySmall?.copyWith(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                request['time'],
                style: AppTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.textColor.withOpacity(0.5),
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'baru':
        return Colors.blue;
      case 'proses':
        return Colors.orange;
      case 'selesai':
        return Colors.green;
      case 'batal':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getDeviceIcon(String deviceType) {
    switch (deviceType.toLowerCase()) {
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

  List<Map<String, dynamic>> _getMockRequests() {
    return [
      {
        'id': '1',
        'deviceType': 'Smartphone',
        'deviceBrand': 'iPhone',
        'deviceModel': '13 Pro',
        'customerName': 'John Doe',
        'problem': 'Layar retak, touchscreen tidak responsif',
        'status': 'Baru',
        'time': '10:30',
      },
      {
        'id': '2',
        'deviceType': 'Laptop',
        'deviceBrand': 'ASUS',
        'deviceModel': 'ROG Strix',
        'customerName': 'Jane Smith',
        'problem': 'Laptop tidak bisa menyala',
        'status': 'Proses',
        'time': '09:15',
      },
      {
        'id': '3',
        'deviceType': 'Gaming Console',
        'deviceBrand': 'PlayStation',
        'deviceModel': '5',
        'customerName': 'Mike Johnson',
        'problem': 'Controller tidak connect',
        'status': 'Selesai',
        'time': '08:45',
      },
      {
        'id': '4',
        'deviceType': 'Smartphone',
        'deviceBrand': 'Samsung',
        'deviceModel': 'Galaxy S23',
        'customerName': 'Sarah Wilson',
        'problem': 'Baterai cepat habis',
        'status': 'Baru',
        'time': '07:20',
      },
    ];
  }
}