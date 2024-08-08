import 'package:flutter/material.dart';

import 'package:rideme_mobile/assets/images/image_name_constants.dart';
import 'package:rideme_mobile/core/size/sizes.dart';
import 'package:rideme_mobile/core/widgets/become_a_driver_card.dart';

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
          ],
        ),
      ),
    );
  }
}
