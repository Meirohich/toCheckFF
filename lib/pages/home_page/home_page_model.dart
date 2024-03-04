import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'home_page_widget.dart' show HomePageWidget;
import 'package:flutter/material.dart';

class HomePageModel extends FlutterFlowModel<HomePageWidget> {
  ///  Local state fields for this page.

  List<MotorbikesRecord> bikesList = [];
  void addToBikesList(MotorbikesRecord item) => bikesList.add(item);
  void removeFromBikesList(MotorbikesRecord item) => bikesList.remove(item);
  void removeAtIndexFromBikesList(int index) => bikesList.removeAt(index);
  void insertAtIndexInBikesList(int index, MotorbikesRecord item) =>
      bikesList.insert(index, item);
  void updateBikesListAtIndex(int index, Function(MotorbikesRecord) updateFn) =>
      bikesList[index] = updateFn(bikesList[index]);

  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();

  /// Initialization and disposal methods.

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
  }

  /// Action blocks are added here.

  /// Additional helper methods are added here.
}
