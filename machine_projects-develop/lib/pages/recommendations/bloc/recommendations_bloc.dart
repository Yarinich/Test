import 'package:machine/base/bloc/base_bloc.dart';
import 'package:machine/data/network/apis/recommendations_api.dart';
import 'package:machine/data/network/requests/get_recommendations_request.dart';
import 'package:machine/pages/recommendations/bloc/recommendation_event.dart';
import 'package:machine/pages/recommendations/bloc/recommendation_state.dart';
import 'package:machine/utils/extensions/emitter_ext.dart';
import 'package:machine/utils/mixins/logout_bloc_mixin.dart';

class RecommendationsBloc extends BaseBloc with LogoutBlocMixin {
  RecommendationsBloc() {
    on<GetRecommendationsEvent>(
      (event, emit) => emit.async(_getRecommendations()),
    );
  }

  final _recommendationsApi = RecommendationsApi();

  Stream<BaseState> _getRecommendations() {
    return doAsync(
      () => _recommendationsApi.getRecommendations(GetRecommendationsRequest()),
      onComplete: GotRecommendationsState.new,
    );
  }
}
