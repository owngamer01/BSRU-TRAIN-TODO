import 'dart:io';
import 'package:flutter/material.dart';
import 'package:todo/utils/image_utils.dart';

class AvatarComponent extends StatefulWidget {

  final File file;
  
  AvatarComponent({
    this.file
  });

  @override
  _AvatarComponentState createState() => _AvatarComponentState();
}

class _AvatarComponentState extends State<AvatarComponent> {

  final String _defaultAvatar = 'assets/avatar_empty.png';
  final imagePick = ImagePick();
  File file;

  void takePhoto() async {
    var newPhoto = await imagePick.takePhoto();
    if (newPhoto == null) return;

    setState(() {
      file = newPhoto;
    });
  }

  @override
  void initState() {
    file = widget.file != null ? File(widget.file.path) : null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: takePhoto,
      child: Container(
        height: 200,
        width: 200,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            fit: file != null ? BoxFit.cover : BoxFit.contain,
            image: file != null ? FileImage(file) : AssetImage(_defaultAvatar)
          )
        ),
      ),
    );
  }
}