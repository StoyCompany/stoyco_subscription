# Changelog

## [2.0.9] - 2025-11-18

### Features

- A new card for merchandise and experience has been added.
- A new event_grid was created


## [2.0.7] - 2025-11-18

### Features

- Added new subscription management methods to Service, Repository, and DataSource:
  - `subscribeToPlan(SubscribeRequest request)`
  - `unsubscribe(String planId)`
  - `renewSubscription(String planId)`
  - `updateSubscriptionPaymentMethod(SubscriptionMethodModificationRequest request)`
  - All methods are documented in English, following atomic design system context.

### Technical Details

- Adjusted types for subscription methods to use primitives (`String planId`) for unsubscribe and renew operations, improving API clarity and usability.
- Unified method signatures and documentation for consistency across layers.

## 2.0.10 - 2025-11-18

**refactor:** Simplify slider layout by replacing Column with SizedBox and optimizing ListView structure

## 2.0.6 - 2025-11-17

### Features

- **Implemented Repository Caching System** using stoyco_shared RepositoryCacheMixin
  - Added intelligent caching to PartnerProfileRepository (TTL: 5-15 minutes based on data volatility)
  - Added caching to ActiveSubscriptionRepository (TTL: 3 minutes for fresh subscription data)
  - Added caching to SubscriptionCatalogRepository (TTL: 4-5 minutes for catalog data)
  - Added caching to PaymentSummaryRepository (TTL: 5 minutes for payment information)
  - Automatic cache invalidation on token changes (login/logout events)
  - Significant performance improvements: ~100x faster on cache hits (500ms → 5ms)
  - Reduced server load and improved user experience with instant cached responses

### Technical Details

- Leverages InMemoryCacheManager from stoyco_shared package
- Cache keys include relevant identifiers (partner IDs, user IDs, etc.)
- TTL values balanced between data freshness and performance
- Graceful error handling with automatic cache bypass on failures

## 2.0.5 - 2025-11-14

### Features

- Added TagIcon widget and padlock SVG asset with associated colors.
- Enhanced card number handling and added UnionPay support.

### Fixes

- Set default package name for SvgGenImage to 'stoyco_subscription'.
- Updated functionToUpdateToken type to a callback for better clarity and usage.

### Other

- Merged changes from feature/STOYCO-21 and feaure/STOYCO-21 branches.

## 2.0.4 - 2025-11-13

## Features

- Added Expired subscription modal component
- Added AccessContent model for content accesses retrieval

## [Unreleased]

## 2.0.3 - 2025-11-11

### Features

- Implemented Active Subscription Management
- Added ActiveSubscriptionRepository for handling active subscription data retrieval and token management.
- Introduced ActiveSubscriptionService for managing active subscriptions with caching and Firebase Auth integration.
- Created models for ActiveUserPlanResponse and ActiveUserPlan to structure API responses.
- Implemented caching strategy for subscription data with automatic refresh and cache clearing on user logout.
- Developed comprehensive tests for ActiveSubscriptionService and its methods, ensuring correct functionality and error handling.
- Added environment configurations for different API base URLs.

## [Unreleased]

## 2.0.2 - 2025-11-07

### Features

- Added isPlanDeleted field in subscription history related model
- Shrink Text widget showing 'Ver planes' or 'Ver suscripción' state in case that the plan has been deleted

## [Unreleased]

## 2.0.1 - 2025-11-05

### Adjusted

- Adjust GlassmorphicContainer height adaptation for SubscriptionPaymentPreviewCard
- Adjust PaymentInformationSection horizontal padding
- Adjust SelectPaymentMethodSection horizontal padding and icon and text alignment

## [Unreleased]

## 2.0.0 (ddc12ee) - 2025-10-31

### Added

- AddCardPayment page now includes payment summary info and refactored import paths
- SubscriptionPlanCard component for displaying subscription plan details and actions
- SubscriptionPlanCancelCard component for displaying subscription plan cancellation details
- SubscriptionPaymentPreviewCard component for displaying subscription payment details
- CurrencyWidthFlag component for formatted price, currency code, and flag
- SubscriptionPlanPaymentInfoCard component for payment summary information
- CardGradient component for customizable gradient card UI
- CustomCheckboxRow component for customizable checkbox functionality
- Card holder name validation and improved input handling in AddCardPaymentNotifier
- AddCardPaymentNotifier for managing payment card input and validation
- AddCardPayment screen with form and validation for card details
- PaymentCard and PaymentMethodModel for handling payment card details and validation
- CardSubscriptionPlanCancel widget for displaying subscription plan details
- CardImageDescriptionTag with padding and margin properties for improved layout control
- TermsPrivacyAutoRenewCard widget for managing subscription terms and privacy agreements
- ModalBaseSubscription widget for styled modal dialogs
- SubscriptionTextForm widget for customizable text input
- New payment icons and images

### Changed

- Removed auto-renew option and updated card number masking logic for Diners Club
- Expiration date validation now restricts maximum year to 2034
- Refactored date formatting function into StoycoDateFormatters class
- Updated payment image file paths and names for consistency
- ButtonGradientText component now supports loading state and icon customization
- TagCorner component enhanced with showExclamationIcon parameter
- PaymentSummaryScreen and PaymentSummaryMobileScreen enhanced with additional parameters for payment plan interaction
- selectPaymentMethodSection parameter added to PaymentSummaryScreen for improved payment method selection
- CardSubscriptionPlan layout enhanced with conditional spacing and centered text
- Asset paths for icons updated across multiple components
- Dependencies reorganized in pubspec.yaml for better clarity and structure

### Fixed

- Updated jcb payment image for consistency
- Correct closing brace in ButtonGradientText class

### Removed

- Unused subscription plan card components
- Unused payment method related files

### Documentation

- Enhanced documentation for TermsPrivacyAutoRenewCard and other components

## 1.1.0 - 2025-10-22

### Added

- Subscription summary integration
- Cultural assets integration
- Init modal setup for expired suscriptions notification

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

## 0.8.0

### Features

- Added payment summary mobile screen design
- Added payment summary card
- Added payment summary info list
- Added payment method buttons

## 0.7.0

### Features

- Added PartnerProfile service, datasource and repository
- Added response models for getLowestPricePlanByPartner and getLastUserPlanByPartner services.
- Added PartnerProfileSubscriptionBtn component
- Added CulturalAssetSlider and CulturalAssetCard components

## 0.6.1

### Features

- Add hasSubscription param and hide Subscribe button depending on it

## 0.6.0

### Features

- Add page and pageSize to getSubscriptionCatalogService
- Implement subscription catalog service in catalog screen to fetch real data

## 0.5.4

### Features

- Search icon refactor

## 0.5.3

### Features

- Added default package 'stoyco_subscription' name in assets.gen for assets tokens
- replace SvgPicture.asset with generated asset references in multiple components

## 0.5.2

### Features

- Add receiving of auth token for subscription_catalog_service init
- Update service, repository and datasource accordingly, to receive auth token.

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
