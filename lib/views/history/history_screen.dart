import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pharma/controllers/history_controller.dart';
import 'package:provider/provider.dart';

import '../../configs/app_strings.dart';
import '../../controllers/navigation_controller.dart';
import '../../models/visit_model/patient_meta_model.dart';
import '../../models/visit_model/visit_model.dart';
import '../../providers/history_provider.dart';
import '../../providers/home_page_provider.dart';
import '../../utils/date_presentation.dart';
import '../common/components/loading_widget.dart';
import '../dashboard/dashboard_screen.dart';
import '../dashboard/visit_details.dart';

class HistoryMainScreen extends StatefulWidget {
  static const String routeName = "/HistoryMainScreen";

  const HistoryMainScreen({Key? key}) : super(key: key);

  @override
  State<HistoryMainScreen> createState() => _HistoryMainScreenState();
}

class _HistoryMainScreenState extends State<HistoryMainScreen> {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: NavigationController.historyScreenNavigator,
      onGenerateRoute: NavigationController.onHistoryGeneratedRoutes,
      initialRoute: HistoryScreen.routeName,
    );
  }
}

class HistoryScreen extends StatefulWidget {
  static const String routeName = "/HistoryScreen";

  const HistoryScreen({Key? key}) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {

  Future? getVisitListData;
  late HistoryProvider historyProvider;

  Future<void> getVisitList() async {
    await HistoryController().getHistoryData();
  }

  @override
  void initState() {
    super.initState();
    getVisitListData = getVisitList();
    historyProvider = Provider.of<HistoryProvider>(context,listen: false);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: mainBody(),
    );
  }

 Widget mainBody() {
    return FutureBuilder(
      future:getVisitListData,
      builder: (BuildContext context,AsyncSnapshot asyncSnapshot){
        if(asyncSnapshot.connectionState == ConnectionState.done){
          return getVisitListView();
        }
        else {
          return Center(child: const LoadingWidget());
        }
      },
    );
 }

  Widget getVisitListView(){
    if(historyProvider.visitList.isEmpty){
      return Container(child: const Text("No Data"),);
    }
    return ListView.builder(
        itemCount: historyProvider.visitList.length,
        itemBuilder: (BuildContext context,int index){
          return visitItemView(historyProvider.visitList[index]);
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
      padding: const EdgeInsets.all(5),
      margin: const EdgeInsets.all(5),
      child: InkWell(
        borderRadius: BorderRadius.circular(5),
        onTap: (){
          Provider.of<HomePageProvider>(context,listen: false).setBuildContext(NavigationController.historyScreenNavigator.currentContext ?? context);
          Navigator.pushNamed(context, VisitDetailsScreen.routeName, arguments: {"id":visitModel.id, "visitModel":visitModel.toMap(), "isFromHistory":true});
          Provider.of<HomePageProvider>(context,listen: false).setHomeTabIndex(-1);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // PrimaryText(text: AppStrings.customerDetail,size: 16),
            // SizedBox(height: 20,),
            Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(width: 0.5,color: Colors.black54)
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Flexible(child: commonWidgetWithHeader(AppStrings.patientName, patientMetaModel.name)),
                      const SizedBox(width: 10,),
                      Flexible(child: commonWidgetWithHeader(AppStrings.userId,visitModel.id)),
                      const SizedBox(width: 10,),
                      Flexible(child: commonWidgetWithHeader(AppStrings.dob, DatePresentation.ddMMMMyyyyTimeStamp(patientMetaModel.dateOfBirth ?? Timestamp.now())))
                    ],
                  ),
                  const SizedBox(height: 10,),
                  Row(
                    children: [
                      Flexible(child: commonWidgetWithHeader(AppStrings.bloodGroup, patientMetaModel.bloodGroup )),
                      const SizedBox(width: 10,),
                      Flexible(child: commonWidgetWithHeader(AppStrings.mobile,patientMetaModel.userMobile)),
                      const SizedBox(width: 10,),
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
            child: Text(headerText, style: const TextStyle(fontSize: 14),)),
        Container(
            child: const Text(":")),
        const SizedBox(width: 15,),
        Text(text,style: const TextStyle(fontWeight: FontWeight.w600),)
      ],
    );
  }
}
