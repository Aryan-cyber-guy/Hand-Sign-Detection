import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';

class CameraService {
  CameraController? _controller;
  List<CameraDescription> _cameras = [];
  CameraDescription? _currentCamera;

  CameraController? get controller => _controller;
  CameraDescription? get currentCamera => _currentCamera;

  bool get isCameraInitialized =>
      _controller != null && _controller!.value.isInitialized;

  bool get isFrontCamera =>
      _currentCamera?.lensDirection == CameraLensDirection.front;

  bool get isStreamingImages => _controller?.value.isStreamingImages ?? false;

  // ─────────────────────────────────────────────
  // Fetch cameras
  // ─────────────────────────────────────────────

  Future<void> _fetchCameras() async {
    if (_cameras.isEmpty) {
      _cameras = await availableCameras();
      print("DEBUG: Found ${_cameras.length} cameras");
    }
  }

  // ─────────────────────────────────────────────
  // Init front camera
  // ─────────────────────────────────────────────

  Future<void> initializeFrontCamera() async {
    await _fetchCameras();

    final cam = _cameras.firstWhere(
          (c) => c.lensDirection == CameraLensDirection.front,
      orElse: () => _cameras.first,
    );

    await _initWith(cam);
  }

  // ─────────────────────────────────────────────
  // Init back camera
  // ─────────────────────────────────────────────

  Future<void> initializeBackCamera() async {
    await _fetchCameras();

    final cam = _cameras.firstWhere(
          (c) => c.lensDirection == CameraLensDirection.back,
      orElse: () => _cameras.first,
    );

    await _initWith(cam);
  }

  // ─────────────────────────────────────────────
  // Init selected camera
  // ─────────────────────────────────────────────

  Future<void> _initWith(CameraDescription description) async {
    print("DEBUG: _initWith: ${description.lensDirection}");

    if (_controller != null) {
      if (!kIsWeb && _controller!.value.isStreamingImages) {
        await _controller!.stopImageStream();
      }

      await _controller!.dispose();
      _controller = null;
    }

    _currentCamera = description;

    _controller = CameraController(
      description,
      ResolutionPreset.medium,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    await _controller!.initialize();

    print("DEBUG: CameraController initialized");

    try {
      await _controller!.setFocusMode(
        isFrontCamera ? FocusMode.locked : FocusMode.auto,
      );
    } catch (e) {
      print("DEBUG: setFocusMode not supported — ignoring: $e");
    }

    try {
      await _controller!.setFlashMode(FlashMode.off);
    } catch (_) {}
  }

  // ─────────────────────────────────────────────
  // Start image stream
  // ─────────────────────────────────────────────

  Future<void> startImageStream(
      void Function(CameraImage image) onFrame) async {
    if (_controller == null || !_controller!.value.isInitialized) {
      print("ERROR: Camera not initialized");
      return;
    }

    if (_controller!.value.isStreamingImages) {
      print("DEBUG: Stream already running");
      return;
    }

    if (kIsWeb) {
      print("DEBUG: Web detected — image stream not supported");
      return;
    }

    await _controller!.startImageStream(onFrame);

    print("DEBUG: Image stream started");
  }

  // ─────────────────────────────────────────────
  // Stop image stream
  // ─────────────────────────────────────────────

  Future<void> stopImageStream() async {
    if (kIsWeb) {
      print("DEBUG: Web mode — no stream to stop");
      return;
    }

    if (_controller == null) return;

    if (_controller!.value.isStreamingImages) {
      await _controller!.stopImageStream();
      print("DEBUG: Image stream stopped");
    }
  }

  // ─────────────────────────────────────────────
  // Flash
  // ─────────────────────────────────────────────

  Future<void> setFlashMode(FlashMode mode) async {
    if (_controller == null || !isCameraInitialized) return;

    try {
      await _controller!.setFlashMode(mode);
    } catch (e) {
      print("ERROR setFlashMode: $e");
    }
  }

  // ─────────────────────────────────────────────
  // Capture image for web/manual detection
  // ─────────────────────────────────────────────

  Future<XFile?> captureImage() async {
    if (_controller == null || !_controller!.value.isInitialized) {
      return null;
    }

    try {
      return await _controller!.takePicture();
    } catch (e) {
      print("ERROR captureImage: $e");
      return null;
    }
  }

  // ─────────────────────────────────────────────
  // Dispose
  // ─────────────────────────────────────────────

  Future<void> dispose() async {
    if (_controller != null) {
      if (!kIsWeb && _controller!.value.isStreamingImages) {
        await _controller!.stopImageStream();
      }

      await _controller!.dispose();
      _controller = null;
    }
  }
}