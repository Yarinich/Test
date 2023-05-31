import 'package:flutter/material.dart';
import 'package:machine/base/bloc/base_bloc.dart';
import 'package:machine/base/page/base_page_state.dart';
import 'package:machine/data/network/clients/rest_client.dart';
import 'package:machine/pages/auth/sign_in/bloc/sign_in_bloc.dart';
import 'package:machine/pages/auth/sign_up/sign_up_page.dart';
import 'package:machine/pages/bottom_navigation/bottom_navigation_page.dart';
import 'package:machine/utils/extensions/context_navigation_ext.dart';
import 'package:machine/utils/validators/validators.dart';
import 'package:machine/widgets/cr_form/src/cr_form.dart';
import 'package:machine/widgets/cr_form/src/cr_form_controller.dart';
import 'package:machine/widgets/cr_text_controller.dart';
import 'package:machine/widgets/cr_text_field.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  static const routeName = '/signIn';

  @override
  SignInPageState createState() => SignInPageState();
}

class SignInPageState extends BasePageState<SignInPage, SignInBloc> {
  final _emailCtr = CRTextController();
  final _pwCtr = CRTextController();
  final _passVisibilityNt = ValueNotifier<bool>(false);
  final _formController = CRFormController();

  @override
  SignInBloc createBloc() => SignInBloc();

  @override
  void initState() {
    super.initState();

    /// Щоб показати кнопку дебага
    WidgetsBinding.instance.addPostFrameCallback((_) {
      RestClient.instance.initDebugLog(context);
    });
  }

  @override
  void dispose() {
    _emailCtr.dispose();
    _pwCtr.dispose();
    _formController.dispose();
    super.dispose();
  }

  @override
  Widget bodyWidget(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign in')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 20,
            horizontal: 16,
          ),
          child: CRForm(
            controller: _formController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                CRTextField(
                  controller: _emailCtr,
                  validator: (text) => Validators.emailValidator(text, context),
                  hintText: 'Enter your email',
                  title: 'Email',
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 20),
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

                /// Sign in btn.
                ElevatedButton(
                  onPressed: _signIn,
                  child: const Text('Sign in'),
                ),

                /// Sign up btn.
                TextButton(
                  onPressed: _signUp,
                  child: const Text("Don't you have an account? Sign up"),
                ),
                const SizedBox(height: 36),
                OutlinedButton(
                  onPressed: () => bloc.add(SignInWithGoogleEvent()),
                  child: const Text('Sign in with Google'),
                ),
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
    if (state is SignedInState) {
      await context.pushNamedAndRemoveAll(BottomNavigationPage.routeName);
    }
  }

  Future<void> _signIn() async {
    final isValid = await _formController.validate();
    if (isValid) {
      bloc.add(
        SignInWithEmailEvent(_emailCtr.text.trim(), _pwCtr.text.trim()),
      );
    }
  }

  void _onVisibilityChanged() =>
      _passVisibilityNt.value = !_passVisibilityNt.value;

  void _signUp() => context.pushNamed(SignUpPage.routeName);
}
