import 'dart:io';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_hub/core/Themes/app_theme.dart';
import 'package:video_hub/presentation/Screens/video_view_screen.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen>
    with SingleTickerProviderStateMixin {
  List<AssetEntity> videos = [];
  List<File> audioFiles = [];
  bool isLoading = true;
  String statusMessage = "Loading...";
  late TabController _tabController;

  late final PlayerController playerController;
  int? playingIndex;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    playerController = PlayerController();
    checkPermissionAndLoad();

    playerController.onPlayerStateChanged.listen((state) {
      if (state == PlayerState.stopped || state == PlayerState.paused) {
        if (mounted) {
          setState(() => playingIndex = null);
        }
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loadAllMedia();
  }

  @override
  void dispose() {
    _tabController.dispose();
    playerController.dispose();
    super.dispose();
  }

  Future<void> checkPermissionAndLoad() async {
    try {
      final PermissionState ps = await PhotoManager.requestPermissionExtend();
      if (ps.isAuth || ps.hasAccess) {
        await loadAllMedia();
      } else {
        setState(() {
          isLoading = false;
          statusMessage = "Permission Denied!";
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        statusMessage = "Error: $e";
      });
    }
  }

  Future<void> loadAllMedia() async {
    try {
      List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(
        type: RequestType.video,
      );
      if (albums.isNotEmpty) {
        final int assetCount = await albums[0].assetCountAsync;
        videos = await albums[0].getAssetListPaged(page: 0, size: assetCount);
      }
      final directory = await getApplicationDocumentsDirectory();
      final List<FileSystemEntity> files = directory.listSync();

      audioFiles =
          files
              .whereType<File>()
              .where((file) => file.path.endsWith('.m4a'))
              .toList()
            ..sort(
              (a, b) => b.lastModifiedSync().compareTo(a.lastModifiedSync()),
            );

      if (mounted) {
        setState(() {
          isLoading = false;
          statusMessage = (videos.isEmpty && audioFiles.isEmpty)
              ? "No Media Found"
              : "";
        });
      }
    } catch (e) {
      debugPrint("Error loading media: $e");
    }
  }

  Future<void> _playAudio(String path, int index) async {
    try {
      if (playingIndex == index) {
        await playerController.pausePlayer();
        setState(() => playingIndex = null);
      } else {
        await playerController.preparePlayer(
          path: path,
          shouldExtractWaveform: false,
        );
        await playerController.startPlayer();
        setState(() => playingIndex = index);
      }
    } catch (e) {
      debugPrint("Error playing audio: $e");
    }
  }

  void _showDeleteDialog(File file, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.secondary,
        title: const Text(
          "Delete Record",
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          "Are you sure you want to delete this recording?",
          style: TextStyle(color: Colors.grey),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel", style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            onPressed: () async {
              try {
                if (file.existsSync()) {
                  await file.delete();
                  setState(() {
                    audioFiles.removeAt(index);
                  });
                }
                if (mounted) Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Recording deleted")),
                );
              } catch (e) {
                debugPrint("Error deleting file: $e");
              }
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary,
      appBar: AppBar(
        backgroundColor: AppColors.secondary,
        elevation: 0,
        toolbarHeight: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.primary,
          labelColor: AppColors.primary,
          unselectedLabelColor: Colors.grey,
          tabs: const [
            Tab(icon: Icon(Icons.video_library), text: "Videos"),
            Tab(icon: Icon(Icons.mic), text: "Audios"),
          ],
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [_buildVideoGrid(), _buildAudioList()],
            ),
    );
  }

  Widget _buildVideoGrid() {
    return RefreshIndicator(
      onRefresh: loadAllMedia,
      color: AppColors.primary,
      child: videos.isEmpty
          ? ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.35),
                Center(
                  child: Text(
                    "No Videos",
                    style: TextStyle(color: AppColors.tertiary),
                  ),
                ),
              ],
            )
          : GridView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(8),
              itemCount: videos.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 6,
                mainAxisSpacing: 6,
              ),
              itemBuilder: (context, index) {
                final video = videos[index];
                return InkWell(
                  onTap: () async {
                    final File? file = await video.file;
                    if (file != null && context.mounted) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              VideoViewScreen(videoPath: file.path),
                        ),
                      );
                    }
                  },
                  child: _buildThumbnail(video),
                );
              },
            ),
    );
  }

  Widget _buildAudioList() {
    return RefreshIndicator(
      onRefresh: loadAllMedia,
      color: AppColors.primary,
      child: audioFiles.isEmpty
          ? ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.35),
                Center(
                  child: Text(
                    "No Audios",
                    style: TextStyle(color: AppColors.tertiary),
                  ),
                ),
              ],
            )
          : ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(10),
              itemCount: audioFiles.length,
              itemBuilder: (context, index) {
                final audio = audioFiles[index];
                final bool isCurrentPlaying = playingIndex == index;

                return Card(
                  color: isCurrentPlaying
                      ? AppColors.primary.withOpacity(0.2)
                      : Colors.white10,
                  margin: const EdgeInsets.only(bottom: 10),
                  child: ListTile(
                    leading: Icon(
                      isCurrentPlaying
                          ? Icons.spatial_audio_off
                          : Icons.music_note,
                      color: isCurrentPlaying ? AppColors.primary : Colors.blue,
                    ),
                    title: Text(
                      audio.path.split('/').last,
                      style: const TextStyle(color: Colors.white, fontSize: 13),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      "Date: ${FileStat.statSync(audio.path).modified.toString().split('.')[0]}",
                      style: const TextStyle(color: Colors.grey, fontSize: 11),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.delete_outline,
                            color: Colors.redAccent,
                            size: 22,
                          ),
                          onPressed: () => _showDeleteDialog(audio, index),
                        ),
                        IconButton(
                          icon: Icon(
                            isCurrentPlaying
                                ? Icons.pause_circle_filled
                                : Icons.play_arrow,
                            color: isCurrentPlaying
                                ? Colors.orange
                                : Colors.green,
                            size: 30,
                          ),
                          onPressed: () => _playAudio(audio.path, index),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  Widget _buildThumbnail(AssetEntity video) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Stack(
        children: [
          Positioned.fill(
            child: Image(
              image: AssetEntityImageProvider(
                video,
                isOriginal: false,
                thumbnailSize: const ThumbnailSize.square(250),
              ),
              fit: BoxFit.cover,
            ),
          ),
          const Center(
            child: Icon(
              Icons.play_circle_fill,
              color: Colors.white70,
              size: 35,
            ),
          ),
        ],
      ),
    );
  }
}
