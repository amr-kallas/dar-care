import 'package:dar_care/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ClientHomeErrorState extends StatelessWidget {
  const ClientHomeErrorState({super.key, required this.errorKey});

  final String? errorKey;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        (errorKey?.trim().isNotEmpty ?? false)
            ? errorKey!.tr()
            : LocaleKeys.home_error_generic.tr(),
      ),
    );
  }
}
