import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:k2k/app/routes_name.dart';
import 'package:k2k/utils/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> storeUserData(
  String accessToken,
  String refreshToken,
  bool isLogedIn,
) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  if (accessToken.isNotEmpty) {
    await prefs.setString('accessToken', accessToken);
    await prefs.setString('refreshToken', accessToken);
    await prefs.setBool('isLogedIn', isLogedIn);
  } else {}
}

Future<String?> fetchAccessToken() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();

  String? accessToken = preferences.getString("accessToken");
  if (accessToken != null && accessToken.isNotEmpty) {
    return accessToken;
  } else {
    return null;
  }
}

Future<void> clearUserData() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove('accessToken');
  await prefs.remove('refreshToken');
  await prefs.remove('isLogedIn');
}

Future<void> confirmLogout(BuildContext context) async {
  final shouldLogout = await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (ctx) {
      return Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: 400.w,
            minWidth: 320.w,
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark
                ? const Color(0xFF1E293B)
                : Colors.white,
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 20,
                offset: const Offset(0, 10),
                spreadRadius: 0,
              ),
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 40,
                offset: const Offset(0, 20),
                spreadRadius: 0,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header with icon
              Container(
                width: double.infinity,
                padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 16.h),
                child: Column(
                  children: [
                    // Warning Icon with gradient background
                    Container(
                      width: 64.w,
                      height: 64.h,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFFEF4444),
                            Color(0xFFDC2626),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(32.r),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFEF4444).withOpacity(0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.logout_rounded,
                        color: Colors.white,
                        size: 32.sp,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    
                    // Title
                    Text(
                      "Confirm Logout",
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : const Color(0xFF1E293B),
                        letterSpacing: -0.5,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Content
              Padding(
                padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 24.h),
                child: Column(
                  children: [
                    Text(
                      "Are you sure you want to log out?",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w400,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.grey.shade300
                            : Colors.grey.shade600,
                        height: 1.5,
                      ),
                    ),
                    Text(
                      "You'll need to sign in again to continue using the app.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.grey.shade400
                            : Colors.grey.shade500,
                        height: 1.4,
                      ),
                    ),
                    SizedBox(height: 32.h),
                    
                    // Action Buttons
                    Row(
                      children: [
                        // Cancel Button
                        Expanded(
                          child: Container(
                            height: 48.h,
                            decoration: BoxDecoration(
                              color: Theme.of(context).brightness == Brightness.dark
                                  ? Colors.grey.shade800
                                  : Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(12.r),
                              border: Border.all(
                                color: Theme.of(context).brightness == Brightness.dark
                                    ? Colors.grey.shade700
                                    : Colors.grey.shade300,
                                width: 1,
                              ),
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () => Navigator.of(ctx).pop(false),
                                borderRadius: BorderRadius.circular(12.r),
                                child: Center(
                                  child: Text(
                                    "Cancel",
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w600,
                                      color: Theme.of(context).brightness == Brightness.dark
                                          ? Colors.white
                                          : const Color(0xFF374151),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        
                        SizedBox(width: 12.w),
                        
                        // Logout Button
                        Expanded(
                          child: Container(
                            height: 48.h,
                            decoration: BoxDecoration(
                              gradient: AppTheme.primaryGradient,
                              borderRadius: BorderRadius.circular(12.r),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFFEF4444).withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () => Navigator.of(ctx).pop(true),
                                borderRadius: BorderRadius.circular(12.r),
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.logout_rounded,
                                        color: Colors.white,
                                        size: 18.sp,
                                      ),
                                      SizedBox(width: 8.w),
                                      Text(
                                        "Logout",
                                        style: TextStyle(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    },
  );

  if (shouldLogout == true) {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('accessToken');
    await prefs.remove('refreshToken');
    await prefs.remove('isLogedIn');

    if (context.mounted) {
      context.go(RouteNames.login); // GoRouter redirect
    }
  }
}