import 'dart:io' show File;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // لا تنسى إضافة bloc
import 'package:gap/gap.dart';
import 'package:video_hub/core/Themes/app_theme.dart';
import 'package:video_hub/logic/audio_logic/audio_cubit.dart';
import 'package:video_hub/model/services/image_picker_services.dart';
import 'package:video_hub/model/services/shared_prefs_services.dart';
import 'package:video_hub/presentation/Screens/settings_screen.dart';
import 'package:video_hub/presentation/Screens/library_screen.dart';
import 'package:video_hub/presentation/Widgets/custom_home_stack.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;
  File? pickedImage;
  String userName = "User";

  final List<String> appBarTitles = ["Welcome Back", "Library", "Settings"];

  late List<Widget> screens;

  @override
  void initState() {
    super.initState();
    displayProfileImage();
    displayUserName();

    screens = [
      HomeContent(onCaptureVideo: captureVideo, onCaptureRecord: captureAudio),
      const LibraryScreen(),
      SettingsScreen(),
    ];
  }

  Future<void> displayProfileImage() async {
    final String? path = await SharedPrefsService.getProfileImage();
    setState(() {
      pickedImage = (path != null) ? File(path) : null;
    });
  }

  Future<void> displayUserName() async {
    final String? name = await SharedPrefsService.getUserName();
    setState(() {
      userName = (name != null && name.isNotEmpty) ? name : "User";
    });
  }

  // دالة تسجيل الفيديو
  Future<void> captureVideo() async {
    File? videoFile = await ImagePickerService().pickVideoFromCamera();
    if (videoFile != null) {
      setState(() {
        currentIndex = 1;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Video Saved To Library")));
    }
  }

  // دالة تسجيل الصوت المرتبطة بالكيوبيت
  void captureAudio() {
    final audioCubit = context.read<AudioCubit>();
    if (audioCubit.state is AudioRecording) {
      audioCubit.stopRecording();
    } else {
      audioCubit.startRecording();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AudioCubit, AudioState>(
      listener: (context, state) {
        if (state is AudioRecording) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Recording Started..."),
              backgroundColor: Colors.red,
              duration: Duration(milliseconds: 500),
            ),
          );
        } else if (state is AudioRecordingSuccess) {
          setState(() {
            currentIndex = 1; // الانتقال للمكتبة بعد النجاح
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Audio Saved To Library")),
          );
        } else if (state is AudioError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.secondary,
        appBar: AppBar(
          backgroundColor: AppColors.secondary,
          elevation: 0,
          title: Text(
            currentIndex == 0
                ? "Welcome Back, $userName"
                : appBarTitles[currentIndex],
          ),
          centerTitle: false,
          titleTextStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          leading: currentIndex == 0
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    radius: 100,
                    backgroundColor: AppColors.primary,
                    backgroundImage: pickedImage != null
                        ? FileImage(pickedImage!)
                        : null,
                    child: pickedImage == null
                        ? const Icon(
                            Icons.person,
                            size: 20,
                            color: Colors.white,
                          )
                        : null,
                  ),
                )
              : null,
        ),
        body: IndexedStack(index: currentIndex, children: screens),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (index) {
            setState(() {
              currentIndex = index;
            });
            if (index == 0) {
              displayProfileImage();
              displayUserName();
            }
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: AppColors.secondary,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: Colors.grey,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(
              icon: Icon(Icons.video_library),
              label: "Library",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: "Settings",
            ),
          ],
        ),
      ),
    );
  }
}

// محتوى صفحة الهوم تم تعديله ليستخدم BlocBuilder لتحديث شكل زر الريكورد
class HomeContent extends StatelessWidget {
  const HomeContent({
    super.key,
    required this.onCaptureVideo,
    required this.onCaptureRecord,
  });
  final VoidCallback onCaptureVideo;
  final VoidCallback onCaptureRecord;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AudioCubit, AudioState>(
      builder: (context, state) {
        // التحقق من حالة التسجيل الحالية
        final bool isRecording = state is AudioRecording;

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Start Recording",
                  style: TextStyle(
                    color: AppColors.whiteColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                  ),
                ),
              ),
              const Gap(20),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    CustomHomeStack(
                      onTap: onCaptureVideo,
                      backgroundColor: AppColors.tertiary,
                      positionedicon: Icon(
                        Icons.video_camera_back,
                        size: 38,
                        color: AppColors.black,
                      ),
                      positionedString: "Capture Video",
                      stringColor: AppColors.black,
                    ),
                    const Spacer(),
                    CustomHomeStack(
                      onTap: onCaptureRecord,
                      // تغيير اللون للأحمر إذا كان التسجيل جارياً
                      backgroundColor: isRecording
                          ? Colors.red
                          : AppColors.darkBlue,
                      positionedString: isRecording
                          ? "Stop Now"
                          : "Record Audio",
                      stringColor: isRecording
                          ? Colors.white
                          : AppColors.tertiary,
                      positionedicon: Icon(
                        isRecording
                            ? Icons.stop_circle
                            : Icons.mic_none_rounded,
                        size: 38,
                        color: isRecording ? Colors.white : AppColors.tertiary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
