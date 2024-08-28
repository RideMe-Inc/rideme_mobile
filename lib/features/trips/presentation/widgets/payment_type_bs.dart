import 'package:flutter/material.dart';
import 'package:rideme_mobile/features/trips/presentation/widgets/payment_type_selection.dart';
import 'package:rideme_mobile/features/trips/presentation/widgets/payment_type_selection_page.dart';

buildPaymentTypeSelectionBs(
        {required BuildContext context, required PaymentTypes? paymentType}) =>
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      builder: (context) => PaymentTypeSelectionPage(paymentTypes: paymentType),
    );
