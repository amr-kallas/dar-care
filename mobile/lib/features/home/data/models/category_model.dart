import 'package:solar_icon_pack/solar_icon_pack.dart';
import 'package:flutter/material.dart';

class CategoryModel {
  final String id;
  final String name;
  final String? description;

  const CategoryModel({
    required this.id,
    required this.name,
    this.description,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
    );
  }

  // Helper to map DB names to Icons
  IconData get icon {
    final lowerName = name.toLowerCase();
    if (lowerName.contains('plumb')) return SolarLinearIcons.waterdrop;
    if (lowerName.contains('ac') || lowerName.contains('cool')) return SolarLinearIcons.snowflake;
    if (lowerName.contains('elec')) return SolarLinearIcons.bolt;
    if (lowerName.contains('clean')) return SolarLinearIcons.broom;
    if (lowerName.contains('carpen')) return SolarLinearIcons.sledgehammer;
    if (lowerName.contains('pest')) return SolarLinearIcons.bug;
    if (lowerName.contains('paint')) return SolarLinearIcons.paintRoller;
    return SolarLinearIcons.box; // Default icon
  }
}

