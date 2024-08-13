import 'package:flutter/material.dart';

import 'package:rideme_mobile/core/size/sizes.dart';
import 'package:rideme_mobile/core/spacing/whitspacing.dart';
import 'package:rideme_mobile/core/widgets/become_a_driver_card.dart';
import 'package:rideme_mobile/features/home/presentation/widgets/dropoff_field_widget.dart';

class IAMScreenImplementer extends StatefulWidget {
  const IAMScreenImplementer({super.key});

  @override
  State<IAMScreenImplementer> createState() => _IAMScreenImplementerState();
}

class _IAMScreenImplementerState extends State<IAMScreenImplementer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(Sizes.height(context, 0.02)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BecomeADriverCard(),
            Space.height(context, 0.05),
            SetDropOffField(dropOffOnTap: null, schedularOnTap: null)
          ],
        ),
      ),
    );
  }
}
