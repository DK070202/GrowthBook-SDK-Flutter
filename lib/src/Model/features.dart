import 'package:enhanced_enum/enhanced_enum.dart';
import 'package:growthbook_sdk_flutter/growthbook_sdk_flutter.dart';

part 'features.g.dart';

/// A Feature object consists of possible values plus rules for how to assign values to users.
class GBFeature {
  GBFeature({
    this.rules,
    this.defaultValue,
  });

  /// The default value (should use null if not specified)
  ///2 Array of Rule objects that determine when and how the defaultValue gets overridden
  List<GBFeatureRule>? rules;

  ///  The default value (should use null if not specified)
  dynamic defaultValue;

  factory GBFeature.fromMap(Map<String, dynamic> dataMap) {
    return GBFeature(
      rules: dataMap['rules'] != null
          ? List<GBFeatureRule>.from(
              (dataMap['rules'] as List).map(
                (e) => GBFeatureRule.fromMap(e),
              ),
            )
          : null,
      defaultValue: dataMap["defaultValue"],
    );
  }
}

/// Rule object consists of various definitions to apply to calculate feature value

class GBFeatureRule {
  GBFeatureRule({
    this.condition,
    this.coverage,
    this.force,
    this.variations,
    this.key,
    this.weights,
    this.nameSpace,
    this.hashAttribute,
  });

  /// Optional targeting condition
  GBCondition? condition;

  /// What percent of users should be included in the experiment (between 0 and 1, inclusive)
  double? coverage;

  /// Immediately force a specific value (ignore every other option besides condition and coverage)
  dynamic force;

  /// Run an experiment (A/B test) and randomly choose between these variations
  List<dynamic>? variations;

  /// The globally unique tracking key for the experiment (default to the feature key)
  String? key;

  /// How to weight traffic between variations. Must add to 1.
  List<double>? weights;

  /// A tuple that contains the namespace identifier, plus a range of coverage for the experiment.
  List? nameSpace;

  /// What user attribute should be used to assign variations (defaults to id)
  String? hashAttribute;

  factory GBFeatureRule.fromMap(Map<String, dynamic> mappedData) {
    return GBFeatureRule(
      nameSpace: mappedData['namespace'],
      condition: mappedData['condition'],
      coverage: (mappedData['coverage'] as num?)?.toDouble(),
      variations: mappedData['variations'] != null
          ? List<dynamic>.from(mappedData['variations'].map((e) => e))
          : null,
      key: mappedData['key'],
      weights: mappedData['weights'] != null
          ? List<double>.from(
              (mappedData['weights'] as List).map((e) => e.toDouble()).toList())
          : null,
      force: mappedData['force'],
      hashAttribute: mappedData["hashAttribute"],
    );
  }
}

/// Enum For defining feature value source.
@EnhancedEnum()
enum GBFeatureSource {
  /// Queried Feature doesn't exist in GrowthBook.
  @EnhancedEnumValue(name: 'unknownFeature')
  unknownFeature,

  /// Default Value for the Feature is being processed.
  @EnhancedEnumValue(name: 'defaultValue')
  defaultValue,

  /// Forced Value for the Feature is being processed.
  @EnhancedEnumValue(name: 'force')
  force,

  /// Experiment Value for the Feature is being processed.
  @EnhancedEnumValue(name: 'experiment')
  experiment
}

/// Result for Feature
class GBFeatureResult {
  GBFeatureResult({
    this.value,
    this.on,
    this.off,
    this.source,
    this.experiment,
    this.experimentResult,
  });

  /// The assigned value of the feature
  dynamic value;

  /// The assigned value cast to a boolean
  bool? on = false;

  /// The assigned value cast to a boolean and then negated
  bool? off = true;

  /// One of "unknownFeature", "defaultValue", "force", or "experiment"

  GBFeatureSource? source;

  /// When source is "experiment", this will be the Experiment object used
  GBExperiment? experiment;

  ///When source is "experiment", this will be an ExperimentResult object
  GBExperimentResult? experimentResult;
}
