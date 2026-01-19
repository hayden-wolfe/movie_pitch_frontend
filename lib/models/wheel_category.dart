/// Defines a category of spinning wheel with its items and constraints.
class WheelCategory {
  final String id;
  final String displayName;
  final List<String> items;
  final int minWheels;
  final int maxWheels;
  final int defaultWheelCount;

  const WheelCategory({
    required this.id,
    required this.displayName,
    required this.items,
    required this.minWheels,
    required this.maxWheels,
    required this.defaultWheelCount,
  });
}
