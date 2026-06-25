class Doctors {
  final String image;
  final String name;
  final String title;
  final int coursesCount;
  final int followersCount;

  Doctors( {
    required this.image,
    required this.name,
    required this.coursesCount,
    required this.followersCount,
    required this.title,
  });

  factory Doctors.fromJson(Map<String, dynamic> json) => Doctors(
    image: json['image'],
    name: json['name'],
    coursesCount: json['courses_count'],
    followersCount: json['followers_count'],
    title: json['title'],
  );
}

class LearningProgramsCourses {
  final String image;
  final String title;
  final String name;

  LearningProgramsCourses({
    required this.image,
    required this.title,
    required this.name,
  });

  factory LearningProgramsCourses.fromJson(Map<String, dynamic> json) =>
      LearningProgramsCourses(
        image: json['image'],
        title: json['title'],
        name: json['name'],
      );
}

class WhatYouLearn {
  final String title;

  WhatYouLearn({required this.title});
  factory WhatYouLearn.fromJson(Map<String, dynamic> json) =>
      WhatYouLearn(title: json['title']);
}

class LearningProgramsModel {
  final String title;
  final String desc;
  final String image;
  final int coursesCount;
  final List<WhatYouLearn> whatYouLearn;
  final List<LearningProgramsCourses> learningProgramsCourses;

  final List<Doctors> doctors;

  LearningProgramsModel({
    required this.title,
    required this.desc,
    required this.image,
    required this.coursesCount,
    required this.whatYouLearn,
    required this.learningProgramsCourses,
    required this.doctors,
  });
  factory LearningProgramsModel.fromJson(Map<String, dynamic> json) =>
      LearningProgramsModel(
        title: json['title'],
        desc: json['desc'],
        image: json['image'],
        coursesCount: json['courses_count'],
        whatYouLearn:
            (json['what_you_learn'] as List)
                .map((e) => WhatYouLearn.fromJson(e))
                .toList(),
        learningProgramsCourses:
            (json['learning_programs_courses'] as List)
                .map((e) => LearningProgramsCourses.fromJson(e))
                .toList(),
        doctors:
            (json['doctors'] as List).map((e) => Doctors.fromJson(e)).toList(),
      );
}
