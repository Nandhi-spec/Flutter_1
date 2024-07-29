import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:video_trimmer/video_trimmer.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io'; // Importing dart:io to use the File class

import 'chat_page.dart';

class VideoEditorPage extends StatefulWidget {
  const VideoEditorPage({Key? key}) : super(key: key);

  @override
  _VideoEditorPageState createState() => _VideoEditorPageState();
}

class _VideoEditorPageState extends State<VideoEditorPage> {
  final Trimmer _trimmer = Trimmer();
  VideoPlayerController? _videoController;
  AudioPlayer _audioPlayer = AudioPlayer();
  String? _audioFilePath;
  List<XFile> _imageSequence = [];
  String? _videoFilePath;
  String? _outputFilePath;
  double _startValue = 0.0;
  double _endValue = 0.0;

  Future<void> _importVideo() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.video);
    if (result != null) {
      String? filePath = result.files.single.path;
      if (filePath != null) {
        _videoFilePath = filePath;
        await _trimmer.loadVideo(videoFile: File(filePath));
        setState(() {});
      }
    }
  }

  Future<void> _importAudio() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.audio);
    if (result != null) {
      String? filePath = result.files.single.path;
      if (filePath != null) {
        setState(() {
          _audioFilePath = filePath;
        });
      }
    }
  }

  Future<void> _importImages() async {
    final picker = ImagePicker();
    final List<XFile>? images = await picker.pickMultiImage();
    if (images != null) {
      setState(() {
        _imageSequence = images;
      });
    }
  }

  Future<void> _saveTrimmedVideo() async {
    await _trimmer.saveTrimmedVideo(
      startValue: _startValue,
      endValue: _endValue,
      onSave: (outputPath) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Video saved at $outputPath')));
        setState(() {
          _outputFilePath = outputPath;
        });
      },
    );
  }

  void _play() {
    if (_audioFilePath != null) {
      _audioPlayer.play(_audioFilePath!, isLocal: true);
    }
    _videoController?.play();
  }

  void _pause() {
    _audioPlayer.pause();
    _videoController?.pause();
  }

  Future<void> _applyFilter() async {
    if (_videoFilePath != null) {
      String outputFilePath = "/path/to/output.mp4";
      // Apply filter using FFmpegKit (You need to implement this part)
      // For example:
      // await FFmpegKit.execute('-i $_videoFilePath -vf edgedetect $outputFilePath');
      setState(() {
        _outputFilePath = outputFilePath;
      });
    }
  }

  Future<void> _createMovieFromImages() async {
    // Example movie creation from images using FFmpeg (You need to integrate FFmpeg)
    // This is a placeholder for image sequencing
    if (_imageSequence.isNotEmpty) {
      String outputFilePath = "/path/to/output_movie.mp4";
      // Use FFmpegKit to create a movie from the images
      // FFmpegKit.execute('-framerate 1 -i image%d.jpg -c:v libx264 -r 30 -pix_fmt yuv420p $outputFilePath');
      setState(() {
        _outputFilePath = outputFilePath;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Video Editor Page'),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            const DrawerHeader(
              child: Text('Options'),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              title: const Text('Chat'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatPage(outputFilePath: _outputFilePath),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            ElevatedButton.icon(
              onPressed: _importVideo,
              icon: const Icon(Icons.video_library),
              label: const Text('Import Video'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                textStyle: const TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: _importAudio,
              icon: const Icon(Icons.audiotrack),
              label: const Text('Import Audio'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                textStyle: const TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: _importImages,
              icon: const Icon(Icons.image),
              label: const Text('Import Images'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                textStyle: const TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 20),
            if (_videoFilePath != null)
              Expanded(
                child: Column(
                  children: [
                    AspectRatio(
                      aspectRatio: 16 / 9,
                      child: VideoViewer(trimmer: _trimmer),
                    ),
                    TrimEditor(
                      trimmer: _trimmer,
                      viewerHeight: 50.0,
                      viewerWidth: MediaQuery.of(context).size.width,
                      maxVideoLength: const Duration(seconds: 30),
                      onChangeStart: (value) {
                        setState(() {
                          _startValue = value;
                        });
                      },
                      onChangeEnd: (value) {
                        setState(() {
                          _endValue = value;
                        });
                      },
                      onChangePlaybackState: (controller) {
                        setState(() {
                          _videoController = controller as VideoPlayerController;
                        });
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: _play,
                          child: const Icon(Icons.play_arrow),
                        ),
                        ElevatedButton(
                          onPressed: _pause,
                          child: const Icon(Icons.pause),
                        ),
                      ],
                    ),
                    ElevatedButton.icon(
                      onPressed: _saveTrimmedVideo,
                      icon: const Icon(Icons.save),
                      label: const Text('Save Trimmed Video'),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        textStyle: const TextStyle(fontSize: 18),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton.icon(
                      onPressed: _applyFilter,
                      icon: const Icon(Icons.filter),
                      label: const Text('Apply Filter'),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        textStyle: const TextStyle(fontSize: 18),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton.icon(
                      onPressed: _createMovieFromImages,
                      icon: const Icon(Icons.movie),
                      label: const Text('Create Movie from Images'),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        textStyle: const TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
