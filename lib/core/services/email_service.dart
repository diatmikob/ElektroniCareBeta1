import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import '../models/repair_model.dart';
import '../models/technician_model.dart';
import '../models/user_model.dart';

class EmailService {

  EmailService() {
    _smtpServer = gmail(_username, _password);
  }
  // Email configuration - Replace with your SMTP settings
  static const String _smtpHost = 'smtp.gmail.com';
  static const int _smtpPort = 587;
  static const String _username = 'your-email@gmail.com'; // Replace with your email
  static const String _password = 'your-app-password'; // Replace with your app password
  static const String _fromEmail = 'noreply@elektronicare.com';
  static const String _fromName = 'ElektroniCare';

  late final SmtpServer _smtpServer;

  /// Send repair request notification to technician
  Future<bool> sendRepairRequestToTechnician({
    required TechnicianModel technician,
    required RepairModel repair,
    required UserModel customer,
  }) async {
    try {
      final message = Message()
        ..from = Address(_fromEmail, _fromName)
        ..recipients.add(technician.email)
        ..subject = 'Permintaan Perbaikan Baru - ElektroniCare'
        ..html = _buildRepairRequestEmailHtml(
          technician: technician,
          repair: repair,
          customer: customer,
        );

      final sendReport = await send(message, _smtpServer);
      print('Email sent to ${technician.email}: ${sendReport.toString()}');
      return true;
    } catch (e) {
      print('Error sending email to technician: $e');
      return false;
    }
  }

  /// Send repair status update to customer
  Future<bool> sendRepairStatusUpdate({
    required UserModel customer,
    required RepairModel repair,
    required String newStatus,
    String? message,
  }) async {
    try {
      final emailMessage = Message()
        ..from = Address(_fromEmail, _fromName)
        ..recipients.add(customer.email)
        ..subject = 'Update Status Perbaikan - ElektroniCare'
        ..html = _buildStatusUpdateEmailHtml(
          customer: customer,
          repair: repair,
          newStatus: newStatus,
          message: message,
        );

      final sendReport = await send(emailMessage, _smtpServer);
      print('Status update email sent to ${customer.email}: ${sendReport.toString()}');
      return true;
    } catch (e) {
      print('Error sending status update email: $e');
      return false;
    }
  }

  /// Send repair completion notification
  Future<bool> sendRepairCompletionNotification({
    required UserModel customer,
    required RepairModel repair,
    required TechnicianModel technician,
  }) async {
    try {
      final message = Message()
        ..from = Address(_fromEmail, _fromName)
        ..recipients.add(customer.email)
        ..subject = 'Perbaikan Selesai - ElektroniCare'
        ..html = _buildCompletionEmailHtml(
          customer: customer,
          repair: repair,
          technician: technician,
        );

      final sendReport = await send(message, _smtpServer);
      print('Completion email sent to ${customer.email}: ${sendReport.toString()}');
      return true;
    } catch (e) {
      print('Error sending completion email: $e');
      return false;
    }
  }

  /// Send welcome email to new user
  Future<bool> sendWelcomeEmail({
    required UserModel user,
  }) async {
    try {
      final message = Message()
        ..from = Address(_fromEmail, _fromName)
        ..recipients.add(user.email)
        ..subject = 'Selamat Datang di ElektroniCare!'
        ..html = _buildWelcomeEmailHtml(user: user);

      final sendReport = await send(message, _smtpServer);
      print('Welcome email sent to ${user.email}: ${sendReport.toString()}');
      return true;
    } catch (e) {
      print('Error sending welcome email: $e');
      return false;
    }
  }

  /// Send technician verification email
  Future<bool> sendTechnicianVerificationEmail({
    required TechnicianModel technician,
  }) async {
    try {
      final message = Message()
        ..from = Address(_fromEmail, _fromName)
        ..recipients.add(technician.email)
        ..subject = 'Verifikasi Teknisi - ElektroniCare'
        ..html = _buildTechnicianVerificationEmailHtml(technician: technician);

      final sendReport = await send(message, _smtpServer);
      print('Verification email sent to ${technician.email}: ${sendReport.toString()}');
      return true;
    } catch (e) {
      print('Error sending verification email: $e');
      return false;
    }
  }

  /// Build repair request email HTML
  String _buildRepairRequestEmailHtml({
    required TechnicianModel technician,
    required RepairModel repair,
    required UserModel customer,
  }) {
    return '''
    <!DOCTYPE html>
    <html>
    <head>
        <meta charset="UTF-8">
        <title>Permintaan Perbaikan Baru</title>
        <style>
            body { font-family: Arial, sans-serif; line-height: 1.6; color: #333; }
            .container { max-width: 600px; margin: 0 auto; padding: 20px; }
            .header { background: #2196F3; color: white; padding: 20px; text-align: center; }
            .content { padding: 20px; background: #f9f9f9; }
            .footer { padding: 20px; text-align: center; color: #666; }
            .button { background: #2196F3; color: white; padding: 12px 24px; text-decoration: none; border-radius: 5px; display: inline-block; }
            .info-box { background: white; padding: 15px; margin: 10px 0; border-radius: 5px; border-left: 4px solid #2196F3; }
        </style>
    </head>
    <body>
        <div class="container">
            <div class="header">
                <h1>ElektroniCare</h1>
                <h2>Permintaan Perbaikan Baru</h2>
            </div>
            
            <div class="content">
                <p>Halo ${technician.fullName},</p>
                
                <p>Anda mendapat permintaan perbaikan baru dari pelanggan. Berikut detail permintaannya:</p>
                
                <div class="info-box">
                    <h3>Detail Pelanggan</h3>
                    <p><strong>Nama:</strong> ${customer.fullName}</p>
                    <p><strong>Email:</strong> ${customer.email}</p>
                    <p><strong>Telepon:</strong> ${customer.phone ?? 'Tidak tersedia'}</p>
                </div>
                
                <div class="info-box">
                    <h3>Detail Perbaikan</h3>
                    <p><strong>ID Perbaikan:</strong> ${repair.id}</p>
                    <p><strong>Jenis Perangkat:</strong> ${repair.deviceType}</p>
                    <p><strong>Model:</strong> ${repair.deviceModel}</p>
                    <p><strong>Masalah:</strong> ${repair.issueDescription}</p>
                    <p><strong>Tanggal Dibuat:</strong> ${repair.createdAt?.toString().split('.')[0] ?? 'Tidak tersedia'}</p>
                </div>
                
                <p>Silakan buka aplikasi ElektroniCare untuk melihat detail lengkap dan merespons permintaan ini.</p>
                
                <p style="text-align: center;">
                    <a href="#" class="button">Buka Aplikasi</a>
                </p>
            </div>
            
            <div class="footer">
                <p>Email ini dikirim otomatis oleh sistem ElektroniCare.</p>
                <p>Jika Anda memiliki pertanyaan, silakan hubungi support@elektronicare.com</p>
            </div>
        </div>
    </body>
    </html>
    ''';
  }

  /// Build status update email HTML
  String _buildStatusUpdateEmailHtml({
    required UserModel customer,
    required RepairModel repair,
    required String newStatus,
    String? message,
  }) {
    return '''
    <!DOCTYPE html>
    <html>
    <head>
        <meta charset="UTF-8">
        <title>Update Status Perbaikan</title>
        <style>
            body { font-family: Arial, sans-serif; line-height: 1.6; color: #333; }
            .container { max-width: 600px; margin: 0 auto; padding: 20px; }
            .header { background: #2196F3; color: white; padding: 20px; text-align: center; }
            .content { padding: 20px; background: #f9f9f9; }
            .footer { padding: 20px; text-align: center; color: #666; }
            .status-badge { background: #4CAF50; color: white; padding: 8px 16px; border-radius: 20px; display: inline-block; }
            .info-box { background: white; padding: 15px; margin: 10px 0; border-radius: 5px; border-left: 4px solid #2196F3; }
        </style>
    </head>
    <body>
        <div class="container">
            <div class="header">
                <h1>ElektroniCare</h1>
                <h2>Update Status Perbaikan</h2>
            </div>
            
            <div class="content">
                <p>Halo ${customer.fullName},</p>
                
                <p>Status perbaikan perangkat Anda telah diperbarui:</p>
                
                <div class="info-box">
                    <h3>Detail Perbaikan</h3>
                    <p><strong>ID Perbaikan:</strong> ${repair.id}</p>
                    <p><strong>Perangkat:</strong> ${repair.deviceBrand} ${repair.deviceModel}</p>
                    <p><strong>Status Baru:</strong> <span class="status-badge">$newStatus</span></p>
                    ${message != null ? '<p><strong>Pesan:</strong> $message</p>' : ''}
                </div>
                
                <p>Anda dapat melihat detail lengkap di aplikasi ElektroniCare.</p>
            </div>
            
            <div class="footer">
                <p>Email ini dikirim otomatis oleh sistem ElektroniCare.</p>
                <p>Jika Anda memiliki pertanyaan, silakan hubungi support@elektronicare.com</p>
            </div>
        </div>
    </body>
    </html>
    ''';
  }

  /// Build completion email HTML
  String _buildCompletionEmailHtml({
    required UserModel customer,
    required RepairModel repair,
    required TechnicianModel technician,
  }) {
    return '''
    <!DOCTYPE html>
    <html>
    <head>
        <meta charset="UTF-8">
        <title>Perbaikan Selesai</title>
        <style>
            body { font-family: Arial, sans-serif; line-height: 1.6; color: #333; }
            .container { max-width: 600px; margin: 0 auto; padding: 20px; }
            .header { background: #4CAF50; color: white; padding: 20px; text-align: center; }
            .content { padding: 20px; background: #f9f9f9; }
            .footer { padding: 20px; text-align: center; color: #666; }
            .success-badge { background: #4CAF50; color: white; padding: 8px 16px; border-radius: 20px; display: inline-block; }
            .info-box { background: white; padding: 15px; margin: 10px 0; border-radius: 5px; border-left: 4px solid #4CAF50; }
        </style>
    </head>
    <body>
        <div class="container">
            <div class="header">
                <h1>🎉 Perbaikan Selesai!</h1>
            </div>
            
            <div class="content">
                <p>Halo ${customer.fullName},</p>
                
                <p>Kabar baik! Perbaikan perangkat Anda telah selesai dikerjakan.</p>
                
                <div class="info-box">
                    <h3>Detail Perbaikan</h3>
                    <p><strong>ID Perbaikan:</strong> ${repair.id}</p>
                    <p><strong>Perangkat:</strong> ${repair.deviceBrand} ${repair.deviceModel}</p>
                    <p><strong>Teknisi:</strong> ${technician.fullName}</p>
                    <p><strong>Status:</strong> <span class="success-badge">Selesai</span></p>
                </div>
                
                <p>Silakan hubungi teknisi untuk mengambil perangkat Anda atau mengatur pengiriman.</p>
                
                <p>Terima kasih telah menggunakan layanan ElektroniCare!</p>
            </div>
            
            <div class="footer">
                <p>Email ini dikirim otomatis oleh sistem ElektroniCare.</p>
                <p>Jika Anda memiliki pertanyaan, silakan hubungi support@elektronicare.com</p>
            </div>
        </div>
    </body>
    </html>
    ''';
  }

  /// Build welcome email HTML
  String _buildWelcomeEmailHtml({required UserModel user}) {
    return '''
    <!DOCTYPE html>
    <html>
    <head>
        <meta charset="UTF-8">
        <title>Selamat Datang di ElektroniCare</title>
        <style>
            body { font-family: Arial, sans-serif; line-height: 1.6; color: #333; }
            .container { max-width: 600px; margin: 0 auto; padding: 20px; }
            .header { background: #2196F3; color: white; padding: 20px; text-align: center; }
            .content { padding: 20px; background: #f9f9f9; }
            .footer { padding: 20px; text-align: center; color: #666; }
            .feature { background: white; padding: 15px; margin: 10px 0; border-radius: 5px; }
        </style>
    </head>
    <body>
        <div class="container">
            <div class="header">
                <h1>Selamat Datang di ElektroniCare!</h1>
            </div>
            
            <div class="content">
                <p>Halo ${user.fullName},</p>
                
                <p>Selamat datang di ElektroniCare! Kami senang Anda bergabung dengan platform perbaikan elektronik terpercaya.</p>
                
                <h3>Apa yang bisa Anda lakukan:</h3>
                
                <div class="feature">
                    <h4>📱 Booking Perbaikan</h4>
                    <p>Ajukan permintaan perbaikan untuk berbagai perangkat elektronik</p>
                </div>
                
                <div class="feature">
                    <h4>👨‍🔧 Pilih Teknisi</h4>
                    <p>Pilih teknisi terbaik sesuai kebutuhan Anda</p>
                </div>
                
                <div class="feature">
                    <h4>📊 Lacak Progress</h4>
                    <p>Pantau status perbaikan secara real-time</p>
                </div>
                
                <p>Mulai gunakan aplikasi sekarang dan rasakan kemudahan perbaikan elektronik!</p>
            </div>
            
            <div class="footer">
                <p>Terima kasih telah memilih ElektroniCare</p>
                <p>Tim ElektroniCare</p>
            </div>
        </div>
    </body>
    </html>
    ''';
  }

  /// Build technician verification email HTML
  String _buildTechnicianVerificationEmailHtml({required TechnicianModel technician}) {
    return '''
    <!DOCTYPE html>
    <html>
    <head>
        <meta charset="UTF-8">
        <title>Verifikasi Teknisi</title>
        <style>
            body { font-family: Arial, sans-serif; line-height: 1.6; color: #333; }
            .container { max-width: 600px; margin: 0 auto; padding: 20px; }
            .header { background: #FF9800; color: white; padding: 20px; text-align: center; }
            .content { padding: 20px; background: #f9f9f9; }
            .footer { padding: 20px; text-align: center; color: #666; }
            .info-box { background: white; padding: 15px; margin: 10px 0; border-radius: 5px; border-left: 4px solid #FF9800; }
        </style>
    </head>
    <body>
        <div class="container">
            <div class="header">
                <h1>Verifikasi Teknisi ElektroniCare</h1>
            </div>
            
            <div class="content">
                <p>Halo ${technician.fullName},</p>
                
                <p>Terima kasih telah mendaftar sebagai teknisi di ElektroniCare. Profil Anda sedang dalam proses verifikasi.</p>
                
                <div class="info-box">
                    <h3>Status Verifikasi</h3>
                    <p><strong>Status:</strong> ${technician.isVerified ? 'Terverifikasi' : 'Menunggu Verifikasi'}</p>
                    <p><strong>Spesialisasi:</strong> ${technician.specialization}</p>
                    <p><strong>Layanan:</strong> ${technician.services.join(', ')}</p>
                </div>
                
                <p>Tim kami akan meninjau dokumen dan informasi yang Anda berikan. Proses verifikasi biasanya memakan waktu 1-3 hari kerja.</p>
                
                <p>Setelah terverifikasi, Anda akan dapat menerima permintaan perbaikan dari pelanggan.</p>
            </div>
            
            <div class="footer">
                <p>Email ini dikirim otomatis oleh sistem ElektroniCare.</p>
                <p>Jika Anda memiliki pertanyaan, silakan hubungi support@elektronicare.com</p>
            </div>
        </div>
    </body>
    </html>
    ''';
  }
}