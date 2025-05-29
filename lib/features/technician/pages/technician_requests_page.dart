import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../../../core/widgets/custom_card.dart';
import '../widgets/request_filter_chips.dart';
import '../widgets/request_item_card.dart';

class TechnicianRequestsPage extends ConsumerStatefulWidget {
  const TechnicianRequestsPage({super.key});

  @override
  ConsumerState<TechnicianRequestsPage> createState() => _TechnicianRequestsPageState();
}

class _TechnicianRequestsPageState extends ConsumerState<TechnicianRequestsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedFilter = 'Semua';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: CustomAppBar(
        title: 'Permintaan Perbaikan',
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: _showSearchDialog,
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          _buildTabBar(),
          _buildFilterChips(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildRequestsList('all'),
                _buildRequestsList('new'),
                _buildRequestsList('in_progress'),
                _buildRequestsList('completed'),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAvailabilityDialog,
        backgroundColor: AppTheme.primaryColor,
        icon: const Icon(Icons.schedule, color: Colors.white),
        label: Text(
          'Ketersediaan',
          style: AppTheme.textTheme.bodyMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: Colors.white,
      child: TabBar(
        controller: _tabController,
        labelColor: AppTheme.primaryColor,
        unselectedLabelColor: Colors.grey,
        indicatorColor: AppTheme.primaryColor,
        indicatorWeight: 3,
        tabs: const [
          Tab(text: 'Semua'),
          Tab(text: 'Baru'),
          Tab(text: 'Proses'),
          Tab(text: 'Selesai'),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: RequestFilterChips(
        selectedFilter: _selectedFilter,
        onFilterChanged: (filter) {
          setState(() {
            _selectedFilter = filter;
          });
        },
      ),
    );
  }

  Widget _buildRequestsList(String status) {
    final requests = _getFilteredRequests(status);

    if (requests.isEmpty) {
      return _buildEmptyState(status);
    }

    return RefreshIndicator(
      onRefresh: () => _refreshRequests(status),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: requests.length,
        itemBuilder: (context, index) {
          final request = requests[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: RequestItemCard(
              request: request,
              onTap: () => _showRequestDetail(request),
              onAccept: () => _acceptRequest(request),
              onReject: () => _rejectRequest(request),
              onUpdateStatus: (newStatus) => _updateRequestStatus(request, newStatus),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(String status) {
    String message;
    IconData icon;

    switch (status) {
      case 'new':
        message = 'Tidak ada permintaan baru';
        icon = Icons.inbox;
        break;
      case 'in_progress':
        message = 'Tidak ada perbaikan dalam proses';
        icon = Icons.build;
        break;
      case 'completed':
        message = 'Belum ada perbaikan yang selesai';
        icon = Icons.check_circle_outline;
        break;
      default:
        message = 'Tidak ada permintaan perbaikan';
        icon = Icons.assignment;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 80,
            color: Colors.grey.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: AppTheme.textTheme.titleMedium?.copyWith(
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tarik ke bawah untuk memperbarui',
            style: AppTheme.textTheme.bodySmall?.copyWith(
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cari Permintaan'),
        content: TextField(
          decoration: const InputDecoration(
            hintText: 'Masukkan kata kunci...',
            prefixIcon: Icon(Icons.search),
          ),
          onSubmitted: (value) {
            Navigator.pop(context);
            // Implement search functionality
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Filter Permintaan',
              style: AppTheme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            _buildFilterOption('Jenis Perangkat', ['Semua', 'Smartphone', 'Laptop', 'Gaming Console']),
            _buildFilterOption('Prioritas', ['Semua', 'Tinggi', 'Sedang', 'Rendah']),
            _buildFilterOption('Lokasi', ['Semua', 'Jakarta Selatan', 'Jakarta Pusat', 'Jakarta Barat']),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Reset'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Terapkan'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterOption(String title, List<String> options) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTheme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: options.map((option) => FilterChip(
            label: Text(option),
            selected: false,
            onSelected: (selected) {
              // Handle filter selection
            },
          )).toList(),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  void _showAvailabilityDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Atur Ketersediaan'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SwitchListTile(
              title: const Text('Tersedia untuk permintaan baru'),
              value: true,
              onChanged: (value) {
                // Update availability
              },
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Catatan ketersediaan',
                hintText: 'Contoh: Tersedia hingga jam 18:00',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  void _showRequestDetail(Map<String, dynamic> request) {
    Navigator.pushNamed(
      context,
      '/technician/request-detail',
      arguments: request,
    );
  }

  void _acceptRequest(Map<String, dynamic> request) {
    // Show confirmation dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Terima Permintaan'),
        content: Text('Apakah Anda yakin ingin menerima permintaan perbaikan ${request['deviceBrand']} ${request['deviceModel']}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Accept request logic
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Permintaan berhasil diterima')),
              );
            },
            child: const Text('Terima'),
          ),
        ],
      ),
    );
  }

  void _rejectRequest(Map<String, dynamic> request) {
    // Show rejection reason dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tolak Permintaan'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Berikan alasan penolakan untuk ${request['deviceBrand']} ${request['deviceModel']}:'),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                hintText: 'Masukkan alasan penolakan...',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Reject request logic
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Permintaan ditolak')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Tolak'),
          ),
        ],
      ),
    );
  }

  void _updateRequestStatus(Map<String, dynamic> request, String newStatus) {
    // Update request status logic
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Status diperbarui ke: $newStatus')),
    );
  }

  Future<void> _refreshRequests(String status) async {
    // Simulate refresh delay
    await Future.delayed(const Duration(seconds: 1));
    
    // Refresh requests logic
    if (mounted) {
      setState(() {});
    }
  }

  List<Map<String, dynamic>> _getFilteredRequests(String status) {
    final allRequests = _getMockRequests();
    
    if (status == 'all') return allRequests;
    
    return allRequests.where((request) {
      switch (status) {
        case 'new':
          return request['status'] == 'Baru';
        case 'in_progress':
          return request['status'] == 'Proses';
        case 'completed':
          return request['status'] == 'Selesai';
        default:
          return true;
      }
    }).toList();
  }

  List<Map<String, dynamic>> _getMockRequests() {
    return [
      {
        'id': '1',
        'deviceType': 'Smartphone',
        'deviceBrand': 'iPhone',
        'deviceModel': '13 Pro',
        'customerName': 'John Doe',
        'customerPhone': '+62812-3456-7890',
        'problem': 'Layar retak, touchscreen tidak responsif',
        'status': 'Baru',
        'priority': 'Tinggi',
        'location': 'Jakarta Selatan',
        'estimatedPrice': 'Rp 800.000',
        'createdAt': '2024-01-15 10:30',
        'images': ['image1.jpg', 'image2.jpg'],
      },
      {
        'id': '2',
        'deviceType': 'Laptop',
        'deviceBrand': 'ASUS',
        'deviceModel': 'ROG Strix',
        'customerName': 'Jane Smith',
        'customerPhone': '+62813-9876-5432',
        'problem': 'Laptop tidak bisa menyala, kemungkinan masalah power',
        'status': 'Proses',
        'priority': 'Sedang',
        'location': 'Jakarta Pusat',
        'estimatedPrice': 'Rp 500.000',
        'createdAt': '2024-01-15 09:15',
        'images': ['image3.jpg'],
      },
      {
        'id': '3',
        'deviceType': 'Gaming Console',
        'deviceBrand': 'PlayStation',
        'deviceModel': '5',
        'customerName': 'Mike Johnson',
        'customerPhone': '+62814-5555-1234',
        'problem': 'Controller tidak bisa connect, masalah bluetooth',
        'status': 'Selesai',
        'priority': 'Rendah',
        'location': 'Jakarta Barat',
        'estimatedPrice': 'Rp 200.000',
        'createdAt': '2024-01-15 08:45',
        'images': [],
      },
      {
        'id': '4',
        'deviceType': 'Smartphone',
        'deviceBrand': 'Samsung',
        'deviceModel': 'Galaxy S23',
        'customerName': 'Sarah Wilson',
        'customerPhone': '+62815-7777-8888',
        'problem': 'Baterai cepat habis, perlu ganti baterai',
        'status': 'Baru',
        'priority': 'Sedang',
        'location': 'Jakarta Timur',
        'estimatedPrice': 'Rp 300.000',
        'createdAt': '2024-01-15 07:20',
        'images': ['image4.jpg'],
      },
    ];
  }
}