/// Response model for the movie pitch API.
class PitchResult {
  final String title;
  final String tagline;
  final String pitch;

  const PitchResult({
    required this.title,
    required this.tagline,
    required this.pitch,
  });

  factory PitchResult.fromJson(Map<String, dynamic> json) {
    return PitchResult(
      title: json['title'] as String,
      tagline: json['tagline'] as String,
      pitch: json['pitch'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'title': title, 'tagline': tagline, 'pitch': pitch};
  }
}
