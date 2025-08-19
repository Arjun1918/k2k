import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart' hide ScreenUtil;
import 'package:k2k/app/routes_name.dart';
import 'package:k2k/common/list_helper/add_button.dart';
import 'package:k2k/common/list_helper/refresh.dart';
import 'package:k2k/common/widgets/appbar/app_bar.dart';
import 'package:k2k/common/widgets/custom_backbutton.dart';
import 'package:k2k/common/widgets/custom_card.dart';
import 'package:k2k/common/widgets/gradient_icon_button.dart';
import 'package:k2k/common/widgets/title_text.dart';
import 'package:k2k/konkrete_klinkers/master_data/clients/provider/clients_provider.dart';
import 'package:k2k/konkrete_klinkers/master_data/clients/view/clients_delete_screen.dart';
import 'package:k2k/utils/sreen_util.dart';
import 'package:k2k/utils/theme.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

class ClientsListView extends StatefulWidget {
  const ClientsListView({super.key});

  @override
  State<ClientsListView> createState() => _ClientsListViewState();
}

class _ClientsListViewState extends State<ClientsListView> {
  bool _isInitialized = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Defer data loading until after the build phase
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeData();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _initializeData() {
    if (!_isInitialized) {
      _isInitialized = true;
      final provider = context.read<ClientsProvider>();
      if (provider.clients.isEmpty && provider.error == null) {
        provider.loadClients();
      }
    }
  }

  void _editClient(String? clientId) {
    if (clientId != null) {
      context.goNamed(
        RouteNames.clientsedit,
        pathParameters: {'clientId': clientId},
      );
    }
  }

  String _formatDateTime(DateTime? dateTime) {
    if (dateTime == null) return 'N/A';
    return '${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year}';
  }

  String _getCreatedBy(dynamic createdBy) {
    if (createdBy is Map<String, dynamic>) {
      return createdBy['username']?.toString() ?? 'Unknown';
    }
    return createdBy?.toString() ?? 'Unknown';
  }

  Widget _buildClientCard(dynamic client) {
    final clientData = client is Map<String, dynamic>
        ? client
        : client.toJson();
    final clientId =
        clientData['_id']?.toString() ?? clientData['id']?.toString() ?? '';
    final name = clientData['name']?.toString() ?? 'Unknown Client';
    final address = clientData['address']?.toString() ?? 'N/A';
    final createdBy = _getCreatedBy(
      clientData['created_by'] ?? clientData['createdBy'],
    );
    final createdAt = clientData['createdAt'] != null
        ? DateTime.tryParse(clientData['createdAt'].toString())
        : null;

    return CustomCard(
      title: name,
      leading: Icon(Icons.apartment_outlined, color: Colors.black54),

      headerGradient: AppTheme.cardGradientList,
      borderRadius: 12,
      backgroundColor: AppColors.cardBackground,
      borderColor: const Color(0xFFE5E7EB),
      borderWidth: 1,
      elevation: 0,
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      menuItems: [
        PopupMenuItem<String>(
          value: 'edit',
          child: Row(
            children: [
              Icon(
                Icons.edit_outlined,
                size: 20.sp,
                color: const Color(0xFFF59E0B),
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
          ClientDeleteHandler.deleteClient(context, clientId, name);
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
            "Address : $address",
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF3B82F6),
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
            Icons.person_outline,
            size: 64.sp,
            color: const Color(0xFF3B82F6),
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
            route: RouteNames.clientsadd,
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
      child: Container(
        decoration: BoxDecoration(gradient: AppTheme.backgroundGradient),
        child: Scaffold(
          backgroundColor: AppColors.transparent,
          appBar: AppBars(
            title: TitleText(title: 'Clients'),
            leading: CustomBackButton(
              onPressed: () {
                context.go(RouteNames.homeScreen);
              },
            ),
          ),
          floatingActionButton: GradientIconTextButton(
            onPressed: () => context.goNamed(RouteNames.clientsadd),
            label: 'Add Clients',
            icon: Icons.add,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          ),
          body: Consumer<ClientsProvider>(
            builder: (context, provider, child) {
              // Show full-screen loader during initial load
              if (provider.isLoading &&
                  provider.clients.isEmpty &&
                  provider.error == null) {
                return const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Color(0xFF3B82F6),
                    ),
                  ),
                );
              }

              if (provider.error != null && provider.clients.isEmpty) {
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
                          provider.error!,
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
                          provider.clearError();
                          provider.loadClients(refresh: true);
                        },
                      ),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: () async {
                  await context.read<ClientsProvider>().loadClients(
                    refresh: true,
                  );
                },
                color: const Color(0xFF3B82F6),
                backgroundColor: Colors.white,
                child: provider.clients.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        controller: _scrollController,
                        padding: EdgeInsets.only(bottom: 80.h),
                        itemCount: provider.clients.length,
                        itemBuilder: (context, index) {
                          return _buildClientCard(provider.clients[index]);
                        },
                      ),
              );
            },
          ),
        ),
      ),
    );
  }
}
