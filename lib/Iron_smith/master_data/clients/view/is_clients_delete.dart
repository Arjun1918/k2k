import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:k2k/Iron_smith/master_data/clients/provider/is_client_provider.dart';
import 'package:k2k/common/widgets/snackbar.dart';
import 'package:k2k/utils/theme.dart';
import 'package:provider/provider.dart';

class IsClientDeleteHandler {
  static void deleteClient(
    BuildContext context,
    String? clientId,
    String? clientName,
  ) {
   if (clientId == null || clientName == null) return;


    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return Consumer<IsClientsProvider>(
          builder: (context, provider, _) {
            return AlertDialog(
              backgroundColor: AppColors.cardBackground,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              title: Text(
                'Delete Client',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF334155),
                ),
              ),
              content: Text(
                'Are you sure you want to delete $clientName?',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: const Color(0xFF64748B),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppTheme.ironSmithPrimary,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: provider.isDeleting
                      ? null
                      : () async {
                          final success =
                              await provider.deleteClient(clientId);

                          if (dialogContext.mounted) {
                            Navigator.of(dialogContext).pop();
                            context.showSuccessSnackbar(
                              success
                                  ? 'Client deleted successfully'
                                  : provider.error ?? 'Failed to delete client',
                            );
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF43F5E),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 8.h,
                    ),
                  ),
                  child: provider.isDeleting
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
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.sp,
                          ),
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