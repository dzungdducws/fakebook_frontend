import 'package:flutter/material.dart';
@immutable
class Configuration {
  static const port = '5001';
  // chỉ hoạt động với web, đối với physical device phải dùng ip
  static const String baseUrl = 'localhost:5001';
  static const String baseUrlPhysicalDevice = '192.168.1.5:5001';
  static const String baseUrlPhysicalDevice2 = '10.0.2.2:5001';
  static const String token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhY2NvdW50X2lkIjoiNjNiYmZmMThmYzEzYWU2NDkzMDAwODJhIiwicGhvbmVOdW1iZXIiOiIwMTIzNDU2Nzg5IiwiaWF0IjoxNjc1NTA2NTA2LCJleHAiOjE2NzgwOTg1MDZ9.YRLyFEV1VKKCBP8QwVJ4ZFDz7BJjNUfOK0BK3CvvdHw';
}