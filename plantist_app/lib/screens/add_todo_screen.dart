import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plantist_app/controllers/add_todo_controller.dart';
import 'package:plantist_app/reusable_widgets/custom_list_tile.dart';
import 'package:plantist_app/reusable_widgets/text_field/custom_text_field.dart';
import 'package:plantist_app/reusable_widgets/prefix_widget.dart';

class AddTodoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AddTodoController controller = Get.put(AddTodoController());

    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(10.0),
        topRight: Radius.circular(10.0),
      ),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.75,
        color: Colors.white,
        padding: const EdgeInsets.all(16.0),
        child: GetBuilder<AddTodoController>(
          builder: (controller) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        Get.back();
                      },
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                            color: CupertinoColors.activeBlue),
                      ),
                    ),
                    const Text(
                      "New Reminder",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: CupertinoColors.black),
                    ),
                    TextButton(
                      onPressed: controller.isButtonEnabled
                          ? () {
                              controller.addTodo();
                            }
                          : null,
                      child: const Text(
                        'Add',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
                Obx(() => !controller.showDetails.value
                    ? Column(
                        children: [
                          CustomTextField(
                            placeholder: 'Title',
                            controller: controller.titleController,
                          ),
                          CustomTextField(
                            placeholder: 'Notes', // Notes text field
                            controller: controller.notesController,
                          ),
                          const SizedBox(height: 16),
                          CustomListTile(
                            title: "Details",
                            onTap: () => controller.toggleDetails(),
                            trailing: const CupertinoListTileChevron(),
                            subtitle: const Text("Today"),
                          ),
                        ],
                      )
                    : Column(
                        children: [
                          CupertinoFormRow(
                            prefix: const PrefixWidget(
                              icon: CupertinoIcons.calendar,
                              title: 'Date',
                              color: CupertinoColors.systemBlue,
                            ),
                            child: CupertinoSwitch(
                              value: controller.enableDate.value,
                              onChanged: (bool value) {
                                controller.enableDate.value = value;
                                if (!value) {
                                  controller.enableTime.value = false;
                                }
                              },
                            ),
                          ),
                          AnimatedSize(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOut,
                            child: SizedBox(
                              height: controller.enableDate.value &&
                                      !controller.enableTime.value
                                  ? 200
                                  : 0,
                              child: controller.enableDate.value &&
                                      !controller.enableTime.value
                                  ? CupertinoDatePicker(
                                      mode: CupertinoDatePickerMode.date,
                                      initialDateTime:
                                          controller.selectedDate.value,
                                      onDateTimeChanged:
                                          (DateTime newDateTime) {
                                        controller.selectedDate.value =
                                            newDateTime;
                                      },
                                    )
                                  : null,
                            ),
                          ),
                          const Divider(
                            indent: CupertinoCheckbox.width * 3,
                          ),
                          CupertinoFormRow(
                            prefix: const PrefixWidget(
                              icon: CupertinoIcons.time,
                              title: 'Time',
                              color: CupertinoColors.systemRed,
                            ),
                            child: CupertinoSwitch(
                              value: controller.enableTime.value,
                              onChanged: (bool value) {
                                controller.enableTime.value = value;
                                if (value) {
                                  controller.enableDate.value = true;
                                  controller.selectedTimeCupertino.value =
                                      DateTime.now();
                                }
                              },
                            ),
                          ),
                          AnimatedSize(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOut,
                            child: SizedBox(
                              height: controller.enableTime.value ? 200 : 0,
                              child: controller.enableTime.value
                                  ? CupertinoDatePicker(
                                      mode: CupertinoDatePickerMode.time,
                                      use24hFormat: true,
                                      initialDateTime: controller
                                          .selectedTimeCupertino.value,
                                      onDateTimeChanged:
                                          (DateTime newDateTime) {
                                        controller.selectedTimeCupertino.value =
                                            newDateTime;
                                      },
                                    )
                                  : null,
                            ),
                          ),
                          CustomListTile(
                            title: "Priority",
                            onTap: () => controller.showPrioritySelectorIn(),
                            trailing: const CupertinoListTileChevron(),
                            additionalInfo: controller.selectedPriority.value,
                          ),
                          CustomListTile(
                            title: "Attachment",
                            onTap: () {
                              controller.selectFile();
                            },
                            trailing: const Icon(CupertinoIcons.paperclip),
                            subtitle: const Text("max size: 1MB"),
                          ),
                          Obx(() {
                            final file = controller.pickedFile.value;
                            return file != null
                                ? ListTile(
                                    title: Text(file.name),
                                    trailing: IconButton(
                                      icon: const Icon(Icons.delete),
                                      onPressed: () {
                                        controller.clearPickedFile();
                                      },
                                    ),
                                  )
                                : Container();
                          }),
                          TextButton(
                            onPressed: () => controller.toggleDetails(),
                            child: const Text('Back'),
                          )
                        ],
                      )),
                const SizedBox(height: 16),
              ],
            );
          },
        ),
      ),
    );
  }
}
