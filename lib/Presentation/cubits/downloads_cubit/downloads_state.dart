import '../../../models/download_model.dart';

abstract class DownloadsState {}

class DownloadsInitial extends DownloadsState {}

class DownloadsLoading extends DownloadsState {}

class DownloadsSuccess extends DownloadsState {
  final List<DownloadModel> downloads;

  DownloadsSuccess(this.downloads);
}

class DownloadsEmpty extends DownloadsState {}

class DownloadsError extends DownloadsState {
  final String message;

  DownloadsError(this.message);
}