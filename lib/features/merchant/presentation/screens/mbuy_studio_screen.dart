import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';

/// شاشة Mbuy Studio (توليد المحتوى فقط)
class MbuyStudioScreen extends StatefulWidget {
  const MbuyStudioScreen({super.key});

  @override
  State<MbuyStudioScreen> createState() => _MbuyStudioScreenState();
}

class _MbuyStudioScreenState extends State<MbuyStudioScreen> {
  int _selectedTab = 0; // 0: Video, 1: Image, 2: Audio, 3: Templates

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MbuyColors.background,
      appBar: AppBar(
        title: const Text('Mbuy Studio'),
        backgroundColor: MbuyColors.cardBackground,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Tabs
          Container(
            height: 50,
            decoration: BoxDecoration(
              color: MbuyColors.cardBackground,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                _buildTab(0, Icons.video_library, 'فيديو'),
                _buildTab(1, Icons.image, 'صورة'),
                _buildTab(2, Icons.audiotrack, 'صوت'),
                _buildTab(3, Icons.article, 'قوالب'),
              ],
            ),
          ),

          // Content
          Expanded(
            child: IndexedStack(
              index: _selectedTab,
              children: [
                _buildVideoTab(),
                _buildImageTab(),
                _buildAudioTab(),
                _buildTemplatesTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(int index, IconData icon, String label) {
    final isSelected = _selectedTab == index;
    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedTab = index;
          });
        },
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isSelected ? MbuyColors.primaryMaroon : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isSelected ? MbuyColors.primaryMaroon : MbuyColors.textSecondary,
                size: 20,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: GoogleFonts.cairo(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? MbuyColors.primaryMaroon : MbuyColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVideoTab() {
    final promptController = TextEditingController();
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'توليد مقطع فيديو',
                    style: GoogleFonts.cairo(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: MbuyColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: promptController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      labelText: 'وصف الفيديو',
                      hintText: 'اكتب وصفاً للفيديو الذي تريد إنشاؤه...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (promptController.text.trim().isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('الرجاء إدخال وصف الفيديو')),
                          );
                          return;
                        }
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('سيتم إضافة توليد الفيديو قريباً')),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: MbuyColors.primaryMaroon,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('توليد الفيديو'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageTab() {
    final promptController = TextEditingController();
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'توليد صورة',
                    style: GoogleFonts.cairo(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: MbuyColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: promptController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      labelText: 'وصف الصورة',
                      hintText: 'اكتب وصفاً للصورة التي تريد إنشاؤها...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (promptController.text.trim().isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('الرجاء إدخال وصف الصورة')),
                          );
                          return;
                        }
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('سيتم إضافة توليد الصورة قريباً')),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: MbuyColors.primaryMaroon,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('توليد الصورة'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAudioTab() {
    final textController = TextEditingController();
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'توليد صوت',
                    style: GoogleFonts.cairo(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: MbuyColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: textController,
                    maxLines: 6,
                    decoration: InputDecoration(
                      labelText: 'النص',
                      hintText: 'اكتب النص الذي تريد تحويله إلى صوت...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (textController.text.trim().isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('الرجاء إدخال النص')),
                          );
                          return;
                        }
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('سيتم إضافة توليد الصوت قريباً')),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: MbuyColors.primaryMaroon,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('توليد الصوت'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTemplatesTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'القوالب الجاهزة',
            style: GoogleFonts.cairo(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: MbuyColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: Column(
                  children: [
                    Icon(Icons.article, size: 64, color: MbuyColors.textSecondary),
                    const SizedBox(height: 16),
                    Text(
                      'سيتم إضافة القوالب الجاهزة قريباً',
                      style: GoogleFonts.cairo(
                        fontSize: 16,
                        color: MbuyColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

