import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart' show AssetEntity;

@immutable
abstract class VideoState {}

class VideoInitial extends VideoState {}

class VideoLoading extends VideoState {}

class VideoLoaded extends VideoState {
  final List<AssetEntity> videos;
  final String? message; // لو عايز رسالة زي "No videos found"

  VideoLoaded(this.videos, {this.message});
}

class VideoError extends VideoState {
  final String message;
  VideoError(this.message);
}
