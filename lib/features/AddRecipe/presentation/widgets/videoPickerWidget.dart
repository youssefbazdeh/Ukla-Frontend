import 'dart:io';
import 'dart:convert';
import 'dart:async';
import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'package:ukla_app/Localizations/app_localizations.dart';
import 'package:ukla_app/core/Presentation/buttons/main_red_button.dart';
import 'package:ukla_app/core/Presentation/inputs/InputField.dart';
import 'package:ukla_app/core/Presentation/resources/colors_manager.dart';
import 'package:ukla_app/core/domain/entities/video.dart';
import 'package:ukla_app/features/AddRecipe/presentation/bloc/creator_recipe_bloc.dart';
import 'package:ukla_app/features/AddRecipe/presentation/bloc/creator_recipe_event.dart';
import 'package:ukla_app/main.dart';

import '../../../../core/Presentation/resources/strings_manager.dart';

class VideoPickerWidget extends StatefulWidget {
  const VideoPickerWidget({super.key});

  @override
  _VideoPickerWidgetState createState() => _VideoPickerWidgetState();
}

class _VideoPickerWidgetState extends State<VideoPickerWidget> {
  final FocusNode _focusNodeTitle = FocusNode();
  final FocusNode _focusNodeDescription = FocusNode();
  BetterPlayerController? _betterPlayerController;
  double _uploadProgress = 0.0;
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  int videoId = 0;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isUploading = false;
  double _uploadedMB = 0.0;
  double _totalMB = 0.0;
  bool update = false;
  bool removeVideo = false;
  late double videoAspectRation = 0;

  Future<Map<String, String>> _getHeaders() async {
    const storage = FlutterSecureStorage();
    final jwt = await storage.read(key: 'jwt');
    if (jwt == null) {
      return {
        'Content-Type': 'application/json',
      };
    }
    return {
      'Authorization': 'Bearer $jwt',
      'Content-Type': 'application/json',
    };
  }

  Future<void> _pickVideo() async {
    final XFile? pickedFile =
    await _picker.pickVideo(source: ImageSource.gallery);

    if (pickedFile != null) {
      _betterPlayerController = BetterPlayerController(
        const BetterPlayerConfiguration(),
        betterPlayerDataSource: BetterPlayerDataSource(
          BetterPlayerDataSourceType.file,
          pickedFile.path,
        ),

      );
      setState(() {
        _betterPlayerController?.play();
        _uploadVideo(File(pickedFile.path));
      });
    } else {
      _betterPlayerController?.dispose();
      setState(() {
        _betterPlayerController = null;
        _uploadProgress = 0.0;
      });
    }
  }

  Future<void> _uploadVideo(File videoFile) async {
    setState(() {
      _isUploading = true;
      _uploadedMB = 0.0;
      _totalMB = videoFile.lengthSync() / (1024 * 1024);
    });
    final headers = await _getHeaders();

    const String uploadUrl =
        "${AppString.SERVER_IP}/ukla/file-system-video/saveVideo";
    var uri = Uri.parse(uploadUrl);

    var request = http.MultipartRequest('POST', uri);
    var fileStream = http.ByteStream(
        videoFile.openRead().transform(StreamTransformer.fromHandlers(
          handleData: (data, sink) {
            sink.add(data);
            setState(() {
              _uploadProgress += data.length / videoFile.lengthSync();
              _uploadedMB += data.length / (1024 * 1024);
              _uploadProgress = _uploadedMB / _totalMB;
            });
          },
        )));
    var length = await videoFile.length();

    var multipartFile = http.MultipartFile('video', fileStream, length,
        filename: videoFile.path.split('/').last);
    request.files.add(multipartFile);
    request.headers.addAll(headers);

    var streamedResponse = await request.send();

    final response = await http.Response.fromStream(streamedResponse);
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      final Video uploadedVideo = Video.fromJson(jsonResponse);

      setState(() {
        _uploadProgress = 1.0;
        videoId = uploadedVideo.id;
        _isUploading = false;
      });
    } else {
      setState(() {
        _uploadProgress = 0.0;
        _isUploading = false;
      });
    }
  }

  @override
  void dispose() {
    _betterPlayerController?.dispose();
    _focusNodeTitle.unfocus();
    _focusNodeDescription.unfocus();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String? recipeTitle =
        Provider.of<CreatorRecipePorvider>(context, listen: false).title;
    String? recipeDescription =
        Provider.of<CreatorRecipePorvider>(context, listen: false).description;
    String? videoUrl =
        Provider.of<CreatorRecipePorvider>(context, listen: false).videoUrl;
    int? id = Provider.of<CreatorRecipePorvider>(context, listen: false).id;
    if (recipeTitle != null && recipeDescription != null) {
      _descriptionController.text = recipeDescription;
      _titleController.text = recipeTitle;
      update = true;
    }
    return Builder(
      builder: (BuildContext context) {
        return GestureDetector(
          onTap: () {
            _focusNodeDescription.unfocus();
            _focusNodeTitle.unfocus();
          },
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'This interface is temporary and under development'
                                .tr(context),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 18,
                              color: AppColors.buttonTextColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'We are working hard to implement the complete Add Recipe feature. Please bear with us while we make these improvements'
                                .tr(context),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  update
                      ? Stack(children: [
                    if (!removeVideo) ...[
                      BetterPlayer.network(videoUrl!),
                      GestureDetector(
                        onTap: () {
                          _pickVideo();
                          removeVideo = true;
                        },
                        child: const Positioned(
                            right: 10,
                            top: 10,
                            child: Icon(Ionicons.close,
                                color: Colors.white, size: 25)),
                      ),
                    ] else ...[
                      GestureDetector(
                        onTap: _pickVideo,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Builder(
                            builder: (BuildContext context) {
                              if (_betterPlayerController != null) {
                                return Column(
                                  children: [
                                    BetterPlayer(controller: _betterPlayerController!),
                                    if (_uploadProgress > 0)
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.grey[200],
                                          borderRadius:
                                          BorderRadius.circular(10),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Column(
                                            children: [
                                              LinearProgressIndicator(
                                                  value: _uploadProgress,
                                                  color:
                                                  AppColors.secondaryColor),
                                              const SizedBox(height: 5),
                                              Text(
                                                  "${_uploadedMB.toStringAsFixed(2)} MB / ${_totalMB.toStringAsFixed(2)} MB "
                                                      " (${(_uploadProgress * 100).toStringAsFixed(0)}%)"),
                                            ],
                                          ),
                                        ),
                                      )
                                    else
                                      Container(),
                                  ],
                                );
                              } else {
                                return Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(100),
                                    child: Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      children: [
                                        const Icon(Icons.video_library,
                                            size: 50, color: Colors.grey),
                                        const SizedBox(height: 10),
                                        Text('no_video'.tr(context)),
                                      ],
                                    ),
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                      ),
                    ]
                  ])
                      : GestureDetector(
                    onTap: _pickVideo,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Builder(
                        builder: (BuildContext context) {
                          if (_betterPlayerController != null) {
                            return Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: AspectRatio(
                                    aspectRatio:
                                    _betterPlayerController!.videoPlayerController!.value.aspectRatio,
                                    child: BetterPlayer(controller: _betterPlayerController!),
                                  ),
                                ),
                                if (_uploadProgress > 0)
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius:
                                      BorderRadius.circular(10),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Column(
                                        children: [
                                          LinearProgressIndicator(
                                              value: _uploadProgress,
                                              color:
                                              AppColors.secondaryColor),
                                          const SizedBox(height: 5),
                                          Text(
                                              "${_uploadedMB.toStringAsFixed(2)} MB / ${_totalMB.toStringAsFixed(2)} MB "
                                                  " (${(_uploadProgress * 100).toStringAsFixed(0)}%)"),
                                        ],
                                      ),
                                    ),
                                  )
                                else
                                  Container(),
                              ],
                            );
                          } else {
                            return Padding(
                              padding: const EdgeInsets.all(100),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.video_library,
                                      size: 50, color: Colors.grey),
                                  const SizedBox(height: 10),
                                  Text('no_video'.tr(context)),
                                ],
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  InputField(
                    key: GlobalKey(),
                    applyPadding: false,
                    focusNode: _focusNodeTitle,
                    labelText: 'Recipe title'.tr(context),
                    hintText: 'Mediterranean Lemon Herb Chicken'.tr(context),
                    textEditingController: _titleController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please insert recipe title'.tr(context);
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: InputField(
                      key: GlobalKey(),
                      applyPadding: false,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      minLines: 5,
                      focusNode: _focusNodeDescription,
                      labelText: 'Description'.tr(context),
                      hintText: 'Steps'.tr(context),
                      textEditingController: _descriptionController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please insert recipe description'.tr(context);
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: MainRedButton(
                      onPressed: _isUploading
                          ? null
                          : () async {
                        if (_formKey.currentState?.validate() ?? false) {
                          if (update) {
                            context.read<CreatorRecipeBloc>().add(UpdateCreatorRecipeEvent(
                                _titleController.text,
                                _descriptionController.text,
                                videoId,
                                id!));
                            Navigator.pop(context);
                          } else {
                            context.read<CreatorRecipeBloc>().add(
                                AddCreatorRecipeEvent(
                                    _titleController.text,
                                    _descriptionController.text,
                                    videoId)
                            );
                            Navigator.pop(context);
                          }
                        }
                      },
                      text: update ? 'Update Recipe'.tr(context) : 'add_recipe'.tr(context),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
