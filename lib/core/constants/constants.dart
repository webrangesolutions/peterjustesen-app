import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

TextTheme custom_poppinsTextTheme = TextTheme(
  headline1: GoogleFonts.poppins(
      fontSize: 37.sp,
      fontWeight: FontWeight.bold,
      letterSpacing: 0.5,
      color: Colors.white),
  headline2: GoogleFonts.poppins(
      fontSize: 58, fontWeight: FontWeight.w300, letterSpacing: -0.5),
  headline3: GoogleFonts.poppins(fontSize: 46, fontWeight: FontWeight.w400),
  headline4: GoogleFonts.poppins(
      fontSize: 33, fontWeight: FontWeight.w400, letterSpacing: 0.25),
  headline5: GoogleFonts.poppins(
      fontSize: 22.sp, fontWeight: FontWeight.w500, color: Colors.white),
  // Custom app bar and profile
  headline6: GoogleFonts.poppins(
      fontSize: 18,
      fontWeight: FontWeight.normal,
      letterSpacing: 0.3,
      color: Colors.white),
  subtitle1: GoogleFonts.poppins(
      fontSize: 10.82.sp,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.15,
      color: Colors.white),
  subtitle2: GoogleFonts.poppins(
      fontSize: 13,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.1,
      color: Colors.white),
  bodyText1: GoogleFonts.roboto(
      fontSize: 18,
      fontWeight: FontWeight.normal,
      letterSpacing: 0.5,
      color: Colors.white),
  bodyText2: GoogleFonts.poppins(
      fontSize: 8,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.5,
      color: Colors.red),
  button: GoogleFonts.roboto(
      fontSize: 14.sp,
      fontWeight: FontWeight.bold,
      color: Colors.black,
      letterSpacing: 0.5),
  caption: GoogleFonts.poppins(
      fontSize: 12.sp,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.4,
      color: Colors.white),
  overline: GoogleFonts.poppins(
      fontSize: 12.sp,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.5,
      color: Colors.white),
);

// Button Style 1.

ButtonStyle buttonStyle() {
  return ButtonStyle(
    backgroundColor: const MaterialStatePropertyAll<Color>(Colors.white),
    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(11.r),
      ),
    ),
  );
}

// Button Style 2.

ButtonStyle secondbuttonStyle() {
  return ButtonStyle(
    backgroundColor: const MaterialStatePropertyAll<Color>(
      Color.fromARGB(255, 2, 13, 40),
    ),
    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(11.r),
      ),
    ),
  );
}

// TextField without icon........

TextField myTextFields(
  String hintText,
) {
  return TextField(
    decoration: InputDecoration(
        hintText: hintText,
        contentPadding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 20.w),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: Colors.transparent, width: 0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: Colors.transparent, width: 0),
        ),
        filled: true,
        fillColor: Colors.white),
  );
}

class callToActionButton extends StatelessWidget {
  final double width;
  final String text;
  final Function onPressed;

  const callToActionButton({
    Key? key,
    required this.width,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: 50.h,
      child: ElevatedButton(
        onPressed: () {
          onPressed();
        },
        style: ElevatedButton.styleFrom(
          primary: primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.r),
          ),
        ),
        child: Text(
          text,
          // text bold
          style: GoogleFonts.montserrat(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class TextNormalField extends StatelessWidget {
  final String hintText;
  const TextNormalField({
    Key? key,
    required this.hintText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 340.w,
      height: 50.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6.r),
        border: Border.all(
          color: Colors.grey,
          width: 1,
        ),
      ),
      child: TextFormField(
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 0.h, horizontal: 10.w),
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: GoogleFonts.montserrat(
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}

class PasswordField extends StatelessWidget {
  const PasswordField({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 340.w,
      height: 50.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6.r),
        border: Border.all(
          color: Colors.grey,
          width: 1,
        ),
      ),
      child: TextFormField(
        decoration: InputDecoration(
          border: InputBorder.none,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6.r),
            borderSide: const BorderSide(color: Colors.transparent, width: 1),
          ),
          filled: true,
          fillColor: Colors.white,
          hintText: "Password",
          hintStyle: GoogleFonts.montserrat(
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            color: Colors.black,
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 0.h, horizontal: 10.w),
          suffixIcon: Icon(
            Icons.visibility,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}

TextField passwordFieldWithIcon(
  String hintText,
) {
  return TextField(
    decoration: InputDecoration(
      hintText: hintText,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: const BorderSide(color: Colors.transparent, width: 0),
      ),
    ),
  );
}

// font 14 with black
TextStyle font14withblack() {
  return GoogleFonts.montserrat(
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    color: Colors.black,
  );
}

// font 14 with grey

TextStyle font14withgrey() {
  return GoogleFonts.montserrat(
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    color: Colors.grey,
  );
}

// textfieldWithicon

TextField textfieldWithicon(String hintText, IconData iconData) {
  return TextField(
    decoration: InputDecoration(
        suffixIcon: Icon(iconData),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.grey, width: 1.0),
          borderRadius: BorderRadius.circular(15.0),
        ),
        filled: true,
        hintStyle: GoogleFonts.montserrat(
          fontSize: 14.sp,
          fontWeight: FontWeight.w400,
          color: Colors.black,
        ),
        hintText: hintText,
        fillColor: Colors.white),
  );
}

var custom_montserratTextTheme = TextTheme(
  headline1: GoogleFonts.montserrat(
      fontSize: 37.sp,
      fontWeight: FontWeight.bold,
      letterSpacing: 0.5,
      color: Colors.white),
  headline2: GoogleFonts.montserrat(
      fontSize: 58, fontWeight: FontWeight.w300, letterSpacing: -0.5),
  headline3: GoogleFonts.montserrat(fontSize: 46, fontWeight: FontWeight.w400),
  headline4: GoogleFonts.montserrat(
      fontSize: 33, fontWeight: FontWeight.w400, letterSpacing: 0.25),
  headline5: GoogleFonts.montserrat(
      fontSize: 22.sp, fontWeight: FontWeight.w500, color: Colors.white),
  headline6: GoogleFonts.montserrat(
      fontSize: 18,
      fontWeight: FontWeight.normal,
      letterSpacing: 0.3,
      color: Colors.white),
  subtitle1: GoogleFonts.montserrat(
      fontSize: 10.82.sp,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.15,
      color: Colors.white),
  subtitle2: GoogleFonts.montserrat(
      fontSize: 13,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.1,
      color: Colors.white),
  bodyText1: GoogleFonts.roboto(
      fontSize: 18,
      fontWeight: FontWeight.normal,
      letterSpacing: 0.5,
      color: Colors.white),
  bodyText2: GoogleFonts.montserrat(
      fontSize: 8,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.5,
      color: Colors.red),
  button: GoogleFonts.roboto(
      fontSize: 14.sp,
      fontWeight: FontWeight.bold,
      color: Colors.black,
      letterSpacing: 0.5),
  caption: GoogleFonts.montserrat(
      fontSize: 12.sp,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.4,
      color: Colors.white),
  overline: GoogleFonts.montserrat(
      fontSize: 12.sp,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.5,
      color: Colors.white),
);

const primaryColor = Color(0xFF212C62);
const secondaryColor = Color(0xFFBFC7F2);

const h1Size = 24.0;
const h2Size = 20.0;
const h3Size = 16.0;
const h4Size = 14.0;
const h5Size = 12.0;
const textButtonSize = 14.0;
const bodyTextSize = 14.0;
const captionSize = 12.0;
const overlineSize = 10.0;
const buttonSize = 14.0;

const h1Weight = FontWeight.w700;
const kDefaultBorderRadius = 50.0;
const kDefaultBorderRadius2 = 10.0;
const kDefaultBorderRadius3 = 8.0;
const kDefaultBorderRadius4 = 5.0;

const kDefaultPadding = 20.0;
const kDefaultPadding2 = 10.0;
const kDefaultPadding3 = 5.0;

const kDefaultShadow = BoxShadow(
  offset: Offset(0, 15),
  blurRadius: 27,
  color: Colors.black12,
);

const kDefaultDuration = Duration(milliseconds: 250);
const kDefaultCurve = Curves.easeInOut;

bool isLoading = false;
bool isConnected = true;
