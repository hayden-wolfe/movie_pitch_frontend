import 'package:movie_pitch_generator/models/wheel_category.dart';

/// Predefined items for each wheel category.
const List<String> characterItems = [
  'Baker Mayfield',
  'A rogue AI',
  'Rachel McAdams',
  'Johnny Drama',
  'A talking dog detective',
];

const List<String> creativeItems = [
  'Christopher Nolan',
  'Greta Gerwig',
  'Quentin Tarantino',
  'Denis Villeneuve',
  'Jordan Peele',
  'The Russo Brothers',
  'Rian Johnson',
  'Ava DuVernay',
];

const List<String> locationItems = [
  'A futuristic Tokyo',
  'A haunted Victorian mansion',
  'A colony on Mars',
  'An underwater kingdom',
  'A magical forest',
  'A dystopian megacity',
  'A secret underground lab',
  'A floating sky island',
  'An abandoned theme park',
  'A parallel dimension',
];

const List<String> genreItems = [
  'Sci-Fi',
  'Horror',
  'Comedy',
  'Action',
  'Romance',
  'Thriller',
  'Fantasy',
  'Mystery',
  'Drama',
  'Animation',
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
