import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class FeatureModel extends Equatable {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;

  const FeatureModel({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.backgroundColor,
  });

  @override
  List<Object?> get props => [title, subtitle];
}
