import 'package:epi_extensions/src/timeago.dart';

extension TimeAgo on DateTime {
  String timeAgo({DateTime? clock, bool allowFromNow = false, bool shortFormat = false}) {
    return getTimeAgo(this, clock: clock, allowFromNow: allowFromNow, shortFormat: shortFormat);
  }
}
