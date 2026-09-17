import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/widgets/app_card.dart';
import '../../../app/widgets/empty_state.dart';
import '../../../app/widgets/loading_view.dart';
import '../controllers/notifications_controller.dart';
import '../../../app/localization/t.dart';

class NotificationsView extends GetView<NotificationsController> {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(t('notifications.title')),
        actions: [
          Obx(() => controller.unreadCount.value == 0
              ? const SizedBox.shrink()
              : TextButton(
                  onPressed: controller.markAllRead,
                  // White so it stays visible on the green app bar.
                  style: TextButton.styleFrom(foregroundColor: Colors.white),
                  child: Text(t('notifications.mark_all_read')),
                )),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.items.isEmpty) {
          return LoadingView(message: t('common.loading'));
        }
        if (controller.isEmpty) {
          return EmptyState(
            title: t('notifications.empty_title'),
            message: t('notifications.empty_message'),
            icon: Icons.notifications_none,
          );
        }

        return RefreshIndicator(
          color: AppColors.primary,
          onRefresh: controller.load,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.items.length,
            itemBuilder: (context, index) {
              final item = controller.items[index];

              return AppCard(
                margin: const EdgeInsets.only(bottom: 12),
                onTap: () => controller.markRead(item),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      margin: const EdgeInsets.only(top: 6, right: 10),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        // A filled dot marks unread; read rows keep the space
                        // so the text stays aligned down the column.
                        color: item.isUnread ? AppColors.primary : Colors.transparent,
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.title,
                            style: TextStyle(
                              fontSize: 13.5,
                              fontWeight: item.isUnread ? FontWeight.w800 : FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item.message,
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 12.5,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
