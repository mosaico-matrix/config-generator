import 'package:flutter/material.dart';

class MosaicoLoadingState with ChangeNotifier {

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  bool _isOverlayLoading = false;
  bool get isOverlayLoading => _isOverlayLoading;


  void showLoading() {
    if(_isLoading) return;
    _isLoading = true;
    notifyListeners();
  }

  void hideLoading() {
    if(!_isLoading) return;
    _isLoading = false;
    notifyListeners();
  }

  void showOverlayLoading() {
    if(_isOverlayLoading) return;
    _isOverlayLoading = true;
    notifyListeners();
  }

  void hideOverlayLoading() {
    if(!_isOverlayLoading) return;
    _isOverlayLoading = false;
    notifyListeners();
  }
}
