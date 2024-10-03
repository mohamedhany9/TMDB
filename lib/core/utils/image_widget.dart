import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class PersonImageWidget extends StatelessWidget {
  final String imageUrl;
  const PersonImageWidget({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'personImage',
      child: CachedNetworkImage(
        height: 0.4.sh,
        width: 1.sw,
        fit: BoxFit.fill,
        imageUrl: 'https://image.tmdb.org/t/p/w300/$imageUrl',
        placeholder: (context, url) => const SpinKitThreeBounce(
          size: 30,
          color: Colors.green,
        ),
        errorWidget: (context, url, error) => const PlaceholderImage(),
      ),
    );
  }
}

class PlaceholderImage extends StatelessWidget {
  const PlaceholderImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 0.4.sh,
      width: 1.sw,
      color: Colors.grey[300],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.image_not_supported,
            size: 50.sp,
            color: Colors.grey[600],
          ),
          SizedBox(height: 10.h),
          Text(
            'Image not available',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 16.sp,
            ),
          ),
        ],
      ),
    );
  }
}