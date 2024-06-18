import 'package:get/get.dart';
import 'package:plantist_app/utils/database_manager.dart';
import 'package:plantist_app/utils/todo_model.dart';

class HomeController extends GetxController {
  late Stream<List<Todo>> todosStream;
  var searchController = ''.obs; // Observable for search query
  var isSearching = false.obs;

  @override
  void onInit() {
    super.onInit();
    todosStream = DatabaseManager.todosStream();
  }

  void startSearch() {
    isSearching.value = true;
  }

  void stopSearch() {
    isSearching.value = false;
    searchController.value = ''; // Clear search query
  }

  void setSearchQuery(String query) {
    searchController.value = query;
  }

  Stream<List<Todo>> getTodosStream() => todosStream;

  List<Todo> filterTodos(List<Todo> todos, String query) {
    if (query.isEmpty) {
      return todos;
    } else {
      return todos
          .where(
              (todo) => todo.title.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
  }
}
