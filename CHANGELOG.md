# Changelog

## [Unreleased]

## 1.0.0 - 2025-10-21

### Added

- ProductsSlider and ProductsSliderStyle components for customizable product card displays.
- EventsSlider and EventsSliderStyle components for event card displays with customizable styles.
- LockedBlur widget for exclusive content overlays with customizable blur effects.
- TagLocked widget for exclusive content overlays.
- ImageNetworkBlur widget with customizable blur effect and overlay.
- New colors and icons for dark mode support.

### Changed / Enhanced

- PaymentSummaryInfoModel: Added JSON serialization and improved builder signature for PaymentItemCardState.
- CulturalAssetCardModel: Added hasAccess field and updated JSON serialization.
- CardSubscriptionPlan: Enhanced documentation with detailed parameters and example usage.
- CulturalAssetCard: Improved access handling and UI elements.
- CardImageDescriptionTag: Enhanced documentation and added image URL visibility.
- PaymentMethodSelectButton: Enhanced documentation and improved callback types.
- PartnerProfileSubscribeBtn: Improved subscription handling.
- CulturalAssetsSlider: Improved loading state handling and documentation.
- SubscriptionPlansList: Enhanced documentation and updated import statements for tab_bar_v2.
- Atomic design components: Enhanced documentation and structure for better maintainability.

### Fixed

- Replaced print statements with logger in SubscriptionCatalogNotifier.
- Corrected import path in SubscriptionHistoryNotifier.

### Removed

- Deprecated tab bar and card components.

### Chore

- Updated version number to 1.0.0 in pubspec.yaml.
- update README.md with version badge, enhance features section, and improve asset usage examples

## 0.9.0

### Features

- Added subscription history screen design
- Added subscription history integration


## [Unreleased]

## 0.8.0

### Features

- Added payment summary mobile screen design
- Added payment summary card
- Added payment summary info list
- Added payment method buttons

## [Unreleased]

## 0.7.0

### Features

- Added PartnerProfile service, datasource and repository
- Added response models for getLowestPricePlanByPartner and getLastUserPlanByPartner services.
- Added PartnerProfileSubscriptionBtn component
- Added CulturalAssetSlider and CulturalAssetCard components

## [Unreleased]

## 0.6.1

### Features

- Add hasSubscription param and hide Subscribe button depending on it

## [Unreleased]

## 0.6.0

### Features

- Add page and pageSize to getSubscriptionCatalogService
- Implement subscription catalog service in catalog screen to fetch real data

## [Unreleased]

## 0.5.4

### Features

- Search icon refactor

## [Unreleased]

## 0.5.3

### Features

- Added default package 'stoyco_subscription' name in assets.gen for assets tokens
- replace SvgPicture.asset with generated asset references in multiple components

## [Unreleased]

## 0.5.2

### Features

- Add receiving of auth token for subscription_catalog_service init
- Update service, repository and datasource accordingly, to receive auth token.

## [Unreleased]

## 0.5.1

### Features

- Enhanced subscription plans display with availability checks and improved messaging.
- Adjusted padding and font size for ButtonGradientText based on device type.

### Fixes

- Renamed `titleStyleTagGradient` to `tagGradientTitleStyle` for consistency.
- Corrected property name for tag gradient title style in `CardSubscriptionPlan`.
- Removed redundant token verification in `getSubscriptionPlansByPartnerAndUser` method.

## 0.5.0

## Features

- Added stoyco catalog responsive design
- Added stoyco web view
- Added onTapSubscribe button callback
- Added get subscription plan service

## Fixes

- Adjust screen sizes, paddings and text sizes for catalog related widgets

## [Unreleased]

## 0.4.0

### Features

- Added `SubscriptionPlansList` widget for displaying subscription plans with customizable styles and actions.
- Enhanced subscription plan model and UI with new currency handling and button styles.
- Implemented custom error handling classes and logging utilities for improved error management.
- Refactored subscription plans data handling with new data source and repository structure.
- Added logger dependency for improved logging capabilities.
- Integrated Google Fonts for improved text styling in multiple widgets.
- Added SVG icon assets for subscription tags and replaced default arrow icon in `HtmlDropdown`.
- Implemented responsive device type detection and environment management.
- Added `SubscriptionPlanScreenStyleParams` class for managing subscription plan styles and parameters.
- Added `CardSubscriptionPlan` widget and enhanced model with ID.
- Added `ButtonGradientText` and `ButtonGradient` widgets for customizable gradient buttons.
- Added `TabMenuItem` and `CustomTabBar` widgets for tabbed navigation.
- Added `CardWithShadow`, `SkeletonCard`, and `CurrencyFlag` widgets for improved UI components.
- Added `HtmlDropdown` widget for rendering HTML content in a dropdown.
- Added `TagCorner`, `TagGradientIcon`, and related enums for customizable tags.
- Added `GradientBorderPainter`, `GradientPathBorderPainter`, and `PathBuilderBorder` for advanced border and shadow effects.
- Added color and asset generation files for design tokens and components.
- Added mock data and models for monthly and annual subscription plans.

### Improvements

- Enhanced layout and visual consistency for buttons, cards, and tags.
- Improved padding, shadow, and border properties across multiple components.
- Updated color definitions and removed deprecated widgets.
- Refactored documentation and parameter descriptions for better clarity.
- Updated analysis options with comprehensive linter rules and error handling.
- Updated pubspec.yaml to clean up dependencies and asset paths.

### Fixes

- Fixed callback names for subscription actions in `SubscriptionPlansList`.
- Adjusted content padding in `HtmlDropdown` for better responsiveness.
- Updated onboarding key retrieval logic in `StoycoTabBarV2` for better clarity.
- Simplified `SkeletonCard` widget structure by removing unnecessary `Stack`.
- Adjusted shadow properties for `ButtonGradientText` to improve visual consistency.
- Disabled page swiping in `TabMenuItem` for controlled navigation.
- Adjusted padding in `CustomTabBar` for improved layout consistency.
- Removed deprecated linter rule `use_setters_to_change_properties` from analysis options.

### Refactoring

- Refactored color and font utilities; removed unused files and implemented new alert components.
- Updated documentation and improved parameter descriptions in `TagGradientIcon`.
- Removed unused atomic design widgets and related files.

### Other

- Merged changes from `main` branch.
- Updated SDK requirements.
- Added documentation to existing exports.

## 0.3.0

- Add documentation to existing exports

## 0.2.0

- Add stoyco subscription circular image with info and fonts

## 0.1.0

- Add fonts and color utils. Add subscription search bar widget

## 0.0.1

- TODO: Describe initial release.
