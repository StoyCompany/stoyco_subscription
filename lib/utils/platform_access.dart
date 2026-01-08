import 'package:flutter/foundation.dart' show TargetPlatform, defaultTargetPlatform, kIsWeb;
import 'package:stoyco_subscription/pages/subscription_plans/data/models/response/subscription_plan.dart';


String getCurrentPlatform() {
  if (kIsWeb) {
    return 'Web';
  }
  // Only import dart:io for non-web platforms
  try {
    // Dynamic check for mobile platforms
    return _getCurrentMobilePlatform();
  } catch (e) {
    return 'Unknown';
  }
}

String _getCurrentMobilePlatform() {
  // This will only be called on non-web platforms
  // Use defaultTargetPlatform instead of Platform
  if (defaultTargetPlatform == TargetPlatform.iOS) {
    return 'iOS';
  }
  if (defaultTargetPlatform == TargetPlatform.android) {
    return 'Android';
  }
  return 'Unknown';
}


bool hasPlatformAccessFromPlan(SubscriptionPlan plan) {
  final UserStatus? userStatus = plan.userStatus;
  if (userStatus == null) {
    return false;
  }
  return userStatus.userPlatform == getCurrentPlatform();
}
