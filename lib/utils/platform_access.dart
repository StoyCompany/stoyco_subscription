import 'dart:io';

import 'package:stoyco_subscription/pages/subscription_plans/data/models/response/subscription_plan.dart';


String getCurrentPlatform() {
  if (Platform.isIOS) {
    return 'iOS';
  }
  if (Platform.isAndroid) {
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
