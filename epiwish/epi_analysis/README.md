# Epi Analysis

This package includes a list of linter rules for Dart & Flutter projects or libraries.

Inspired by [very_good_analysis][very_good_analysis_link]

---

# Usage

To use epi_analysis, add to your `dev` dependencies in your `pubspec.yaml` like this:

```yaml
epi_analysis:
  git:
    url: https://github.com/Epiwish/epi_analysis
    ref: 1.0.0
```

Or run this command in your terminal:

```yaml
dart pub add dev:epi_analysis --git-url https://github.com/Epiwish/epi_analysis --git-ref 1.0.0
```

Then, update your `analysis_options.yaml` file to include epi_analysis in the project:

```yaml
include: package:epi_analysis/analysis_options.yaml
```

## Disabling Lints

To disable any rule for your project, edit your `analysis_options.yaml`

```yaml
linter:
  rules:
    always_use_package_imports: false
```

**Note**: This will disable the `always_use_package_imports` for the entire project.

To disable rule just for the specific file, use this at the top of your file:

```dart
// ignore_for_file: always_use_package_imports
```

To disable rule for just in one line, use this at the top of your line:

```dart
// ignore: always_use_package_imports
```

[very_good_analysis_link]: https://github.com/VeryGoodOpenSource/very_good_analysis
