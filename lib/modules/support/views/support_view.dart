import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/widgets/app_card.dart';
import '../controllers/support_controller.dart';
import '../../../app/localization/t.dart';

class SupportView extends GetView<SupportController> {
  const SupportView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(t('menu.support'))),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          AppCard(
            child: Column(
              children: [
                TextField(controller: controller.subject, decoration: InputDecoration(labelText: t('support.subject'))),
                const SizedBox(height: 12),
                TextField(controller: controller.message, minLines: 5, maxLines: 7, decoration: InputDecoration(labelText: t('common.message'))),
                const SizedBox(height: 20),
                Obx(() => ElevatedButton(onPressed: controller.isLoading.value ? null : controller.submit, child: Text(controller.isLoading.value ? t('common.sending') : t('support.create_ticket')))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
