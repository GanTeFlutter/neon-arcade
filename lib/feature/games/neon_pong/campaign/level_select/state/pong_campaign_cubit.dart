import 'package:akillisletme/feature/games/neon_pong/campaign/level_select/state/pong_campaign_state.dart';
import 'package:akillisletme/product/service/service_locator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Campaign progress cubit.
class PongCampaignCubit extends Cubit<PongCampaignState> {
  PongCampaignCubit() : super(const PongCampaignState()) {
    _loadProgress();
  }

  void _loadProgress() {
    emit(state.copyWith(progress: locator.scoreService.pongProgress));
  }

  void selectWorld(int index) {
    emit(state.copyWith(selectedWorldIndex: index));
  }

  void refresh() => _loadProgress();

  /// Level lock status.
  bool isUnlocked(int levelId) {
    if (levelId == 1) return true;
    final prevStars = state.progress[levelId - 1] ?? 0;
    final selfStars = state.progress[levelId] ?? 0;
    return prevStars > 0 || selfStars > 0;
  }

  int starsFor(int levelId) => state.progress[levelId] ?? 0;
}
