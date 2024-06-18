import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plantist_app/reusable_widgets/edit_dialog.dart';
import 'package:plantist_app/reusable_widgets/todo_item_widget.dart';
import 'package:plantist_app/utils/database_manager.dart';
import 'package:plantist_app/utils/todo_model.dart';
import 'package:plantist_app/utils/todo_utils.dart';
import '../reusable_widgets/button/ui_button.dart';
import 'add_todo_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Stream<List<Todo>> _todosStream;
  late TextEditingController _searchController;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _todosStream = DatabaseManager.todosStream();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: Colors.white,
        title: const Text(
          "Plantist",
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        actions: _buildAppBarActions(),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_isSearching) _buildSearchField(),
          Expanded(
            child: StreamBuilder<List<Todo>>(
              stream: _todosStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text('No todos found.'),
                  );
                }
                final todos = snapshot.data!;
                final filteredTodos =
                    _filterTodos(todos, _searchController.text);
                final groupedTodos = groupTodosByDate(filteredTodos);

                return ListView(
                  children: [
                    buildTodoSection(
                      context,
                      'Today',
                      groupedTodos['Today'] ?? [],
                    ),
                    buildTodoSection(
                      context,
                      'Tomorrow',
                      groupedTodos['Tomorrow'] ?? [],
                    ),
                    buildTodoSection(
                      context,
                      'Others',
                      groupedTodos['Others'] ?? [],
                    ),
                  ],
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8.0, 16, 24),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: firebaseUIButton(
                context,
                "New Reminder",
                Icons.add,
                const Color.fromARGB(255, 15, 22, 39),
                Colors.white,
                onTap: () {
                  Get.bottomSheet(
                    _buildBottomSheetContent(),
                    backgroundColor:
                        CupertinoColors.darkBackgroundGray.withOpacity(0.85),
                    isScrollControlled: true,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTodoSection(
      BuildContext context, String sectionTitle, List<Todo> todos) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            sectionTitle,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: todos.length,
          separatorBuilder: (context, index) => const Divider(
            color: Colors.grey,
            height: 1,
          ),
          itemBuilder: (context, index) {
            final todo = todos[index];

            return TodoItemWidget(
              todo: todo,
              onEdit: (id) {
                showEditDialog(context, id, todo.title);
              },
              onDelete: (id) {
                DatabaseManager.deleteTodo(id);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Todo deleted')),
                );
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildBottomSheetContent() {
    return FractionallySizedBox(
      heightFactor: 0.75,
      child: AddTodoScreen(),
    );
  }

  List<Widget> _buildAppBarActions() {
    if (_isSearching) {
      return [
        IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            setState(() {
              _isSearching = false;
              _searchController.clear();
            });
          },
        ),
      ];
    } else {
      return [
        IconButton(
          icon: const Icon(Icons.search, size: 30),
          onPressed: () {
            setState(() {
              _isSearching = true;
            });
          },
        ),
      ];
    }
  }

  Widget _buildSearchField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: _searchController,
        decoration: const InputDecoration(
          hintText: 'Search...',
          border: OutlineInputBorder(),
        ),
        onChanged: (value) {
          setState(() {});
        },
      ),
    );
  }

  List<Todo> _filterTodos(List<Todo> todos, String query) {
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
