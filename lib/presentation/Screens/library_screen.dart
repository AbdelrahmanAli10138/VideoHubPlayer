import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_hub/core/Themes/app_theme.dart';
import 'video_player_screen.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  List<AssetEntity> videos = [];
  bool isLoading = true;
  bool hasPermission = true;

  @override
  void initState() {
    super.initState();
    checkPermissionAndLoad();
  }

  Future<void> checkPermissionAndLoad() async {
    // طلب الإذن للمستخدم
    var status = await Permission.storage.request();

    if (!status.isGranted) {
      setState(() {
        hasPermission = false;
        isLoading = false;
      });
      return;
    }

    loadVideos();
  }

  Future<void> loadVideos() async {
    List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(
      type: RequestType.video,
    );

    List<AssetEntity> allVideos = [];

    for (var album in albums) {
      final media = await album.getAssetListPaged(page: 0, size: 1000);
      allVideos.addAll(media);
    }

    print("Videos count: ${allVideos.length}");

    setState(() {
      videos = allVideos;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppColors.tertiary),
        backgroundColor: AppColors.secondary,
        title: const Text("Library"),
        titleTextStyle: TextStyle(
          color: AppColors.tertiary,
          fontSize: 26,
          fontWeight: FontWeight.bold,
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Search
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search, color: AppColors.tertiary),
                hintText: "Search videos...",
                hintStyle: TextStyle(color: AppColors.tertiary),
                filled: true,
                fillColor: AppColors.secondary,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          // Content
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : !hasPermission
                ? Center(
                    child: Text(
                      "Storage permission denied 😢",
                      style: TextStyle(color: AppColors.tertiary, fontSize: 18),
                    ),
                  )
                : videos.isEmpty
                ? Center(
                    child: Text(
                      "No videos found",
                      style: TextStyle(color: AppColors.tertiary, fontSize: 18),
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: videos.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 6,
                          mainAxisSpacing: 6,
                        ),
                    itemBuilder: (context, index) {
                      final video = videos[index];

                      return GestureDetector(
                        onTap: () async {
                          final file = await video.file;
                          if (file != null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => VideoPlayerScreen(file.path),
                              ),
                            );
                          }
                        },
                        child: FutureBuilder<Uint8List?>(
                          future: video.thumbnailDataWithSize(
                            const ThumbnailSize(200, 200),
                          ),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                    ConnectionState.done &&
                                snapshot.data != null) {
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Stack(
                                  children: [
                                    Positioned.fill(
                                      child: Image.memory(
                                        snapshot.data!,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    const Center(
                                      child: Icon(
                                        Icons.play_circle_fill,
                                        color: Colors.white,
                                        size: 40,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }
                            return Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.videocam,
                                  color: Colors.white,
                                  size: 30,
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
