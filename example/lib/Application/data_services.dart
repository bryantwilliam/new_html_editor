import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../Data/html_repo.dart';

///THE SERVICE CLASS IS TO GET THE AVAILABLE VIDEOS AND THE LAST SAVED DURATION
///TOGETHER WITH THE LAST SAVED SCROLL POSITION.
final dataServicesProvider = Provider.autoDispose
    .family<Map<String, dynamic>, int>((ref, index) {
      Map<String, dynamic> params = {};
      final data = ref.watch(repoProvider).getHtmlList();

      ///I want to get the videos and then map it to the values,
      ///I want to get the scrollPosition and then put it in the map also.
      if (data[index].videos?.isNotEmpty == true) {
        //   params['scrollPosition'] = data[index].scrollProgress;
        for (final video in data[index].videos!) {
          if (kIsWeb) {
            if (video.videoUrl?.contains('youtube') == true) {
              params['${video.videoUrl}?enablejsapi=1'] = video.savedDuration;
            } else {
              params[video.videoUrl!] = video.savedDuration;
            }
          } else {
            params[video.videoUrl!] = video.savedDuration;
          }
        }
      }
      return params;
    });

final mobileDataServicesProvider = Provider.autoDispose
    .family<Map<String, dynamic>, int>((ref, index) {
      Map<String, dynamic> params = {};
      final data = ref.watch(repoProvider).getHtmlList();

      if (data[index].videos?.isNotEmpty == true) {
        params['scrollPosition'] = data[index].scrollProgress;
        for (final video in data[index].videos!) {
          if (video.videoUrl?.contains('youtube') == true) {
            params['${video.videoUrl}?enablejsapi=1'] = video.savedDuration;
          } else {
            params[video.videoUrl!] = video.savedDuration;
          }
        }
      }
      return params;
    });

final videoTotalDurationProvider = Provider.autoDispose.family<int, int>((
  ref,
  index,
) {
  final data = ref.watch(repoProvider).getHtmlList();
  final totalDuration = data[index].videosTotalDuration?.toInt();
  return totalDuration ?? 0;
});

final getVideoDurationsProvider = Provider.autoDispose
    .family<Map<String, dynamic>, int>((ref, index) {
      Map<String, dynamic> params = {};
      final data = ref.watch(repoProvider).getHtmlList();
      if (data[index].videos?.isNotEmpty == true) {
        for (final video in data[index].videos!) {
          if (kIsWeb) {
            if (video.videoUrl?.contains('youtube') == true) {
              params['${video.videoUrl}?enablejsapi=1'] = video.videoDuration;
            } else {
              params[video.videoUrl!] = video.videoDuration;
            }
          } else {
            params[video.videoUrl!] = video.videoDuration;
          }
        }
        return params;
      }
      return params;
    });
