import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:new_html_editor_example/Domain/html_data_model.dart';
import '../../Data/html_repo.dart';

class HtmlContentController extends Notifier<List<HtmlData>> {
  @override
  List<HtmlData> build() {
    return ref.read(repoProvider).getHtmlList();
  }

  void saveArticleProgress({
    required String articleID,
    String? articleData,
    Map<String, dynamic>? videoMetaData,
    Map<String, dynamic>? videosDurationsData,
    num? scrollProgress,
    num? totalProgress,
    num? videosTotalDuration,
    dynamic comments,
  }) {
    final myCurrentData = state;
    final videos =
        videoMetaData?.keys
            .where((key) => videosDurationsData?.containsKey(key) == true)
            .map(
              (key) => Video(
                videoUrl: key,
                savedDuration: videoMetaData[key],
                videoDuration: videosDurationsData?[key],
              ),
            )
            .toList();
    state = [
      for (final doc in myCurrentData)
        if (doc.articleID == articleID)
          doc.copyWith(
            isLocal: true,
            articleData: articleData,
            articleID: articleID,
            videos: videos,
            videosTotalDuration: videosTotalDuration,
            scrollProgress: scrollProgress,
            totalProgress: totalProgress,
            comments: comments,
          )
        else
          doc,
    ];
    // print(
    //   "This is the current state ${state.firstWhere((element) => element.articleID == articleID).comments}",
    // );
  }
}

final htmlContentControllerProvider =
    NotifierProvider.autoDispose<HtmlContentController, List<HtmlData>>(
      HtmlContentController.new,
    );

class ParamsUpateController extends Notifier<void> {
  @override
  void build() {}

  void updateTotalProgress(Map<String, dynamic> totalProgress) async {
    return await ref.read(repoProvider).updateTotalProgress(totalProgress);
  }

  void updateCurrentVideoProgress({
    required String articleID,
    required String videoUrl,
    required num currentPosition,
  }) async {
    return ref
        .read(repoProvider)
        .updateCurrentVideoPosition(
          articleID: articleID,
          videoUrl: videoUrl,
          currentPosition: currentPosition,
        );
  }

  void updateScrollProgress(num readProgress) async {
    //    print("Printing the scroll Progress of the article $readProgress");
    return await ref.read(repoProvider).updateScrollProgress(readProgress);
  }
}

final paramsUpateControllerProvider =
    NotifierProvider.autoDispose<ParamsUpateController, void>(
      ParamsUpateController.new,
    );
