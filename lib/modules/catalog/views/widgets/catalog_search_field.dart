import 'package:flutter/material.dart';
import '../../../../app/localization/t.dart';

/// Search field shown above the category menu / product grid.
class CatalogSearchField extends StatelessWidget {
  const CatalogSearchField({super.key, required this.onSearchChanged});

  final ValueChanged<String> onSearchChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 12),
      child: TextField(
        onChanged: onSearchChanged,
        decoration: InputDecoration(
          hintText: t('catalog.search_short'),
          prefixIcon: Icon(Icons.search_rounded),
        ),
      ),
    );
  }
}
