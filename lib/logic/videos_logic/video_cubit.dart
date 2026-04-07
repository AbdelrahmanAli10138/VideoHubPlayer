import 'package:bloc/bloc.dart';
import 'package:photo_manager/photo_manager.dart'
    show AssetEntity, AssetPathEntity, PhotoManager, RequestType;
import 'package:video_hub/logic/videos_logic/video_state.dart'
    show VideoLoaded, VideoError, VideoLoading, VideoState, VideoInitial;

class VideoCubit extends Cubit<VideoState> {
  VideoCubit() : super(VideoInitial());

  List<AssetEntity> allVideos = [];

  Future<void> loadVideos() async {
    try {
      emit(VideoLoading());

      List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(
        type: RequestType.video,
      );

      if (albums.isNotEmpty) {
        final result = await albums[0].getAssetListPaged(page: 0, size: 50);
        allVideos = result;
        emit(VideoLoaded(result));
      } else {
        emit(VideoError("No video albums found"));
      }
    } catch (e) {
      emit(VideoError("Failed to load videos: $e"));
    }
  }

  void search(String query) {
    if (query.isEmpty) {
      emit(VideoLoaded(allVideos));
      return;
    }

    final filtered = allVideos.where((video) {
      final name = video.title ?? "";
      return name.toLowerCase().contains(query.toLowerCase());
    }).toList();

    if (filtered.isEmpty) {
      emit(VideoLoaded([], message: "No videos found"));
    } else {
      emit(VideoLoaded(filtered));
    }
  }
}
