import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:k2k/api_services/shared_preference/shared_preference.dart';
import 'package:k2k/app/routes_name.dart';
import 'package:k2k/utils/theme.dart';

class MenuItem {
  final String title;
  final IconData icon;
  final String? route;
  final List<SubMenuItem>? subItems;
  bool isExpanded;
  final Color? iconColor;

  MenuItem({
    required this.title,
    required this.icon,
    this.route,
    this.subItems,
    this.isExpanded = false,
    this.iconColor,
  });
}

class SubMenuItem {
  final String title;
  final IconData icon;
  final String? route;
  final List<SubMenuItem>? subItems;
  bool isExpanded;
  final Color? iconColor;

  SubMenuItem({
    required this.title,
    required this.icon,
    this.route,
    this.subItems,
    this.isExpanded = false,
    this.iconColor,
  });
}

class MenuSection {
  final String? heading;
  final String? imagePath;
  final List<MenuItem> items;
  final IconData? sectionIcon;
  final Color? sectionColor;
  bool isExpanded;

  MenuSection({
    this.heading, 
    this.imagePath, 
    required this.items, 
    this.sectionIcon,
    this.sectionColor,
    this.isExpanded = false,
  });
}

class EnhancedMenuDrawer extends StatefulWidget {
  const EnhancedMenuDrawer({super.key});

  @override
  State<EnhancedMenuDrawer> createState() => _EnhancedMenuDrawerState();
}

class _EnhancedMenuDrawerState extends State<EnhancedMenuDrawer>
    with TickerProviderStateMixin {
  late AnimationController _logoAnimationController;
  late Animation<double> _logoAnimation;

  String currentLogo = 'assets/images/login_image_1.png';

  List<MenuSection> menuSections = [
    // Main Dashboard Section
    MenuSection(
      heading: null,
      items: [
        MenuItem(
          title: 'Dashboard',
          icon: Icons.dashboard_rounded,
          route: '/homescreen',
          iconColor: const Color(0xFF4F46E5),
        ),
      ],
    ),
    
    // Falcon Facade Section - Collapsed by default
    MenuSection(
      heading: "Falcon Facade",
      imagePath: "assets/images/falcon.png",
      sectionIcon: Icons.agriculture_rounded,
      sectionColor: const Color(0xFF10B981),
      isExpanded: false, // Collapsed by default
      items: [
        MenuItem(
          title: 'Work Order', 
          icon: Icons.work_history_rounded,
          iconColor:  const Color(0xFFEF4444),
        ),
        MenuItem(
          title: 'Job Order', 
          icon: Icons.assignment_turned_in_rounded,
          iconColor:const Color(0xFFF59E0B),
        ),
        MenuItem(
          title: 'Internal Work Order', 
          icon: Icons.assignment_ind_rounded,
          iconColor: const Color(0xFF10B981),
        ),
        MenuItem(
          title: 'Production', 
          icon: Icons.precision_manufacturing_rounded,
          iconColor: const Color(0xFF10B981),
        ),
        MenuItem(
          title: 'Packing', 
          icon: Icons.inventory_2_rounded,
          iconColor:const Color(0xFF3B82F6),
        ),
        MenuItem(
          title: 'Dispatch', 
          icon: Icons.local_shipping_rounded,
          iconColor: const Color(0xFFEC4899),
        ),
        MenuItem(
          title: 'QC Check', 
          icon: Icons.verified_rounded,
          iconColor: const Color(0xFF06B6D4),
        ),
        MenuItem(
          title: 'Master Data',
          icon: Icons.settings_applications_rounded,
          iconColor: const Color(0xFF64748B), // Gray for Master Data
          subItems: [
            SubMenuItem(
              title: 'Master Clients',
              icon: Icons.business_rounded,
              route: '/settings/plant',
              iconColor: const Color(0xFF64748B),
              subItems: [
                SubMenuItem(
                  title: 'Client',
                  icon: Icons.person_add_rounded,
                  route: '/settings/plant/add-client',
                  iconColor: const Color(0xFF64748B),
                ),
                SubMenuItem(
                  title: 'Projects',
                  icon: Icons.folder_copy_rounded,
                  route: '/settings/plant/view-clients',
                  iconColor: const Color(0xFF64748B),
                ),
              ],
            ),
            SubMenuItem(
              title: 'Master Products',
              icon: Icons.category_rounded,
              route: '/settings/users',
              iconColor: const Color.fromARGB(255, 255, 255, 255),
              subItems: [
                SubMenuItem(
                  title: 'Systems',
                  icon: Icons.device_hub_rounded,
                  route: '/settings/products/add',
                  iconColor: const Color(0xFF64748B),
                ),
                SubMenuItem(
                  title: 'Product Systems',
                  icon: Icons.apps_rounded,
                  route: '/settings/products/categories',
                  iconColor: const Color(0xFF64748B),
                ),
                SubMenuItem(
                  title: 'Products',
                  icon: Icons.inventory_rounded,
                  route: '/settings/products/inventory',
                  iconColor: const Color(0xFF64748B),
                ),
              ],
            ),
          ],
        ),
      ],
    ),

    // Konkrete Klinkers Section - Collapsed by default
    MenuSection(
      heading: "Konkrete Klinkers",
      imagePath: "assets/images/konkrete_klinkers.png",
      sectionIcon: Icons.foundation_rounded,
      sectionColor: const Color(0xFFF59E0B),
      isExpanded: false, // Collapsed by default
      items: [
        MenuItem(
          title: 'Work Orders',
          icon: Icons.work_history_rounded,
          route: RouteNames.workorders,
          iconColor: const Color(0xFFEF4444), // Red for Work Order (same as Falcon)
        ),
        MenuItem(
          title: 'Job Order/Planning',
          icon: Icons.schedule_rounded,
          route: RouteNames.jobOrder,
          iconColor: const Color(0xFFF59E0B), // Orange for Job Order (same as Falcon)
        ),
        MenuItem(
          title: 'Production',
          icon: Icons.precision_manufacturing_rounded,
          route: RouteNames.production,
          iconColor: const Color(0xFF10B981), // Green for Production (same as Falcon)
        ),
        MenuItem(
          title: 'QC Check',
          icon: Icons.fact_check_rounded,
          route: RouteNames.qcCheck,
          iconColor: const Color(0xFF06B6D4), // Cyan for QC Check (same as Falcon)
        ),
        MenuItem(
          title: 'Packing',
          icon: Icons.all_inbox_rounded,
          route: RouteNames.packing,
          iconColor: const Color(0xFF3B82F6), // Blue for Packing (consistent everywhere)
        ),
        MenuItem(
          title: 'Dispatch',
          icon: Icons.local_shipping_rounded,
          route: RouteNames.dispatch,
          iconColor: const Color(0xFFEC4899), // Pink for Dispatch (same as Falcon)
        ),
        MenuItem(
          title: 'Inventory',
          icon: Icons.inventory_2_rounded,
          route: RouteNames.inventory,
          iconColor: const Color(0xFF8B5CF6), // Purple for Inventory
        ),
        MenuItem(
          title: 'Stock Management',
          icon: Icons.store_rounded,
          route: RouteNames.stockmanagement,
          iconColor: const Color(0xFF059669), // Emerald for Stock Management
        ),
        MenuItem(
          title: "Master Data",
          icon: Icons.settings_applications_rounded,
          iconColor: const Color(0xFF64748B), // Gray for Master Data (consistent)
          subItems: [
            SubMenuItem(
              title: 'Plants',
              icon: Icons.factory_rounded,
              iconColor: const Color(0xFF64748B),
              subItems: [
                SubMenuItem(
                  title: 'Plants',
                  icon: Icons.business_rounded,
                  route: RouteNames.plants,
                  iconColor: const Color(0xFF64748B),
                ),
                SubMenuItem(
                  title: 'Machines',
                  icon: Icons.precision_manufacturing_rounded,
                  route: RouteNames.machines,
                  iconColor: const Color(0xFF64748B),
                ),
              ],
            ),
            SubMenuItem(
              title: 'Clients',
              icon: Icons.people_rounded,
              route: RouteNames.clients,
              iconColor: const Color(0xFF64748B),
            ),
            SubMenuItem(
              title: 'Projects',
              icon: Icons.folder_rounded,
              route: RouteNames.projects,
              iconColor: const Color(0xFF64748B),
            ),
            SubMenuItem(
              title: 'Products',
              icon: Icons.category_rounded,
              route: RouteNames.products,
              iconColor: const Color(0xFF64748B),
            ),
          ],
        ),
      ],
    ),

    // Iron Smith Section - Collapsed by default
    MenuSection(
      heading: "Iron Smith",
      imagePath: "assets/images/iron_smith.png",
      sectionIcon: Icons.construction_rounded,
      sectionColor: const Color(0xFFEF4444),
      isExpanded: false, // Collapsed by default
      items: [
        MenuItem(
          title: 'Work Order', 
          icon: Icons.work_history_rounded,
          iconColor: const Color(0xFFEF4444),
        ),
        MenuItem(
          title: 'Job Order/Planning', 
          icon: Icons.schedule_rounded,
          iconColor:const Color(0xFFF59E0B),
        ),
        MenuItem(
          title: 'Production', 
          icon: Icons.precision_manufacturing_rounded,
          iconColor:const Color(0xFF10B981),
        ),
        MenuItem(
          title: 'QC Check', 
          icon: Icons.verified_rounded,
          iconColor: const Color(0xFF06B6D4),
        ),
        MenuItem(
          title: 'Packing', 
          icon: Icons.all_inbox_rounded,
          iconColor:const Color(0xFF3B82F6),
        ),
        MenuItem(
          title: 'Dispatch', 
          icon: Icons.local_shipping_rounded,
          iconColor:const Color(0xFFEC4899),
        ),
        MenuItem(
          title: 'Dispatch Invoice', 
          icon: Icons.receipt_long_rounded,
          iconColor: const Color(0xFFEF4444),
        ),
        MenuItem(
          title: 'Inventory', 
          icon: Icons.inventory_2_rounded,
          iconColor: const Color(0xFF8B5CF6),
        ),
        MenuItem(
          title: 'Master Data',
          icon: Icons.settings_applications_rounded,
          iconColor: const Color(0xFF64748B), // Gray for Master Data (consistent)
          subItems: [
            SubMenuItem(
              title: 'Machines',
              icon: Icons.precision_manufacturing_rounded,
              route: RouteNames.ismachine,
              iconColor: const Color(0xFF64748B),
            ),
            SubMenuItem(
              title: 'Clients',
              icon: Icons.people_rounded,
              route: RouteNames.isClients,
              iconColor: const Color(0xFF64748B),
            ),
            SubMenuItem(
              title: 'Projects',
              icon: Icons.folder_rounded,
              route: RouteNames.isProjetct,
              iconColor: const Color(0xFF64748B),
            ),
            SubMenuItem(
              title: 'Shapes',
              icon: Icons.auto_fix_high_rounded,
              route: '/settings/plant/view-clients',
              iconColor: const Color(0xFF64748B),
            ),
          ],
        ),
      ],
    ),
    
    // Users Section - Collapsed by default
    MenuSection(
      heading: "Users",
      sectionIcon: Icons.people_rounded,
      sectionColor: const Color(0xFF8B5CF6),
      isExpanded: false, // Collapsed by default
      items: [
        MenuItem(
          title: 'User Management',
          icon: Icons.admin_panel_settings_rounded,
          route: '/settings/users',
          iconColor: const Color(0xFF8B5CF6),
          subItems: [
            SubMenuItem(
              title: 'Users',
              icon: Icons.person_rounded,
              route: '/settings/plant',
              iconColor: const Color(0xFF8B5CF6),
            ),
            SubMenuItem(
              title: 'Clients',
              icon: Icons.business_rounded,
              route: '/settings/plant/add-client',
              iconColor: const Color(0xFF8B5CF6),
            ),
            SubMenuItem(
              title: 'Projects',
              icon: Icons.folder_rounded,
              route: '/settings/plant/view-clients',
              iconColor: const Color(0xFF8B5CF6),
            ),
          ],
        ),
      ],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _logoAnimationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _logoAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoAnimationController,
        curve: Curves.elasticOut,
      ),
    );
    _logoAnimationController.forward();
  }

  @override
  void dispose() {
    _logoAnimationController.dispose();
    super.dispose();
  }

  void _updateLogo(String? imagePath) {
    if (imagePath != null) {
      setState(() {
        currentLogo = imagePath;
      });
      _logoAnimationController.reset();
      _logoAnimationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: 300.w,
        child: Drawer(
          backgroundColor: const Color(0xFF1E293B), // Dark background like screenshot
          child: Column(
            children: [
              // Logo Section
              Container(
                padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
                child: AnimatedBuilder(
                  animation: _logoAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _logoAnimation.value,
                      child: Image.asset(
                        currentLogo,
                        width: 140.w,
                        height: 40.h,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.precision_manufacturing_outlined,
                            size: 28.sp,
                            color: Colors.white,
                          );
                        },
                      ),
                    );
                  },
                ),
              ),

              // Menu Sections
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                  itemCount: menuSections.length,
                  itemBuilder: (context, sectionIndex) {
                    final section = menuSections[sectionIndex];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Main Section Header (Clickable for expand/collapse)
                        if (section.heading != null)
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    section.isExpanded = !section.isExpanded;
                                  });
                                  if (section.isExpanded && section.imagePath != null) {
                                    _updateLogo(section.imagePath);
                                  }
                                },
                                borderRadius: BorderRadius.circular(12.r),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16.w,
                                    vertical: 12.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: section.isExpanded 
                                      ? section.sectionColor?.withOpacity(0.1)
                                      : Colors.transparent,
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(8.w),
                                        decoration: BoxDecoration(
                                          color: section.sectionColor?.withOpacity(0.2) ?? 
                                                 Colors.grey.withOpacity(0.2),
                                          borderRadius: BorderRadius.circular(8.r),
                                        ),
                                        child: Icon(
                                          section.sectionIcon ?? Icons.folder_rounded,
                                          color: section.sectionColor ?? Colors.grey,
                                          size: 20.sp,
                                        ),
                                      ),
                                      SizedBox(width: 12.w),
                                      Expanded(
                                        child: Text(
                                          section.heading!,
                                          style: TextStyle(
                                            color: section.isExpanded 
                                              ? section.sectionColor 
                                              : Colors.grey.shade400,
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      AnimatedRotation(
                                        turns: section.isExpanded ? 0.5 : 0,
                                        duration: const Duration(milliseconds: 200),
                                        child: Icon(
                                          Icons.keyboard_arrow_down_rounded,
                                          color: section.isExpanded 
                                            ? section.sectionColor 
                                            : Colors.grey.shade500,
                                          size: 24.sp,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        
                        // Section Items - Only show if expanded or no heading
                        if (section.heading == null || section.isExpanded)
                          ...section.items
                              .map((item) => _buildMenuItem(
                                    item,
                                    0,
                                    section.imagePath,
                                  ))
                              .toList(),
                      ],
                    );
                  },
                ),
              ),

              // Logout Button
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: Colors.grey.shade700,
                      width: 1,
                    ),
                  ),
                ),
                child: Container(
                  width: double.infinity,
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
                      onTap: () async {
                        confirmLogout(context);
                      },
                      borderRadius: BorderRadius.circular(12.r),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.logout_rounded,
                              color: Colors.white,
                              size: 20.sp,
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              'Logout',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
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
        ),
      ),
    );
  }

  Widget _buildMenuItem(MenuItem item, int level, String? sectionImagePath) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 8.w, vertical: 1.h),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                if (item.subItems != null) {
                  setState(() {
                    item.isExpanded = !item.isExpanded;
                  });
                  if (item.isExpanded && sectionImagePath != null) {
                    _updateLogo(sectionImagePath);
                  }
                } else {
                  if (sectionImagePath != null) {
                    _updateLogo(sectionImagePath);
                  }
                  Navigator.pop(context);
                  if (item.route != null) {
                    context.push(item.route!);
                  }
                  FocusScope.of(context).unfocus();
                }
              },
              borderRadius: BorderRadius.circular(10.r),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: item.isExpanded
                      ? Colors.grey.shade800.withOpacity(0.3)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(6.w),
                      decoration: BoxDecoration(
                        color: item.iconColor?.withOpacity(0.2) ?? 
                               Colors.grey.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: Icon(
                        item.icon,
                        color: item.iconColor ?? Colors.grey.shade400,
                        size: 18.sp,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Text(
                        item.title,
                        style: TextStyle(
                          color: item.isExpanded
                              ? item.iconColor ?? Colors.white
                              : Colors.grey.shade300,
                          fontSize: 15.sp,
                          fontWeight: item.isExpanded 
                            ? FontWeight.w600 
                            : FontWeight.w500,
                        ),
                      ),
                    ),
                    if (item.subItems != null)
                      AnimatedRotation(
                        turns: item.isExpanded ? 0.5 : 0,
                        duration: const Duration(milliseconds: 200),
                        child: Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: Colors.grey.shade500,
                          size: 20.sp,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
        if (item.subItems != null && item.isExpanded)
          Container(
            margin: EdgeInsets.only(left: 24.w, right: 8.w),
            child: Column(
              children: item.subItems!
                  .map((subItem) => _buildSubMenuItem(
                        subItem,
                        level + 1,
                        sectionImagePath,
                      ))
                  .toList(),
            ),
          ),
      ],
    );
  }

  Widget _buildSubMenuItem(SubMenuItem subItem, int level, String? sectionImagePath) {
    double leftPadding = (level * 12.0).w;

    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(bottom: 1.h),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                if (subItem.subItems != null) {
                  setState(() {
                    subItem.isExpanded = !subItem.isExpanded;
                  });
                  if (subItem.isExpanded && sectionImagePath != null) {
                    _updateLogo(sectionImagePath);
                  }
                } else {
                  if (sectionImagePath != null) {
                    _updateLogo(sectionImagePath);
                  }
                  Navigator.pop(context);
                  if (subItem.route != null) {
                    context.push(subItem.route!);
                  }
                  FocusScope.of(context).unfocus();
                }
              },
              borderRadius: BorderRadius.circular(8.r),
              child: Container(
                padding: EdgeInsets.only(
                  left: leftPadding,
                  right: 8.w,
                  top: 6.h,
                  bottom: 6.h,
                ),
                decoration: BoxDecoration(
                  color: subItem.isExpanded
                      ? Colors.grey.shade800.withOpacity(0.2)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(4.w),
                      decoration: BoxDecoration(
                        color: subItem.iconColor?.withOpacity(0.1) ?? 
                               Colors.grey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Icon(
                        subItem.icon,
                        color: subItem.iconColor?.withOpacity(0.8) ?? 
                               Colors.grey.shade400,
                        size: 14.sp,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Text(
                        subItem.title,
                        style: TextStyle(
                          color: subItem.isExpanded
                              ? subItem.iconColor
                              : Colors.grey.shade400,
                          fontSize: 14.sp,
                          fontWeight: subItem.isExpanded
                              ? FontWeight.w600
                              : FontWeight.w500,
                        ),
                      ),
                    ),
                    if (subItem.subItems != null)
                      AnimatedRotation(
                        turns: subItem.isExpanded ? 0.5 : 0,
                        duration: const Duration(milliseconds: 200),
                        child: Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: Colors.grey.shade600,
                          size: 16.sp,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
        // Nested sub-items
        if (subItem.subItems != null && subItem.isExpanded)
          Container(
            margin: EdgeInsets.only(left: 12.w),
            child: Column(
              children: subItem.subItems!
                  .map((nestedSubItem) => _buildSubMenuItem(
                        nestedSubItem,
                        level + 1,
                        sectionImagePath,
                      ))
                  .toList(),
            ),
          ),
      ],
    );
  }
}