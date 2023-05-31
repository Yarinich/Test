import 'package:flutter/material.dart';
import 'package:machine/application/app.dart';
import 'package:machine/base/bloc/base_bloc.dart';
import 'package:machine/base/page/base_page_state.dart';
import 'package:machine/data/models/resources/resource_info.dart';
import 'package:machine/pages/auth/sign_in/sign_in_page.dart';
import 'package:machine/pages/bottom_navigation/page_refresh_controller.dart';
import 'package:machine/pages/resource_info/bloc/resource_bloc.dart';
import 'package:machine/pages/resource_info/bloc/resource_event.dart';
import 'package:machine/pages/resource_info/bloc/resource_state.dart';
import 'package:machine/utils/extensions/enum_ext.dart';
import 'package:machine/utils/extensions/navigator_state_ext.dart';
import 'package:machine/utils/mixins/logout_event.dart';
import 'package:machine/widgets/popup_menu.dart';

class ResourceInfoPage extends StatefulWidget {
  const ResourceInfoPage({this.controller, Key? key}) : super(key: key);

  static const bottomNavIndex = 0;
  final ResourcePageRefreshController? controller;

  @override
  State<ResourceInfoPage> createState() => _ResourceInfoPageState();
}

class _ResourceInfoPageState
    extends BasePageState<ResourceInfoPage, ResourceBloc> {
  ResourceInfo? _resource;

  @override
  ResourceBloc createBloc() => ResourceBloc();

  @override
  void initState() {
    super.initState();
    bloc.add(GetResourceInfoEvent());
    widget.controller?.addListener(_getResources);
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_getResources);
    super.dispose();
  }

  @override
  void onRebuild(BuildContext context, BaseState state) {
    super.onRebuild(context, state);
    if (state is ReceivedResourcesState) {
      _resource = state.resourceInfo;
    }
  }

  @override
  Widget bodyWidget(BuildContext context) {
    final conditioner = _resource?.conditioner;
    final innerSensor = _resource?.innerSensor;
    final outerSensor = _resource?.outerSensor;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Resource Info'),
        centerTitle: true,
        actions: [PopupMenu(onLogout: _logout)],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Conditioner',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 16),

                  /// Status
                  Row(
                    children: [
                      const Text('Status: '),
                      Checkbox(
                        value: conditioner?.status ?? false,
                        onChanged: null,
                      ),
                    ],
                  ),
                  const SizedBox(width: 10),

                  /// State
                  Text('State: ${conditioner?.state?.sentenceCase}'),
                  const SizedBox(height: 10),
                  Text('Power: ${conditioner?.power}'),
                  const SizedBox(height: 10),
                  Text('Work Temperature:  ${conditioner?.workTemperature} '),
                ],
              ),
            ),
            const SizedBox(height: 32),
            const Divider(),
            const SizedBox(height: 16),

            /// Inner sensor
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Inner sensor',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text('Temperature: ${innerSensor?.temperature}'),
                  const SizedBox(height: 10),
                  Text('Humidity:  ${innerSensor?.humidity}'),
                ],
              ),
            ),
            const SizedBox(height: 32),
            const Divider(),
            const SizedBox(height: 16),

            /// Outer sensor
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Outer sensor',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text('Temperature: ${outerSensor?.temperature}'),
                  const SizedBox(height: 10),
                  Text('Humidity: ${outerSensor?.humidity}'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  FutureOr<void> onAction(BuildContext context, ActionState state) {
    if (state is LogoutState) {
      nav?.pushNamedAndRemoveAll(SignInPage.routeName);
    }
    return super.onAction(context, state);
  }

  void _logout() => bloc.add(LogoutEvent());

  void _getResources() {
    bloc.add(GetResourceInfoEvent());
  }
}
