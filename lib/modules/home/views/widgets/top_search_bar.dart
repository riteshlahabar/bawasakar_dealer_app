import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/localization/t.dart';

/// Search field + category grid shortcut shown at the top of the home tab.
class TopSearchBar extends StatelessWidget {
  const TopSearchBar({
    super.key,
    required this.onSearchChanged,
    required this.onGridTap,
  });

  final ValueChanged<String> onSearchChanged;
  final VoidCallback onGridTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              onChanged: onSearchChanged,
              decoration: InputDecoration(
                hintText: t('catalog.search_hint'),
                prefixIcon: Icon(Icons.search_rounded),
              ),
            ),
          ),
          const SizedBox(width: 10),
          InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: onGridTap,
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.grid_view_rounded,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
