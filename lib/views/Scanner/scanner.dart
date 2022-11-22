import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:pharma/controllers/visit_controller.dart';
import 'package:pharma/utils/logger_service.dart';

import '../../configs/app_strings.dart';
import '../../configs/constants.dart';
import '../../models/visit_model/visit_model.dart';
import '../common/components/loading_widget.dart';
import '../common/components/primary_text.dart';
import '../dashboard/visit_details.dart';

class ScannerScreen extends StatefulWidget {
  static const String routeName = "/ScannerScreen";
  const ScannerScreen({Key? key}) : super(key: key);

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> with SingleTickerProviderStateMixin{

  String scannedText = "";
  VisitModel? visitModel;

  void showDialogView()async{
   String value = await showDialog(context: context, builder: (BuildContext context){
      return Dialog(
        child: Container(
          height: 500,
          width: 500,
          child: Stack(
            children: [
              MobileScanner(
                  allowDuplicates: false,

                  controller: MobileScannerController(

                      facing: CameraFacing.front, torchEnabled: true),
                  onDetect: (barcode, args) {
                    if (barcode.rawValue == null) {
                      debugPrint('Failed to scan Barcode');
                    } else {
                      final String code = barcode.rawValue ?? "";
                      debugPrint('Barcode found! $code');
                      if(code.isNotEmpty){
                        scannedText = code;
                        setState(() {});
                        Navigator.pop(context,code);
                      }
                    }
                  }),
              Lottie.asset('assets/lotties/scan.json',)
            ],
          ),
        ),
      );
    });
     if(value.isNotEmpty){
       getVisitData(value);
     }
  }

  Future<void> getVisitData(String id)async{
    await VisitController().getVisitModelFromPatientId(id).then((VisitModel value) {
        showVisitDetailDialog(value);
    });
    setState(() {});
  }

  void showVisitDetailDialog(VisitModel visitModel){
    showDialog(context: context, builder: (BuildContext context){
      return Dialog(
        child: Container(
          height: MediaQuery.of(context).size.height *.6,
          width: MediaQuery.of(context).size.width *.7,
          child: VisitDetailsScreen(
                  id: visitModel.id ??"",
                  visitModel: visitModel,
                ),
        ),
      );
    });
  }


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      showDialogView();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            child: Text("scannedText: ${scannedText}"),
          ),
          MaterialButton(onPressed: (){
            showDialogView();
          },child: Text("Scan"),),
        ],
      ),
    );
  }
}

