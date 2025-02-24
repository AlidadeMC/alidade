#!/bin/sh

defaults write com.apple.dt.Xcode IDESkipPackagePluginFingerprintValidatation -bool YES
defaults write com.apple.dt.Xcode IDESkipMacroFingerprintValidation -bool YES

ls CubiomesKit/Tests/CubiomesKitTests/__Snapshots__/CubiomesKitTests
