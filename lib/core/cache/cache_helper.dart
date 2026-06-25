import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/courses.dart';

class CacheHelper {
  static late SharedPreferences _preferences;

  // Keys لتخزين الـLists
  static const _userId = 'id';
  static const _language = 'lang';
  static const _deviceToken = 'deviceToken';
  static const _themeMode = 'themeMode'; // 'light' | 'dark' | 'system'
  static const _selectedCoursesKey = 'selectedCourses';
  static const _completedCoursesKey = 'completedCourses';
  static const _savedCoursesKey = 'savedCourses';

  static init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  // User ID
  static setUserId(String? id) async {
    await _preferences.setString(_userId, id ?? '');
  }

  static String getUserId() {
    return _preferences.getString(_userId) ?? '';
  }

  static removeUserId() async {
    await _preferences.remove(_userId);
  }

  // Device Token
  static setDeviceToken(String? deviceToken) async {
    await _preferences.setString(_deviceToken, deviceToken ?? '');
  }

  static String getDeviceToken() {
    return _preferences.getString(_deviceToken) ?? '';
  }

  // Language
  static setLang(String lang) async {
    await _preferences.setString(_language, lang);
  }

  static String getLang() {
    return _preferences.getString(_language) ?? '';
  }

  // Theme mode ('light' | 'dark' | 'system')
  static Future<void> setThemeMode(String mode) async {
    await _preferences.setString(_themeMode, mode);
  }

  static String getThemeMode() {
    return _preferences.getString(_themeMode) ?? 'system';
  }

  // Clear Data
  static clearData() async {
    await _preferences.clear();
  }

  // Add Course to Selected Courses
  static addSelectedCourse(Course course) async {
    List<String>? coursesJson = _preferences.getStringList(_selectedCoursesKey);
    List<Course> courses =
        coursesJson != null && coursesJson.isNotEmpty
            ? coursesJson
                .map((json) => Course.fromJson(jsonDecode(json)))
                .toList()
            : [];

    // Add new course to the list if it's not already added
    if (!courses.any(
      (existingCourse) => existingCourse.title == course.title,
    )) {
      courses.add(course);
    }

    // Save updated list back to SharedPreferences
    List<String> updatedCoursesJson =
        courses.map((course) => jsonEncode(course.toJson())).toList();
    await _preferences.setStringList(_selectedCoursesKey, updatedCoursesJson);
  }

  // Get Selected Courses
  static List<Course> getSelectedCourses() {
    List<String>? coursesJson = _preferences.getStringList(_selectedCoursesKey);
    if (coursesJson != null && coursesJson.isNotEmpty) {
      return coursesJson
          .map((json) => Course.fromJson(jsonDecode(json)))
          .toList();
    } else {
      return [];
    }
  }

  // Remove a specific course from Selected Courses
  static removeSelectedCourse(String courseTitle) async {
    List<String>? coursesJson = _preferences.getStringList(_selectedCoursesKey);
    List<Course> courses =
        coursesJson != null && coursesJson.isNotEmpty
            ? coursesJson
                .map((json) => Course.fromJson(jsonDecode(json)))
                .toList()
            : [];

    // Remove the course if it exists
    courses.removeWhere((course) => course.title == courseTitle);

    // Save updated list back to SharedPreferences
    List<String> updatedCoursesJson =
        courses.map((course) => jsonEncode(course.toJson())).toList();
    await _preferences.setStringList(_selectedCoursesKey, updatedCoursesJson);
  }

  // Add Course to Completed Courses
  static addCompletedCourse(Course course) async {
    List<String>? coursesJson = _preferences.getStringList(
      _completedCoursesKey,
    );
    List<Course> courses =
        coursesJson != null && coursesJson.isNotEmpty
            ? coursesJson
                .map((json) => Course.fromJson(jsonDecode(json)))
                .toList()
            : [];

    // Add new course to the list if it's not already added
    if (!courses.any(
      (existingCourse) => existingCourse.title == course.title,
    )) {
      courses.add(course);
    }

    // Save updated list back to SharedPreferences
    List<String> updatedCoursesJson =
        courses.map((course) => jsonEncode(course.toJson())).toList();
    await _preferences.setStringList(_completedCoursesKey, updatedCoursesJson);
  }

  // Get Completed Courses
  static List<Course> getCompletedCourses() {
    List<String>? coursesJson = _preferences.getStringList(
      _completedCoursesKey,
    );
    if (coursesJson != null && coursesJson.isNotEmpty) {
      return coursesJson
          .map((json) => Course.fromJson(jsonDecode(json)))
          .toList();
    } else {
      return [];
    }
  }

  // Remove a specific course from Completed Courses
  static removeCompletedCourse(String courseTitle) async {
    List<String>? coursesJson = _preferences.getStringList(
      _completedCoursesKey,
    );
    List<Course> courses =
        coursesJson != null && coursesJson.isNotEmpty
            ? coursesJson
                .map((json) => Course.fromJson(jsonDecode(json)))
                .toList()
            : [];

    // Remove the course if it exists
    courses.removeWhere((course) => course.title == courseTitle);

    // Save updated list back to SharedPreferences
    List<String> updatedCoursesJson =
        courses.map((course) => jsonEncode(course.toJson())).toList();
    await _preferences.setStringList(_completedCoursesKey, updatedCoursesJson);
  }

  // Add Course to Saved Courses
  static addSavedCourse(Course course) async {
    List<String>? coursesJson = _preferences.getStringList(_savedCoursesKey);
    List<Course> courses =
        coursesJson != null && coursesJson.isNotEmpty
            ? coursesJson
                .map((json) => Course.fromJson(jsonDecode(json)))
                .toList()
            : [];

    // Add new course to the list if it's not already added
    if (!courses.any(
      (existingCourse) => existingCourse.title == course.title,
    )) {
      courses.add(course);
    }

    // Save updated list back to SharedPreferences
    List<String> updatedCoursesJson =
        courses.map((course) => jsonEncode(course.toJson())).toList();
    await _preferences.setStringList(_savedCoursesKey, updatedCoursesJson);
  }

  // Get Saved Courses
  static List<Course> getSavedCourses() {
    List<String>? coursesJson = _preferences.getStringList(_savedCoursesKey);
    if (coursesJson != null && coursesJson.isNotEmpty) {
      return coursesJson
          .map((json) => Course.fromJson(jsonDecode(json)))
          .toList();
    } else {
      return [];
    }
  }

  // Remove a specific course from Saved Courses
  static removeSavedCourse(String courseTitle) async {
    List<String>? coursesJson = _preferences.getStringList(_savedCoursesKey);
    List<Course> courses =
        coursesJson != null && coursesJson.isNotEmpty
            ? coursesJson
                .map((json) => Course.fromJson(jsonDecode(json)))
                .toList()
            : [];

    // Remove the course if it exists
    courses.removeWhere((course) => course.title == courseTitle);

    // Save updated list back to SharedPreferences
    List<String> updatedCoursesJson =
        courses.map((course) => jsonEncode(course.toJson())).toList();
    await _preferences.setStringList(_savedCoursesKey, updatedCoursesJson);
  }

  // Remove all courses from each list
  static removeAllCourses() async {
    await _preferences.remove(_selectedCoursesKey);
    await _preferences.remove(_completedCoursesKey);
    await _preferences.remove(_savedCoursesKey);
  }
}
