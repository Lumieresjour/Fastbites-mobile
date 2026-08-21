class Settings {
  final int? id;
  final String? appName;
  final String? appLogo; // asset path like 'assets/images/logo.png'
  final String? appDescription;
  final String? supportEmail;
  final String? whatsappNumber;
  final Map<String, String>?
  socialMediaLinks; // e.g., {'instagram': '@fastbites', 'facebook': 'fastbites.id'}
  final String? termsAndConditions;
  final String? privacyPolicy;
  final bool notificationEnabled;
  final DateTime? updatedAt;

  Settings({
    this.id,
    this.appName,
    this.appLogo,
    this.appDescription,
    this.supportEmail,
    this.whatsappNumber,
    this.socialMediaLinks,
    this.termsAndConditions,
    this.privacyPolicy,
    this.notificationEnabled = true,
    this.updatedAt,
  });

  Map<String, dynamic> toMap() => {
    if (id != null) 'id': id,
    'app_name': appName,
    'app_logo': appLogo,
    'app_description': appDescription,
    'support_email': supportEmail,
    'whatsapp_number': whatsappNumber,
    'social_media_links':
        socialMediaLinks?.toString(),
    'terms_and_conditions': termsAndConditions,
    'privacy_policy': privacyPolicy,
    'notification_enabled': notificationEnabled ? 1 : 0,
    'updated_at': updatedAt?.toIso8601String(),
  };

  factory Settings.fromMap(Map<String, dynamic> m) {
    // Parse socialMediaLinks from string representation
    Map<String, String>? socialLinks;
    final socialStr = m['social_media_links'] as String?;
    if (socialStr != null && socialStr.isNotEmpty && socialStr != '{}') {
      try {
        // Parse from '{key: value, key2: value2}' format
        final cleanStr =
            socialStr.replaceAll('{', '').replaceAll('}', '').trim();
        if (cleanStr.isNotEmpty) {
          socialLinks = {};
          final pairs = cleanStr.split(',');
          for (final pair in pairs) {
            final parts = pair.split(':');
            if (parts.length == 2) {
              socialLinks[parts[0].trim()] = parts[1].trim();
            }
          }
        }
      } catch (e) {
        // ignore parse error
      }
    }
    return Settings(
      id: m['id'] as int?,
      appName: m['app_name'] as String?,
      appLogo: m['app_logo'] as String?,
      appDescription: m['app_description'] as String?,
      supportEmail: m['support_email'] as String?,
      whatsappNumber: m['whatsapp_number'] as String?,
      socialMediaLinks: socialLinks,
      termsAndConditions: m['terms_and_conditions'] as String?,
      privacyPolicy: m['privacy_policy'] as String?,
      notificationEnabled: (m['notification_enabled'] as int?) != 0,
      updatedAt:
          m['updated_at'] != null
              ? DateTime.tryParse(m['updated_at'] as String)
              : null,
    );
  }
}
