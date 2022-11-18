import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pharma/configs/constants.dart';
import 'package:pharma/models/visit_model/patient_meta_model.dart';
import 'package:pharma/providers/home_page_provider.dart';
import 'package:pharma/utils/date_presentation.dart';
import 'package:pharma/views/common/components/loading_widget.dart';
import 'package:pharma/views/dashboard/visit_details.dart';
import 'package:provider/provider.dart';

import '../../configs/app_strings.dart';
import '../../controllers/navigation_controller.dart';
import '../../controllers/visit_controller.dart';
import '../../models/visit_model/visit_model.dart';
import '../../providers/visit_provider.dart';
import '../../utils/my_safe_state.dart';
import '../common/components/primary_text.dart';

class DashBoardMainScreen extends StatefulWidget {
  static const String routeName = "/DashBoardMainScreen";

  const DashBoardMainScreen({Key? key}) : super(key: key);

  @override
  State<DashBoardMainScreen> createState() => _DashBoardMainScreenState();
}

class _DashBoardMainScreenState extends State<DashBoardMainScreen> {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: NavigationController.dashboardScreenNavigator,
      onGenerateRoute: NavigationController.onHomeGeneratdRoutes,
      initialRoute: DashBoardScreen.routeName,
    );
  }
}





class DashBoardScreen extends StatefulWidget {
  static const String routeName = "/DashBoardScreen";

  const DashBoardScreen({Key? key}) : super(key: key);

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> with MySafeState {

  Future? getVisitListData;
  late VisitProvider visitProvider;

  Future<void> getVisitList() async {
    await VisitController().getVisitList();
  }

  @override
  void initState() {
    super.initState();
    getVisitListData = getVisitList();
    visitProvider = Provider.of<VisitProvider>(context,listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: getMainBody(),
    );
  }

  Widget getMainBody(){
    return FutureBuilder(
      future: getVisitListData,
      builder: (BuildContext context, AsyncSnapshot asyncSnapshot){
        if(asyncSnapshot.connectionState == ConnectionState.done){
          return getVisitListView();
        } else {
          return Center(child: LoadingWidget());
        }
      },
    );
  }

  Widget getVisitListView(){
    if(visitProvider.visitList.isEmpty){
      return Container(child: const Text("No Data"),);
    }
    return ListView.builder(
        itemCount: visitProvider.visitList.length,
        itemBuilder: (BuildContext context,int index){
      return visitItemView(visitProvider.visitList[index]);
    });
  }

  Widget visitItemView(VisitModel visitModel){
    return Column(
      children: [
        customerDetailView(visitModel)
      ],
    );
  }

  Widget customerDetailView(VisitModel visitModel){
    PatientMetaModel patientMetaModel = visitModel.patientMetaModel ?? PatientMetaModel();
    // VisitModel? model = provider.getVisitModel();
    return Container(
      padding: EdgeInsets.all(5),
      margin: EdgeInsets.all(5),
      child: InkWell(
        borderRadius: BorderRadius.circular(5),
        onTap: (){
          Navigator.pushNamed(context, VisitDetailsScreen.routeName, arguments: {"id":visitModel.id, "visitModel":visitModel.toMap()});
          Provider.of<HomePageProvider>(context,listen: false).setHomeTabIndex(-1);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // PrimaryText(text: AppStrings.customerDetail,size: 16),
            // SizedBox(height: 20,),
            Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(width: 0.5,color: Colors.black54)
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Flexible(child: commonWidgetWithHeader(AppStrings.patientName, patientMetaModel.name)),
                      SizedBox(width: 10,),
                      Flexible(child: commonWidgetWithHeader(AppStrings.userId,visitModel.id)),
                      SizedBox(width: 10,),
                      Flexible(child: commonWidgetWithHeader(AppStrings.dob, DatePresentation.ddMMMMyyyyTimeStamp(patientMetaModel.dateOfBirth ?? Timestamp.now())))
                    ],
                  ),
                  SizedBox(height: 10,),
                  Row(
                    children: [
                      Flexible(child: commonWidgetWithHeader(AppStrings.bloodGroup, patientMetaModel.bloodGroup )),
                      SizedBox(width: 10,),
                      Flexible(child: commonWidgetWithHeader(AppStrings.mobile,patientMetaModel.userMobile)),
                      SizedBox(width: 10,),
                      Flexible(child: commonWidgetWithHeader(AppStrings.gender,patientMetaModel.gender))
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget commonWidgetWithHeader(String headerText,String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
            child: Text(headerText, style: TextStyle(fontSize: 14),)),
        Container(
            child: Text(":")),
        SizedBox(width: 15,),
        Text(text,style: TextStyle(fontWeight: FontWeight.w600),)
      ],
    );
  }

}
