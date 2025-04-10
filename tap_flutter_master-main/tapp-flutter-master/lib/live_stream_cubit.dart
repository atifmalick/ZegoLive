import 'package:bloc/bloc.dart';

import 'live_stream_service.dart';

class LiveStreamState {
  final bool isStreaming;
  final String? streamUrl;

  LiveStreamState({required this.isStreaming, this.streamUrl});
}

class LiveStreamCubit extends Cubit<LiveStreamState> {
  final LiveStreamService _liveStreamService;

  LiveStreamCubit(this._liveStreamService)
      : super(LiveStreamState(isStreaming: false));

  Future<Map<String, dynamic>> startNewStream(
      Map<String, dynamic> input) async {
    try {
      final streamData = await _liveStreamService.startNewStream(input);
      emit(LiveStreamState(
          isStreaming: true, streamUrl: streamData['streamUrl']));
      return streamData;
    } catch (e) {
      // Handle exception
      print('Error starting new stream: $e');
      emit(LiveStreamState(isStreaming: true));
      return {};
    }
  }

  Future<void> joinStream(Map<String, dynamic> input) async {
    try {
      final streamData = await _liveStreamService.joinStream(input);
      emit(LiveStreamState(
          isStreaming: true, streamUrl: streamData['streamUrl']));
    } catch (e) {
      // Handle exception
      print('Error joining stream: $e');
      emit(LiveStreamState(isStreaming: false));
    }
  }

  Future<void> endStream(Map<String, dynamic> input) async {
    try {
      final success = await _liveStreamService.endStream(input);
      if (success) {
        emit(LiveStreamState(isStreaming: false));
      }
    } catch (e) {
      // Handle exception
      print('Error ending stream: $e');
    }
  }
}
