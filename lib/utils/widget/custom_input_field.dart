import 'package:flutter/material.dart';

class CustomInputField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final Function(String?)? onSaved;
  final TextInputType keyboardType;

  const CustomInputField({
    super.key,
    required this.controller,
    required this.hintText,
    this.onSaved,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomCenter,
      margin: const EdgeInsets.only(left: 15, right: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Theme.of(context).primaryColor.withOpacity(0.35),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 5, left: 20, right: 20),
        child: TextFormField(
          controller: controller,
          onSaved: onSaved,
          keyboardType: keyboardType,
          decoration: InputDecoration(
              hintText: hintText,
              hintStyle: const TextStyle(
                fontFamily: 'Gotham',
                fontWeight: FontWeight.w400,
                fontSize: 12.0,
              ),
              enabledBorder: InputBorder.none),
        ),
      ),
    );
  }
}
