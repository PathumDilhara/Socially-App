enum Mood {
  happy,
  sad,
  angry,
  excited,
  bored,
}

extension MoodsExtension on Mood {
  // Mood extension >> enum >> name
  String get name {
    switch (this) {
      case Mood.happy:
        return "happy";
      case Mood.sad:
        return "Sad";
      case Mood.angry:
        return "Angry";
      case Mood.excited:
        return "Excited";
      case Mood.bored:
        return "Bored";
    }
  }

  // MoodExtension >> enum > emoji
  String get emoji {
    switch (this) {
      case Mood.happy:
        return "😊";
      case Mood.sad:
        return "😢";
      case Mood.angry:
        return "😡";
      case Mood.excited:
        return "🤩";
      case Mood.bored:
        return "😴";
    }
  }

  // matches the given string (moodString) with the name property of the Mood
  // enum values. If no match is found, it falls back to a default value
  // (Mood.happy).
  // Method to helps to safely convert Strings to enum values
  static Mood formString(String moodString) {
    return Mood.values.firstWhere(
      (mood) => mood.name == moodString,
      orElse: () => Mood.happy,
    );
  }
}
