// TODO Implement this library.
import 'package:flutter/material.dart';

class Patient {
  final String id;
  final String name;
  final int heartRate;
  final int spo2;
  final double temperature;
  final String status;
  final Color statusColor;

  Patient(
    this.id,
    this.name,
    this.heartRate,
    this.spo2,
    this.temperature,
    this.status,
    this.statusColor,
  );
}
