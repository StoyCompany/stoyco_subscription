/// Represents the different environments the application can run in.
enum StoycoEnvironment {
  /// Development environment.
  development,

  /// Production environment.
  production,

  /// Testing environment.
  testing,
}

/// Extension on `StoycoEnvironment` to provide the base URL for each environment
extension StoycoEnvironmentExtension on StoycoEnvironment {
  /// Gets the base URL for the current environment
  String baseUrl({String version = 'v1'}) {
    switch (this) {
      case StoycoEnvironment.development:
        return 'https://dev.api.stoyco.io/api/stoyco/$version/';
      case StoycoEnvironment.production:
        return 'https://api.stoyco.io/api/stoyco/$version/';
      case StoycoEnvironment.testing:
        return 'https://qa.api.stoyco.io/api/stoyco/$version/';
    }
  }

  String web3BaseUrl({String version = 'v1'}) {
    switch (this) {
      case StoycoEnvironment.development:
        return 'https://dev.api.stoyco.io/api/stoycoweb3/$version/';
      case StoycoEnvironment.production:
        return 'https://api.stoyco.io/api/stoycoweb3/$version/';
      case StoycoEnvironment.testing:
        return 'https://qa.api.stoyco.io/api/stoycoweb3/$version/';
    }
  }
}
