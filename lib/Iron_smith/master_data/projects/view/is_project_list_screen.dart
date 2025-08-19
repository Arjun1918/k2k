import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart' hide ScreenUtil;
import 'package:intl/intl.dart';
import 'package:k2k/Iron_smith/master_data/projects/model/is_project_model.dart';
import 'package:k2k/Iron_smith/master_data/projects/provider/is_project_provider.dart';
import 'package:k2k/Iron_smith/master_data/projects/view/is_project_delete_screen.dart';
import 'package:k2k/app/routes_name.dart';
import 'package:k2k/common/widgets/custom_card.dart';
import 'package:k2k/utils/sreen_util.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:k2k/common/list_helper/refresh.dart';
import 'package:k2k/common/list_helper/shimmer.dart';
import 'package:k2k/common/widgets/appbar/app_bar.dart';
import 'package:k2k/utils/theme.dart';

class IsProjectsListScreen extends StatefulWidget {
  const IsProjectsListScreen({super.key});

  @override
  State<IsProjectsListScreen> createState() => _IsProjectsListScreenState();
}

class _IsProjectsListScreenState extends State<IsProjectsListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        Provider.of<IsProjectsProvider>(
          context,
          listen: false,
        ).fetchProjects(refresh: true);
      }
    });
  }

  // void _editProject(String? projectId) {
  //   if (projectId != null) {
  //     print('Navigating to edit project: $projectId');
  //     context.goNamed(
  //       RouteNames.isProjectEdit,
  //       pathParameters: {'projectId': projectId},
  //     );
  //   } else {
  //     print('Error: projectId is null');
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text(
  //           'Invalid Project ID',
  //           style: TextStyle(fontSize: 14.sp),
  //         ),
  //         backgroundColor: AppTheme.appBarcolor,
  //         duration: const Duration(seconds: 2),
  //         behavior: SnackBarBehavior.floating,
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(8.r),
  //         ),
  //         margin: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
  //       ),
  //     );
  //   }
  // }
  String _formatDateTime(String createdAt) {
    try {
      // Parse the input string with the expected format
      final dateFormat = DateFormat('dd-MM-yyyy HH:mm:ss');
      final dateTime = dateFormat.parse(createdAt);
      // Format the DateTime object to the desired output format
      return DateFormat('dd-MM-yyyy, hh:mm a').format(dateTime);
    } catch (e) {
      print('Error parsing date: $e');
      return 'Invalid Date';
    }
  }

  String _getCreatedBy(CreatedBy? createdBy) {
    return createdBy?.username ?? 'Unknown';
  }

  Widget _buildLogoAndTitle() {
    return Row(
      children: [
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            'Projects',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF334155),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBackButton() {
    return IconButton(
      icon: Icon(
        Icons.arrow_back_ios,
        size: 24.sp,
        color: const Color(0xFF334155),
      ),
      onPressed: () {
        context.go(RouteNames.homeScreen);
      },
    );
  }

  // Widget _buildActionButtons() {
  //   return Padding(
  //     padding: EdgeInsets.only(right: 16.w),
  //     child: TextButton(
  //       onPressed: () {
  //         print('Navigating to add project screen');
  //         context.goNamed(RouteNames.isProjectAdd);
  //       },
  //       child: Row(
  //         children: [
  //           Icon(Icons.add, size: 20.sp, color: AppTheme.ironSmithPrimary),
  //           SizedBox(width: 4.w),
  //           Text(
  //             'Add Project',
  //             style: TextStyle(
  //               fontSize: 16.sp,
  //               fontWeight: FontWeight.w600,
  //               color: AppTheme.ironSmithPrimary,
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget _buildProjectCard(Project project) {
    final projectId = project.id;
    final name = project.name;
    final clientName = project.client.name;
    final address = project.address;
    final createdBy = _getCreatedBy(project.createdBy);
    final createdAt = project.createdAt;
    return CustomCard(
      title: name,
      leading: const Icon(Icons.work_outline, color: Colors.black54),
      headerGradient: AppTheme.ironSmithGradient,
      borderRadius: 12,
      backgroundColor: AppColors.cardBackground,
      borderColor: const Color(0xFFE5E7EB),
      borderWidth: 1,
      elevation: 0,
      margin: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
      menuItems: [
        PopupMenuItem<String>(
          value: 'edit',
          child: Row(
            children: [
              Icon(
                Icons.edit_outlined,
                size: 20.sp,
                color: AppTheme.ironSmithSecondary,
              ),
              SizedBox(width: 8.w),
              Text(
                'Edit',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: const Color(0xFF334155),
                ),
              ),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: 'delete',
          child: Row(
            children: [
              Icon(
                Icons.delete_outline,
                size: 20.sp,
                color: const Color(0xFFF43F5E),
              ),
              SizedBox(width: 8.w),
              Text(
                'Delete',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: const Color(0xFF334155),
                ),
              ),
            ],
          ),
        ),
      ],
      onMenuSelected: (value) {
        if (value == 'edit') {
          print('Edit project: $projectId (functionality not implemented)');
        } else if (value == 'delete') {
          print('Initiating delete for project: $projectId');
          IsProjectDeleteHandler.deleteProject(context, projectId, name);
        }
      },
      bodyItems: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Text(
            "Client: $clientName",
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: AppTheme.ironSmithSecondary,
            ),
          ),
        ),
        SizedBox(height: 6.h),
        Row(
          children: [
            Icon(
              Icons.location_on_outlined,
              size: 16.sp,
              color: const Color(0xFF64748B),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Text(
                'Address: $address',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: const Color(0xFF64748B),
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        SizedBox(height: 6.h),
        Row(
          children: [
            Icon(
              Icons.person_outline,
              size: 16.sp,
              color: const Color(0xFF64748B),
            ),
            SizedBox(width: 8.w),
            Text(
              'Created by: $createdBy',
              style: TextStyle(fontSize: 13.sp, color: const Color(0xFF64748B)),
            ),
          ],
        ),
        SizedBox(height: 6.h),
        Row(
          children: [
            Icon(
              Icons.access_time_outlined,
              size: 16.sp,
              color: const Color(0xFF64748B),
            ),
            SizedBox(width: 8.w),
            Text(
              'Created: ${_formatDateTime(createdAt)}',
              style: TextStyle(fontSize: 13.sp, color: const Color(0xFF64748B)),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.factory_outlined,
            size: 64.sp,
            color: AppTheme.ironSmithPrimary,
          ),
          SizedBox(height: 16.h),
          Text(
            'No Projects Found',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF334155),
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Tap the button below to add your first project!',
            style: TextStyle(fontSize: 14.sp, color: const Color(0xFF64748B)),
          ),
          SizedBox(height: 16.h),
          // AddButton(
          //   text: 'Add Project',
          //   icon: Icons.add,
          //   route: RouteNames.isProjectAdd,
          // ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (!didPop) {
          context.go(RouteNames.homeScreen);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBars(
          title: _buildLogoAndTitle(),
          leading: _buildBackButton(),
          action: [_buildActionButtons()],
        ),
        body: Consumer<IsProjectsProvider>(
          builder: (context, provider, child) {
            if (provider.error != null) {
              print('Error in IsProjectsProvider: ${provider.error}');
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64.sp,
                      color: const Color(0xFFF43F5E),
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      'Error Loading Projects',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF334155),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: Text(
                        provider.error.toString(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: const Color(0xFF64748B),
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),
                    RefreshButton(
                      text: 'Retry',
                      icon: Icons.refresh,
                      onTap: () {
                        print('Retrying to load projects');
                        provider.clearError();
                        provider.fetchProjects(refresh: true);
                      },
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                print('Refreshing projects list');
                await provider.fetchProjects(refresh: true);
              },
              color: AppTheme.ironSmithPrimary,
              backgroundColor: Colors.white,
              child: provider.isLoading && provider.projects.isEmpty
                  ? ListView.builder(
                      itemCount: 5,
                      itemBuilder: (context, index) => buildShimmerCard(),
                    )
                  : provider.projects.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      padding: EdgeInsets.only(bottom: 16.h),
                      itemCount: provider.projects.length,
                      itemBuilder: (context, index) {
                        return _buildProjectCard(provider.projects[index]);
                      },
                    ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: EdgeInsets.only(right: 16.w),
      child: TextButton(
        onPressed: () {
          context.goNamed(RouteNames.isProjectAdd);
        },
        child: Row(
          children: [
            Icon(Icons.add, size: 20.sp, color: AppTheme.ironSmithPrimary),
            SizedBox(width: 4.w),
            Text(
              'Add Project',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: AppTheme.ironSmithPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
