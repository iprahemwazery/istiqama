import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class PrayerModel extends Equatable {
  final String name;
  final String time;
  final IconData icon;
  final Color color;

  const PrayerModel({
    required this.name,
    required this.time,
    required this.icon,
    required this.color,
  });

  @override
  List<Object?> get props => [name, time];
}
