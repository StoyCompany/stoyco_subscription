# Changelog

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
