import 'package:flutter/material.dart';
import 'package:machine/application/app.dart';
import 'package:machine/base/bloc/base_bloc.dart';
import 'package:machine/base/page/base_page_state.dart';
import 'package:machine/data/models/recommendation.dart';
import 'package:machine/pages/auth/sign_in/sign_in_page.dart';
import 'package:machine/pages/bottom_navigation/page_refresh_controller.dart';
import 'package:machine/pages/recommendations/bloc/recommendation_event.dart';
import 'package:machine/pages/recommendations/bloc/recommendation_state.dart';
import 'package:machine/pages/recommendations/bloc/recommendations_bloc.dart';
import 'package:machine/utils/extensions/navigator_state_ext.dart';
import 'package:machine/utils/mixins/logout_event.dart';
import 'package:machine/widgets/popup_menu.dart';

class RecommendationsPage extends StatefulWidget {
  const RecommendationsPage({this.controller, Key? key}) : super(key: key);

  static const bottomNavIndex = 1;
  final RecommendationPageRefreshCtr? controller;

  @override
  State<RecommendationsPage> createState() => _RecommendationsPageState();
}

class _RecommendationsPageState
    extends BasePageState<RecommendationsPage, RecommendationsBloc> {
  Recommendations? _recommendations;

  @override
  RecommendationsBloc createBloc() => RecommendationsBloc();

  @override
  void initState() {
    super.initState();
    bloc.add(GetRecommendationsEvent());
    widget.controller?.addListener(_reloadRecommendations);
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_reloadRecommendations);
    super.dispose();
  }

  @override
  void onRebuild(BuildContext context, BaseState state) {
    super.onRebuild(context, state);
    if (state is GotRecommendationsState) {
      _recommendations = state.recommendations;
    }
  }

  @override
  Widget bodyWidget(BuildContext context) {
    final advises = _recommendations?.advise;

    return Scaffold(
        appBar: AppBar(
          title: const Text('Recommendations'),
          centerTitle: true,
          actions: [PopupMenu(onLogout: _logout)],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _reloadRecommendations,
          child: const Icon(Icons.refresh),
        ),
        body: advises != null
            ? ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: advises.length,
                itemBuilder: (context, index) {
                  final advise = advises[index];

                  return Stack(
                    children: [
                      Card(
                        elevation: 6,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Recommendation #${index + 1}    ',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                advise,
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              )
            : const Center(
                child: Text(
                  'No recommendations',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ));
  }

  @override
  FutureOr<void> onAction(BuildContext context, ActionState state) {
    if (state is LogoutState) {
      nav?.pushNamedAndRemoveAll(SignInPage.routeName);
    }
    return super.onAction(context, state);
  }

  void _reloadRecommendations() => bloc.add(GetRecommendationsEvent());

  void _logout() => bloc.add(LogoutEvent());
}
