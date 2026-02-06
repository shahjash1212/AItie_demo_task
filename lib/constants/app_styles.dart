import 'package:aitie_demo/constants/app_colors.dart';
import 'package:flutter/widgets.dart';

class AppStyles {
  static const String ppCirka = 'PPCirka';
  static const String gilroy = 'Gilroy';

  static const TextStyle kPPCirkaBig = TextStyle(
    fontFamily: ppCirka,
    fontWeight: FontWeight.w700,
    fontSize: 33.0,
    letterSpacing: 0.0,
    height: 1.09,
    color: AppColor.kFFFFFF,
  );

  static const TextStyle kPPCirkaMedium = TextStyle(
    fontFamily: ppCirka,
    fontWeight: FontWeight.w700,
    fontSize: 24.0,
    color: AppColor.k0D0D0D,
  );
  static const TextStyle kGilroyMedium = TextStyle(
    fontFamily: gilroy,
    fontWeight: FontWeight.w500,
    fontStyle: FontStyle.normal,
    fontSize: 16.0,
    height: 1.1,
    letterSpacing: .4,
    color: AppColor.k8A8A8A,
  );

  static const TextStyle kGilroyBold = TextStyle(
    fontFamily: gilroy,
    fontWeight: FontWeight.w700,
    fontStyle: FontStyle.normal,
    fontSize: 13.0,
    height: 1.23,
    color: AppColor.k0D0D0D,
  );

  static const TextStyle kGilroySemiBold = TextStyle(
    fontFamily: gilroy,
    fontWeight: FontWeight.w600,
    fontStyle: FontStyle.normal,
    fontSize: 12.0,
    color: AppColor.k3D3D3D,
  );
  static const TextStyle kGilroyRegular = TextStyle(
    fontFamily: gilroy,
    fontWeight: FontWeight.w400,
    color: AppColor.kFFFFFF,
    fontStyle: FontStyle.normal,
    fontSize: 12.0,
    height: 1.5,
  );

  static const TextStyle kGilroyMediumItalic = TextStyle(
    fontFamily: gilroy,
    fontWeight: FontWeight.w500,
    fontStyle: FontStyle.italic,
    fontSize: 8,
    color: AppColor.k8A8A8A,
    letterSpacing: 0,
    height: 1,
  );
}
