import 'package:movie_pitch_generator/models/wheel_category.dart';

/// Predefined items for each wheel category.
const List<String> characterItems = [
  'Baker Mayfield',
  'Ernie Johnson',
  'Rachel McAdams',
  'Harrison Ford',
  'Carrie Fisher',
  'Russell Westbrook',
  'Johnny Drama',
  'A talking dog detective',
  'Walton Goggins',
];

const List<String> creativeItems = [
  'Christopher Nolan',
  'Steven Spielberg',
  'Jordan Peele',
  'Rian Johnson',
  'Danny McBride',
  'Ava DuVernay',
  'Denis Villeneuve',
  'Kathryn Bigelow',
];

const List<String> locationItems = [
  'Norman, OK',
  "Braum's Ice Cream Store",
  'Oklahoma Memorial Stadium',
  'Texas State Fair',
  'A colony on Mars',
  'Rome, Italy',
  'A futuristic Tokyo',
  'New York City',
];

const List<String> genreItems = [
  'Comedy',
  'Action',
  'Romance',
  'Thriller',
  'Sci-Fi',
  'Horror',
  'Fantasy',
  'Mystery',
  'Drama',
  'Animation',
  'Family',
];

/// All wheel categories with their configurations.
final List<WheelCategory> wheelCategories = [
  WheelCategory(
    id: 'characters',
    displayName: 'Characters',
    items: characterItems,
    minWheels: 1,
    maxWheels: 3,
    defaultWheelCount: 1,
  ),
  WheelCategory(
    id: 'creatives',
    displayName: 'Creatives',
    items: creativeItems,
    minWheels: 1,
    maxWheels: 2,
    defaultWheelCount: 1,
  ),
  WheelCategory(
    id: 'locations',
    displayName: 'Locations',
    items: locationItems,
    minWheels: 1,
    maxWheels: 2,
    defaultWheelCount: 1,
  ),
  WheelCategory(
    id: 'genres',
    displayName: 'Genres',
    items: genreItems,
    minWheels: 1,
    maxWheels: 2,
    defaultWheelCount: 1,
  ),
];
