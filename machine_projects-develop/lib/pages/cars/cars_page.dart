import 'package:flutter/material.dart';
import 'package:machine/application/app.dart';
import 'package:machine/base/bloc/base_bloc.dart';
import 'package:machine/base/page/base_page_state.dart';
import 'package:machine/data/models/car.dart';
import 'package:machine/pages/auth/sign_in/sign_in_page.dart';
import 'package:machine/pages/cars/bloc/car_event.dart';
import 'package:machine/pages/cars/bloc/car_state.dart';
import 'package:machine/pages/cars/bloc/cars_bloc.dart';
import 'package:machine/pages/cars/widgets/car_widget.dart';
import 'package:machine/utils/extensions/navigator_state_ext.dart';
import 'package:machine/utils/mixins/logout_event.dart';
import 'package:machine/widgets/popup_menu.dart';

class CarsPage extends StatefulWidget {
  const CarsPage({Key? key}) : super(key: key);

  @override
  State<CarsPage> createState() => _CarsPageState();
}

class _CarsPageState extends BasePageState<CarsPage, CarsBloc> {
  Car? _carInfo;

  @override
  CarsBloc createBloc() => CarsBloc();

  @override
  void initState() {
    super.initState();
    bloc.add(GetCarInfoEvent());
  }

  @override
  void onRebuild(BuildContext context, BaseState state) {
    super.onRebuild(context, state);
    if (state is ReceivedCarInfoState) {
      _carInfo = state.car;
    }
  }

  @override
  Widget bodyWidget(BuildContext context) {
    final carInfo = _carInfo;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cars info'),
        centerTitle: true,
        actions: [PopupMenu(onLogout: _logout)],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: carInfo != null
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    ' Car #1',
                    style: TextStyle(color: Colors.black45),
                  ),
                  CarWidget(carInfo: carInfo),
                ],
              )
            : const Center(
                child: Text(
                  'No cars',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
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
}
