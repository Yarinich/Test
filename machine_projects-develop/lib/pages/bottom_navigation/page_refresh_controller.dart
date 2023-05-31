import 'package:flutter/cupertino.dart';

/// лісенер для того, щоб сторінки рефершались
class ResourcePageRefreshController extends ChangeNotifier {
  void refresh() => notifyListeners();
}

class RecommendationPageRefreshCtr extends ChangeNotifier {
  void refresh() => notifyListeners();
}
