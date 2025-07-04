import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shadowbladerush/game.dart';
import 'package:shadowbladerush/helpers/shared_preferences.dart';
import 'package:shadowbladerush/overlays/settings_overlay.dart';

enum Ability { quick, camouflage, throwSword }

class AbilityButtonConfig {
  Offset position;
  double size;

  AbilityButtonConfig({
    required this.position,
    required this.size,
  });

  Map<String, dynamic> toJson() => {
        'x': position.dx,
        'y': position.dy,
        'size': size,
      };

  factory AbilityButtonConfig.fromJson(Map<String, dynamic> json) {
    return AbilityButtonConfig(
      position: Offset(json['x'] as double, json['y'] as double),
      size: json['size'] as double,
    );
  }
}

class AbilitiesOverlay extends StatefulWidget {
  final ShadowBladeRush game;

  const AbilitiesOverlay({super.key, required this.game});

  @override
  State<AbilitiesOverlay> createState() => _AbilitiesOverlayState();
}

class _AbilitiesOverlayState extends State<AbilitiesOverlay>
    with TickerProviderStateMixin {
  final SharedPrefsService _prefs = SharedPrefsService();
  bool _quickAttackAvailable = true;
  bool _camouflageAvailable = true;
  bool _throwSwordAvailable = true;
  bool _editMode = false; // Düzenleme modu

  late AnimationController _quickAttackController;
  late AnimationController _camouflageController;
  late AnimationController _throwSwordController;

  final Duration quickAttackCooldown = const Duration(seconds: 3);
  final Duration camouflageCooldown = const Duration(seconds: 5);
  final Duration throwSwordCooldown = const Duration(seconds: 1);

  // Ability button configurations
  late AbilityButtonConfig _quickAttackConfig;
  late AbilityButtonConfig _camouflageConfig;
  late AbilityButtonConfig _throwSwordConfig;

  @override
  void initState() {
    super.initState();
    _initializeConfigs();
    _initializeAsync();

    _quickAttackController = AnimationController(
      vsync: this,
      duration: quickAttackCooldown,
    );
    _camouflageController = AnimationController(
      vsync: this,
      duration: camouflageCooldown,
    );
    _throwSwordController = AnimationController(
      vsync: this,
      duration: throwSwordCooldown,
    );
  }

  Future<void> _initializeAsync() async {
    try {
      print('Initializing SharedPrefs...');
      await _prefs.init();
      print('SharedPrefs initialized');
      await _loadConfigurations();
    } catch (e) {
      print('Error during initialization: $e');
    }
  }

  void _initializeConfigs() {
    _quickAttackConfig = AbilityButtonConfig(
      position: const Offset(20, 100),
      size: 60,
    );
    _camouflageConfig = AbilityButtonConfig(
      position: const Offset(20, 180),
      size: 60,
    );
    _throwSwordConfig = AbilityButtonConfig(
      position: const Offset(20, 260),
      size: 60,
    );
  }

  Future<void> _loadConfigurations() async {
    try {
      print('Loading configurations...');

      // Quick Attack Config
      final quickAttackJson = _prefs.getString('quickAttackConfig');
      if (quickAttackJson != null && quickAttackJson.isNotEmpty) {
        try {
          _quickAttackConfig =
              AbilityButtonConfig.fromJson(json.decode(quickAttackJson));
          print(
              'Quick Attack loaded: ${_quickAttackConfig.position}, size: ${_quickAttackConfig.size}');
        } catch (e) {
          print('Error parsing quickAttackConfig: $e');
          // Varsayılan değer kalacak
        }
      } else {
        print('quickAttackConfig not found, using default');
      }

      // Camouflage Config
      final camouflageJson = _prefs.getString('camouflageConfig');
      if (camouflageJson != null && camouflageJson.isNotEmpty) {
        try {
          _camouflageConfig =
              AbilityButtonConfig.fromJson(json.decode(camouflageJson));
          print(
              'Camouflage loaded: ${_camouflageConfig.position}, size: ${_camouflageConfig.size}');
        } catch (e) {
          print('Error parsing camouflageConfig: $e');
          // Varsayılan değer kalacak
        }
      } else {
        print('camouflageConfig not found, using default');
      }

      // Throw Sword Config
      final throwSwordJson = _prefs.getString('throwSwordConfig');
      if (throwSwordJson != null && throwSwordJson.isNotEmpty) {
        try {
          _throwSwordConfig =
              AbilityButtonConfig.fromJson(json.decode(throwSwordJson));
          print(
              'Throw Sword loaded: ${_throwSwordConfig.position}, size: ${_throwSwordConfig.size}');
        } catch (e) {
          print('Error parsing throwSwordConfig: $e');
          // Varsayılan değer kalacak
        }
      } else {
        print('throwSwordConfig not found, using default');
      }

      if (mounted) setState(() {});
      print('Configuration loading completed');
    } catch (e) {
      print('Error loading configurations: $e');
      // Hata durumunda varsayılan değerler kullanılacak
    }
  }

  Future<void> _saveConfigurations() async {
    try {
      print('Saving configurations...');

      // Quick Attack Config
      final quickAttackJson = json.encode(_quickAttackConfig.toJson());
      await _prefs.saveString('quickAttackConfig', quickAttackJson);
      print('Quick Attack saved: $quickAttackJson');

      // Camouflage Config
      final camouflageJson = json.encode(_camouflageConfig.toJson());
      await _prefs.saveString('camouflageConfig', camouflageJson);
      print('Camouflage saved: $camouflageJson');

      // Throw Sword Config
      final throwSwordJson = json.encode(_throwSwordConfig.toJson());
      await _prefs.saveString('throwSwordConfig', throwSwordJson);
      print('Throw Sword saved: $throwSwordJson');

      print('All configurations saved successfully!');
    } catch (e) {
      print('Error saving configurations: $e');
    }
  }

  void _resetToDefaults() {
    setState(() {
      _initializeConfigs();
    });
    _saveConfigurations();
  }

  void _toggleEditMode() {
    setState(() {
      _editMode = !_editMode;
    });

    if (_editMode) {
      // Edit modu açıldığında oyunu duraklat
      widget.game.pauseGame();
      print('Edit mode AÇILDI - Oyun DURAKLADI');
    } else {
      // Edit modu kapandığında ayarları kaydet ve oyunu devam ettir
      _saveConfigurations();
      widget.game.resumeGame();
      print('Edit mode KAPANDI - Oyun DEVAM ETTİ');
    }
  }

  @override
  void dispose() {
    _quickAttackController.dispose();
    _camouflageController.dispose();
    _throwSwordController.dispose();
    super.dispose();
  }

  void _startCooldown(Ability ability) {
    setState(() {
      switch (ability) {
        case Ability.quick:
          _quickAttackAvailable = false;
          _quickAttackController.forward(from: 0).whenComplete(() {
            if (mounted) setState(() => _quickAttackAvailable = true);
          });
          break;
        case Ability.camouflage:
          _camouflageAvailable = false;
          _camouflageController.forward(from: 0).whenComplete(() {
            if (mounted) setState(() => _camouflageAvailable = true);
          });
          break;
        case Ability.throwSword:
          _throwSwordAvailable = false;
          _throwSwordController.forward(from: 0).whenComplete(() {
            if (mounted) setState(() => _throwSwordAvailable = true);
          });
          break;
      }
    });
  }

  void _showSettingsDialog() {
    SettingsOverlay.show(
      context,
      widget.game,
      isEditMode: () => _editMode,
      onEditModeToggle: _toggleEditMode,
      onResetToDefaults: _resetToDefaults,
    );
  }

  Widget _buildHealthBar() {
    return StreamBuilder<double?>(
      stream: Stream.periodic(const Duration(milliseconds: 100),
          (_) => widget.game.hasLoaded ? widget.game.ninja.health : null),
      builder: (context, snapshot) {
        if (!widget.game.hasLoaded) {
          return Container(
            width: 200,
            height: 20,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              borderRadius: BorderRadius.circular(10),
              border:
                  Border.all(color: Colors.white.withOpacity(0.8), width: 2),
            ),
            child: const Center(
              child: Text(
                'Loading...',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        }

        final health = snapshot.data ?? widget.game.ninja.health;
        final maxHealth = widget.game.ninja.maxHealth;
        final healthPercentage = (health / maxHealth).clamp(0.0, 1.0);

        return Container(
          width: 200,
          height: 20,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.5),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.white.withOpacity(0.8), width: 2),
          ),
          child: Stack(
            children: [
              // Health bar background
              Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              // Current health
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: (196 * healthPercentage).clamp(0.0, 196.0),
                height: double.infinity,
                margin: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: healthPercentage > 0.5
                        ? [Colors.green, Colors.lightGreen]
                        : healthPercentage > 0.25
                            ? [Colors.orange, Colors.yellow]
                            : [Colors.red, Colors.deepOrange],
                  ),
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              // Health text
              Center(
                child: Text(
                  '${health.clamp(0, maxHealth).toInt()}/${maxHealth.toInt()}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        offset: Offset(1, 1),
                        blurRadius: 2,
                        color: Colors.black,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAbilityButton({
    required bool available,
    required String activeImagePath,
    required String passiveImagePath,
    required VoidCallback onPressed,
    required AnimationController controller,
    required AbilityButtonConfig config,
    required Function(Offset) onPositionChanged,
    required Function(double) onSizeChanged,
  }) {
    Widget buttonWidget = Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: config.size,
          height: config.size,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              elevation: 0,
              shape: const CircleBorder(),
              padding: EdgeInsets.zero,
            ),
            onPressed: _editMode ? null : (available ? onPressed : null),
            child: Container(
              width: config.size - 10,
              height: config.size - 10,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage(
                      available ? activeImagePath : passiveImagePath),
                  fit: BoxFit.cover,
                ),
                border:
                    _editMode ? Border.all(color: Colors.blue, width: 2) : null,
              ),
            ),
          ),
        ),
        if (!available && !_editMode)
          AnimatedBuilder(
            animation: controller,
            builder: (context, child) {
              return SizedBox(
                width: config.size - 2,
                height: config.size - 2,
                child: CircularProgressIndicator(
                  value: 1.0 - controller.value,
                  strokeWidth: 5,
                  backgroundColor: Colors.black54,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Colors.white.withOpacity(0.5),
                  ),
                ),
              );
            },
          ),
        // Size handles for edit mode
        if (_editMode) ...[
          Positioned(
            top: 0,
            right: 0,
            child: GestureDetector(
              onPanUpdate: (details) {
                double newSize =
                    (config.size + details.delta.dx).clamp(40.0, 100.0);
                onSizeChanged(newSize);
              },
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 1),
                ),
                child: const Icon(Icons.open_in_full,
                    size: 12, color: Colors.white),
              ),
            ),
          ),
        ],
      ],
    );

    if (_editMode) {
      return Draggable(
        feedback: Opacity(
          opacity: 0.8,
          child: buttonWidget,
        ),
        childWhenDragging: Opacity(
          opacity: 0.3,
          child: buttonWidget,
        ),
        onDragEnd: (details) {
          print('Drag ended at: ${details.offset}');
          onPositionChanged(details.offset);
        },
        child: buttonWidget,
      );
    }

    return buttonWidget;
  }

  Widget _buildSettingsButton() {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.6),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.white.withOpacity(0.8), width: 2),
      ),
      child: IconButton(
        onPressed: _showSettingsDialog,
        icon: const Icon(
          Icons.settings,
          color: Colors.white,
          size: 28,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Stack(
      children: [
        // Health Bar - Ekranın üst ortasında
        Positioned(
          top: 10,
          left: MediaQuery.of(context).size.width / 2 - 100,
          child: Column(
            children: [
              _buildHealthBar(),
            ],
          ),
        ),
        // Settings Button - Sağ üst köşede
        Positioned(
          top: 10,
          right: 20,
          child: _buildSettingsButton(),
        ),
        // Edit Mode Confirm Button - Edit modundayken sağ üstte
        if (_editMode)
          Positioned(
            top: 70,
            right: 20,
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.8),
                borderRadius: BorderRadius.circular(25),
                border:
                    Border.all(color: Colors.white.withOpacity(0.8), width: 2),
              ),
              child: IconButton(
                onPressed: () {
                  _toggleEditMode();
                  _showSettingsDialog();
                },
                icon: const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 28,
                ),
              ),
            ),
          ),
        // Quick Attack Button
        Positioned(
          left: _quickAttackConfig.position.dx,
          top: _quickAttackConfig.position.dy,
          child: _buildAbilityButton(
            controller: _quickAttackController,
            available: _quickAttackAvailable,
            activeImagePath: 'assets/images/quick_attack_active.png',
            passiveImagePath: 'assets/images/quick_attack_passive.png',
            config: _quickAttackConfig,
            onPositionChanged: (newPosition) {
              final safeX = newPosition.dx
                  .clamp(0.0, screenSize.width - _quickAttackConfig.size);
              final safeY = newPosition.dy
                  .clamp(0.0, screenSize.height - _quickAttackConfig.size);
              final safePosition = Offset(safeX, safeY);

              setState(() {
                _quickAttackConfig.position = safePosition;
              });
              print('Quick Attack position updated: $safePosition');
            },
            onSizeChanged: (newSize) {
              setState(() {
                _quickAttackConfig.size = newSize;
              });
            },
            onPressed: () {
              if (widget.game.hasLoaded) {
                widget.game.ninja.quickAttack();
                _startCooldown(Ability.quick);
              }
            },
          ),
        ),
        // Camouflage Button
        Positioned(
          left: _camouflageConfig.position.dx,
          top: _camouflageConfig.position.dy,
          child: _buildAbilityButton(
            controller: _camouflageController,
            available: _camouflageAvailable,
            activeImagePath: 'assets/images/kamuflaj_active.png',
            passiveImagePath: 'assets/images/kamuflaj_passive.png',
            config: _camouflageConfig,
            onPositionChanged: (newPosition) {
              final safeX = newPosition.dx
                  .clamp(0.0, screenSize.width - _camouflageConfig.size);
              final safeY = newPosition.dy
                  .clamp(0.0, screenSize.height - _camouflageConfig.size);
              final safePosition = Offset(safeX, safeY);

              setState(() {
                _camouflageConfig.position = safePosition;
              });
              print('Camouflage position updated: $safePosition');
            },
            onSizeChanged: (newSize) {
              setState(() {
                _camouflageConfig.size = newSize;
              });
            },
            onPressed: () {
              if (widget.game.hasLoaded) {
                widget.game.ninja.toggleCamouflage();
                _startCooldown(Ability.camouflage);
              }
            },
          ),
        ),
        // Throw Sword Button
        Positioned(
          left: _throwSwordConfig.position.dx,
          top: _throwSwordConfig.position.dy,
          child: _buildAbilityButton(
            controller: _throwSwordController,
            available: _throwSwordAvailable,
            activeImagePath: 'assets/images/throw_sword2_active.png',
            passiveImagePath: 'assets/images/throw_sword2_passive.png',
            config: _throwSwordConfig,
            onPositionChanged: (newPosition) {
              final safeX = newPosition.dx
                  .clamp(0.0, screenSize.width - _throwSwordConfig.size);
              final safeY = newPosition.dy
                  .clamp(0.0, screenSize.height - _throwSwordConfig.size);
              final safePosition = Offset(safeX, safeY);

              setState(() {
                _throwSwordConfig.position = safePosition;
              });
              print('Throw Sword position updated: $safePosition');
            },
            onSizeChanged: (newSize) {
              setState(() {
                _throwSwordConfig.size = newSize;
              });
            },
            onPressed: () {
              if (widget.game.hasLoaded) {
                widget.game.ninja.throwSword();
                _startCooldown(Ability.throwSword);
              }
            },
          ),
        ),
      ],
    );
  }
}
