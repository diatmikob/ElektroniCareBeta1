# Dependency Management Guide

## Known Issues & Solutions

### 1. Form Builder Validators Conflict

**Issue**: `form_builder_validators ^9.1.0` conflicts with `intl ^0.19.0`

**Solution**: Use compatible versions:
```yaml
intl: ^0.18.1
form_builder_validators: ^9.1.0
```

### 2. Firebase Version Compatibility

**Issue**: Latest Firebase packages may not be compatible with Flutter 3.32.0

**Solution**: Use tested compatible versions:
```yaml
firebase_core: ^2.24.2
firebase_auth: ^4.15.3
cloud_firestore: ^4.13.6
firebase_messaging: ^14.7.10
```

### 3. Flutter SDK Issues

**Issue**: "sky_engine from sdk which doesn't exist" error

**Solutions**:
1. Use `pubspec_working.yaml` as reference for working configuration
2. Run `flutter clean` before `flutter pub get`
3. Ensure Flutter SDK is properly installed

## Working Configuration

Use the `pubspec_working.yaml` file for a minimal, tested configuration that works with Flutter 3.32.0.

## Testing Dependencies

1. Copy `pubspec_working.yaml` to `pubspec.yaml`
2. Run `flutter clean`
3. Run `flutter pub get`
4. If successful, gradually add more dependencies

## Recommended Approach

Start with minimal dependencies and add features incrementally:

1. **Core**: Flutter, Material Design
2. **State Management**: Provider/Riverpod
3. **Firebase**: Auth, Firestore
4. **UI Enhancements**: Charts, Animations
5. **Additional Features**: Location, Email, etc.

## Environment Requirements

- Flutter SDK: 3.32.0 or compatible
- Dart SDK: 3.8.0 or compatible
- Android SDK: API 21+ (Android 5.0+)
- iOS: 11.0+

## Troubleshooting

If you encounter dependency conflicts:

1. Check `pubspec_working.yaml` for working versions
2. Use `flutter pub deps` to analyze dependency tree
3. Use `flutter pub upgrade --major-versions` carefully
4. Consider using `dependency_overrides` for specific conflicts

## Production Notes

- Test all dependencies in development environment first
- Use exact versions in production (`1.2.3` instead of `^1.2.3`)
- Keep a backup of working `pubspec.yaml`
- Document any custom dependency overrides