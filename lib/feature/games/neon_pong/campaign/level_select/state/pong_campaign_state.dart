import 'package:freezed_annotation/freezed_annotation.dart';

part 'pong_campaign_state.freezed.dart';

@freezed
abstract class PongCampaignState with _$PongCampaignState {
  const factory PongCampaignState({
    /// Level progress map: levelId -> stars.
    @Default({}) Map<int, int> progress,
    /// Selected world index.
    @Default(0) int selectedWorldIndex,
  }) = _PongCampaignState;
}
