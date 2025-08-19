import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart' hide ScreenUtil;
import 'package:intl/intl.dart';
import 'package:k2k/Iron_smith/master_data/clients/model/Is_clients.dart';
import 'package:k2k/Iron_smith/master_data/clients/provider/is_client_provider.dart';
import 'package:k2k/Iron_smith/master_data/clients/view/is_clients_delete.dart';
import 'package:k2k/app/routes_name.dart';
import 'package:k2k/common/widgets/custom_card.dart';
import 'package:k2k/utils/sreen_util.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:k2k/common/list_helper/add_button.dart';
import 'package:k2k/common/list_helper/refresh.dart';
import 'package:k2k/common/list_helper/shimmer.dart';
import 'package:k2k/common/widgets/appbar/app_bar.dart';
import 'package:k2k/utils/theme.dart';

class IsClientsListScreen extends StatefulWidget {
  const IsClientsListScreen({super.key});

  @override
  State<IsClientsListScreen> createState() => _IsClientsListScreenState();
}

class _IsClientsListScreenState extends State<IsClientsListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        Provider.of<IsClientsProvider>(
          context,
          listen: false,
        ).fetchClients(refresh: true);
      }
    });
  }

  void _editClient(String? clientId) {
    if (clientId != null) {
      print('Navigating to edit client: $clientId');
      final provider = Provider.of<IsClientsProvider>(context, listen: false);
      final client = provider.clients.firstWhere(
        (client) => client.id == clientId,
      );

      if (client.id != null) {
        context.goNamed(RouteNames.isClientsEdit, extra: client);
      } else {
        print('Error: Client not found for ID $clientId');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Client not found',
              style: TextStyle(fontSize: 14.sp),
            ),
            backgroundColor: AppTheme.appBarcolor,
            duration: const Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
            margin: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
          ),
        );
      }
    } else {
      print('Error: clientId is null');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Invalid Client ID', style: TextStyle(fontSize: 14.sp)),
          backgroundColor: AppTheme.appBarcolor,
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
          margin: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
        ),
      );
    }
  }

  String formatDateTime(String? dateTime) {
    if (dateTime == null || dateTime.isEmpty) return 'Unknown';

    try {
      final parsed = DateTime.parse(dateTime).toLocal();
      return DateFormat('dd-MM-yyyy, hh:mm a').format(parsed);
    } catch (_) {
      final possibleFormats = [
        "yyyy-MM-dd HH:mm:ss",
        "dd-MM-yyyy HH:mm:ss",
        "yyyy-MM-dd",
      ];

      for (final format in possibleFormats) {
        try {
          final parsed = DateFormat(format).parse(dateTime, false).toLocal();
          return DateFormat('dd-MM-yyyy, hh:mm a').format(parsed);
        } catch (_) {}
      }
    }

    print('Error parsing date: $dateTime');
    return 'Invalid Date';
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
            'Clients',
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

  Widget _buildActionButtons() {
    return Padding(
      padding: EdgeInsets.only(right: 16.w),
      child: TextButton(
        onPressed: () {
          print('Navigating to add client screen');
          context.goNamed(RouteNames.isClientsAdd);
        },
        child: Row(
          children: [
            Icon(Icons.add, size: 20.sp, color: AppTheme.ironSmithPrimary),
            SizedBox(width: 4.w),
            Text(
              'Add Client',
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

  Widget _buildClientCard(Client client) {
    final clientId = client.id;
    final name = client.name ?? 'Unknown';
    final address = client.address ?? 'N/A';
    final createdBy = _getCreatedBy(client.createdBy);
    final createdAt = client.createdAt;

    return CustomCard(
      title: name,
      leading: Icon(Icons.apartment_outlined, color: Colors.black54),
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
          _editClient(clientId);
        } else if (value == 'delete') {
          print('Initiating delete for client: $clientId');
          IsClientDeleteHandler.deleteClient(context, clientId, name);
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
            "Address: $address",
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: AppTheme.ironSmithSecondary,
            ),
          ),
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
        if (createdAt != null)
          Row(
            children: [
              Icon(
                Icons.access_time_outlined,
                size: 16.sp,
                color: const Color(0xFF64748B),
              ),
              SizedBox(width: 8.w),
              Text(
                'Created At: ${formatDateTime(createdAt)}',
                style: TextStyle(
                  fontSize: 17.sp,
                  color: const Color(0xFF64748B),
                ),
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
            Icons.person_add_alt_1_outlined,
            size: 64.sp,
            color: AppTheme.ironSmithPrimary,
          ),
          SizedBox(height: 16.h),
          Text(
            'No Clients Found',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF334155),
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Tap the button below to add your first client!',
            style: TextStyle(fontSize: 14.sp, color: const Color(0xFF64748B)),
          ),
          SizedBox(height: 16.h),
          AddButton(
            text: 'Add Client',
            icon: Icons.add,
            route: RouteNames.clients, // Fixed route name
          ),
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
        body: Consumer<IsClientsProvider>(
          builder: (context, provider, child) {
            if (provider.error != null) {
              print('Error in IsClientsProvider: ${provider.error}');
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
                      'Error Loading Clients',
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
                        print('Retrying to load clients');
                        provider.clearError();
                        provider.fetchClients(refresh: true);
                      },
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                print('Refreshing clients list');
                await provider.fetchClients(refresh: true);
              },
              color: AppTheme.ironSmithPrimary,
              backgroundColor: Colors.white,
              child: provider.isLoading && provider.clients.isEmpty
                  ? ListView.builder(
                      itemCount: 5,
                      itemBuilder: (context, index) => buildShimmerCard(),
                    )
                  : provider.clients.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      padding: EdgeInsets.only(bottom: 16.h),
                      itemCount: provider.clients.length,
                      itemBuilder: (context, index) {
                        return _buildClientCard(provider.clients[index]);
                      },
                    ),
            );
          },
        ),
      ),
    );
  }
}
