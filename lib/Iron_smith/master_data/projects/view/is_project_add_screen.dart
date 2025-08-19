import 'package:flutter/material.dart';
import 'package:flutter_debouncer/flutter_debouncer.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';
import 'package:k2k/Iron_smith/master_data/projects/provider/is_project_provider.dart';
import 'package:k2k/app/routes_name.dart';
import 'package:k2k/common/widgets/appbar/app_bar.dart';
import 'package:k2k/common/widgets/searchable_dropdown.dart';
import 'package:k2k/common/widgets/snackbar.dart';
import 'package:k2k/common/widgets/textfield.dart';
import 'package:k2k/utils/theme.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddIsProjectFormScreen extends StatefulWidget {
  const AddIsProjectFormScreen({super.key});

  @override
  _AddIsProjectFormScreenState createState() => _AddIsProjectFormScreenState();
}

class _AddIsProjectFormScreenState extends State<AddIsProjectFormScreen> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  final ScrollController _scrollController = ScrollController();
  final Map<String, FocusNode> _focusNodes = {
    'name': FocusNode(),
    'client': FocusNode(),
    'address': FocusNode(),
  };
  final Debouncer _scrollDebouncer = Debouncer();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final projectsProvider = Provider.of<IsProjectsProvider>(
        context,
        listen: false,
      );
      projectsProvider.fetchClients().then((_) {
        if (projectsProvider.clients.isEmpty) {
          context.showErrorSnackbar(
            "No valid clients available. Please try again later.",
          );
        }
      });
    });
  }

  void _scrollToFocusedField(BuildContext context, FocusNode focusNode) {
    if (focusNode.hasFocus) {
      _scrollDebouncer.debounce(
        duration: const Duration(milliseconds: 100),
        onDebounce: () {
          final RenderObject? renderObject = context.findRenderObject();
          if (renderObject is RenderBox) {
            final position = renderObject.localToGlobal(Offset.zero).dy;
            final screenHeight = MediaQuery.of(context).size.height;
            final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

            double targetOffset = _scrollController.offset + position;
            if (position + 200.h > screenHeight - keyboardHeight) {
              targetOffset =
                  _scrollController.offset +
                  (position - (screenHeight - keyboardHeight - 200.h));
            }

            _scrollController.animateTo(
              targetOffset.clamp(
                0.0,
                _scrollController.position.maxScrollExtent,
              ),
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          }
        },
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _focusNodes.forEach((_, node) => node.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final projectsProvider = Provider.of<IsProjectsProvider>(context);

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (!didPop) {
          context.go(RouteNames.isProjetct);
        }
      },

      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        resizeToAvoidBottomInset: true,
        appBar: AppBars(
          title: _buildLogoAndTitle(),
          leading: _buildBackButton(),
          action: [],
        ),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          behavior: HitTestBehavior.opaque,
          child: SingleChildScrollView(
            controller: _scrollController,
            padding: EdgeInsets.all(
              24.w,
            ).copyWith(bottom: MediaQuery.of(context).viewInsets.bottom + 24.h),
            child: Column(
              children: [_buildFormCard(context, projectsProvider)],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogoAndTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Add Project',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF334155),
          ),
        ),
      ],
    );
  }

  Widget _buildBackButton() {
    return Builder(
      builder: (BuildContext context) {
        return IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            size: 24.sp,
            color: const Color(0xFF334155),
          ),
          onPressed: () {
            context.go(
              RouteNames.isProjetct,
            ); // Assuming RouteNames.projects exists
          },
        );
      },
    );
  }

  Widget _buildFormCard(
    BuildContext context,
    IsProjectsProvider projectsProvider,
  ) {
    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: FormBuilder(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Project Details',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF334155),
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Enter the required information below',
              style: TextStyle(fontSize: 14.sp, color: const Color(0xFF64748B)),
            ),
            SizedBox(height: 24.h),
            CustomTextFormField(
              name: 'name',
              labelText: 'Name',
              hintText: 'Enter Project Name',
              focusNode: _focusNodes['name'],
              prefixIcon: Icons.label,
              prefixIconColor: AppTheme.ironSmithPrimary,
              validators: [
                FormBuilderValidators.required(),
                FormBuilderValidators.minLength(2),
              ],
              fillColor: const Color(0xFFF8FAFC),
              borderColor: Colors.grey.shade300,
              focusedBorderColor: AppTheme.ironSmithSecondary,
              borderRadius: 12.r,
              onTap: () => _scrollToFocusedField(context, _focusNodes['name']!),
            ),
            SizedBox(height: 18.h),
            CustomSearchableDropdownFormField(
              name: 'client',
              labelText: 'Client',
              hintText: 'Select Client',
              prefixIcon: Icons.people,
              initialValue: null,
              options: projectsProvider.clients.isEmpty
                  ? ['No clients available']
                  : projectsProvider.clients
                        .where(
                          (client) => client.id.isNotEmpty,
                        ) // Assuming Client has 'id' and 'name'
                        .map(
                          (client) => client.name,
                        ) // Assuming 'name' field in Client model
                        .toList(),
              fillColor: const Color(0xFFF8FAFC),
              focusedBorderColor: AppTheme.ironSmithSecondary,
              borderColor: Colors.grey.shade300,
              borderRadius: 12.r,
              validators: [
                FormBuilderValidators.required(
                  errorText: 'Please select a client',
                ),
              ],
              enabled: projectsProvider.clients.any(
                (client) => client.id.isNotEmpty,
              ),
              onChanged: (value) {
                print('Dropdown onChanged: $value');
                _formKey.currentState?.fields['client']?.didChange(value);
              },
            ),
            SizedBox(height: 18.h),
            CustomTextFormField(
              name: 'address',
              labelText: 'Address',
              hintText: 'Enter Address',
              prefixIconColor: AppTheme.ironSmithPrimary,
              focusNode: _focusNodes['address'],
              prefixIcon: Icons.location_on,
              focusedBorderColor: AppTheme.ironSmithSecondary,
              validators: [
                FormBuilderValidators.required(),
                FormBuilderValidators.minLength(5),
              ],
              fillColor: const Color(0xFFF8FAFC),
              borderColor: Colors.grey.shade300,
              borderRadius: 12.r,
              onTap: () =>
                  _scrollToFocusedField(context, _focusNodes['address']!),
            ),
            SizedBox(height: 40.h),
            Consumer<IsProjectsProvider>(
              builder: (context, provider, _) => SizedBox(
                width: double.infinity,
                height: 56.h,
                child: _buildSubmitButton(context, provider),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitButton(BuildContext context, IsProjectsProvider provider) {
    final isLoading = provider.isLoading;

    return Container(
      decoration: BoxDecoration(
        gradient: AppTheme.ironSmithGradient,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF3B82F6).withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : () => _submitForm(context, provider),
          borderRadius: BorderRadius.circular(12.r),
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 16.h),
              child: isLoading
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Text(
                          'Creating Project...',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_circle,
                          color: Colors.white,
                          size: 20.sp,
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          'Create Project',
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
    );
  }

  Future<void> _submitForm(
    BuildContext context,
    IsProjectsProvider provider,
  ) async {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      final formData = _formKey.currentState!.value;

      final selectedClientName = formData['client'] as String?;

      if (selectedClientName == null || selectedClientName.isEmpty) {
        context.showErrorSnackbar("Please select a client.");
        return;
      }

      if (provider.clients.isEmpty) {
        context.showErrorSnackbar(
          "No clients available. Please refresh and try again.",
        );
        return;
      }

      print(
        'Available clients: ${provider.clients.map((c) => "${c.name} (ID: ${c.id})").toList()}', // Assuming 'name' and 'id' in Client
      );

      final selectedClient = provider.clients.firstWhere(
        (client) =>
            client.name.trim() ==
            selectedClientName.trim(), // Assuming 'name' field
      );

      if (selectedClient.id.isEmpty) {
        try {
          context.showInfoSnackbar("Refreshing client data...");
          await provider.fetchClients();

          if (provider.clients.isEmpty ||
              provider.clients.every((client) => client.id.isEmpty)) {
            context.showErrorSnackbar(
              "All clients have invalid IDs. Please contact support or check the client configuration.",
            );
            return;
          }

          final refreshedClient = provider.clients.firstWhere(
            (client) => client.name.trim() == selectedClientName.trim(),
          );

          if (refreshedClient.id.isEmpty) {
            context.showErrorSnackbar(
              "Selected client '$selectedClientName' has no valid ID even after refresh.",
            );
            return;
          }

          selectedClient.id;
        } catch (e) {
          context.showErrorSnackbar(
            "Failed to refresh client data: ${e.toString()}",
          );
          return;
        }
      }

      print('Selected client ID: ${selectedClient.id}');

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => Center(
          child: Container(
            padding: EdgeInsets.all(24.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(color: Color(0xFF3B82F6)),
                SizedBox(height: 16.h),
                Text(
                  'Creating Project...',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF334155),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      final projectData = {
        'name': formData['name'],
        'client': selectedClient.id,
        'address': formData['address'],
      };

      final success = await provider.createProject(projectData);

      Navigator.of(context).pop();

      if (success && context.mounted) {
        context.showSuccessSnackbar("Project successfully created");
        context.go(RouteNames.isProjetct);
      } else {
        context.showErrorSnackbar(
          "Failed to create Project: ${provider.error?.replaceFirst('Exception: ', '') ?? 'Unknown error. Please try again.'}",
        );
      }
    } else {
      context.showWarningSnackbar(
        "Please fill in all required fields correctly.",
      );
    }
  }
}
