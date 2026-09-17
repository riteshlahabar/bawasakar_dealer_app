import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/widgets/app_card.dart';
import '../../../../app/localization/t.dart';

/// Round profile photo with an edit button, plus name and subtitle.
/// This is the only place a profile photo can be uploaded.
class ProfileHeaderCard extends StatelessWidget {
  const ProfileHeaderCard({
    super.key,
    required this.photoUrl,
    required this.title,
    required this.subtitle,
    required this.uploading,
    required this.onPick,
    this.placeholderIcon = Icons.person_rounded,
  });

  final String photoUrl;
  final String title;
  final String subtitle;
  final bool uploading;
  final ValueChanged<ImageSource> onPick;
  final IconData placeholderIcon;

  static const _size = 96.0;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        children: [
          SizedBox(
            width: _size + 8,
            height: _size + 4,
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                Container(
                  width: _size,
                  height: _size,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primarySoft,
                    border: Border.all(color: AppColors.primary.withValues(alpha: .25), width: 3),
                  ),
                  child: ClipOval(
                    child: photoUrl.isEmpty
                        ? Icon(placeholderIcon, size: 46, color: AppColors.primary)
                        : CachedNetworkImage(
                            imageUrl: photoUrl,
                            fit: BoxFit.cover,
                            errorWidget: (_, _, _) => Icon(placeholderIcon, size: 46, color: AppColors.primary),
                          ),
                  ),
                ),
                if (uploading)
                  Container(
                    width: _size,
                    height: _size,
                    decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.black38),
                    child: const Center(child: CircularProgressIndicator(color: Colors.white)),
                  ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Material(
                    color: AppColors.primary,
                    shape: const CircleBorder(side: BorderSide(color: Colors.white, width: 2.5)),
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: uploading ? null : _chooseSource,
                      child: const Padding(
                        padding: EdgeInsets.all(8),
                        child: Icon(Icons.edit_rounded, size: 17, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w900)),
          if (subtitle.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(subtitle, textAlign: TextAlign.center, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12.5)),
          ],
        ],
      ),
    );
  }

  void _chooseSource() {
    Get.bottomSheet<void>(
      SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(20, 4, 20, 8),
                child: Text(t('account.profile_photo'), style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
              ),
              _sourceTile(Icons.photo_camera_outlined, t('profile.take_photo'), ImageSource.camera),
              _sourceTile(Icons.photo_library_outlined, t('profile.choose_gallery'), ImageSource.gallery),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
    );
  }

  Widget _sourceTile(IconData icon, String label, ImageSource source) {
    return ListTile(
      leading: CircleAvatar(backgroundColor: AppColors.primarySoft, child: Icon(icon, color: AppColors.primary)),
      title: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
      onTap: () {
        Get.back<void>();
        onPick(source);
      },
    );
  }
}
