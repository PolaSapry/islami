import 'package:flutter/cupertino.dart';
import 'package:just_audio/just_audio.dart';

class RadioManagerProvider extends ChangeNotifier {
  late AudioPlayer _player;

  String? _currentPlayerUrl;
  late bool _isPlaying;
  late double _currentVolume = 2;

  String? get currentPlayingUrl => _currentPlayerUrl;
  bool get isPlaying => _isPlaying;
  double get currentVolume => _currentVolume;

  RadioManagerProvider() {
    _player = AudioPlayer();
    _player.playerStateStream.listen((state) {
      _isPlaying = state.playing;
      notifyListeners();
    });
  }

  //play
  Future<void> play(String url) async {
    try{
      if (_currentPlayerUrl == url) {
        if (_isPlaying) {
          await _player.pause();
        } else {
          await _player.play();
        }
      }else{
        await _player.stop();
        _currentPlayerUrl = url ;
        await _player.setUrl(url);
        await _player.play();
      }
    }catch (e) {
      print(e.toString());
    }
    }



  //stop
Future<void> stop(String url)async {
    if(_currentPlayerUrl == url ){
      await _player.stop();
      _currentPlayerUrl = null ;
      notifyListeners();
    }
}

Future<void> mute(String url, double volume)async {
    if(_currentPlayerUrl == url ){
      await _player.setVolume(volume);
      _currentVolume = volume ;
      notifyListeners();
    }
}




}
