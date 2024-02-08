import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';

import 'MusicService.dart';

class AudioPlayerHandler extends BaseAudioHandler with SeekHandler {
  static final AudioPlayerHandler _instance = AudioPlayerHandler._internal();
  AudioPlayer _audioPlayer = AudioPlayer();

  final _player = AudioPlayer();
  String _imageUrl = '';
  String _title = '';
  String _subtitle = '';
  factory AudioPlayerHandler() {
    return _instance;
  }

  AudioPlayerHandler._internal();

  /// Initialise our audio handler.
  // factory AudioPlayerHandler() {
  //   // So that our clients (the Flutter UI and the system notification) know
  //   // what state to display, here we set up our audio handler to broadcast all
  //   // playback state changes as they happen via playbackState...
  //   _player.playbackEventStream.map(_transformEvent).pipe(playbackState);
  //   // ... and also the current media item via mediaItem.
  //   // mediaItem.add();
  //   return _instance;
  //
  //   // Load the player.
  // }

  Future<void> playSong(String url,String imageUrl, String title, String subtitle,) async {
    try {
      _title = title;
      _subtitle = subtitle;
      _imageUrl = imageUrl;
      await _audioPlayer.setUrl(url);
      await _audioPlayer.play();
    } catch (e) {
      print('Error playing song: $e');
    }
  }

  // In this simple example, we handle only 4 actions: play, pause, seek and
  // stop. Any button press from the Flutter UI, notification, lock screen or
  // headset will be routed through to these 4 methods so that you can handle
  // your audio playback logic in one place.

  @override
  Future<void> play() => _player.play();

  @override
  Future<void> pause() => _player.pause();

  @override
  Future<void> seek(Duration position) => _player.seek(position);

  @override
  Future<void> stop() => _player.stop();

  /// Transform a just_audio event into an audio_service state.
  ///
  /// This method is used from the constructor. Every event received from the
  /// just_audio player will be transformed into an audio_service state so that
  /// it can be broadcast to audio_service clients.
  PlaybackState _transformEvent(PlaybackEvent event) {
    return PlaybackState(
      controls: [
        MediaControl.rewind,
        if (_player.playing) MediaControl.pause else MediaControl.play,
        MediaControl.stop,
        MediaControl.fastForward,
      ],
      systemActions: const {
        MediaAction.seek,
        MediaAction.seekForward,
        MediaAction.seekBackward,
      },
      androidCompactActionIndices: const [0, 1, 3],
      processingState: const {
        ProcessingState.idle: AudioProcessingState.idle,
        ProcessingState.loading: AudioProcessingState.loading,
        ProcessingState.buffering: AudioProcessingState.buffering,
        ProcessingState.ready: AudioProcessingState.ready,
        ProcessingState.completed: AudioProcessingState.completed,
      }[_player.processingState]!,
      playing: _player.playing,
      updatePosition: _player.position,
      bufferedPosition: _player.bufferedPosition,
      speed: _player.speed,
      queueIndex: event.currentIndex,
    );
  }
}