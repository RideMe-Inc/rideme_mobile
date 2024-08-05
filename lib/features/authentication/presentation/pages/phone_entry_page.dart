import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rideme_mobile/core/widgets/textfield/generic_textfield_widget.dart';

class PhoneEntryPage extends StatefulWidget {
  const PhoneEntryPage({super.key});

  @override
  State<PhoneEntryPage> createState() => _PhoneEntryPageState();
}

class _PhoneEntryPageState extends State<PhoneEntryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GenericTextField(
              label: 'First name',
              hint: 'Something',
              controller: TextEditingController(),
            ),
          ],
        ),
      ),
    );
  }
}
