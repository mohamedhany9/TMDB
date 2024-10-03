import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:tmdb/core/constants/app_constants.dart';
import 'package:tmdb/core/styles/styles_manager.dart';
import 'package:tmdb/presentation/providers/person_provider.dart';
import 'package:tmdb/presentation/screens/person_details_screen.dart';

class PersonListScreen extends StatefulWidget {
  const PersonListScreen({super.key});

  @override
  State<PersonListScreen> createState() => _PersonListScreenState();
}

class _PersonListScreenState extends State<PersonListScreen> {

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final plantProvider = Provider.of<PersonProvider>(context, listen: false);
      plantProvider.refreshPersons();
    });
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      final plantProvider = Provider.of<PersonProvider>(context, listen: false);
      if (!plantProvider.isLoading && plantProvider.hasMore) {
        plantProvider.fetchPersons();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppConstants.horizontalPadding),
        child: Consumer<PersonProvider>(
          builder: (context, plantProvider, child) {
            return ListView(
              controller: _scrollController,
              children: [
                const SizedBox(height: 10),
                _buildPersonList(plantProvider),
                if (plantProvider.isLoading)
                  const Center(child: CircularProgressIndicator()),
                if (!plantProvider.hasMore && plantProvider.persons.isNotEmpty)
                  Center(child: Text(AppConstants.noMorePersonsMessage, style: AppTextStyle.blackRegular)),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildPersonList(PersonProvider plantProvider) {
    if (plantProvider.persons.isEmpty && !plantProvider.isLoading) {
      return const Center(child: Text(AppConstants.noPersonsFoundMessage));
    }

    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: plantProvider.persons.length,
      itemBuilder: (context, index) {
        final person = plantProvider.persons[index];
        return GestureDetector(
          onTap: (){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PersonDetailsScreen(person: person,)),
            );
          },
          child: Container(
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
                  imageUrl: 'https://image.tmdb.org/t/p/w185/${person.profilepath}',
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
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoRow(person.name),

                  ],
                )
              ],
            ),
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
