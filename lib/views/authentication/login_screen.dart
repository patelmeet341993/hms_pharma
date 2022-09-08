import 'package:flutter/material.dart';

import '../../configs/app_strings.dart';
import '../../configs/app_theme.dart';
import '../../controllers/authentication_controller.dart';
import '../../utils/logger_service.dart';
import '../../utils/my_safe_state.dart';
import '../../utils/my_toast.dart';
import '../common/components/loading_widget.dart';
import '../common/components/modal_progress_hud.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = "/LoginScreen";
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with MySafeState {
  late ThemeData themeData;
  bool isLoading = false;

  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<void> login(String userName, String password) async {
    isLoading = true;
    mySetState();

    // await Future.delayed(const Duration(seconds: 3));
    bool isLoggedIn = await AuthenticationController().loginAdminUserWithUsernameAndPassword(context: context, userName: userName, password: password,);
    Log().i("isLoggedIn:$isLoggedIn");

    isLoading = false;
    mySetState();

    if(!isLoggedIn) {
      MyToast.showError("Login Failed", context);
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);
    super.pageBuild();

    return ModalProgressHUD(
      inAsyncCall: isLoading,
      progressIndicator: const LoadingWidget(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Login Screen"),
        ),
        body: Center(
          child: Container(
            constraints: BoxConstraints(maxWidth: 700),
            child: Form(
              key: _globalKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text("Admin Login"),
                  const SizedBox(height: 20,),
                  TextFormField(
                    controller: usernameController,
                    decoration: InputDecoration(
                      hintText: "Username",
                    ),
                    validator: (String? text) {
                      if(text?.isNotEmpty ?? false) {
                        return null;
                      }
                      else {
                        return "Username is Required";
                      }
                    },
                  ),
                  const SizedBox(height: 20,),
                  TextFormField(
                    controller: passwordController,
                    keyboardType: TextInputType.visiblePassword,
                    decoration: InputDecoration(
                      hintText: "Password",
                    ),
                    validator: (String? text) {
                      if(text?.isNotEmpty ?? false) {
                        return null;
                      }
                      else {
                        return "Password is Required";
                      }
                    },
                  ),
                  const SizedBox(height: 20,),
                  FlatButton(
                    onPressed: () {
                      if(_globalKey.currentState?.validate() ?? false) {
                        login(usernameController.text, passwordController.text);
                      }
                      // VisitController().createDummyVisitDataInFirestore();
                      // PatientController().createDummyPatientDataInFirestore();
                    },
                    color: themeData.colorScheme.primary,
                    child: Text(
                      AppStrings.login,
                      style: AppTheme.getTextStyle(themeData.textTheme.caption!),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}