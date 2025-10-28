import 'package:flutter/material.dart';
import 'package:stoyco_subscription/designs/atomic/tokens/src/gen/colors.gen.dart';

/// {@template terms_privacy_auto_renew_card}
/// Molecule card with gradient background, border radius 16, and three checkboxes:
/// 1. "Acepto términos y condiciones de acceso y uso.*" (required, con callback de navegación)
/// 2. "Acepto políticas de privacidad.*" (required, con callback de navegación)
/// 3. "Autorizas que este medio de pago sea usado para renovar tu suscripción de forma automática." (opcional)
///
/// Los dos primeros checkboxes son obligatorios para habilitar el botón de acción. Los callbacks de navegación se exponen para los dos primeros.
///
/// ### Atomic Level
/// **Molecule** – Compuesto por checkboxes y contenedor de tarjeta.
///
/// ### Parámetros
/// - `valueTerms`: Si el checkbox de términos está seleccionado.
/// - `valuePrivacy`: Si el checkbox de privacidad está seleccionado.
/// - `valueAutoRenew`: Si el checkbox de auto-renovación está seleccionado.
/// - `onChangedTerms`: Callback al cambiar el checkbox de términos.
/// - `onChangedPrivacy`: Callback al cambiar el checkbox de privacidad.
/// - `onChangedAutoRenew`: Callback al cambiar el checkbox de auto-renovación.
/// - `onTapTerms`: Callback para navegar a términos y condiciones.
/// - `onTapPrivacy`: Callback para navegar a políticas de privacidad.
///
/// ### Ejemplo
/// ```dart
/// TermsPrivacyAutoRenewCard(
///   valueTerms: true,
///   valuePrivacy: false,
///   valueAutoRenew: false,
///   onChangedTerms: (v) {},
///   onChangedPrivacy: (v) {},
///   onChangedAutoRenew: (v) {},
///   onTapTerms: () {},
///   onTapPrivacy: () {},
/// )
/// ```
/// {@endtemplate}
class TermsPrivacyAutoRenewCard extends StatelessWidget {
  /// {@macro terms_privacy_auto_renew_card}
  const TermsPrivacyAutoRenewCard({
    super.key,
    required this.valueTerms,
    required this.valuePrivacy,
    required this.valueAutoRenew,
    required this.onChangedTerms,
    required this.onChangedPrivacy,
    required this.onChangedAutoRenew,
    required this.onTapTerms,
    required this.onTapPrivacy,
  });

  /// Whether the terms checkbox is checked.
  final bool valueTerms;
  /// Whether the privacy checkbox is checked.
  final bool valuePrivacy;
  /// Whether the auto-renew checkbox is checked.
  final bool valueAutoRenew;

  /// Callback when the terms checkbox is toggled.
  final ValueChanged<bool?> onChangedTerms;
  /// Callback when the privacy checkbox is toggled.
  final ValueChanged<bool?> onChangedPrivacy;
  /// Callback when the auto-renew checkbox is toggled.
  final ValueChanged<bool?> onChangedAutoRenew;

  /// Callback to navigate to terms and conditions.
  final VoidCallback onTapTerms;
  /// Callback to navigate to privacy policy.
  final VoidCallback onTapPrivacy;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: <double>[0.0751, 0.5643, 0.6543],
          colors: <Color>[
            Color.fromRGBO(255, 255, 255, 0.25),
            Color.fromRGBO(0, 0, 0, 0.25),
            Color.fromRGBO(0, 0, 0, 0.25),
          ],
        ),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _CustomCheckboxRow(
            value: valueTerms,
            onChanged: onChangedTerms,
            label: 'Acepto términos y condiciones de acceso y uso.*',
            onTapLabel: onTapTerms,
          ),
          const SizedBox(height: 16),
          _CustomCheckboxRow(
            value: valuePrivacy,
            onChanged: onChangedPrivacy,
            label: 'Acepto políticas de privacidad.*',
            onTapLabel: onTapPrivacy,
          ),
          const SizedBox(height: 16),
          _CustomCheckboxRow(
            value: valueAutoRenew,
            onChanged: onChangedAutoRenew,
            label: 'Autorizas que este medio de pago sea usado para renovar tu suscripción de forma automática.',
            onTapLabel: null,
          ),
        ],
      ),
    );
  }
}

class _CustomCheckboxRow extends StatelessWidget {
  const _CustomCheckboxRow({
    required this.value,
    required this.onChanged,
    required this.label,
    this.onTapLabel,
  });

  /// Whether the checkbox is checked.
  final bool value;
  /// Callback when the checkbox is toggled.
  final ValueChanged<bool?> onChanged;
  /// The label for the checkbox.
  final String label;
  /// Optional callback when the label is tapped (for navigation).
  final VoidCallback? onTapLabel;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        GestureDetector(
          onTap: () => onChanged(!value),
          child: Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: value ? StoycoColors.principal : Colors.transparent,
              border: Border.all(
                color: value ? StoycoColors.principal : StoycoColors.text.withOpacity(0.3),
                width: 2,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: value
                ? const Center(
                    // TODO: Replace with custom SVG when available
                    child: Icon(Icons.check_rounded, color: Colors.white, size: 18),
                  )
                : null,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: GestureDetector(
            onTap: onTapLabel,
            child: Text(
              label,
              style: const TextStyle(
                color: StoycoColors.text,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
