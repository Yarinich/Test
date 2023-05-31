import 'package:machine/base/bloc/base_bloc.dart';

abstract class IBloc<Bloc extends BlocBase> {
  late Bloc bloc;
}
