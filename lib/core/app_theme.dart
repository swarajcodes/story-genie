import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:story_genie/core/app_colours.dart';
import 'package:story_genie/core/app_textstyles.dart';

class AppTheme {
  static final theme = ThemeData(
    primarySwatch: Colors.indigo,
    colorScheme: ColorScheme.fromSeed(seedColor: AppColors.bidPry400),
    fontFamily: AppTextStyles.ibmPlexSans,
    scaffoldBackgroundColor: AppColors.white,
    useMaterial3: true,
    dialogTheme: const DialogTheme(
      backgroundColor: AppColors.white,
      surfaceTintColor: AppColors.white,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.white,
      elevation: 0.5,
      iconTheme: IconThemeData(size: 17.sp),
      surfaceTintColor: AppColors.transparent,
    ),
    expansionTileTheme: const ExpansionTileThemeData(
      tilePadding: EdgeInsets.symmetric(vertical: 4),
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: AppColors.gray50,
    ),
    // radioTheme: RadioThemeData(
    //   fillColor: MaterialStateProperty.resolveWith(
    //     (states) => states.isEmpty ? AppColors.lightColor3 : null,
    //   ),
    // ),
    // checkboxTheme: CheckboxThemeData(
    //   fillColor: MaterialStateProperty.resolveWith(
    //     (states) => states.isEmpty ? AppColors.lightColor3 : null,
    //   ),
    // ),
  );

  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.indigo,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.darkPrimary,
      brightness: Brightness.dark,
    ),
    fontFamily: AppTextStyles.ibmPlexSans,
    scaffoldBackgroundColor: AppColors.darkBackground,
    useMaterial3: true,
    dialogTheme: const DialogTheme(
      backgroundColor: AppColors.darkSurface,
      surfaceTintColor: AppColors.darkSurface,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.darkSurface,
      elevation: 0.5,
      iconTheme: IconThemeData(size: 17),
      surfaceTintColor: AppColors.transparent,
    ),
    expansionTileTheme: const ExpansionTileThemeData(
      tilePadding: EdgeInsets.symmetric(vertical: 4),
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: AppColors.darkGray50,
    ),
  );
}
