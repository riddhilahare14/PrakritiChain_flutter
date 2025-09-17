import 'dart:typed_data';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

import '../utils/colors.dart';

class QRDisplayScreen extends StatefulWidget {
  final Map<String, dynamic> qrCodeData;
  final String batchId;
  final String herbName;

  const QRDisplayScreen({
    super.key,
    required this.qrCodeData,
    required this.batchId,
    required this.herbName,
  });

  @override
  State<QRDisplayScreen> createState() => _QRDisplayScreenState();
}

class _QRDisplayScreenState extends State<QRDisplayScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _copyQRHash() {
    final qrHash = widget.qrCodeData['qrHash'] ?? '';
    Clipboard.setData(ClipboardData(text: qrHash));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('QR Hash copied to clipboard'),
        backgroundColor: AppColors.primaryGreen,
      ),
    );
  }

  Future<void> _shareQRCode() async {
    try {
      // Get the QR image data URL
      final qrImage = widget.qrCodeData['qrImage'] as String?;
      if (qrImage != null && qrImage.startsWith('data:image')) {
        // Extract base64 data
        final base64Data = qrImage.split(',')[1];
        final bytes = base64Decode(base64Data);
        
        // Save to temporary file
        final tempDir = await getTemporaryDirectory();
        final file = File('${tempDir.path}/qr_code_${widget.batchId}.png');
        await file.writeAsBytes(bytes);
        
        // Share the file
        await Share.shareXFiles(
          [XFile(file.path)],
          text: 'QR Code for ${widget.herbName} - Batch ID: ${widget.batchId}',
        );
      } else {
        // Fallback to sharing text
        await Share.share(
          'QR Hash: ${widget.qrCodeData['qrHash']}\nBatch ID: ${widget.batchId}\nHerb: ${widget.herbName}',
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error sharing QR code: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _downloadQRCode() async {
    try {
      final qrImage = widget.qrCodeData['qrImage'] as String?;
      if (qrImage != null && qrImage.startsWith('data:image')) {
        // Extract base64 image data
        final base64Data = qrImage.split(',')[1];
        final bytes = base64Decode(base64Data);

        // Choose directory based on platform
        Directory? dir;

        if (Platform.isAndroid) {
          dir = await getExternalStorageDirectory(); 
        } else if (Platform.isIOS) {
          dir = await getApplicationDocumentsDirectory();
        } else {
          dir = await getDownloadsDirectory();
        }

        final path = dir?.path ?? (await getTemporaryDirectory()).path;
        final file = File('$path/qr_code_${widget.batchId}.png');
        await file.writeAsBytes(bytes);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("✅ QR Code saved to: ${file.path}"),
            backgroundColor: AppColors.primaryGreen,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("⚠️ No QR image available to download"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error saving QR: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }




  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String value,
    Color? valueColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primaryGreen.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.primaryGreen, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.subtitleColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: valueColor ?? AppColors.textColor,
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
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: AppColors.primaryGreen,
        title: const Text(
          "QR Code Generated",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: _shareQRCode,
          ),
        ],
      ),
      body: AnimatedBuilder(
        animation: _fadeAnimation,
        builder: (context, child) {
          return Opacity(
            opacity: _fadeAnimation.value,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Success Message
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.green.withOpacity(0.3)),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.green, size: 24),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            "Collection, batch, and QR code created successfully!",
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // QR Code Display
                  AnimatedBuilder(
                    animation: _scaleAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _scaleAnimation.value,
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              // QR Code Image
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: AppColors.primaryGreen.withOpacity(0.2)),
                                ),
                                child: widget.qrCodeData['qrImage'] != null
                                    ? Image.memory(
                                        base64Decode(widget.qrCodeData['qrImage'].split(',')[1]),
                                        width: 200,
                                        height: 200,
                                        fit: BoxFit.contain,
                                      )
                                    : Container(
                                        width: 200,
                                        height: 200,
                                        decoration: BoxDecoration(
                                          color: AppColors.primaryGreen.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: const Icon(
                                          Icons.qr_code,
                                          size: 100,
                                          color: AppColors.primaryGreen,
                                        ),
                                      ),
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                "Scan to trace your herbs",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textColor,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "QR Hash: ${widget.qrCodeData['qrHash']?.toString().substring(0, 8)}...",
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.subtitleColor,
                                  fontFamily: 'monospace',
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 24),

                  // Information Cards
                  Expanded(
                    child: ListView(
                      children: [
                        _buildInfoCard(
                          icon: Icons.eco,
                          title: "Herb Name",
                          value: widget.herbName,
                        ),
                        const SizedBox(height: 12),
                        _buildInfoCard(
                          icon: Icons.inventory,
                          title: "Batch ID",
                          value: widget.batchId,
                        ),
                        const SizedBox(height: 12),
                        _buildInfoCard(
                          icon: Icons.qr_code,
                          title: "QR Code ID",
                          value: widget.qrCodeData['qrCodeId']?.toString() ?? 'N/A',
                        ),
                        const SizedBox(height: 12),
                        _buildInfoCard(
                          icon: Icons.calendar_today,
                          title: "Generated On",
                          value: DateTime.now().toString().split(' ')[0],
                        ),
                        const SizedBox(height: 12),
                        _buildInfoCard(
                          icon: Icons.verified,
                          title: "Status",
                          value: "Active",
                          valueColor: Colors.green,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _downloadQRCode,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueGrey,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        icon: const Icon(Icons.download),
                        label: const Text("Download"),
                      ),
                    ),
                    const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.of(context).popUntil((route) => route.isFirst);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryGreen,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          icon: const Icon(Icons.home),
                          label: const Text("Go Home"),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}