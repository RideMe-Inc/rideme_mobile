import 'package:flutter/material.dart';
import 'package:rideme_mobile/assets/images/image_name_constants.dart';
import 'package:rideme_mobile/core/extensions/context_extensions.dart';
import 'package:rideme_mobile/core/size/sizes.dart';
import 'package:rideme_mobile/core/spacing/whitspacing.dart';
import 'package:rideme_mobile/core/theme/app_colors.dart';
import 'package:rideme_mobile/features/onboarding/domain/entities/onboarding_info.dart';
import 'package:rideme_mobile/features/onboarding/presentation/widgets/onboarding_transition.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  int currentIndex = 0;
  PageController controller = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    List<OnboardingInfo> onboardingContent = [
      OnboardingInfo(
        title: context.appLocalizations.ecoFriendly,
        body: context.appLocalizations.ecoFriendlyNotice,
        imagePath: ImageNameConstants.onboardingIMG1,
      ),
      OnboardingInfo(
        title: context.appLocalizations.safetyFeatures,
        body: context.appLocalizations.safetyFeaturesNotice,
        imagePath: ImageNameConstants.onboardingIMG2,
      ),
      OnboardingInfo(
        title: context.appLocalizations.subscriptionPlans,
        body: context.appLocalizations.subscriptionPlansNotice,
        imagePath: ImageNameConstants.onboardingIMG3,
      ),
    ];
    return Scaffold(
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: PageView.builder(
          controller: controller,
          itemCount: onboardingContent.length,
          onPageChanged: (value) {
            currentIndex = value;
            setState(() {});
          },
          itemBuilder: (context, index) {
            return Image.asset(
              onboardingContent[index].imagePath,
              fit: BoxFit.cover,
            );
          },
        ),
      ),
      bottomSheet: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(15),
            topLeft: Radius.circular(15),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.only(
            left: Sizes.height(context, 0.01),
            right: Sizes.height(context, 0.01),
            top: Sizes.height(context, 0.009),
            bottom: Sizes.height(context, 0.017),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              //TRANSITION
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ...List.generate(
                    onboardingContent.length,
                    (index) {
                      return OnboardingTransition(
                          index: index, currentIndex: currentIndex);
                    },
                  )
                ],
              ),

              Space.height(context, 0.02),

              //TITLE
              Text(
                onboardingContent[currentIndex].title,
                style: context.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),

              Space.height(context, 0.016),

              //BODY
              Text(
                onboardingContent[currentIndex].body,
                style: context.textTheme.displayMedium?.copyWith(
                  color: AppColors.rideMeBlackLightActive,
                ),
                textAlign: TextAlign.center,
              ),

              Space.height(context, 0.03),

              //BUTTONS
            ],
          ),
        ),
      ),
    );
  }
}
