import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tmdb/core/styles/styles_manager.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

class PersonImageScreen extends StatefulWidget {
  String image;
  PersonImageScreen({super.key,required this.image});

  @override
  State<PersonImageScreen> createState() => _PersonImageScreenState();
}

class _PersonImageScreenState extends State<PersonImageScreen> {

  Future<void> saveImage(BuildContext context, String imageUrl) async {
    // Request storage permission
    var status = await Permission.storage.request();
    if (status.isGranted) {
      try {

        final response = await http.get(Uri.parse(imageUrl));

        final directory = await getTemporaryDirectory();

        final fileName = '${DateTime.now().millisecondsSinceEpoch}.png';
        final filePath = '${directory.path}/$fileName';

        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Image saved to: $filePath')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save image: $e')),
        );
      }
    } else if (status.isPermanentlyDenied) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Storage permission is permanently denied. Please enable it in app settings.'),
          action: SnackBarAction(
            label: 'Open Settings',
            onPressed: () => openAppSettings(),
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Storage permission denied')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CachedNetworkImage(
                height: 0.4.sh,
                width: 0.8.sw,
                fit: BoxFit.fill,
                imageUrl: 'https://image.tmdb.org/t/p/w185/${widget.image}',
                placeholder: (context, url) => const SpinKitThreeBounce(
                  size: 30,
                  color: Colors.green,
                ),
                errorWidget: (context, url, error) => CachedNetworkImage(
                  imageUrl: "http://via.placeholder.com/200x150",
                  imageBuilder: (context, imageProvider) => Container(
                    height: 50.h,
                    width: 200.w,
                    decoration: BoxDecoration(
                      image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30,),
              GestureDetector(
                onTap: (){
                  saveImage(context,'https://image.tmdb.org/t/p/w185/${widget.image}');
                },
                child: Container(
                  height: 50,
                  width: 0.7.sw,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.green
                  ),
                  child: Text("Download",style: AppTextStyle.blackBold.copyWith(fontSize: 16.sp,color: Colors.white),),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
