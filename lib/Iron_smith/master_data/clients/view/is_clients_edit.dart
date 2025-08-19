import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';
import 'package:k2k/Iron_smith/master_data/clients/provider/is_client_provider.dart';
import 'package:k2k/common/widgets/appbar/app_bar.dart';
import 'package:k2k/common/widgets/snackbar.dart';
import 'package:k2k/common/widgets/textfield.dart';
import 'package:k2k/utils/theme.dart';
import 'package:k2k/app/routes_name.dart';
import 'package:k2k/Iron_smith/master_data/clients/model/Is_clients.dart';
import 'package:provider/provider.dart';

class IsClientEditScreen extends StatefulWidget {
  final Client client;

  const IsClientEditScreen({super.key, required this.client});

  @override
  State<IsClientEditScreen> createState() => _IsClientEditScreenState();
}

class _IsClientEditScreenState extends State<IsClientEditScreen> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  Widget _buildLogoAndTitle() {
    return Row(
      children: [
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            'Edit Client',
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
        context.go(RouteNames.isClients);
      },
    );
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.saveAndValidate()) {
      final formData = _formKey.currentState!.value;
      final client = Client(
        id: widget.client.id,
        name: formData['client_name'] as String,
        address: formData['client_address'] as String,
      );

      try {
        await Provider.of<IsClientsProvider>(
          context,
          listen: false,
        ).updateClient(client);
        if (mounted) {
          context.showSuccessSnackbar('Client updated successfully');
          context.go(RouteNames.isClients);
        }
      } catch (e) {
        if (mounted) {
          context.showErrorSnackbar('Failed to update client: $e');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (!didPop) {
          context.go(RouteNames.isClients);
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        appBar: AppBars(
          title: _buildLogoAndTitle(),
          leading: _buildBackButton(),
          action: [],
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [_buildFormCard(context)],
          ),
        ),
      ),
    );
  }

  Widget _buildFormCard(BuildContext context) {
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
              'Client Details',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF334155),
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Update the required information below',
              style: TextStyle(fontSize: 14.sp, color: AppTheme.headingform),
            ),
            SizedBox(height: 24.h),
            CustomTextFormField(
              name: 'client_name',
              labelText: 'Client Name',
              hintText: 'Enter client name',
              initialValue: widget.client.name,
              prefixIcon: Icons.person_outline,
              validators: [
                FormBuilderValidators.required(),
                FormBuilderValidators.minLength(2),
              ],
              fillColor: AppTheme.white,
              prefixIconColor: AppTheme.ironSmithPrimary,
              borderColor: AppTheme.grey,
              focusedBorderColor: AppTheme.ironSmithSecondary,
              borderRadius: 12.r,
            ),
            SizedBox(height: 24.h),
            CustomTextFormField(
              name: 'client_address',
              labelText: 'Client Address',
              hintText: 'Enter client address',
              initialValue: widget.client.address,
              prefixIcon: Icons.location_on_outlined,
              prefixIconColor: AppTheme.ironSmithPrimary,
              validators: [
                FormBuilderValidators.required(),
                FormBuilderValidators.minLength(5),
              ],
              fillColor: AppTheme.white,
              borderColor: AppTheme.grey,
              focusedBorderColor: AppTheme.ironSmithSecondary,
              borderRadius: 12.r,
            ),
            SizedBox(height: 24.h),
            Consumer<IsClientsProvider>(
              builder: (context, provider, child) {
                return SizedBox(
                  width: double.infinity,
                  height: 56.h,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: AppTheme.ironSmithGradient,
                      borderRadius: BorderRadius.circular(12.r),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.ironSmithPrimary.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: provider.isLoading ? null : _submitForm,
                        borderRadius: BorderRadius.circular(12.r),
                        child: Center(
                          child: provider.isLoading
                              ? CircularProgressIndicator(
                                  color: AppTheme.lightGray,
                                )
                              : Text(
                                  'Update Client',
                                  style: TextStyle(
                                    color: AppTheme.lightGray,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}