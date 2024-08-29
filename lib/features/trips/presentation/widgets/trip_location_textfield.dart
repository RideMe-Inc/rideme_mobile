import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rideme_mobile/assets/images/image_name_constants.dart';
import 'package:rideme_mobile/assets/svgs/svg_name_constants.dart';
import 'package:rideme_mobile/core/size/sizes.dart';
import 'package:rideme_mobile/core/widgets/textfield/generic_textfield_widget.dart';

class TripLocationTextfield extends StatefulWidget {
  final String hint;
  final String? label;
  final bool isRequired;
  final String? errorText;
  final bool? hasSuffix;
  final bool? isPickup;
  final bool? filled;
  final bool enabled;
  final TextEditingController controller;
  final void Function(String)? onChanged;
  final void Function()? onTap;
  final void Function()? onMapTap;

  ///Creates a trip location widget for selecting and typing location details
  const TripLocationTextfield({
    super.key,
    required this.hint,
    required this.label,
    required this.isRequired,
    required this.errorText,
    required this.controller,
    required this.onChanged,
    this.enabled = true,
    this.hasSuffix,
    this.isPickup,
    this.onTap,
    this.onMapTap,
    this.filled = false,
  });

  @override
  State<TripLocationTextfield> createState() => _TripLocationTextfieldState();
}

class _TripLocationTextfieldState extends State<TripLocationTextfield> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GenericTextField(
          hint: widget.hint,
          filled: widget.filled,
          label: widget.label,
          errorText: widget.errorText,
          onChanged: widget.onChanged,
          enabled: widget.enabled,
          controller: widget.controller,
          onTap: widget.onTap,
          suffixIcon: null,
          prefixIcon: Tab(
            child: SvgPicture.asset(
              widget.isPickup ?? false
                  ? SvgNameConstants.startPointActiveSVG
                  : SvgNameConstants.searchSVG,
              fit: BoxFit.fitHeight,
              height: Sizes.height(context, 0.021),
            ),
          ),
          textInputAction: TextInputAction.search,
        ),
        if (widget.hasSuffix ?? true)

          // Positioned GestureDetector for suffix icon
          Positioned(
            top: 0,
            right: 10,
            bottom: 0,
            child: Align(
              alignment: Alignment.bottomRight,
              child: GestureDetector(
                onTap: widget.onMapTap,
                child: Tab(
                  child: Image.asset(
                    ImageNameConstants.mapIndicatorIMG,
                    height: Sizes.height(context, 0.03),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
