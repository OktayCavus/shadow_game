import 'package:flutter/material.dart';
import 'package:shadowbladerush/game.dart';

class SettingsOverlay {
  static void show(
    BuildContext context,
    ShadowBladeRush game, {
    required bool Function() isEditMode, // Function olarak değiştirdik
    required VoidCallback onEditModeToggle,
    required VoidCallback onResetToDefaults,
  }) {
    game.pauseGame();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: const EdgeInsets.all(24),
          backgroundColor: const Color(0xFF1A1A1A),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            width: 600,
            constraints: const BoxConstraints(maxHeight: 500),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Ayarlar',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          color: Colors.white,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          if (!isEditMode()) {
                            game.resumeGame();
                          }
                        },
                        icon: const Icon(Icons.close, color: Colors.white),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1, color: Colors.grey),
                // Settings Content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: [
                        // Sound Effects
                        ListTile(
                          leading:
                              const Icon(Icons.volume_up, color: Colors.white),
                          title: const Text(
                            'Ses Efektleri',
                            style: TextStyle(color: Colors.white),
                          ),
                          trailing: Switch(
                            value: true,
                            activeColor: Colors.redAccent,
                            onChanged: (value) {
                              // TODO: Implement sound effects toggle
                            },
                          ),
                        ),
                        // Music
                        ListTile(
                          leading:
                              const Icon(Icons.music_note, color: Colors.white),
                          title: const Text(
                            'Müzik',
                            style: TextStyle(color: Colors.white),
                          ),
                          trailing: Switch(
                            value: true,
                            activeColor: Colors.redAccent,
                            onChanged: (value) {
                              // TODO: Implement music toggle
                            },
                          ),
                        ),
                        // Vibration
                        ListTile(
                          leading:
                              const Icon(Icons.vibration, color: Colors.white),
                          title: const Text(
                            'Titreşim',
                            style: TextStyle(color: Colors.white),
                          ),
                          trailing: Switch(
                            value: true,
                            activeColor: Colors.redAccent,
                            onChanged: (value) {
                              // TODO: Implement vibration toggle
                            },
                          ),
                        ),
                        const Divider(color: Colors.grey),
                        // Layout Edit
                        ListTile(
                          leading: const Icon(Icons.tune, color: Colors.white),
                          title: const Text(
                            'Düzenle',
                            style: TextStyle(color: Colors.white),
                          ),
                          subtitle: const Text(
                            'Yetenek tuşlarının konumunu ve boyutunu değiştir',
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                          onTap: () {
                            onEditModeToggle();
                            Navigator.of(context).pop();
                          },
                        ),
                        // Reset to defaults (only show in edit mode)
                        if (isEditMode())
                          ListTile(
                            leading:
                                const Icon(Icons.refresh, color: Colors.white),
                            title: const Text(
                              'Varsayılana Sıfırla',
                              style: TextStyle(color: Colors.white),
                            ),
                            subtitle: const Text(
                              'Tüm yetenek tuşlarını varsayılan konumlarına döndür',
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 12),
                            ),
                            onTap: () {
                              onResetToDefaults();
                              Navigator.of(context).pop();
                            },
                          ),
                      ],
                    ),
                  ),
                ),
                const Divider(height: 1, color: Colors.grey),
                // Footer Buttons
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.of(context).pop();
                          // Close edit mode if active before going to main menu
                          if (isEditMode()) {
                            onEditModeToggle();
                          }
                          // TODO: Implement main menu navigation
                          game.resumeGame();
                        },
                        icon: const Icon(Icons.home),
                        label: const Text('Ana Menü'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent.shade700,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                          textStyle:
                              const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ).then((_) {
      // Only resume game if edit mode is not active
      if (game.isPaused && !isEditMode()) {
        game.resumeGame();
        print(
            'Dialog kapandı - Edit mode: ${isEditMode()}, Game resumed: ${!isEditMode()}');
      } else {
        print('Dialog kapandı - Edit mode AKTIF, oyun duraklı kalıyor');
      }
    });
  }
}
