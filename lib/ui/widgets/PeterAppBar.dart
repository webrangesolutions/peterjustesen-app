import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:peterjustesen/core/constants/constants.dart';
import 'package:velocity_x/velocity_x.dart';

class PeterAppBar extends StatefulWidget implements PreferredSizeWidget {
  final bool sortingShown;

  const PeterAppBar({Key? key, required this.title, this.sortingShown = false}) : super(key: key);
  final String title;

  @override
  State<PeterAppBar> createState() => _PeterAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _PeterAppBarState extends State<PeterAppBar> {
  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(73.h),
      child: AppBar(
        toolbarHeight: 73.h,
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          widget.title,
          style: custom_montserratTextTheme.headline5?.copyWith(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 22.sp,
          ),
        ),
        leading: IconButton(
          padding: const EdgeInsets.only(top: 10),
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
            // size: 20,
          ),
        ),
        actions: [
          widget.sortingShown
              ? SvgPicture.asset(
                  'assets/images/sorting.svg',
                ).onTap(() {
                  // show side bar
                  Fluttertoast.showToast(msg: 'Sorting');
                }).px24()
              : Container(),
        ],
      ),
    );
  }
}

class PeterAppBarOne extends StatefulWidget implements PreferredSizeWidget {
  final bool sortingShown;

  const PeterAppBarOne({Key? key, required this.title, this.sortingShown = false}) : super(key: key);
  final String title;

  @override
  State<PeterAppBarOne> createState() => _PeterAppBarOneState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _PeterAppBarOneState extends State<PeterAppBarOne> {
  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(73.h),
      child: AppBar(
        toolbarHeight: 73.h,
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          widget.title,
          style: custom_montserratTextTheme.headline5?.copyWith(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 22.sp,
          ),
        ),
        actions: [
          widget.sortingShown
              ? SvgPicture.asset(
            'assets/images/sorting.svg',
          ).onTap(() {
            // show side bar
            Fluttertoast.showToast(msg: 'Sorting');
          }).px24()
              : Container(),
        ],
      ),
    );
  }
}
