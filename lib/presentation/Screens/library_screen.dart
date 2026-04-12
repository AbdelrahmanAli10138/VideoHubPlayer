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

  // ✅ هذه الدالة تضمن تحديث البيانات في كل مرة يتم عرض الصفحة فيها
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
    // لا نضع isLoading هنا لتجنب الوميض المتكرر عند التحديث
    try {
      // 1. جلب الفيديوهات
      List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(
        type: RequestType.video,
      );
      if (albums.isNotEmpty) {
        videos = await albums[0].getAssetListPaged(page: 0, size: 100);
      }

      // 2. جلب الملفات الصوتية من مجلد التطبيق
      final directory = await getApplicationDocumentsDirectory();
      final List<FileSystemEntity> files = directory.listSync();

      // ترتيب الملفات حسب التاريخ (الأحدث أولاً)
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
        // تم استخدام forceRefresh لضمان التشغيل في حال كان هناك ملف محمل مسبقاً
        await playerController.startPlayer();
        setState(() => playingIndex = index);
      }
    } catch (e) {
      debugPrint("Error playing audio: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary,
      appBar: AppBar(
        backgroundColor: AppColors.secondary,
        elevation: 0,
        toolbarHeight: 0, // أخفينا الـ toolbar لتركيز المساحة للـ Tabs
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
    if (videos.isEmpty) {
      return Center(
        child: Text("No Videos", style: TextStyle(color: AppColors.tertiary)),
      );
    }
    return GridView.builder(
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
                  builder: (context) => VideoViewScreen(videoPath: file.path),
                ),
              );
            }
          },
          child: _buildThumbnail(video),
        );
      },
    );
  }

  Widget _buildAudioList() {
    if (audioFiles.isEmpty) {
      return Center(
        child: Text("No Audios", style: TextStyle(color: AppColors.tertiary)),
      );
    }
    return ListView.builder(
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
              isCurrentPlaying ? Icons.spatial_audio_off : Icons.music_note,
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
            trailing: Icon(
              isCurrentPlaying ? Icons.pause_circle_filled : Icons.play_arrow,
              color: isCurrentPlaying ? Colors.orange : Colors.green,
              size: 30,
            ),
            onTap: () => _playAudio(audio.path, index),
          ),
        );
      },
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
