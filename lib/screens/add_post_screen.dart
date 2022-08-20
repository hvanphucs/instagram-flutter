import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_flutter/models/user.dart' as model;
import 'package:instagram_flutter/providers/user_provider.dart';
import 'package:instagram_flutter/resources/firestore_methods.dart';
import 'package:instagram_flutter/utils/colors.dart';
import 'package:instagram_flutter/utils/utils.dart';
import 'package:provider/provider.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  Uint8List? _file;
  late final TextEditingController _descriptionEditingController;
  late bool _isLoading;

  void postImage(
    String uid,
    String username,
    String profImage,
  ) async {
    try {
      setState(() {
        _isLoading = true;
      });

      String res = await FirestoreMethods().uploadPost(
        _descriptionEditingController.text,
        _file!,
        uid,
        username,
        profImage,
      );
      setState(() {
        _isLoading = false;
      });

      if (!mounted) return;
      if (res != 'success') {
        showSnackBar(res, context);
      } else {
        showSnackBar('Posted!', context);
      }
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
  }

  @override
  void initState() {
    _descriptionEditingController = TextEditingController();
    _isLoading = false;
    super.initState();
  }

  @override
  void dispose() {
    _descriptionEditingController.dispose();
    super.dispose();
  }

  void _selectImage(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text('Create a Post'),
            children: [
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Take a photo'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List? file = await pickImage(
                    ImageSource.camera,
                  );

                  setState(() {
                    _file = file;
                  });
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Choose file from gallaxy'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List? file = await pickImage(
                    ImageSource.gallery,
                  );

                  setState(() {
                    _file = file;
                  });
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Cancel'),
                onPressed: () async {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  void _removeImage() {
    setState(() {
      _file = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final model.User user = Provider.of<UserProvider>(context).getUser;

    return _file == null
        ? Center(
            child: IconButton(
              onPressed: () {
                _selectImage(context);
              },
              icon: const Icon(Icons.upload),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              leading: IconButton(
                onPressed: () => _removeImage(),
                icon: const Icon(Icons.arrow_back),
              ),
              title: const Text('Post to'),
              centerTitle: false,
              actions: [
                TextButton(
                  onPressed: _isLoading
                      ? null
                      : () => postImage(
                            user.uid,
                            user.username,
                            user.photoUrl,
                          ),
                  child: const Text(
                    'Post',
                    style: TextStyle(
                      color: Colors.blueAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
            body: Column(children: [
              _isLoading
                  ? const LinearProgressIndicator()
                  : const Padding(
                      padding: EdgeInsets.only(top: 0),
                    ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(user.photoUrl),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: TextField(
                      controller: _descriptionEditingController,
                      decoration: const InputDecoration(
                        hintText: 'Write a caption...',
                        border: InputBorder.none,
                      ),
                      maxLines: 8,
                    ),
                  ),
                  SizedBox(
                    height: 45,
                    width: 45,
                    child: AspectRatio(
                      aspectRatio: 487 / 451,
                      child: Container(
                          decoration: BoxDecoration(
                        image: DecorationImage(
                          image: MemoryImage(_file!),
                          fit: BoxFit.fill,
                          alignment: FractionalOffset.topCenter,
                        ),
                      )),
                    ),
                  ),
                  const Divider(),
                ],
              )
            ]),
          );
  }
}
