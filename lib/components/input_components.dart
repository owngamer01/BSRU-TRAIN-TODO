import 'package:flutter/material.dart';

class InputComponent extends StatelessWidget {

  final EdgeInsets margin;
  final InputDecoration decoration;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final bool isPassword;
  final String labelText;
  final Function(String) onChange;
  final TextEditingController controller;

  InputComponent(this.controller, {
    this.margin,
    this.decoration,
    this.keyboardType,
    this.textInputAction,
    this.labelText,
    this.onChange,
    this.isPassword = false
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin ?? EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          (this.labelText ?? '').isNotEmpty 
            ? Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: Text(this.labelText, style: TextStyle(fontSize: 12)),
            ) 
            : Container(),
          
          Stack(
            children: [
              Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(0, 4),
                      spreadRadius: 2,
                      color: Colors.grey[200],
                      blurRadius: 4
                    )
                  ]
                ),
              ),
              TextFormField(
                style: TextStyle(
                  fontSize: 14
                ),
                validator: (text) {
                  return text.isEmpty ? 'This field is empty' : null;
                },
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: this.controller,
                obscureText: this.isPassword,
                textInputAction: this.textInputAction,
                keyboardType: this.keyboardType,
                onChanged: this.onChange,
                decoration: (this.decoration ?? InputDecoration()).applyDefaults(decorationTheme()),
              )
            ],
          ),
        ],
      ),
    );
  }

  InputDecorationTheme decorationTheme() {
    return new InputDecorationTheme(
      contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      isDense: true,
      hintStyle: TextStyle(
        fontSize: 14
      ),
      border: borderInput,
      enabledBorder: borderInput,
      disabledBorder: borderInput,
      filled: true,
      fillColor: Colors.white
    );
  }

  OutlineInputBorder get borderInput => OutlineInputBorder(
    borderRadius: BorderRadius.circular(5),
    borderSide: BorderSide(
      color: Colors.white,
      width: 1
    ),
  );
  
}