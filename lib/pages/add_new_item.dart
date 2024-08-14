import 'package:flutter/material.dart';

import '../database/firbase_data.dart';
//import 'package:url_launcher/url_launcher.dart';

class AddItem extends StatefulWidget {
  const AddItem({super.key});

  //const AddItem({Key? key}) : super(key: key);

  @override
  State<AddItem> createState() => _MyHomeState();
}

class _MyHomeState extends State<AddItem> {
  final List<Map<String, String>> items = [];

  final TextEditingController nameController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController serviceController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    DateTime currentDate = DateTime.now();
    dateController.text =
        '${currentDate.year}/${currentDate.month}/${currentDate.day}';
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('قائمة العناصر'),
        ),
        body: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'اسم العميل',
              ),
            ),
            TextFormField(
              controller: dateController,
              decoration: const InputDecoration(
                labelText: 'تاريخ التسجيل',
              ),
              onTap: () async {
                DateTime? selectedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2022),
                  lastDate: DateTime(2030),
                );

                if (selectedDate != null) {
                  dateController.text =
                      '${selectedDate.year}/${selectedDate.month}/${selectedDate.day}/ ${DateTime.now().hour}/${DateTime.now().minute}';
                }
              },
            ),
            TextFormField(
              controller: addressController,
              decoration: const InputDecoration(
                labelText: 'العنوان',
              ),
            ),
            TextFormField(
              controller: serviceController,
              decoration: const InputDecoration(
                labelText: 'نوع الخدمة',
              ),
            ),
            TextFormField(
              controller: phoneController,
              decoration: const InputDecoration(
                labelText: 'رقم الهاتف',
              ),
            ),
            TextFormField(
              controller: noteController,
              decoration: const InputDecoration(
                labelText: 'ملاحظة',
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                if (nameController.text.isEmpty ||
                    dateController.text.isEmpty ||
                    addressController.text.isEmpty ||
                    serviceController.text.isEmpty ||
                    phoneController.text.isEmpty) {
                  // عرض رسالة خطأ

                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: Text('خطأ'),
                      content: Text('يرجى تعبئة جميع الحقول المطلوبة'),
                      actions: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(ctx).pop();
                          },
                          child: Text('موافق'),
                        ),
                      ],
                    ),
                  );
                } else {
                  dateController.text +=
                      "/${DateTime.now().hour}:${DateTime.now().minute}";
                  await MyFirebase().addData('element', {
                    'name': nameController.text,
                    'date': dateController.text,
                    'address': addressController.text,
                    'tyepServes': serviceController.text,
                    'phon': phoneController.text,
                    'note': noteController.text
                  });
                  nameController.clear();
                  dateController.clear();
                  addressController.clear();
                  serviceController.clear();
                  phoneController.clear();
                  noteController.clear();
                  setState(() {});
                }
              },
              child: Text('حفظ'),
            ),
            SizedBox(height: 16.0),
          ],
        ),
      ),
    );
  }
}
