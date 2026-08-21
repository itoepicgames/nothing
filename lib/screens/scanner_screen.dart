import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../l10n.dart';
import '../models/scan_item.dart';
import '../services/qr_parser.dart';
import '../widgets/scan_frame.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key, required this.t, required this.hapticsEnabled});
  final T t;
  final bool hapticsEnabled;

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> with WidgetsBindingObserver {
  late final MobileScannerController _controller = MobileScannerController(
    autoStart: false,
    detectionSpeed: DetectionSpeed.normal,
    detectionTimeoutMs: 450,
    formats: const [BarcodeFormat.qrCode],
  );
  final ImagePicker _picker = ImagePicker();
  bool _processing = false;
  String? _error;
  Timer? _unlockTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) => _startCamera());
  }

  Future<void> _startCamera() async {
    if (!mounted) return;
    try {
      await _controller.start();
    } on MobileScannerException catch (e) {
      if (!mounted) return;
      setState(() => _error = e.errorCode == MobileScannerErrorCode.permissionDenied
          ? widget.t.cameraDenied
          : e.errorCode == MobileScannerErrorCode.unsupported
              ? widget.t.cameraUnavailable
              : widget.t.scanError);
    } catch (_) {
      if (mounted) setState(() => _error = widget.t.scanError);
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && !_processing) {
      unawaited(_controller.start());
    } else if (state == AppLifecycleState.inactive || state == AppLifecycleState.paused) {
      unawaited(_controller.stop());
    }
  }

  Future<void> _onDetect(BarcodeCapture capture) async {
    if (_processing) return;
    final value = capture.barcodes
        .map((barcode) => barcode.rawValue?.trim())
        .whereType<String>()
        .firstWhere((value) => value.isNotEmpty, orElse: () => '');
    if (value.isEmpty) return;

    _processing = true;
    _unlockTimer?.cancel();
    await _controller.stop();
    if (widget.hapticsEnabled) await HapticFeedback.mediumImpact();
    if (!mounted) return;
    Navigator.of(context).pop(
      ScanItem(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        rawValue: value,
        type: QrParser.typeOf(value),
        createdAt: DateTime.now(),
      ),
    );
  }

  Future<void> _pickImage() async {
    if (_processing) return;
    final image = await _picker.pickImage(source: ImageSource.gallery);
    if (image == null || !mounted) return;
    setState(() => _processing = true);
    try {
      final result = await _controller.analyzeImage(
        image.path,
        formats: const [BarcodeFormat.qrCode],
      );
      final value = result?.barcodes
          .map((barcode) => barcode.rawValue?.trim())
          .whereType<String>()
          .firstWhere((value) => value.isNotEmpty, orElse: () => '');
      if (value.isEmpty) {
        if (mounted) _showMessage(widget.t.noQrFound);
        setState(() => _processing = false);
        await _controller.start();
        return;
      }
      if (widget.hapticsEnabled) await HapticFeedback.mediumImpact();
      await _controller.stop();
      if (!mounted) return;
      Navigator.of(context).pop(
        ScanItem(
          id: DateTime.now().microsecondsSinceEpoch.toString(),
          rawValue: value,
          type: QrParser.typeOf(value),
          createdAt: DateTime.now(),
        ),
      );
    } catch (_) {
      if (mounted) {
        _showMessage(widget.t.invalidQr);
        setState(() => _processing = false);
        await _controller.start();
      }
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _unlockTimer?.cancel();
    unawaited(_controller.stop());
    unawaited(_controller.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                final scanRect = Rect.fromCenter(
                  center: Offset(constraints.maxWidth / 2, constraints.maxHeight * .48),
                  width: constraints.maxWidth * .82,
                  height: constraints.maxWidth * .82,
                );
                return MobileScanner(
                  controller: _controller,
                  scanWindow: scanRect,
                  onDetect: _onDetect,
                  errorBuilder: (context, error) => _ScannerError(message: _error ?? _cameraError(error)),
                  placeholderBuilder: (_) => const ColoredBox(color: Colors.black),
                );
              },
            ),
            const Positioned.fill(child: IgnorePointer(child: ScanFrame())),
            Positioned(
              top: 12,
              left: 16,
              right: 16,
              child: Row(
                children: [
                  _GlassButton(icon: Icons.arrow_back_rounded, onPressed: () => Navigator.of(context).pop()),
                  const Spacer(),
                  ValueListenableBuilder<MobileScannerState>(
                    valueListenable: _controller,
                    builder: (context, state, _) {
                      final enabled = state.torchState == TorchState.on;
                      final unavailable = state.torchState == TorchState.unavailable;
                      return _GlassButton(
                        icon: enabled ? Icons.flash_on_rounded : Icons.flash_off_rounded,
                        onPressed: unavailable ? null : _controller.toggleTorch,
                      );
                    },
                  ),
                ],
              ),
            ),
            Positioned(
              top: constraintsForTop(context),
              left: 24,
              right: 24,
              child: Text(
                widget.t.pointCamera,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, shadows: [Shadow(blurRadius: 10)]),
              ),
            ),
            Positioned(
              left: 22,
              right: 22,
              bottom: 24,
              child: Row(
                children: [
                  Expanded(
                    child: _BottomAction(
                      icon: Icons.photo_library_outlined,
                      label: widget.t.gallery,
                      onTap: _processing ? null : _pickImage,
                    ),
                  ),
                ],
              ),
            ),
            if (_processing)
              const Positioned.fill(
                child: ColoredBox(
                  color: Color(0x55000000),
                  child: Center(child: CircularProgressIndicator()),
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _cameraError(MobileScannerException error) {
    return switch (error.errorCode) {
      MobileScannerErrorCode.permissionDenied => widget.t.cameraDenied,
      MobileScannerErrorCode.unsupported => widget.t.cameraUnavailable,
      _ => widget.t.scanError,
    };
  }

  double constraintsForTop(BuildContext context) => MediaQuery.sizeOf(context).height * .17;
}

class _ScannerError extends StatelessWidget {
  const _ScannerError({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.black,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.camera_alt_outlined, color: Colors.white70, size: 52),
              const SizedBox(height: 16),
              Text(message, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 16)),
            ],
          ),
        ),
      ),
    );
  }
}

class _GlassButton extends StatelessWidget {
  const _GlassButton({required this.icon, required this.onPressed});
  final IconData icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withValues(alpha: .35),
      shape: const CircleBorder(),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.white),
        tooltip: null,
      ),
    );
  }
}

class _BottomAction extends StatelessWidget {
  const _BottomAction({required this.icon, required this.label, required this.onTap});
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withValues(alpha: .55),
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white),
              const SizedBox(width: 10),
              Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
            ],
          ),
        ),
      ),
    );
  }
}
