import 'dart:async';

class TimerHandler {
  Timer? _timer;
  Duration duration;
  Function? _callback;

  TimerHandler(this.duration);

  void startTimer(Function callback) {
    // Timer abbrechen, wenn er aktiv ist
    _timer?.cancel();

    _callback = callback;

    _timer = Timer(const Duration(seconds: 2), () {
      // Timer ist abgelaufen, Callback aufrufen
      if (_callback != null) {
        _callback!();
      }
    });
  }

  void restartTimer() {
    // Timer abbrechen, wenn er aktiv ist
    _timer?.cancel();

    // Timer erneut starten
    startTimer(_callback ?? () {});
  }
}
