import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tmdb/core/styles/styles_manager.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:android_intent_plus/android_intent.dart';

class PersonImageScreen extends StatefulWidget {
  String image;
  PersonImageScreen({super.key,required this.image});

  @override
  State<PersonImageScreen> createState() => _PersonImageScreenState();
}

class _PersonImageScreenState extends State<PersonImageScreen> {

  Future<bool> requestStoragePermission(BuildContext context) async {
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

    if (androidInfo.version.sdkInt >= 33) {
      // No need to request storage permission on Android 13 or higher
      return true;
    }

    var status = await Permission.storage.status;

    // If permission is permanently denied, guide the user to app settings
    if (status.isPermanentlyDenied) {
      bool isPermanentlyDenied = await openAppSettingsIfPermanentlyDenied(context);
      return isPermanentlyDenied;
    }

    // If permission is denied (but not permanently), show explanation dialog
    if (status.isDenied) {
      showPermissionExplanationDialog(context);
      return false;
    }

    // If permission is not granted yet, request it
    if (!status.isGranted) {
      status = await Permission.storage.request();
    }

    return status.isGranted;
  }

  Future<bool> openAppSettingsIfPermanentlyDenied(BuildContext context) async {
    var status = await Permission.storage.status;

    if (status.isPermanentlyDenied) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Storage permission is permanently denied. Please enable it in the settings.',
          ),
          action: SnackBarAction(
            label: 'Settings',
            onPressed: () async {
              // Open app settings
              await openAppSettings();
            },
          ),
        ),
      );
      return false; // Permission still not granted
    }

    return true; // Permission is granted
  }

  void showPermissionExplanationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Storage Permission Required'),
        content: const Text('This app needs storage access to save images. Please allow storage permission.'),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: const Text('Allow Permission'),
            onPressed: () async {
              Navigator.of(context).pop();
              await Permission.storage.request(); // Re-request permission
            },
          ),
        ],
      ),
    );
  }

  Future<void> saveImage(BuildContext context, String imageUrl) async {
    try {
      // Request storage permission if necessary
      if (!await requestStoragePermission(context)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Storage permission denied')),
        );
        return;
      }

      // Download the image
      final response = await http.get(Uri.parse(imageUrl));

      // Get the device's Pictures directory
      final Directory? picturesDir = await getExternalStorageDirectory();
      final myAppImagesDir = Directory('${picturesDir!.path}/Pictures/MyAppImages'); // Save to Pictures

      // Create the directory if it doesn't exist
      if (!await myAppImagesDir.exists()) {
        await myAppImagesDir.create(recursive: true);
      }

      // Generate a unique filename
      final fileName = 'image_${DateTime.now().millisecondsSinceEpoch}.png';
      final filePath = path.join(myAppImagesDir.path, fileName);

      // Write the file
      final file = File(filePath);
      await file.writeAsBytes(response.bodyBytes);

      // Notify the media store to make the image visible in the gallery
      await saveImageToMediaStore(filePath);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Image saved to: $filePath')),
      );

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save image: $e')),
      );
    }
  }

  Future<void> saveImageToMediaStore(String filePath) async {
    try {
      // Create an intent to insert the image
      final intent = AndroidIntent(
        action: 'android.intent.action.MEDIA_SCANNER_SCAN_FILE',
        data: 'file://$filePath', // Convert Uri to String here
      );

      // Start the intent
      await intent.launch();
    } catch (e) {
      print('Failed to refresh media store: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
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
              const SizedBox(height: 30,),
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
