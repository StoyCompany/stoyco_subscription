enum SubscriptionProfileType { music, sport, brand, unknown }

SubscriptionProfileType parseProfileType(String? profile) {
  switch (profile?.toLowerCase()) {
    case 'music':
      return SubscriptionProfileType.music;
    case 'sport':
      return SubscriptionProfileType.sport;
    case 'brand':
    case 'brands':
      return SubscriptionProfileType.brand;
    default:
      return SubscriptionProfileType.unknown;
  }
}
