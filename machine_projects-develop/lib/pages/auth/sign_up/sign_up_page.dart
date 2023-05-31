import 'package:flutter/material.dart';
import 'package:machine/base/bloc/base_bloc.dart';
import 'package:machine/base/page/base_page_state.dart';
import 'package:machine/constants.dart';
import 'package:machine/pages/auth/sign_up/bloc/sign_up_bloc.dart';
import 'package:machine/pages/bottom_navigation/bottom_navigation_page.dart';
import 'package:machine/utils/extensions/context_navigation_ext.dart';
import 'package:machine/utils/validators/validators.dart';
import 'package:machine/widgets/cr_form/src/cr_form.dart';
import 'package:machine/widgets/cr_form/src/cr_form_controller.dart';
import 'package:machine/widgets/cr_text_controller.dart';
import 'package:machine/widgets/cr_text_field.dart';
import 'package:machine/widgets/single_scroll_widget.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  static const routeName = '/signUp';

  @override
  SignUpPageState createState() => SignUpPageState();
}

class SignUpPageState extends BasePageState<SignUpPage, SignUpBloc> {
  final _passVisibilityNt = ValueNotifier<bool>(false);
  final _emailCtr = CRTextController();
  final _pwCtr = CRTextController();
  final _nameCtr = CRTextController();

  final _formController = CRFormController();

  @override
  SignUpBloc createBloc() => SignUpBloc();

  @override
  void dispose() {
    _emailCtr.dispose();
    _pwCtr.dispose();
    _nameCtr.dispose();
    _formController.dispose();
    super.dispose();
  }

  @override
  Widget bodyWidget(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign up'),
      ),
      body: SingleScrollWidget(
        child: CRForm(
          controller: _formController,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 20,
              horizontal: 16,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CRTextField(
                  controller: _nameCtr,
                  key: const Key('nameFiled'),
                  validator: (text) => Validators.nameValidator(text, context),
                  title: 'Name',
                  hintText: 'Enter your name',
                  maxLength: kMaxFieldLength,
                  keyboardType: TextInputType.name,
                ),
                CRTextField(
                  controller: _emailCtr,
                  key: const Key('emailField'),
                  validator: (text) => Validators.emailValidator(text, context),
                  title: 'Email',
                  hintText: 'Enter your email',
                  maxLength: kMaxEmailLength,
                  keyboardType: TextInputType.emailAddress,
                ),
                ValueListenableBuilder(
                    valueListenable: _passVisibilityNt,
                    builder: (context, visible, __) {
                      return CRTextField(
                        controller: _pwCtr,
                        key: const Key('passwordField'),
                        validator: (text) =>
                            Validators.passwordValidator(text, context),
                        suffixIcon: IconButton(
                          onPressed: _onVisibilityChanged,
                          icon: Icon(
                            visible ? Icons.visibility_off : Icons.visibility,
                            color: Colors.blue,
                          ),
                        ),
                        obscureText: !visible,
                        title: 'Password',
                        hintText: 'Enter your password',
                      );
                    }),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _signUp,
                  child: const Text('Sign up'),
                ),
                OutlinedButton(
                  onPressed: () => bloc.add(SignUpWithGoogleEvent()),
                  child: const Text('Sign up with Google'),
                ),
                const SizedBox(height: 36),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Future<void> onAction(BuildContext context, ActionState state) async {
    super.onAction(context, state);

    if (state is OpenResourceInfoPageState) {
      await context.pushNamedAndRemoveAll(BottomNavigationPage.routeName);
    }
  }

  Future<void> _signUp() async {
    if (await _formController.validate()) {
      bloc.add(
        SignUpEvent(
          name: _nameCtr.text.trim(),
          email: _emailCtr.text.trim(),
          password: _pwCtr.text.trim(),
        ),
      );
    }
  }

  void _onVisibilityChanged() =>
      _passVisibilityNt.value = !_passVisibilityNt.value;
}
