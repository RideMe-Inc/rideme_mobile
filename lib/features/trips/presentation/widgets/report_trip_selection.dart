import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rideme_mobile/core/extensions/context_extensions.dart';
import 'package:rideme_mobile/core/size/sizes.dart';
import 'package:rideme_mobile/core/spacing/whitspacing.dart';
import 'package:rideme_mobile/core/theme/app_colors.dart';
import 'package:rideme_mobile/core/widgets/buttons/generic_button_widget.dart';
import 'package:rideme_mobile/core/widgets/loaders/loading_indicator.dart';
import 'package:rideme_mobile/core/widgets/popups/error_popup.dart';
import 'package:rideme_mobile/core/widgets/popups/success_popup.dart';
import 'package:rideme_mobile/core/widgets/textfield/generic_textfield_widget.dart';
import 'package:rideme_mobile/features/authentication/presentation/provider/authentication_provider.dart';
import 'package:rideme_mobile/features/trips/presentation/bloc/trips_bloc.dart';
import 'package:rideme_mobile/injection_container.dart';

class ReportTripReasonsPage extends StatefulWidget {
  final String tripId;
  const ReportTripReasonsPage({
    super.key,
    required this.tripId,
  });

  @override
  State<ReportTripReasonsPage> createState() => _ReportTripReasonsPageState();
}

class _ReportTripReasonsPageState extends State<ReportTripReasonsPage> {
  final tripBloc = sl<TripsBloc>();
  String? reason;
  final reasonController = TextEditingController();

  reportTrip() {
    final params = {
      'locale': context.appLocalizations.localeName,
      'bearer': context.read<AuthenticationProvider>().token,
      'urlParameters': {
        'id': widget.tripId,
      },
      'body': {
        'comment': reasonController.text != '' ? reasonController.text : reason,
      }
    };

    tripBloc.add(ReportTripEvent(params: params));
  }

  int? indexSelected;

  @override
  Widget build(BuildContext context) {
    List<String> reportReasons = [
      context.appLocalizations.unProfessionalBehaviour,
      context.appLocalizations.cancelReason3,
      context.appLocalizations.cancelReason4,
      context.appLocalizations.others,
    ];
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: Sizes.width(context, 0.04),
      ),
      decoration: BoxDecoration(
        color: AppColors.rideMeBackgroundLight,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(Sizes.height(context, 0.02)),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Space.height(context, 0.007),
          Center(
            child: Container(
              width: Sizes.width(context, 0.08),
              height: Sizes.height(context, 0.005),
              decoration: BoxDecoration(
                color: AppColors.rideMeGreyNormal,
                borderRadius: BorderRadius.circular(
                  Sizes.height(context, 0.005),
                ),
              ),
            ),
          ),
          Space.height(context, 0.011),
          Center(
            child: Text(
              context.appLocalizations.reportTrip,
              style: context.textTheme.displayMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          Space.height(context, 0.028),

          Text(
            context.appLocalizations.reportTripDescription,
            style: context.textTheme.displaySmall,
          ),
          Space.height(context, 0.023),

          //payment types

          ...List.generate(
            reportReasons.length,
            (index) => _CancelReasonTile(
              label: reportReasons[index],
              isSelected: indexSelected == index,
              onTap: () {
                indexSelected = index;

                reason = reportReasons[indexSelected!];

                setState(() {});
              },
            ),
          ),

          if (reason == context.appLocalizations.others)
            GenericTextField(
              hint: '',
              label: null,
              maxLines: 4,
              errorText: null,
              controller: reasonController,
              onChanged: (p0) {
                setState(() {
                  reasonController.text = p0;
                });
              },
            ),

          Space.height(context, 0.044),
          BlocConsumer(
            bloc: tripBloc,
            listener: (context, state) {
              if (state is ReportTripLoaded) {
                context.pop();
                showSuccessPopUp(state.report, context);
              }

              if (state is GenericTripsError) {
                showErrorPopUp(state.errorMessage, context);
                if (kDebugMode) print(state.errorMessage);
              }
            },
            builder: (context, state) {
              if (state is ReportTripLoading) {
                return const LoadingIndicator();
              }
              return GenericButton(
                onTap: reportTrip,
                label: context.appLocalizations.reportTrip,
                buttonColor: AppColors.rideMeErrorNormal,
                isActive: indexSelected != null,
              );
            },
          ),
          Space.height(context, 0.03),
        ],
      ),
    );
  }
}

class _CancelReasonTile extends StatelessWidget {
  final VoidCallback onTap;
  final bool isSelected;
  final String label;
  const _CancelReasonTile({
    required this.onTap,
    required this.isSelected,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
      leading: Container(
        width: Sizes.width(context, 0.05),
        height: Sizes.height(context, 0.1),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected
                ? AppColors.rideMeBlueNormal
                : AppColors.rideMeGreyNormalActive,
          ),
        ),
        child: isSelected
            ? Center(
                child: SizedBox(
                  height: Sizes.height(context, 0.015),
                  child: const CircleAvatar(
                    backgroundColor: AppColors.rideMeBlueNormal,
                  ),
                ),
              )
            : null,
      ),
      title: Text(
        label,
        style: context.textTheme.displaySmall?.copyWith(
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
