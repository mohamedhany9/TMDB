import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tmdb/core/constants/app_constants.dart';
import 'package:tmdb/core/styles/styles_manager.dart';
import 'package:tmdb/core/utils/image_widget.dart';
import 'package:tmdb/domain/entities/person.dart';

class PersonDetailsScreen extends StatefulWidget {
  Person person;
   PersonDetailsScreen({super.key,required this.person});

  @override
  State<PersonDetailsScreen> createState() => _PersonDetailsScreenState();
}

class _PersonDetailsScreenState extends State<PersonDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: AppConstants.horizontalPadding),
        child: Column(
          children: [
            const SizedBox(height: 20),
            PersonImageWidget(imageUrl: widget.person.profilepath),
            const SizedBox(height: 20),
            _buildInfoRow("Name", widget.person.name),
            _buildInfoRow("Original Name", widget.person.original_name),
            _buildInfoRow("Popularity", widget.person.popularity.toString()),
            _buildInfoRow("Known For Department", widget.person.known_for_department),

          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String? value) {
    return Row(
      children: [
        Expanded(
            flex: 6,
            child: Text(label, style: AppTextStyle.blackRegular.copyWith(fontSize: 18.sp))),
        Expanded(
          flex: 5,
          child: SizedBox(
            width: 0.5.sw,
            child: AutoSizeText(
              value ?? "NA",
              minFontSize: 12,
              maxLines: 2,
              style: AppTextStyle.blackRegular.copyWith(fontSize: 16.sp,color: Colors.blue),
            ),
          ),
        ),
      ],
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text(widget.person.name, style: AppTextStyle.blackBold.copyWith(fontSize: 18.sp)),
      centerTitle: true,
      backgroundColor: Colors.blue[200],
    );
  }
}
