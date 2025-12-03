/// Represents the different states a subscription can have
enum SubscriptionStatus {
  /// PENDIENTE_PAGO - Payment is pending, blocks all flows
  pendingPayment,

  /// PERIODO_DE_PRUEBA - Trial period active, allows cancellation flow (immediate cancellation)
  trialPeriod,

  /// PAGO_FALLIDO - Payment failed, allows renewal flow
  paymentFailed,

  /// SUSCRIPCIÓN_VIGENTE - Active subscription, allows cancellation flow
  active,

  /// SUSCRIPCIÓN_POR_INICIAR - Subscription scheduled to start, allows cancellation flow (immediate cancellation, if no trial period send refund email)
  scheduledToStart,

  /// SUBSCRIPCIÓN_CANCELADA - Subscription cancelled, allows purchase flow
  cancelled,

  /// PENDIENTE_POR_CANCELAR - Pending cancellation, blocks all flows
  pendingCancellation,

  /// RENOVACIÓN_DISPONIBLE - Renewal available, allows renewal flow
  renewalAvailable;

  /// Converts the enum to a string value
  String toValue() {
    switch (this) {
      case SubscriptionStatus.pendingPayment:
        return 'PendingPayment';
      case SubscriptionStatus.trialPeriod:
        return 'TrialPeriod';
      case SubscriptionStatus.paymentFailed:
        return 'PaymentFailed';
      case SubscriptionStatus.active:
        return 'Active';
      case SubscriptionStatus.scheduledToStart:
        return 'ScheduledToStart';
      case SubscriptionStatus.cancelled:
        return 'Cancelled';
      case SubscriptionStatus.pendingCancellation:
        return 'PendingCancellation';
      case SubscriptionStatus.renewalAvailable:
        return 'RenewalAvailable';
    }
  }

  /// Creates a SubscriptionStatus from a string value
  static SubscriptionStatus fromValue(String value) {
    switch (value) {
      case 'PendingPayment':
        return SubscriptionStatus.pendingPayment;
      case 'TrialPeriod':
        return SubscriptionStatus.trialPeriod;
      case 'PaymentFailed':
        return SubscriptionStatus.paymentFailed;
      case 'Active':
        return SubscriptionStatus.active;
      case 'ScheduledToStart':
        return SubscriptionStatus.scheduledToStart;
      case 'Cancelled':
        return SubscriptionStatus.cancelled;
      case 'PendingCancellation':
        return SubscriptionStatus.pendingCancellation;
      case 'RenewalAvailable':
        return SubscriptionStatus.renewalAvailable;
      default:
        throw ArgumentError('Invalid SubscriptionStatus value: $value');
    }
  }
}
