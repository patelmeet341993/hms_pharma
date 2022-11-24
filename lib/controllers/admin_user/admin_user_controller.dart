import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hms_models/hms_models.dart';
import 'package:provider/provider.dart';

import '../../configs/app_strings.dart';
import '../../providers/admin_user_provider.dart';
import '../navigation_controller.dart';

class AdminUserController {
  static StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? adminUserStreamSubscription;

  Future<AdminUserModel?> createAdminUserWithUsernameAndPassword({required BuildContext context, required AdminUserModel userModel, String userType = AdminUserType.admin,}) async {
    if(userModel.username.isEmpty || userModel.password.isEmpty) {
      MyToast.showError(context: context, msg: "UserName is empty or password is empty",);
      return null;
    }

    AdminUserModel? adminUserModel;

    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseNodes.adminUsersCollectionReference.where("role", isEqualTo: userType).where("username", isEqualTo: userModel.username).get();
    if(querySnapshot.docs.isNotEmpty) {
      DocumentSnapshot<Map<String, dynamic>> docSnapshot = querySnapshot.docs.first;
      if((docSnapshot.data() ?? {}).isNotEmpty) {
        AdminUserModel model = AdminUserModel.fromMap(docSnapshot.data()!);
        if(model.username == userModel.username) {
          adminUserModel = model;
        }
      }
    }

    if(adminUserModel == null) {
      adminUserModel = AdminUserModel(
        id: MyUtils.getUniqueIdFromUuid(),
        name: userModel.name,
        username: userModel.username,
        password: userModel.password,
        role: userType,
        description: userModel.description,
        imageUrl: userModel.imageUrl,
        scannerData: userModel.scannerData,
      );

      bool isCreationSuccess = await FirebaseNodes.adminUserDocumentReference(userId: adminUserModel.id).set(adminUserModel.toMap()).then((value) {
        MyPrint.printOnConsole("Admin User with Id:${adminUserModel!.id} Created Successfully");
        return true;
      })
      .catchError((e, s) {
        MyPrint.printOnConsole("Error in Creating Admin User:$e");
        MyPrint.printOnConsole(s);
        return false;
      });
      MyPrint.printOnConsole("isCreationSuccess:$isCreationSuccess");

      if(isCreationSuccess) {
        return adminUserModel;
      }
      else {
        return null;
      }
    }
    else {
      MyToast.showError(context: context, msg: AppStrings.givenUserAlreadyExist,);
      return null;
    }
  }

  void startAdminUserSubscription() async {
    AdminUserProvider adminUserProvider = Provider.of<AdminUserProvider>(NavigationController.mainScreenNavigator.currentContext!, listen: false);
    String adminUserId = adminUserProvider.adminUserId;

    if(adminUserId.isNotEmpty) {
      if(adminUserStreamSubscription != null) {
        adminUserStreamSubscription!.cancel();
        adminUserStreamSubscription = null;
      }

      adminUserStreamSubscription = FirebaseNodes.adminUserDocumentReference(userId: adminUserId).snapshots().listen((DocumentSnapshot<Map<String, dynamic>> snapshot) {
        MyPrint.printOnConsole("Admin User Document Updated.\n"
            "Snapshot Exist:${snapshot.exists}\n"
            "Data:${snapshot.data()}");

        if(snapshot.exists && (snapshot.data() ?? {}).isNotEmpty) {
          AdminUserModel adminUserModel = AdminUserModel.fromMap(snapshot.data()!);
          adminUserProvider.setAdminUserId(adminUserModel.id);
          adminUserProvider.setAdminUserModel(adminUserModel);
        }
        else {
          adminUserProvider.setAdminUserId("");
          adminUserProvider.setAdminUserModel(null);
        }
      });

      MyPrint.printOnConsole("Admin User Stream Started");
    }
  }

  void stopAdminUserSubscription() async {
    AdminUserProvider adminUserProvider = Provider.of<AdminUserProvider>(NavigationController.mainScreenNavigator.currentContext!, listen: false);

    if(adminUserStreamSubscription != null) {
      adminUserStreamSubscription!.cancel();
      adminUserStreamSubscription = null;
    }
    adminUserProvider.setAdminUserId("");
    adminUserProvider.setAdminUserModel(null);
  }
}