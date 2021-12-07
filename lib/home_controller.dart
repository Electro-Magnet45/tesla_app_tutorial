import 'package:flutter/material.dart';

class HomeController extends ChangeNotifier {
  bool isRightDoorLock = true;
  bool isLeftDoorLock = true;
  bool isBonnetLock = true;
  bool isTrunkLock = true;

  void updateRightDoorLock() {
    isRightDoorLock = !isRightDoorLock;
    //something like setState(){}
    notifyListeners();
  }

  void updateLeftDoorLock() {
    isLeftDoorLock = !isLeftDoorLock;
    notifyListeners();
  }

  void updateBonnetDoorLock() {
    isBonnetLock = !isBonnetLock;
    notifyListeners();
  }

  void updateTrunkDoorLock() {
    isTrunkLock = !isTrunkLock;
    notifyListeners();
  }
}
