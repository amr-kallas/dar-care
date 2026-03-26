import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:solar_icon_pack/solar_icon_pack.dart';
import '../../../../generated/locale_keys.g.dart';
import 'stat_card.dart';

class ProfileStats extends StatelessWidget {
  const ProfileStats({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        StatCard(title: LocaleKeys.completed_orders.tr(), value: '12'),
        StatCard(title: LocaleKeys.addresses.tr(), value: '3'),
        StatCard(
          title: LocaleKeys.my_rating.tr(),
          value: '4.8',
          icon: SolarBoldIcons.star,
        ),
      ],
    );
  }
}
