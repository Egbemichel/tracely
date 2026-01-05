import 'package:flutter/material.dart';

import 'icons.dart';


class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final Widget? prefixIcon;
  final bool isPassword;
  final TextInputType keyboardType;
  final double borderRadius;
  final Color backgroundColor;
  final Color borderColor;
  final Color focusedBorderColor;
  final Color textColor;
  final Color hintColor;
  final Color cursorColor;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.prefixIcon,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.borderRadius = 12.0,
    this.backgroundColor = Colors.white,
    this.borderColor = Colors.grey,
    this.focusedBorderColor = Colors.blue,
    this.textColor = Colors.black87,
    this.hintColor = Colors.grey,
    this.cursorColor = Colors.blue,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    _isPasswordVisible = !widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: BorderRadius.circular(widget.borderRadius),
        border: Border.all(color: widget.borderColor),
      ),
      child: TextField(
        controller: widget.controller,
        obscureText: widget.isPassword && !_isPasswordVisible,
        keyboardType: widget.keyboardType,
        cursorColor: widget.cursorColor,
        style: TextStyle(color: widget.textColor),
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: TextStyle(color: widget.hintColor),
          prefixIcon: widget.prefixIcon,
          suffixIcon:
              widget.isPassword
                  ? IconButton(
                    icon:
                        _isPasswordVisible
                            ? TracelyIcon(
                              path: 'assets/icons/eye.svg',
                              size: 24.0,
                              color: Colors.black54,
                            )
                            : TracelyIcon(
                              path: 'assets/icons/Eye off.svg',
                              size: 24.0,
                              color: Colors.black54,
                            ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  )
                  : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            borderSide: BorderSide(color: widget.borderColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            borderSide: BorderSide(color: widget.borderColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            borderSide: BorderSide(
              color: widget.focusedBorderColor,
              width: 2.0,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 15.0,
            horizontal: 10.0,
          ),
        ),
      ),
    );
  }
}
