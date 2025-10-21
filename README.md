<p align="center">
  <img src="https://img.shields.io/badge/Flutter-02569B?logo=flutter&logoColor=white&style=flat-square" alt="Flutter" />
  <img src="https://img.shields.io/badge/Version-1.0.0-E63946?style=flat-square" alt="version" />
  <img src="https://img.shields.io/badge/Coverage-0%25-4CAF50?style=flat-square" alt="coverage" />
</p>

<p align="center">
<strong>Stoyco Subscription Library</strong> is a <strong>modular Flutter package</strong> implementing <strong>Atomic Design principles</strong> for subscription management and reusable UI components.<br>
It provides scalable, customizable modules for subscription flows, payment, catalog, and profile management, as well as a comprehensive set of design system components for Stoyco products.
</p>

---

## 🚀 Features

- 🧩 **Atomic Design architecture**: Atoms, Molecules, Organisms, Templates, and Pages
- 💳 **Subscription modules**: Catalog, plans, payment summary, history, and partner profile
- 🎨 **Customizable UI components**: Cards, headers, buttons, tags, sliders, and more
- 🌗 **Comprehensive theme management** (light/dark modes)
- 🖼️ **Built-in asset integration** for icons, images, and colors
- 📐 **Responsive tokens and layout utilities**
- 🔌 **Easy integration** into any Flutter app
- 🧪 **Tested and documented** for production use

---

## 🛠️ Getting Started

### Prerequisites
- **Flutter SDK** >= 3.8.0

### Installation
Add this dependency to your `pubspec.yaml`:

```yaml
dependencies:
  stoyco_subscription:
    git:
      url: https://github.com/StoyCompany/stoyco_subscription
      ref: main
```

Then run:

```bash
flutter pub get
```

---

## 📚 Generating Native Documentation (dartdoc)

You can generate native Dart/Flutter documentation for this library using the official dartdoc tool. This allows you to browse technical details of all components, models, and utilities directly in your browser.

### How to generate it?

1. Open a terminal at the root of the project.
2. Run:

```bash
flutter pub global activate dartdoc
flutter pub global run dartdoc
```

This will generate a `doc/` folder with HTML documentation. Open `doc/index.html` in your browser to view it.

> **Note:** Do not commit the `doc/` folder to the repository. This documentation is generated automatically and each developer can generate it locally as needed.

For more information, see the [official dartdoc guide](https://dart.dev/tools/dartdoc).

---

## 🖼️ Asset Usage

All assets are bundled and exposed through the `StoycoAssets` generator — no need to manually declare them.

**Example (Image):**

```dart
StoycoAssets.lib.assets.images.logo.image(
  package: 'stoyco_subscription',
  width: 100,
  height: 100,
);
```

**Example (SVG Icon):**

```dart
StoycoAssets.lib.assets.icons.subscription.svg(
  package: 'stoyco_subscription',
  width: 100,
  height: 100,
);
```

✅ Assets are loaded **directly from the package**, ensuring consistency and no manual setup.

---

## 💡 Example: Using a Subscription Card

```dart
CardSubscriptionPlan(
  plan: myPlan,
  styleParams: myStyleParams,
  onTapRenewSubscription: (plan) => print('Renew: \\${plan.name}'),
  onTapCancelSubscription: (plan) => print('Cancel: \\${plan.name}'),
  onTapNewSubscription: (plan) => print('Subscribe: \\${plan.name}'),
)
```

---

## 🧰 Development Workflow

* **Code style**: follows Dart and Flutter linter rules (effective_dart + custom rules)
* **Documentation**: generated following Stoyco internal standards and Flutter best practices
* **Tests**: focus on widget behavior, business logic, and UI consistency
* **Automation**: via scripts and CI for testing, coverage, and lint checks

---

## 🧭 Philosophy

> “Design once, reuse everywhere.”
> Stoyco Subscription Library is built for **consistency, scalability, and developer productivity** across all Stoyco products.

---

## 📦 Project Structure

```
lib/
 ├── stoyco_subscription.dart
 ├── assets/
 │    ├── colors/
 │    │    └── colors.xml
 │    ├── fonts/
 │    │    ├── Akkurat_Pro/
 │    │    └── GT_Pressura_Mono/
 │    ├── icons/
 │    └── mocks/
 │         ├── payment_summary_info_response.json
 │         └── subscription_plan_by_user.json
 ├── atomic_design/
 │    └── tokens/
 ├── designs/
 │    └── atomic/
 │         ├── atoms/
 │         │    ├── alert/
 │         │    ├── animations/
 │         │    ├── borders/
 │         │    ├── buttons/
 │         │    ├── cards/
 │         │    ├── flags/
 │         │    ├── headers/
 │         │    ├── images/
 │         │    ├── inputs/
 │         │    ├── skeletons/
 │         │    └── tags/
 │         ├── molecules/
 │         │    ├── appbars/
 │         │    ├── blurs/
 │         │    ├── buttons/
 │         │    ├── cards/
 │         │    ├── circular_avatar/
 │         │    ├── dropdowns/
 │         │    ├── tab_bar/
 │         │    ├── tap_menu_items/
 │         │    └── taps/
 │         ├── organisms/
 │         │    ├── cards/
 │         │    ├── sections/
 │         │    └── sliders/
 │         ├── templates/
 │         │    └── sliders/
 │         └── tokens/
 │              └── src/
 │         ├── responsive/
 │         │    ├── device.dart
 │         │    ├── round_polygons.dart
 │         │    └── screen_size.dart
 │         ├── types/
 │         │    └── tag_corner_position.dart
 │         └── utils/
 │              ├── formatter_currency.dart
 │              └── formatter_dates.dart
 ├── envs/
 │    └── envs.dart
 ├── pages/
 │    ├── partner_profile/
 │    │    ├── data/
 │    │    │    ├── partner_profile_data_source.dart
 │    │    │    ├── partner_profile_repository.dart
 │    │    │    ├── partner_profile_service.dart
 │    │    │    └── models/
 │    ├── payment_summary/
 │    │    ├── payment_summary_screen.dart
 │    │    ├── data/
 │    │    │    └── models/
 │    │    ├── notifier/
 │    │    │    └── payment_summary_notifier.dart
 │    │    └── screens/
 │    │         └── payment_summary_mobile_screen.dart
 │    ├── subscription_catalog/
 │    │    ├── responsive_subscription_catalog_screen.dart
 │    │    ├── data/
 │    │    │    ├── subscription_catalog_data_source.dart
 │    │    │    ├── subscription_catalog_repository.dart
 │    │    │    ├── subscription_catalog_service.dart
 │    │    │    └── models/
 │    │    ├── models/
 │    │    │    ├── subscription_catalog_item_map.dart
 │    │    │    └── subscription_catalog_item_map.g.dart
 │    │    ├── notifier/
 │    │    │    └── subscription_catalog_notifier.dart
 │    │    └── screens/
 │    │         ├── subscription_catalog_screen_mobile.dart
 │    │         └── subscriptions_catalog_screen_web.dart
 │    ├── subscription_history/
 │    │    ├── subscription_history_screen.dart
 │    │    ├── notifier/
 │    │    │    └── subscription_history_notifier.dart
 │    │    └── screens/
 │    │         └── subscription_history_mobile_screen.dart
 │    └── subscription_plans/
 │         ├── data/
 │         │    ├── subscription_plans_data_source.dart
 │         │    ├── subscription_plans_repository.dart
 │         │    ├── subscription_plans_service.dart
 │         │    ├── errors/
 │         │    └── models/
 │         └── presentation/
 │              ├── subscription_plans_screen.dart
 │              └── helpers/
 └── utils/

test/
 └── ...
assets/
 ├── icons/
 ├── images/
 ├── fonts/
 └── ...
```

---

## 🏢 About Stoyco

Stoyco is dedicated to building robust, scalable, and user-centric digital solutions. This library is a core part of our subscription and design system ecosystem.
