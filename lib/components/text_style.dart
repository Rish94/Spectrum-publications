import 'package:flutter/material.dart';

class Text_Style {
  static TextStyle small(
      {Color? color, FontWeight? fontWeight, double? fontSize, TextDecoration? decoration}) {
    return TextStyle(
        decoration: decoration,
        color: color ?? Colors.black,
        fontSize: fontSize ?? 12,
        fontWeight: fontWeight ?? FontWeight.w400);
  }

  static TextStyle medium(
      {Color? color, FontWeight? fontWeight, double? fontSize, TextDecoration? decoration}) {
    return TextStyle(
        decoration: decoration,
        color: color ?? Colors.black,
        fontSize: fontSize ?? 14,
        fontWeight: fontWeight ?? FontWeight.w400);
  }

  static TextStyle big(
      {Color? color, FontWeight? fontWeight, double? fontSize, TextDecoration? decoration}) {
    return TextStyle(
      decoration: decoration,
      color: color ?? Colors.black,
      fontSize: fontSize ?? 16,
      fontWeight: fontWeight ?? FontWeight.w600,
    );
  }

  static TextStyle large({
    Color? color,
    FontWeight? fontWeight,
    TextOverflow? overflow,
    double? fontSize,
    TextDecoration? decoration,
    Color? decorationColor,
  }) {
    return TextStyle(
        decoration: decoration,
        decorationColor: decorationColor,
        color: color ?? Colors.black,
        overflow: overflow ?? null,
        fontSize: fontSize ?? 20,
        fontWeight: fontWeight ?? FontWeight.w600);
  }
}
