import '../models/menu_model.dart';

class MenuUtils {
  static List<MenuItem> filterMenuByRole(List<MenuItem> allMenu, String role) {
    return allMenu.where((item) => item.isAccessibleFor(role)).toList();
  }
}
