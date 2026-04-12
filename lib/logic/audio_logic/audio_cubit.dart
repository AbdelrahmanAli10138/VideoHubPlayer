import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart' show AudioRecorder, RecordConfig;

part 'audio_state.dart';

class AudioCubit extends Cubit<AudioState> {
  AudioCubit() : super(AudioInitial());
  final record = AudioRecorder();

  Future<void> startRecording() async {
    try {
      if (await record.hasPermission()) {
        final directory = await getApplicationDocumentsDirectory();
        final path =
            '${directory.path}/record_${DateTime.now().millisecondsSinceEpoch}.m4a';
        await record.start(RecordConfig(), path: path);
        emit(AudioRecording());
      } else {
        emit(AudioError(message: 'Microphone Permission Denied'));
      }
    } catch (e) {
      emit(AudioError(message: "Error Starting Record: $e"));
    }
  }

  Future<void> stopRecording() async {
    try {
      final path = await record.stop();
      if (path != null) {
        emit(AudioRecordingSuccess(path: path));
      }
    } catch (e) {
      AudioError(message: "Error Stopping Record: $e");
    }
  }
}
