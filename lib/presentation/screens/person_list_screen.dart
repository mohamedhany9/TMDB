import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:tmdb/core/constants/app_constants.dart';
import 'package:tmdb/core/styles/styles_manager.dart';

class PersonListScreen extends StatefulWidget {
  const PersonListScreen({super.key});

  @override
  State<PersonListScreen> createState() => _PersonListScreenState();
}

class _PersonListScreenState extends State<PersonListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppConstants.horizontalPadding),
        child: ListView(
          children: [
            const SizedBox(height: 10),
            _buildPersonList(),
          ],
        ),
      ),
    );
  }

  Widget _buildPersonList() {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: 5,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 15),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CachedNetworkImage(
                height: 100.h,
                width: 100.w,
                fit: BoxFit.fill,
                imageUrl: 'https://image.tmdb.org/t/p/w185//4D0PpNI0kmP58hgrwGC3wCjxhnm.jpg',
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
              const SizedBox(width: 20),
              _buildInfoRow("Hany")
            ],
          ),
        );
      },
    );
  }

  Widget _buildInfoRow(String? value) {
    return Row(
      children: [
        SizedBox(
          width: 150.w,
          child: AutoSizeText(
            value ?? "NA",
            minFontSize: 5,
            maxLines: 1,
            style: AppTextStyle.blackRegular.copyWith(fontSize: 16.sp),
          ),
        ),
      ],
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text(AppConstants.personTitle, style: AppTextStyle.blackBold.copyWith(fontSize: 18.sp)),
      centerTitle: true,
      backgroundColor: Colors.blue[200],
    );
  }
}
