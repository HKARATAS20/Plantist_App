import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:plantist_app/reusable_widgets/priority_selector.dart';
import 'package:plantist_app/utils/database_manager.dart';

class AddTodoController extends GetxController {
  TextEditingController titleController = TextEditingController();
  TextEditingController notesController =
      TextEditingController(); // Notes controller
  Rx<DateTime> selectedDate = DateTime.now().obs;
  Rx<DateTime> selectedTimeCupertino = DateTime.now().obs;
  RxString selectedPriority = 'None'.obs;
  RxBool showDetails = false.obs;
  RxBool enableDate = false.obs;
  RxBool enableTime = false.obs;
  Rx<PlatformFile?> pickedFile = Rx<PlatformFile?>(null);

  Future<void> selectFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;

    pickedFile.value = result.files.first;
  }

  Future<void> uploadFile(String todoId) async {
    if (pickedFile.value == null) return;

    final String fileName = pickedFile.value!.name;
    final String folderPath = 'todos/$todoId';
    final String filePath = '$folderPath/$fileName';

    final file = File(pickedFile.value!.path!);
    final ref = FirebaseStorage.instance.ref().child(filePath);
    try {
      await ref.putFile(file);

      clearPickedFile();

      String fileUrl = await ref.getDownloadURL();

      await DatabaseManager.updateTodoFileUrl(todoId, fileUrl);
    } catch (e) {
      print('Error uploading file: $e');
    }
  }

  void clearPickedFile() {
    pickedFile.value = null;
  }

  bool get isButtonEnabled {
    if (showDetails.value) {
      return true;
    } else {
      return titleController.text.trim().isNotEmpty;
    }
  }

  @override
  void onInit() {
    super.onInit();

    titleController.addListener(() {
      update();
    });

    notesController.addListener(() {
      // Listener for notesController
      update();
    });
  }

  void toggleDetails() {
    showDetails.value = !showDetails.value;
  }

  void showPrioritySelectorIn() {
    showPrioritySelector(Get.overlayContext!, (String priority) {
      selectedPriority.value = priority;
    });
  }

  Future<void> addTodo() async {
    String title = titleController.text.trim();
    String notes = notesController.text.trim(); // Get notes text

    if (title.isNotEmpty) {
      DateTime dateTime =
          enableDate.value ? selectedDate.value : DateTime.now();
      DateTime? time = enableTime.value ? selectedTimeCupertino.value : null;

      if (enableDate.value) {
        dateTime = selectedDate.value;
      }

      if (enableTime.value) {
        time = selectedTimeCupertino.value;
      }

      String todoId = '';
      if (showDetails.value) {
        todoId = await DatabaseManager.addTodo(
            title, notes, false, dateTime, time, selectedPriority.value);
      } else {
        todoId = await DatabaseManager.addTodo(
            title, notes, false, dateTime, time, "None");
      }

      await uploadFile(todoId);

      Get.back();
    }
  }

  @override
  void onClose() {
    titleController.dispose();
    notesController.dispose(); // Dispose notesController
    super.onClose();
  }
}
