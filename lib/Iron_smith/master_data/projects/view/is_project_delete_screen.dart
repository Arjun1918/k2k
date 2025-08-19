import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:k2k/Iron_smith/master_data/projects/provider/is_project_provider.dart';
import 'package:k2k/common/widgets/snackbar.dart';
import 'package:provider/provider.dart';

class IsProjectDeleteHandler {
  static void deleteProject(
    BuildContext context,
    String? projectId,
    String? projectName,
  ) {
    if (projectId == null || projectName == null) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        bool isDeleting = false;

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
              backgroundColor: Colors.white,
              title: Row(
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    color: const Color(0xFFF59E0B),
                    size: 24.sp,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'Confirm Delete',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18.sp,
                      color: const Color(0xFF334155),
                    ),
                  ),
                ],
              ),
              content: Text(
                'Are you sure you want to delete "$projectName"?',
                style: TextStyle(fontSize: 14.sp, color: const Color(0xFF64748B)),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: Text(
                    'Cancel',
                    style: TextStyle(fontSize: 14.sp, color: const Color(0xFF3B82F6)),
                  ),
                ),
                ElevatedButton(
                  onPressed: isDeleting
                      ? null
                      : () async {
                          setState(() {
                            isDeleting = true;
                          });

                          final provider = Provider.of<IsProjectsProvider>(
                            dialogContext,
                            listen: false,
                          );
                          final success = await provider.deleteProject(projectId);

                          if (dialogContext.mounted) {
                            Navigator.pop(dialogContext);
                            context.showSuccessSnackbar(
                              success
                                  ? 'Project deleted successfully!'
                                  : 'Failed to delete project: ${provider.error}',
                            );
                          }

                          setState(() {
                            isDeleting = false;
                          });
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF43F5E),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                  ),
                  child: isDeleting
                      ? SizedBox(
                          width: 24.sp,
                          height: 24.sp,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 3,
                          ),
                        )
                      : Text(
                          'Delete',
                          style: TextStyle(color: Colors.white, fontSize: 14.sp),
                        ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}