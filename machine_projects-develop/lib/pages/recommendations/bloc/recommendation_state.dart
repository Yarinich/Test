import 'package:machine/base/bloc/base_bloc.dart';
import 'package:machine/data/models/recommendation.dart';

class GotRecommendationsState extends BaseState {
  const GotRecommendationsState(this.recommendations);

  final Recommendations recommendations;
}
