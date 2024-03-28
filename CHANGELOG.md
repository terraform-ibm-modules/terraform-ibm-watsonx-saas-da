# Changelog

All notable changes to this project will be documented in this file.

## 0.3.0

### Added

- Added unit test

### Changed

- Lite plan for COS is not accepted anymore

### Fixed

## 0.2.0

### Added

### Changed

- Replaced custom code to provision a COS instance with https://github.com/terraform-ibm-modules/terraform-ibm-cos/tree/main

### Fixed

- Project URL now redirect to target account

## 0.1.7

### Added

### Changed

### Fixed

- Patch the ML instance in the project configuration if the user deletes and recreated the ML instance
- Fixed force_account_scope account settings

## 0.1.6

### Added

### Changed

### Fixed

- Changed default plan of optional services to "do not install"

## 0.1.5

### Added

### Changed

### Fixed

- Input plans are now null in Projects UI

## 0.1.4

### Added

### Changed

### Fixed

- Outputs of optional services were arrays, now outputs are string agains

## 0.1.3

### Added

- Restrict resources to the current target account

### Changed

- Watson Conversation, Discover, and Governance are now optional services

### Fixed

## 0.1.2

### Added

- Added dashboard URL for the provisioned services
- Add Watson project URL

### Changed

### Fixed

## 0.1.1

### Added

- Project creation in Watson
- User can specify a prefix to use for the resource names

### Changed

### Fixed

- Fixed the plan names

## 0.1.0

### Added

- User is configured in watsonx platform if it is not already configured

### Changed

### Fixed

## 0.0.2

### Added

- New variables to set the plan for each resource

### Changed

### Fixed

## 0.0.1

### Added

- First release

### Changed

### Fixed
