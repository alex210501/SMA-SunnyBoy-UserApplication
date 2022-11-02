import 'dart:async';

class StreamPeriodic<T> {
  final Future<T> Function() _callback;
  final int _period;
  late final Timer periodicTimer;
  late final StreamController<T> _controller;

  StreamPeriodic(this._period, this._callback) {
    _controller = StreamController<T>();

    periodicTimer = Timer.periodic(
        Duration(milliseconds: _period), (timer) async {
          _controller.add(await _callback());
    });
  }

  void cancel() {
    periodicTimer.cancel();
  }

  void listen(Function(T value) onData, {Function? onError}) {
    _controller.stream.listen(onData, onError: onError);
  }
}
