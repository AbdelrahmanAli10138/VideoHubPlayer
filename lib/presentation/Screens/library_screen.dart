import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';
import 'package:video_hub/core/Themes/app_theme.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  List<AssetEntity> videos = [];
  bool isLoading = true;
  String statusMessage = "Checking Permission...";

  @override
  void initState() {
    super.initState();
    print("--- DEBUG: initState started ---");
    checkPermissionAndLoad();
  }

  Future<void> checkPermissionAndLoad() async {
    try {
      print("--- DEBUG: Requesting Permission ---");

      // take a permission to access the videos in the app
      final PermissionState ps = await PhotoManager.requestPermissionExtend();

      print("--- DEBUG: Permission Status: $ps ---");

      if (ps.isAuth || ps.hasAccess) {
        print("--- DEBUG: Access Granted! Loading Videos... ---");
        setState(() => statusMessage = "Loading Videos...");
        await loadVideos();
      } else {
        print("--- DEBUG: Access Denied! ---");
        setState(() {
          isLoading = false;
          statusMessage = "Permission Denied! Status: $ps";
        });
      }
    } catch (e) {
      print("--- DEBUG: Error in Permission: $e ---");
      setState(() {
        isLoading = false;
        statusMessage = "Permission Error: $e";
      });
    }
  }

  Future<void> loadVideos() async {
    try {
      print("--- DEBUG: Fetching Album List ---");

      // 1. جلب قائمة الألبومات التي تحتوي على فيديوهات
      List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(
        type: RequestType.video,
      );

      if (albums.isNotEmpty) {
        print(
          "--- DEBUG: Found ${albums.length} albums. Fetching from first one ---",
        );

        // fetch first 50 videos
        final List<AssetEntity> result = await albums[0].getAssetListPaged(
          page: 0,
          size: 50,
        );

        print("--- DEBUG: Found ${result.length} videos ---");

        if (mounted) {
          setState(() {
            videos = result;
            isLoading = false;
            statusMessage = result.isEmpty ? "No videos found" : "";
          });
        }
      } else {
        print("--- DEBUG: No albums found ---");
        setState(() {
          isLoading = false;
          statusMessage = "No video albums found";
        });
      }
    } catch (e) {
      print("--- DEBUG: Error in loadVideos: $e ---");
      setState(() {
        isLoading = false;
        statusMessage = "Failed to load videos: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.secondary,
      body: Column(
        children: [
          Gap(size.height * 0.01),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextFormField(
              decoration: InputDecoration(
                hintText: "Search",
                hintStyle: TextStyle(
                  color: AppColors.whiteColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                suffixIcon: Icon(Icons.search),
                fillColor: AppColors.secondary,
                filled: true,
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {},
            ),
          ),
          Gap(size.height * .01),
          Expanded(
            child: isLoading
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CircularProgressIndicator(),
                        const SizedBox(height: 20),
                        Text(
                          statusMessage,
                          style: TextStyle(color: AppColors.tertiary),
                        ),
                      ],
                    ),
                  )
                : videos.isEmpty
                ? Center(
                    child: Text(
                      statusMessage,
                      style: TextStyle(color: AppColors.tertiary),
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
                      return _buildThumbnail(video);
                    },
                  ),
          ),
        ],
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
              errorBuilder: (context, error, stackTrace) => Container(
                color: Colors.grey[900],
                child: const Icon(Icons.error, color: Colors.white),
              ),
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
