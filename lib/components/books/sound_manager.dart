import 'package:audioplayers/audioplayers.dart';

class SoundManager {
  static final SoundManager _instance = SoundManager._internal();
  factory SoundManager() => _instance;
  SoundManager._internal();

  AudioPlayer? _audioPlayer;
  bool _isInitialized = false;
  bool _isPlaying = false;

  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      _audioPlayer = AudioPlayer();
      await _audioPlayer?.setSource(AssetSource('sounds/page_turn.mp3'));
      await _audioPlayer?.setVolume(0.8); // Set a comfortable volume level
      _isInitialized = true;
    } catch (e) {
      print('Failed to initialize audio player: $e');
      _isInitialized = false;
    }
  }

  Future<void> playPageTurnSound() async {
    if (!_isInitialized || _isPlaying) return;

    try {
      _isPlaying = true;
      await _audioPlayer?.stop();
      await _audioPlayer?.setSource(AssetSource('sounds/page_turn.mp3'));
      await _audioPlayer?.resume();
      await Future.delayed(const Duration(
          milliseconds: 200)); // Reduced delay for snappier feedback
      _isPlaying = false;
    } catch (e) {
      print('Failed to play sound: $e');
      _isPlaying = false;
    }
  }

  void dispose() {
    try {
      _audioPlayer?.dispose();
      _audioPlayer = null;
      _isInitialized = false;
      _isPlaying = false;
    } catch (e) {
      print('Error disposing audio player: $e');
    }
  }
}
