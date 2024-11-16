import 'package:flutter/material.dart';


import '../core/field_callback.dart';
import '../core/form_style.dart';
import '../enums/field_status.dart';
import '../util/util.dart';
import 'field.dart';
import 'section.dart';

// ignore: must_be_immutable
class GSForm extends StatelessWidget {
  GSFormStyle? style;
  late List<GSSection> sections;
  late List<Widget> fields;

  GSForm.singleSection(BuildContext context, {Key? key, this.style, required this.fields}) : super(key: key) {
    style ??= GSFormUtils.checkIfDarkModeEnabled(context)
        ? style ?? GSFormStyle.singleSectionFormDefaultDarkStyle
        : GSFormStyle.singleSectionFormDefaultStyle;
    sections = [
      GSSection(
        style: style,
        sectionTitle: null,
        fields: fields,
      )
    ];
    GSForm.multiSection(
      context,
      style: style,
      sections: sections,
    );
  }

  GSForm.multiSection(BuildContext context, {Key? key, this.style, required this.sections}) : super(key: key) {
    style ??= GSFormUtils.checkIfDarkModeEnabled(context)
        ? style ?? GSFormStyle.multiSectionFormDefaultDarkStyle
        : GSFormStyle.multiSectionFormDefaultStyle;
    for (var element in sections) {
      element.style = style;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: sections,
    );
  }

  bool isValid() {
    bool isValid = true;
    for (var section in sections) {
      for (var field in section.fields) {
        if (field is GSField) {
          bool fieldValidation = (field.child as GSFieldCallBack).isValid();
          field.model?.status = fieldValidation ? GSFieldStatusEnum.success : GSFieldStatusEnum.error;
          isValid = isValid && fieldValidation;
          field.update();
        }
      }
    }
    return isValid;
  }

  Map<String, dynamic> onSubmit() {
    Map<String, dynamic> data = {};
    for (var section in sections) {
      for (var filed in section.fields) {
        if (filed is GSField) {
          data[filed.model?.tag ?? ''] = (filed.child as GSFieldCallBack).getValue();
        }
      }
    }
    return data;
  }
}
