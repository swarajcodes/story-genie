import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:story_genie/core/app_colours.dart';
import 'package:story_genie/core/app_textstyles.dart';
import 'package:story_genie/widgets/shared/spacing.dart';

class AppDropdownField<T> extends StatelessWidget {
  final List<T> items;
  final T? value;
  final void Function(T?)? onChanged;
  final String? Function(T?)? validator;
  final Widget Function(T)? customItem;
  final String Function(T)? displayItem;
  final String? label, hint;
  final String? headingText;
  final Widget? prefix;
  final FocusNode? focusNode;
  final bool enabled;
  final Color? fillColor;
  final bool hasBorder;

  const AppDropdownField({
    super.key,
    required this.items,
    required this.value,
    this.onChanged,
    this.validator,
    this.label,
    this.hint,
    this.headingText,
    this.prefix,
    this.enabled = true,
    this.fillColor,
    this.focusNode,
    this.customItem,
    this.displayItem,
    this.hasBorder = true,
  });
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null)
          Text(
            label!,
            style: AppTextStyles.medium14.copyWith(
              color: colorScheme.onSurface,
            ),
          ),
        if (label != null) Spacing.vertExtraTiny(),
        if (label != null) Spacing.vertTiny(),
        DropdownButtonFormField<T>(
          items:
              items.map((T item) {
                if (customItem != null) {
                  return DropdownMenuItem(
                    value: item,
                    child: customItem!(item),
                  );
                }
                return DropdownMenuItem(
                  value: item,
                  child: Text(
                    displayItem != null ? displayItem!(item) : item.toString(),
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                    style: AppTextStyles.medium16.copyWith(
                      color: colorScheme.onSurface,
                      height: .4,
                    ),
                  ),
                );
              }).toList(),
          isExpanded: true,
          onChanged: onChanged,
          validator: validator,
          value: value,
          focusNode: focusNode,
          icon: const Icon(Icons.keyboard_arrow_down, size: 0),
          style: AppTextStyles.medium16.copyWith(
            color: colorScheme.onSurface,
          ),
          decoration: AppTextField.kOutlineDecoration(
            colorScheme: colorScheme,
          ).copyWith(
            hintText: hint,
            prefixIcon: prefix,
            enabled: enabled,
            suffixIcon: Icon(
              Icons.keyboard_arrow_down,
              color: colorScheme.onSurface,
              size: 25.sp,
            ),
          ),
        ),
      ],
    );
  }
}

class AppTextField extends StatelessWidget {
  final String? label;
  final String? hint;
  final String? initialValue;
  final bool obscureText;
  final InputBorder? border;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String)? onFieldSubmitted;
  final void Function()? onTap;
  final void Function()? onEditingComplete;
  final TextInputType? keyboardType;
  final TextCapitalization textCapitalization;
  final TextAlignVertical? textAlignVertical;
  final TextAlign? textAlign;
  final Widget? suffix;
  final Widget? prefix;
  final Widget? bottomRightWidget;
  final bool readOnly;
  final bool expands;
  final bool hasBorder;
  final int? minLines, maxLines, maxLength;
  final bool enabled;
  final Color? fillColor;
  final InputDecoration? decoration;
  final List<TextInputFormatter>? inputFormatters;

  const AppTextField({
    super.key,
    this.label,
    this.hint,
    this.controller,
    this.validator,
    this.border,
    this.keyboardType,
    this.textCapitalization = TextCapitalization.none,
    this.suffix,
    this.obscureText = false,
    this.prefix,
    this.initialValue,
    this.focusNode,
    this.readOnly = false,
    this.expands = false,
    this.hasBorder = true,
    this.minLines,
    this.maxLines,
    this.maxLength,
    this.enabled = true,
    this.onChanged,
    this.onFieldSubmitted,
    this.fillColor,
    this.onTap,
    this.onEditingComplete,
    this.decoration,
    this.textAlign,
    this.textAlignVertical,
    this.bottomRightWidget,
    this.inputFormatters,
  }) : assert(initialValue == null || controller == null);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null)
          Text(
            label!,
            style: AppTextStyles.medium14.copyWith(color: AppColors.black),
          ),
        if (label != null) Spacing.vertExtraTiny(),
        if (label != null) Spacing.vertTiny(),
        TextFormField(
          enabled: enabled,
          controller: controller,
          initialValue: initialValue,
          onChanged: onChanged,
          onFieldSubmitted: onFieldSubmitted,
          onTap: onTap,
          keyboardType: keyboardType,
          cursorWidth: 1,
          textCapitalization: textCapitalization,
          obscureText: obscureText,
          obscuringCharacter: '●',
          readOnly: readOnly,
          focusNode: focusNode,
          expands: expands,
          maxLines: maxLines,
          validator: validator,
          minLines: minLines,
          // maxLength: maxLength,
          inputFormatters: [
            LengthLimitingTextInputFormatter(maxLength),
            ...inputFormatters ?? [],
          ],
          textAlignVertical: textAlignVertical ?? TextAlignVertical.bottom,
          textAlign: textAlign ?? TextAlign.start,
          onEditingComplete:
              onEditingComplete ?? () => FocusScope.of(context).nextFocus(),
          style: AppTextStyles.regular16.copyWith(height: 1.2),
          decoration:
              decoration ??
              kOutlineDecoration().copyWith(
                hintText: hint,
                suffixIcon: suffix,
                prefixIcon:
                    (prefix != null)
                        ? Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 10.r),
                              child: prefix!,
                            ),
                          ],
                        )
                        : null,
                enabled: enabled,
                border: border,
                alignLabelWithHint:
                    maxLines != null && keyboardType == TextInputType.multiline,
              ),
        ),
      ],
    );
  }

  static InputDecoration kOutlineDecoration({ColorScheme? colorScheme}) =>
      InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 13.w),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: colorScheme?.outline ?? AppColors.gray300,
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: colorScheme?.outline ?? AppColors.gray300,
            width: 1,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: colorScheme?.outline ?? AppColors.gray300,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: colorScheme?.primary ?? AppColors.gray300,
            width: 1,
          ),
        ),
        filled: true,
        fillColor: colorScheme?.surface ?? AppColors.white,
        hintStyle: AppTextStyles.regular16.copyWith(
          color: colorScheme?.onSurface ?? AppColors.gray600,
        ),
      );
}
