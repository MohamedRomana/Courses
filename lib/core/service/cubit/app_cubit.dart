import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:unicourse/core/models/courses.dart';
import 'package:unicourse/core/models/learning_programs_model.dart';
import '../../../generated/locale_keys.g.dart';
import '../../../screens/home_layout/home/home.dart';
import '../../../screens/home_layout/my_courses/my_courses.dart';
import '../../../screens/home_layout/profile/profile.dart';
import '../../../screens/home_layout/search/search.dart';
import 'package:http/http.dart' as http;
import '../../cache/cache_helper.dart';
import '../../constants/contsants.dart';
part 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(AppInitial());

  static AppCubit get(context) => BlocProvider.of(context);

  int bottomNavIndex = 0;
  List<Widget> bottomNavScreens = [
    const Home(),
    const Search(),
    const MyCourses(),
    const Profile(),
  ];

  void changebottomNavIndex(index) async {
    bottomNavIndex = index;
    emit(ChangeBottomNav());
  }

  bool hasRead = false;
  void readDesc() {
    hasRead = !hasRead;
    emit(ChangeIndex());
  }

  int openList = -1;
  void openDesc({required int index}) {
    openList = index;
    emit(ChangeIndex());
  }

  int paymentIndex = -1;
  void changePayment({required int index}) {
    paymentIndex = index;
    emit(ChangeIndex());
  }

  bool isSecureLogIn = true;
  isSecureLogInIcon(isSecuree) {
    isSecureLogIn = isSecuree;
    emit(IsSecureIcon());
  }

  List<File> profileImage = [];
  Future<void> getProfileImage(BuildContext context) async {
    final picker = ImagePicker();
    final int? pickedOption = await showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(LocaleKeys.select_image_source.tr()),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text("Camera"),
                onTap: () => Navigator.pop(context, 1),
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text("Gallery"),
                onTap: () => Navigator.pop(context, 2),
              ),
            ],
          ),
        );
      },
    );

    if (pickedOption == null) return;

    XFile? pickedImage;

    if (pickedOption == 1) {
      pickedImage = await picker.pickImage(source: ImageSource.camera);
    } else if (pickedOption == 2) {
      final pickedImages = await picker.pickMultiImage();
      if (pickedImages.isNotEmpty) {
        pickedImage = pickedImages.first;
      }
    }

    if (pickedImage != null) {
      profileImage = [File(pickedImage.path)];
      emit(ChooseImageSuccess());
    }
  }

  void removeProfileImage() {
    profileImage.clear();
    emit(RemoveImageSuccess());
  }

  String? currentVideoUrl;
  String? currentVideoTitle;

  void changeVideoUrl(String url, String title) {
    currentVideoUrl = url;
    currentVideoTitle = title;
    emit(ChangeIndex());
  }

  Map userModel = {};
  Future getUserData() async {
    emit(GetUserDataLoading());
    try {
      http.Response response = await http
          .post(
            Uri.parse("${baseUrl}api/show-user"),
            body: {
              "lang": CacheHelper.getLang(),
              "user_id": CacheHelper.getUserId(),
            },
          )
          .timeout(const Duration(seconds: 15));
      Map<String, dynamic> data = jsonDecode(response.body);

      if (data["key"] == 1) {
        userModel = data["data"];
        debugPrint(userModel.toString());
        emit(GetUserDataSuccess());
      } else {
        emit(GetUserDataFailure(error: data["msg"]));
      }
    } catch (error) {
      // Network/DNS/timeout — don't crash with an unhandled exception.
      debugPrint("getUserData failed: $error");
      emit(GetUserDataFailure(error: error.toString()));
    }
  }

  String? profileImageUrl;
  Future uploadProfileImage() async {
    emit(UploadImagesLoading());
    final request = http.MultipartRequest(
      'POST',
      Uri.parse("${baseUrl}api/upload-image"),
    );
    request.fields['lang'] = CacheHelper.getLang();

    for (var image in profileImage) {
      var stream = http.ByteStream(image.openRead());
      var length = await image.length();
      var multipartFile = http.MultipartFile(
        'image',
        stream,
        length,
        filename: image.path.split('/').last,
      );
      request.files.add(multipartFile);
    }
    final response = await request.send();
    final responseBody = await response.stream.bytesToString();

    Map<String, dynamic> data = jsonDecode(responseBody);
    profileImageUrl = data["app_url"];
    debugPrint("imageUrl is $profileImageUrl");

    if (data["key"] == 1) {
      emit(UploadImagesSuccess());
    } else {
      emit(UploadImagesFailure());
    }
  }

  Future updateProfile({
    required String firstName,
    required String phone,
    required String email,
    required String password,
  }) async {
    if (profileImage.isNotEmpty) {
      await uploadProfileImage();
    }
    emit(UpdateProfileLoading());
    try {
      http.Response response = await http
          .post(
            Uri.parse("${baseUrl}api/update-user"),
            body: {
              "lang": CacheHelper.getLang(),
              "user_id": CacheHelper.getUserId(),
              "first_name": firstName,
              "phone": phone,
              "email": email,
              "password": password,
              if (profileImage.isNotEmpty) "avatar": profileImageUrl,
            },
          )
          .timeout(const Duration(milliseconds: 8000));

      if (response.statusCode == 500) {
        emit(ServerError());
      } else {
        Map<String, dynamic> data = jsonDecode(response.body);
        debugPrint(data.toString());

        if (data["key"] == 1) {
          emit(UpdateProfileSuccess(message: data["msg"]));
          profileImage.clear();
          profileImageUrl = null;
          getUserData();
        } else {
          debugPrint(data["msg"]);
          emit(UpdateProfileFailure(error: data["msg"]));
        }
      }
    } catch (error) {
      if (error is TimeoutException) {
        debugPrint("Request timed out");
        emit(Timeoutt());
      } else {
        debugPrint(error.toString());
        emit(UpdateProfileFailure(error: error.toString()));
      }
    }
  }

  Future contactUs({
    required String name,
    required String email,
    required String message,
  }) async {
    emit(ContactUsLoading());
    try {
      http.Response response = await http
          .post(
            Uri.parse("${baseUrl}api/contact-us"),
            body: {
              "lang": CacheHelper.getLang(),
              "name": name,
              "email": email,
              "message": message,
            },
          )
          .timeout(const Duration(milliseconds: 8000));

      if (response.statusCode == 500) {
        emit(ServerError());
      } else {
        Map<String, dynamic> data = jsonDecode(response.body);
        debugPrint(data.toString());

        if (data["key"] == 1) {
          emit(ContactUsSuccess(message: data["msg"]));
        } else {
          emit(ContactUsFailure(error: data["msg"]));
        }
      }
    } catch (error) {
      if (error is TimeoutException) {
        debugPrint("Request timed out");
        emit(Timeoutt());
      }
    }
  }

  List<Course> courses = [
    Course(
      youTubeLink:
          "https://www.youtube.com/watch?v=h3VCQjyaLws&list=PLuXY3ddo_8nzrO74UeZQVZOb5-wIS6krJ",
      image: "assets/img/doctor.jpg",
      title: "دورة تعليم بايثون من الصفر حتى الاحتراف",
      name: "اسلام هشام محفوظ",
      price: 600,
      time: 5,
      lang: 'العربيه',
      type: 'التكنولوجيا والتطوير',
      desc:
          "في هذه الدورة العملية، ستتعلم أساسيات لغة بايثون، إحدى أشهر وأسهل لغات البرمجة، والمستخدمة في مجالات متعددة مثل تطوير الويب، تحليل البيانات، الذكاء الاصطناعي، والأتمتة.",
      doctorDesc: 'مهندس برمجه',
      videosNum: 51,
      image2: 'assets/img/python.jpg',
      rate: 0.0,
      freeVideos: [
        FreeVideos(
          url:
              "https://www.youtube.com/watch?v=h3VCQjyaLws&list=PLuXY3ddo_8nzrO74UeZQVZOb5-wIS6krJ",
          title:
              'شرح بايثون - تعلم لغة بايثون و اهمية تعلم البرمجة بلغة بايثون؟',
          time: '7 دقايق 1 ثانيه',
        ),
        FreeVideos(
          url:
              "https://www.youtube.com/watch?v=t-bCLbmgesI&list=PLuXY3ddo_8nzrO74UeZQVZOb5-wIS6krJ&index=2",
          title:
              '[ مقدمة كورس تعلم بايثون و اجابة الاسئلة الشائعة - [ تعلم بايثون بالعربي',
          time: '14 دقايق 23 ثانيه',
        ),
        FreeVideos(
          url:
              "https://www.youtube.com/watch?v=WTRKeSoynKI&list=PLuXY3ddo_8nzrO74UeZQVZOb5-wIS6krJ&index=3",
          title: '[#00 تثبيت و تنصيب بايثون - [ تعلم بايثون بالعربي',
          time: '8 دقايق 4 ثانيه',
        ),
        FreeVideos(
          url:
              "https://www.youtube.com/watch?v=SMyzYOPGeD8&list=PLuXY3ddo_8nzrO74UeZQVZOb5-wIS6krJ&index=4",
          title:
              '{Install PyCharm} - [#01 تنصيب بايشارم - [ تعلم بايثون بالعربي',
          time: '2 دقايق 53 ثانيه',
        ),
        FreeVideos(
          url:
              "https://www.youtube.com/watch?v=oMMW_Cx0qW8&list=PLuXY3ddo_8nzrO74UeZQVZOb5-wIS6krJ&index=5",
          title: '[#02 كتابة اول سطر كود في بايثون - [ تعلم بايثون بالعربي',
          time: '1 دقايق 36 ثانيه',
        ),
      ],
      payVideos: [
        PayVideos(
          title:
              'شرح بايثون - تعلم لغة بايثون و اهمية تعلم البرمجة بلغة بايثون؟',
          payVideos2: [
            PayVideos2(
              url:
                  'https://www.youtube.com/watch?v=Vl1mHJMrEnk&list=PLuXY3ddo_8nzrO74UeZQVZOb5-wIS6krJ&index=6',
              title: '[#03 بناء اول برنامج في بايثون - [ تعلم بايثون بالعربي',
              time: '3 دقايق 1 ثانيه',
            ),
            PayVideos2(
              url:
                  'https://www.youtube.com/watch?v=gQxch0k9B0E&list=PLuXY3ddo_8nzrO74UeZQVZOb5-wIS6krJ&index=7',
              title:
                  '{Python Variables} - [#04 المتغيرات في بايثون - [ تعلم بايثون بالعربي',
              time: '10 دقايق 30 ثانيه',
            ),
            PayVideos2(
              url:
                  'https://www.youtube.com/watch?v=5O_m0IGwQLw&list=PLuXY3ddo_8nzrO74UeZQVZOb5-wIS6krJ&index=8',
              title:
                  '{Python Strings} - [#05 السلاسل في بايثون - [ تعلم بايثون بالعربي',
              time: '10 دقايق 33 ثانيه',
            ),
          ],
        ),
        PayVideos(
          title:
              'اهم المفاهيم في بايثون - تعلم لغة بايثون و اهمية تعلم البرمجة بلغة بايثون؟',
          payVideos2: [
            PayVideos2(
              url:
                  'https://www.youtube.com/watch?v=HjfiVp0L3LI&list=PLuXY3ddo_8nzrO74UeZQVZOb5-wIS6krJ&index=9',
              title:
                  '{Python Numbers} - [#06 الارقام في بايثون - [ تعلم بايثون بالعربي',
              time: '5 دقايق 35 ثانيه',
            ),
            PayVideos2(
              url:
                  'https://www.youtube.com/watch?v=bWE45B_O9Lk&list=PLuXY3ddo_8nzrO74UeZQVZOb5-wIS6krJ&index=10',
              title:
                  '{Python Inputs} - [#07 المدخلات في بايثون - [ تعلم بايثون بالعربي',
              time: '3 دقايق 28 ثانيه',
            ),
            PayVideos2(
              url:
                  'https://www.youtube.com/watch?v=hYC0ObXfGjs&list=PLuXY3ddo_8nzrO74UeZQVZOb5-wIS6krJ&index=11',
              title:
                  '{Build Calculator in Python} - [#08 بناء اله حاسبه في بايثون - [ تعلم بايثون بالعربي',
              time: '4 دقايق 14 ثانيه',
            ),
          ],
        ),
      ],
    ),
    Course(
      youTubeLink: "https://www.youtube.com/watch?v=xcg9qq6SZ0w",
      image: "assets/img/elzero.jpg",
      title: "دورة تعليم PHP",
      name: "اسامه الزيرو",
      price: 450,
      time: 6,
      lang: 'العربيه',
      type: 'التكنولوجيا والتطوير',
      desc:
          "هل حلمت يومًا ببناء موقع إلكتروني كامل بيدك؟ مع دورة PHP للمبتدئين، ستنتقل من لا شيء إلى برمجة صفحات ويب ديناميكية وتفاعلية بكل ثقة! 🌐 ما هي PHP؟ PHP هي لغة برمجة مخصصة لتطوير مواقع الويب، وتُستخدم في ملايين المواقع حول العالم، مثل فيسبوك وWordPress!تعلّمها يعني أنك تضع قدمك الأولى في عالم تطوير الويب الاحترافي",
      doctorDesc: 'مهندس برمجه',
      videosNum: 105,
      image2: 'assets/img/php.png',
      rate: 0.0,
      freeVideos: [
        FreeVideos(
          url:
              "https://www.youtube.com/watch?v=xcg9qq6SZ0w&list=PLDoPjvoNmBAy41u35AqJUrI-H83DObUDq",
          title:
              'Learn PHP 8 In Arabic 2022 - #001 - Introduction And Important Information',
          time: '7 دقايق 28 ثانيه',
        ),
        FreeVideos(
          url:
              "https://www.youtube.com/watch?v=nQHqdi4gqh4&list=PLDoPjvoNmBAy41u35AqJUrI-H83DObUDq&index=2",
          title:
              "Learn PHP 8 In Arabic 2022 - #002 - What Is New And How To Study The Course",
          time: '6 دقايق 24 ثانيه',
        ),
        FreeVideos(
          url:
              "https://www.youtube.com/watch?v=79MQ7j06IOM&list=PLDoPjvoNmBAy41u35AqJUrI-H83DObUDq&index=3",
          title:
              "Learn PHP 8 In Arabic 2022 - #003 - Install PHP And Prepare Environment To Work",
          time: '11 دقايق 47 ثانيه',
        ),
        FreeVideos(
          url:
              "https://www.youtube.com/watch?v=tMczMZ6irB8&list=PLDoPjvoNmBAy41u35AqJUrI-H83DObUDq&index=4",
          title:
              "Learn PHP 8 In Arabic 2022 - #004 - PHP Tags And Instructions Separation",
          time: '9 دقايق 11 ثانيه',
        ),
        FreeVideos(
          url:
              "https://www.youtube.com/watch?v=slVIpRJZ1_s&list=PLDoPjvoNmBAy41u35AqJUrI-H83DObUDq&index=5",
          title:
              "Learn PHP 8 In Arabic 2022 - #005 - Comments And Best Practices",
          time: '5 دقايق 4 ثانيه',
        ),
      ],
      payVideos: [
        PayVideos(
          title: "شرح PHP - تعلم لغة PHP و اهمية تعلم البرمجة بلغة PHP ",
          payVideos2: [
            PayVideos2(
              url:
                  "https://www.youtube.com/watch?v=C5VjHQSdhOM&list=PLDoPjvoNmBAy41u35AqJUrI-H83DObUDq&index=6",
              title:
                  "Learn PHP 8 In Arabic 2022 - #006 - Introduction To Data Types",
              time: '8 دقايق 43 ثانيه',
            ),
            PayVideos2(
              url:
                  "https://www.youtube.com/watch?v=rHlzFVkaR0E&list=PLDoPjvoNmBAy41u35AqJUrI-H83DObUDq&index=7",
              title:
                  "Learn PHP 8 In Arabic 2022 - #007 - Type Juggling And Automatic Type Conversion",
              time: '6 دقايق 18 ثانيه',
            ),
            PayVideos2(
              url:
                  "https://www.youtube.com/watch?v=DAsfctr5agc&list=PLDoPjvoNmBAy41u35AqJUrI-H83DObUDq&index=8",
              title: "Learn PHP 8 In Arabic 2022 - #008 - Type Casting",
              time: '5 دقايق 45 ثانيه',
            ),
          ],
        ),
        PayVideos(
          title: "اهم مفاهيم PHP - تعلم لغة PHP و اهمية تعلم البرمجة بلغة PHP",
          payVideos2: [
            PayVideos2(
              url:
                  "https://www.youtube.com/watch?v=Jm9l3zXjIgc&list=PLDoPjvoNmBAy41u35AqJUrI-H83DObUDq&index=9",
              title:
                  "Learn PHP 8 In Arabic 2022 - #009 - Boolean And Converting To Boolean",
              time: '3 دقايق 55 ثانيه',
            ),
            PayVideos2(
              url:
                  "https://www.youtube.com/watch?v=F9LgqsGDQo8&list=PLDoPjvoNmBAy41u35AqJUrI-H83DObUDq&index=10",
              title: "Learn PHP 8 In Arabic 2022 - #010 - String And Escaping",
              time: '6 دقايق 36 ثانيه',
            ),
            PayVideos2(
              url:
                  "https://www.youtube.com/watch?v=aX_3F-8_zqI&list=PLDoPjvoNmBAy41u35AqJUrI-H83DObUDq&index=11",
              title: "Learn PHP 8 In Arabic 2022 - #011 - Heredoc And Nowdoc",
              time: '9 دقايق 10 ثانيه',
            ),
          ],
        ),
      ],
    ),
    Course(
      youTubeLink:
          "https://www.youtube.com/watch?v=AuzjFFjirBc&list=PLGVaNq6mHinjCPki-3xraQdGWKVz7PhgI&index=1",
      image: "assets/img/tharwatsamy.jpg",
      title: "دورة تعليم Dart",
      name: "ثروت سامي",
      price: 250,
      time: 5,
      lang: 'العربيه',
      type: 'التكنولوجيا والتطوير',
      desc:
          'هل ترغب بتطوير تطبيقات موبايل عالية الأداء بواجهة مذهلة؟ رحلتك تبدأ من هنا، مع تعلّم لغة Dart – اللبنة الأساسية لإتقان Flutter وبناء تطبيقات iOS وAndroid من كود واحد! متطلباتها وهتستفاد ايه ف الاخر',
      doctorDesc: 'مهندس برمجه',
      videosNum: 57,
      image2: 'assets/img/dart.jpg',
      rate: 0.0,
      freeVideos: [
        FreeVideos(
          url:
              "https://www.youtube.com/watch?v=AuzjFFjirBc&list=PLGVaNq6mHinjCPki-3xraQdGWKVz7PhgI",
          title:
              'Best Flutter Course for beginners -course content #01 | بالعربي',
          time: '2 دقايق 57 ثانيه',
        ),
        FreeVideos(
          url:
              "https://www.youtube.com/watch?v=YfSq7DiM9dU&list=PLGVaNq6mHinjCPki-3xraQdGWKVz7PhgI&index=2",
          title:
              "Best Flutter Course for beginners -Introduction to programming #02 | بالعربي",
          time: '11 دقايق 57 ثانيه',
        ),
        FreeVideos(
          url:
              "https://www.youtube.com/watch?v=yvwDWIIc6JI&list=PLGVaNq6mHinjCPki-3xraQdGWKVz7PhgI&index=3",
          title:
              "Best Flutter Course for beginners -Difference between native and cross platform #03 | بالعربي",
          time: '9 دقايق 42 ثانيه',
        ),
        FreeVideos(
          url:
              "https://www.youtube.com/watch?v=3M8gyN_Xq7E&list=PLGVaNq6mHinjCPki-3xraQdGWKVz7PhgI&index=4",
          title:
              "Best Flutter Course for beginners -Environment setup #04 | بالعربي",
          time: '13 دقايق 43 ثانيه',
        ),
        FreeVideos(
          url:
              "https://www.youtube.com/watch?v=5GEp6RXlwbc&list=PLGVaNq6mHinjCPki-3xraQdGWKVz7PhgI&index=5",
          title:
              "Best Flutter Course for beginners -First Dart program #05 | بالعربي",
          time: '8 دقايق 46 ثانيه',
        ),
      ],
      payVideos: [
        PayVideos(
          title: "شرح Dart - تعلم لغة Dart و اهمية تعلم البرمجة بلغة Dart ",
          payVideos2: [
            PayVideos2(
              url:
                  "https://www.youtube.com/watch?v=xAnmb0vRxWY&list=PLGVaNq6mHinjCPki-3xraQdGWKVz7PhgI&index=6",
              title:
                  "Best Flutter Course for beginners -Data types and variables #06 | بالعربي",
              time: '11 دقايق 58 ثانيه',
            ),
            PayVideos2(
              url:
                  "https://www.youtube.com/watch?v=HavRgxbTLQI&list=PLGVaNq6mHinjCPki-3xraQdGWKVz7PhgI&index=7",
              title:
                  "Best Flutter Course for beginners -Numeric datatypes #07 | بالعربي",
              time: '4 دقايق 22 ثانيه',
            ),
            PayVideos2(
              url:
                  "https://www.youtube.com/watch?v=zdUMuH6sGBk&list=PLGVaNq6mHinjCPki-3xraQdGWKVz7PhgI&index=8",
              title:
                  "Best Flutter Course for beginners -Import statement #08 | بالعربي",
              time: '4 دقايق 3 ثانيه',
            ),
          ],
        ),
        PayVideos(
          title:
              "اهم مفاهيم Dart - تعلم لغة Dart و اهمية تعلم البرمجة بلغة Dart",
          payVideos2: [
            PayVideos2(
              url:
                  "https://www.youtube.com/watch?v=Zcnx73kmpqY&list=PLGVaNq6mHinjCPki-3xraQdGWKVz7PhgI&index=9",
              title:
                  "Best Flutter Course for beginners -User input #09 | بالعربي",
              time: '7 دقايق 48 ثانيه',
            ),
            PayVideos2(
              url:
                  "https://www.youtube.com/watch?v=YQeC30cemtY&list=PLGVaNq6mHinjCPki-3xraQdGWKVz7PhgI&index=10",
              title:
                  "Best Flutter Course for beginners -Operators in dart #10 | بالعربي",
              time: '5 دقايق 56 ثانيه',
            ),
            PayVideos2(
              url:
                  "https://www.youtube.com/watch?v=UXaNhNjz7DY&list=PLGVaNq6mHinjCPki-3xraQdGWKVz7PhgI&index=11",
              title:
                  "Best Flutter Course for beginners - Comments #11 | بالعربي",
              time: '1 دقايق 27 ثانيه',
            ),
          ],
        ),
      ],
    ),
    Course(
      youTubeLink:
          "https://www.youtube.com/watch?v=z1FdInL8sjg&list=PLCInYL3l2AajFAiw4s1U4QbGszcQ-rAb3",
      image: "assets/img/adelnseem.jpg",
      title: "دورة تعليم C++",
      name: "عادل نسيم",
      price: 800,
      time: 5,
      lang: 'العربيه',
      type: 'التكنولوجيا والتطوير',
      desc:
          "هل تبحث عن لغة برمجة تمنحك فهمًا عميقًا لأساسيات البرمجة وتفتح لك أبواب مجالات مثل برمجة الألعاب، أنظمة التشغيل، والبرمجيات عالية الأداء؟ دورة C++ للمبتدئين هي انطلاقتك المثالية نحو عالم البرمجة القوية والاحترافية!",
      doctorDesc: 'مهندس برمجه',
      videosNum: 38,
      image2: 'assets/img/cplusplus.jpg',
      rate: 0.0,
      freeVideos: [
        FreeVideos(
          url:
              "https://www.youtube.com/watch?v=z1FdInL8sjg&list=PLCInYL3l2AajFAiw4s1U4QbGszcQ-rAb3",
          title: '#01 [c++] - Introduction',
          time: '7 دقايق 11 ثانيه',
        ),
        FreeVideos(
          url:
              "https://www.youtube.com/watch?v=xo1R1nYM4aw&list=PLCInYL3l2AajFAiw4s1U4QbGszcQ-rAb3&index=2",
          title: "#02 [c++] - First project in c++",
          time: '11 دقايق 1 ثانيه',
        ),
        FreeVideos(
          url:
              "https://www.youtube.com/watch?v=pw7rTydaSYs&list=PLCInYL3l2AajFAiw4s1U4QbGszcQ-rAb3&index=3",
          title: "#03 [c++] - Escape Sequence",
          time: '9 دقايق 32 ثانيه',
        ),
        FreeVideos(
          url:
              "https://www.youtube.com/watch?v=FBjOHTuOIqo&list=PLCInYL3l2AajFAiw4s1U4QbGszcQ-rAb3&index=4",
          title: "#04 [c++] - Variables vs Data type",
          time: '16 دقايق 37 ثانيه',
        ),
        FreeVideos(
          url:
              "https://www.youtube.com/watch?v=0rYYaXlEiAY&list=PLCInYL3l2AajFAiw4s1U4QbGszcQ-rAb3&index=5",
          title: "#05 [c++] - Priorities&Calculations in c++",
          time: '19 دقايق 56 ثانيه',
        ),
      ],
      payVideos: [
        PayVideos(
          title: "شرح C++ - تعلم لغة Dart و اهمية تعلم البرمجة بلغة C++ ",
          payVideos2: [
            PayVideos2(
              url:
                  "https://www.youtube.com/watch?v=UpBYeNTwgbs&list=PLCInYL3l2AajFAiw4s1U4QbGszcQ-rAb3&index=6",
              title: "#06 [c++] - Basic Arithmetic&Casting",
              time: '16 دقايق 38 ثانيه',
            ),
            PayVideos2(
              url:
                  "https://www.youtube.com/watch?v=6XjgNR5Cw48&list=PLCInYL3l2AajFAiw4s1U4QbGszcQ-rAb3&index=7",
              title: "#07 [c++] - Prefix and Postfix&Compound assignment",
              time: '14 دقايق 46 ثانيه',
            ),
            PayVideos2(
              url:
                  "https://www.youtube.com/watch?v=Pkl5iFCNNs4&list=PLCInYL3l2AajFAiw4s1U4QbGszcQ-rAb3&index=8",
              title: "#08 [c++] - Variable Scope (Local vs Global)",
              time: '10 دقايق 8 ثانيه',
            ),
          ],
        ),
        PayVideos(
          title: "اهم مفاهيم C++ - تعلم لغة Dart و اهمية تعلم البرمجة بلغة C++",
          payVideos2: [
            PayVideos2(
              url:
                  "https://www.youtube.com/watch?v=F56Bo4I0GhA&list=PLCInYL3l2AajFAiw4s1U4QbGszcQ-rAb3&index=9",
              title: "#09 [c++] - Selection Statement(if-if else -if else if)",
              time: '31 دقايق 35 ثانيه',
            ),
            PayVideos2(
              url:
                  "https://www.youtube.com/watch?v=taov2H_-nlU&list=PLCInYL3l2AajFAiw4s1U4QbGszcQ-rAb3&index=10",
              title: "#10 [c++] - Logical Operators(AND,OR,NOT) / Shortest if",
              time: '18 دقايق 7 ثانيه',
            ),
            PayVideos2(
              url:
                  "https://www.youtube.com/watch?v=-MTeqw7gZf0&list=PLCInYL3l2AajFAiw4s1U4QbGszcQ-rAb3&index=11",
              title: "#11 [c++] - Switch Statement",
              time: '14 دقايق 26 ثانيه',
            ),
          ],
        ),
      ],
    ),
  ];
  List<Course> filteredCourses = [
    Course(
      youTubeLink:
          "https://www.youtube.com/watch?v=h3VCQjyaLws&list=PLuXY3ddo_8nzrO74UeZQVZOb5-wIS6krJ",
      image: "assets/img/doctor.jpg",
      title: "دورة تعليم بايثون من الصفر حتى الاحتراف",
      name: "اسلام هشام محفوظ",
      price: 600,
      time: 5,
      lang: 'العربيه',
      type: 'التكنولوجيا والتطوير',
      desc:
          "في هذه الدورة العملية، ستتعلم أساسيات لغة بايثون، إحدى أشهر وأسهل لغات البرمجة، والمستخدمة في مجالات متعددة مثل تطوير الويب، تحليل البيانات، الذكاء الاصطناعي، والأتمتة.",
      doctorDesc: 'مهندس برمجه',
      videosNum: 51,
      image2: 'assets/img/python.jpg',
      rate: 0.0,
      freeVideos: [
        FreeVideos(
          url:
              "https://www.youtube.com/watch?v=h3VCQjyaLws&list=PLuXY3ddo_8nzrO74UeZQVZOb5-wIS6krJ",
          title:
              'شرح بايثون - تعلم لغة بايثون و اهمية تعلم البرمجة بلغة بايثون؟',
          time: '7 دقايق 1 ثانيه',
        ),
        FreeVideos(
          url:
              "https://www.youtube.com/watch?v=t-bCLbmgesI&list=PLuXY3ddo_8nzrO74UeZQVZOb5-wIS6krJ&index=2",
          title:
              '[ مقدمة كورس تعلم بايثون و اجابة الاسئلة الشائعة - [ تعلم بايثون بالعربي',
          time: '14 دقايق 23 ثانيه',
        ),
        FreeVideos(
          url:
              "https://www.youtube.com/watch?v=WTRKeSoynKI&list=PLuXY3ddo_8nzrO74UeZQVZOb5-wIS6krJ&index=3",
          title: '[#00 تثبيت و تنصيب بايثون - [ تعلم بايثون بالعربي',
          time: '8 دقايق 4 ثانيه',
        ),
        FreeVideos(
          url:
              "https://www.youtube.com/watch?v=SMyzYOPGeD8&list=PLuXY3ddo_8nzrO74UeZQVZOb5-wIS6krJ&index=4",
          title:
              '{Install PyCharm} - [#01 تنصيب بايشارم - [ تعلم بايثون بالعربي',
          time: '2 دقايق 53 ثانيه',
        ),
        FreeVideos(
          url:
              "https://www.youtube.com/watch?v=oMMW_Cx0qW8&list=PLuXY3ddo_8nzrO74UeZQVZOb5-wIS6krJ&index=5",
          title: '[#02 كتابة اول سطر كود في بايثون - [ تعلم بايثون بالعربي',
          time: '1 دقايق 36 ثانيه',
        ),
      ],
      payVideos: [
        PayVideos(
          title:
              'شرح بايثون - تعلم لغة بايثون و اهمية تعلم البرمجة بلغة بايثون؟',
          payVideos2: [
            PayVideos2(
              url:
                  'https://www.youtube.com/watch?v=Vl1mHJMrEnk&list=PLuXY3ddo_8nzrO74UeZQVZOb5-wIS6krJ&index=6',
              title: '[#03 بناء اول برنامج في بايثون - [ تعلم بايثون بالعربي',
              time: '3 دقايق 1 ثانيه',
            ),
            PayVideos2(
              url:
                  'https://www.youtube.com/watch?v=gQxch0k9B0E&list=PLuXY3ddo_8nzrO74UeZQVZOb5-wIS6krJ&index=7',
              title:
                  '{Python Variables} - [#04 المتغيرات في بايثون - [ تعلم بايثون بالعربي',
              time: '10 دقايق 30 ثانيه',
            ),
            PayVideos2(
              url:
                  'https://www.youtube.com/watch?v=5O_m0IGwQLw&list=PLuXY3ddo_8nzrO74UeZQVZOb5-wIS6krJ&index=8',
              title:
                  '{Python Strings} - [#05 السلاسل في بايثون - [ تعلم بايثون بالعربي',
              time: '10 دقايق 33 ثانيه',
            ),
          ],
        ),
        PayVideos(
          title:
              'اهم المفاهيم في بايثون - تعلم لغة بايثون و اهمية تعلم البرمجة بلغة بايثون؟',
          payVideos2: [
            PayVideos2(
              url:
                  'https://www.youtube.com/watch?v=HjfiVp0L3LI&list=PLuXY3ddo_8nzrO74UeZQVZOb5-wIS6krJ&index=9',
              title:
                  '{Python Numbers} - [#06 الارقام في بايثون - [ تعلم بايثون بالعربي',
              time: '5 دقايق 35 ثانيه',
            ),
            PayVideos2(
              url:
                  'https://www.youtube.com/watch?v=bWE45B_O9Lk&list=PLuXY3ddo_8nzrO74UeZQVZOb5-wIS6krJ&index=10',
              title:
                  '{Python Inputs} - [#07 المدخلات في بايثون - [ تعلم بايثون بالعربي',
              time: '3 دقايق 28 ثانيه',
            ),
            PayVideos2(
              url:
                  'https://www.youtube.com/watch?v=hYC0ObXfGjs&list=PLuXY3ddo_8nzrO74UeZQVZOb5-wIS6krJ&index=11',
              title:
                  '{Build Calculator in Python} - [#08 بناء اله حاسبه في بايثون - [ تعلم بايثون بالعربي',
              time: '4 دقايق 14 ثانيه',
            ),
          ],
        ),
      ],
    ),
    Course(
      youTubeLink: "https://www.youtube.com/watch?v=xcg9qq6SZ0w",
      image: "assets/img/elzero.jpg",
      title: "دورة تعليم PHP",
      name: "اسامه الزيرو",
      price: 450,
      time: 6,
      lang: 'العربيه',
      type: 'التكنولوجيا والتطوير',
      desc:
          "هل حلمت يومًا ببناء موقع إلكتروني كامل بيدك؟ مع دورة PHP للمبتدئين، ستنتقل من لا شيء إلى برمجة صفحات ويب ديناميكية وتفاعلية بكل ثقة! 🌐 ما هي PHP؟ PHP هي لغة برمجة مخصصة لتطوير مواقع الويب، وتُستخدم في ملايين المواقع حول العالم، مثل فيسبوك وWordPress!تعلّمها يعني أنك تضع قدمك الأولى في عالم تطوير الويب الاحترافي",
      doctorDesc: 'مهندس برمجه',
      videosNum: 105,
      image2: 'assets/img/php.png',
      rate: 0.0,
      freeVideos: [
        FreeVideos(
          url:
              "https://www.youtube.com/watch?v=xcg9qq6SZ0w&list=PLDoPjvoNmBAy41u35AqJUrI-H83DObUDq",
          title:
              'Learn PHP 8 In Arabic 2022 - #001 - Introduction And Important Information',
          time: '7 دقايق 28 ثانيه',
        ),
        FreeVideos(
          url:
              "https://www.youtube.com/watch?v=nQHqdi4gqh4&list=PLDoPjvoNmBAy41u35AqJUrI-H83DObUDq&index=2",
          title:
              "Learn PHP 8 In Arabic 2022 - #002 - What Is New And How To Study The Course",
          time: '6 دقايق 24 ثانيه',
        ),
        FreeVideos(
          url:
              "https://www.youtube.com/watch?v=79MQ7j06IOM&list=PLDoPjvoNmBAy41u35AqJUrI-H83DObUDq&index=3",
          title:
              "Learn PHP 8 In Arabic 2022 - #003 - Install PHP And Prepare Environment To Work",
          time: '11 دقايق 47 ثانيه',
        ),
        FreeVideos(
          url:
              "https://www.youtube.com/watch?v=tMczMZ6irB8&list=PLDoPjvoNmBAy41u35AqJUrI-H83DObUDq&index=4",
          title:
              "Learn PHP 8 In Arabic 2022 - #004 - PHP Tags And Instructions Separation",
          time: '9 دقايق 11 ثانيه',
        ),
        FreeVideos(
          url:
              "https://www.youtube.com/watch?v=slVIpRJZ1_s&list=PLDoPjvoNmBAy41u35AqJUrI-H83DObUDq&index=5",
          title:
              "Learn PHP 8 In Arabic 2022 - #005 - Comments And Best Practices",
          time: '5 دقايق 4 ثانيه',
        ),
      ],
      payVideos: [
        PayVideos(
          title: "شرح PHP - تعلم لغة PHP و اهمية تعلم البرمجة بلغة PHP ",
          payVideos2: [
            PayVideos2(
              url:
                  "https://www.youtube.com/watch?v=C5VjHQSdhOM&list=PLDoPjvoNmBAy41u35AqJUrI-H83DObUDq&index=6",
              title:
                  "Learn PHP 8 In Arabic 2022 - #006 - Introduction To Data Types",
              time: '8 دقايق 43 ثانيه',
            ),
            PayVideos2(
              url:
                  "https://www.youtube.com/watch?v=rHlzFVkaR0E&list=PLDoPjvoNmBAy41u35AqJUrI-H83DObUDq&index=7",
              title:
                  "Learn PHP 8 In Arabic 2022 - #007 - Type Juggling And Automatic Type Conversion",
              time: '6 دقايق 18 ثانيه',
            ),
            PayVideos2(
              url:
                  "https://www.youtube.com/watch?v=DAsfctr5agc&list=PLDoPjvoNmBAy41u35AqJUrI-H83DObUDq&index=8",
              title: "Learn PHP 8 In Arabic 2022 - #008 - Type Casting",
              time: '5 دقايق 45 ثانيه',
            ),
          ],
        ),
        PayVideos(
          title: "اهم مفاهيم PHP - تعلم لغة PHP و اهمية تعلم البرمجة بلغة PHP",
          payVideos2: [
            PayVideos2(
              url:
                  "https://www.youtube.com/watch?v=Jm9l3zXjIgc&list=PLDoPjvoNmBAy41u35AqJUrI-H83DObUDq&index=9",
              title:
                  "Learn PHP 8 In Arabic 2022 - #009 - Boolean And Converting To Boolean",
              time: '3 دقايق 55 ثانيه',
            ),
            PayVideos2(
              url:
                  "https://www.youtube.com/watch?v=F9LgqsGDQo8&list=PLDoPjvoNmBAy41u35AqJUrI-H83DObUDq&index=10",
              title: "Learn PHP 8 In Arabic 2022 - #010 - String And Escaping",
              time: '6 دقايق 36 ثانيه',
            ),
            PayVideos2(
              url:
                  "https://www.youtube.com/watch?v=aX_3F-8_zqI&list=PLDoPjvoNmBAy41u35AqJUrI-H83DObUDq&index=11",
              title: "Learn PHP 8 In Arabic 2022 - #011 - Heredoc And Nowdoc",
              time: '9 دقايق 10 ثانيه',
            ),
          ],
        ),
      ],
    ),
    Course(
      youTubeLink:
          "https://www.youtube.com/watch?v=AuzjFFjirBc&list=PLGVaNq6mHinjCPki-3xraQdGWKVz7PhgI&index=1",
      image: "assets/img/tharwatsamy.jpg",
      title: "دورة تعليم Dart",
      name: "ثروت سامي",
      price: 250,
      time: 5,
      lang: 'العربيه',
      type: 'التكنولوجيا والتطوير',
      desc:
          'هل ترغب بتطوير تطبيقات موبايل عالية الأداء بواجهة مذهلة؟ رحلتك تبدأ من هنا، مع تعلّم لغة Dart – اللبنة الأساسية لإتقان Flutter وبناء تطبيقات iOS وAndroid من كود واحد! متطلباتها وهتستفاد ايه ف الاخر',
      doctorDesc: 'مهندس برمجه',
      videosNum: 57,
      image2: 'assets/img/dart.jpg',
      rate: 0.0,
      freeVideos: [
        FreeVideos(
          url:
              "https://www.youtube.com/watch?v=AuzjFFjirBc&list=PLGVaNq6mHinjCPki-3xraQdGWKVz7PhgI",
          title:
              'Best Flutter Course for beginners -course content #01 | بالعربي',
          time: '2 دقايق 57 ثانيه',
        ),
        FreeVideos(
          url:
              "https://www.youtube.com/watch?v=YfSq7DiM9dU&list=PLGVaNq6mHinjCPki-3xraQdGWKVz7PhgI&index=2",
          title:
              "Best Flutter Course for beginners -Introduction to programming #02 | بالعربي",
          time: '11 دقايق 57 ثانيه',
        ),
        FreeVideos(
          url:
              "https://www.youtube.com/watch?v=yvwDWIIc6JI&list=PLGVaNq6mHinjCPki-3xraQdGWKVz7PhgI&index=3",
          title:
              "Best Flutter Course for beginners -Difference between native and cross platform #03 | بالعربي",
          time: '9 دقايق 42 ثانيه',
        ),
        FreeVideos(
          url:
              "https://www.youtube.com/watch?v=3M8gyN_Xq7E&list=PLGVaNq6mHinjCPki-3xraQdGWKVz7PhgI&index=4",
          title:
              "Best Flutter Course for beginners -Environment setup #04 | بالعربي",
          time: '13 دقايق 43 ثانيه',
        ),
        FreeVideos(
          url:
              "https://www.youtube.com/watch?v=5GEp6RXlwbc&list=PLGVaNq6mHinjCPki-3xraQdGWKVz7PhgI&index=5",
          title:
              "Best Flutter Course for beginners -First Dart program #05 | بالعربي",
          time: '8 دقايق 46 ثانيه',
        ),
      ],
      payVideos: [
        PayVideos(
          title: "شرح Dart - تعلم لغة Dart و اهمية تعلم البرمجة بلغة Dart ",
          payVideos2: [
            PayVideos2(
              url:
                  "https://www.youtube.com/watch?v=xAnmb0vRxWY&list=PLGVaNq6mHinjCPki-3xraQdGWKVz7PhgI&index=6",
              title:
                  "Best Flutter Course for beginners -Data types and variables #06 | بالعربي",
              time: '11 دقايق 58 ثانيه',
            ),
            PayVideos2(
              url:
                  "https://www.youtube.com/watch?v=HavRgxbTLQI&list=PLGVaNq6mHinjCPki-3xraQdGWKVz7PhgI&index=7",
              title:
                  "Best Flutter Course for beginners -Numeric datatypes #07 | بالعربي",
              time: '4 دقايق 22 ثانيه',
            ),
            PayVideos2(
              url:
                  "https://www.youtube.com/watch?v=zdUMuH6sGBk&list=PLGVaNq6mHinjCPki-3xraQdGWKVz7PhgI&index=8",
              title:
                  "Best Flutter Course for beginners -Import statement #08 | بالعربي",
              time: '4 دقايق 3 ثانيه',
            ),
          ],
        ),
        PayVideos(
          title:
              "اهم مفاهيم Dart - تعلم لغة Dart و اهمية تعلم البرمجة بلغة Dart",
          payVideos2: [
            PayVideos2(
              url:
                  "https://www.youtube.com/watch?v=Zcnx73kmpqY&list=PLGVaNq6mHinjCPki-3xraQdGWKVz7PhgI&index=9",
              title:
                  "Best Flutter Course for beginners -User input #09 | بالعربي",
              time: '7 دقايق 48 ثانيه',
            ),
            PayVideos2(
              url:
                  "https://www.youtube.com/watch?v=YQeC30cemtY&list=PLGVaNq6mHinjCPki-3xraQdGWKVz7PhgI&index=10",
              title:
                  "Best Flutter Course for beginners -Operators in dart #10 | بالعربي",
              time: '5 دقايق 56 ثانيه',
            ),
            PayVideos2(
              url:
                  "https://www.youtube.com/watch?v=UXaNhNjz7DY&list=PLGVaNq6mHinjCPki-3xraQdGWKVz7PhgI&index=11",
              title:
                  "Best Flutter Course for beginners - Comments #11 | بالعربي",
              time: '1 دقايق 27 ثانيه',
            ),
          ],
        ),
      ],
    ),
    Course(
      youTubeLink:
          "https://www.youtube.com/watch?v=z1FdInL8sjg&list=PLCInYL3l2AajFAiw4s1U4QbGszcQ-rAb3",
      image: "assets/img/adelnseem.jpg",
      title: "دورة تعليم C++",
      name: "عادل نسيم",
      price: 800,
      time: 5,
      lang: 'العربيه',
      type: 'التكنولوجيا والتطوير',
      desc:
          "هل تبحث عن لغة برمجة تمنحك فهمًا عميقًا لأساسيات البرمجة وتفتح لك أبواب مجالات مثل برمجة الألعاب، أنظمة التشغيل، والبرمجيات عالية الأداء؟ دورة C++ للمبتدئين هي انطلاقتك المثالية نحو عالم البرمجة القوية والاحترافية!",
      doctorDesc: 'مهندس برمجه',
      videosNum: 38,
      image2: 'assets/img/cplusplus.jpg',
      rate: 0.0,
      freeVideos: [
        FreeVideos(
          url:
              "https://www.youtube.com/watch?v=z1FdInL8sjg&list=PLCInYL3l2AajFAiw4s1U4QbGszcQ-rAb3",
          title: '#01 [c++] - Introduction',
          time: '7 دقايق 11 ثانيه',
        ),
        FreeVideos(
          url:
              "https://www.youtube.com/watch?v=xo1R1nYM4aw&list=PLCInYL3l2AajFAiw4s1U4QbGszcQ-rAb3&index=2",
          title: "#02 [c++] - First project in c++",
          time: '11 دقايق 1 ثانيه',
        ),
        FreeVideos(
          url:
              "https://www.youtube.com/watch?v=pw7rTydaSYs&list=PLCInYL3l2AajFAiw4s1U4QbGszcQ-rAb3&index=3",
          title: "#03 [c++] - Escape Sequence",
          time: '9 دقايق 32 ثانيه',
        ),
        FreeVideos(
          url:
              "https://www.youtube.com/watch?v=FBjOHTuOIqo&list=PLCInYL3l2AajFAiw4s1U4QbGszcQ-rAb3&index=4",
          title: "#04 [c++] - Variables vs Data type",
          time: '16 دقايق 37 ثانيه',
        ),
        FreeVideos(
          url:
              "https://www.youtube.com/watch?v=0rYYaXlEiAY&list=PLCInYL3l2AajFAiw4s1U4QbGszcQ-rAb3&index=5",
          title: "#05 [c++] - Priorities&Calculations in c++",
          time: '19 دقايق 56 ثانيه',
        ),
      ],
      payVideos: [
        PayVideos(
          title: "شرح C++ - تعلم لغة Dart و اهمية تعلم البرمجة بلغة C++ ",
          payVideos2: [
            PayVideos2(
              url:
                  "https://www.youtube.com/watch?v=UpBYeNTwgbs&list=PLCInYL3l2AajFAiw4s1U4QbGszcQ-rAb3&index=6",
              title: "#06 [c++] - Basic Arithmetic&Casting",
              time: '16 دقايق 38 ثانيه',
            ),
            PayVideos2(
              url:
                  "https://www.youtube.com/watch?v=6XjgNR5Cw48&list=PLCInYL3l2AajFAiw4s1U4QbGszcQ-rAb3&index=7",
              title: "#07 [c++] - Prefix and Postfix&Compound assignment",
              time: '14 دقايق 46 ثانيه',
            ),
            PayVideos2(
              url:
                  "https://www.youtube.com/watch?v=Pkl5iFCNNs4&list=PLCInYL3l2AajFAiw4s1U4QbGszcQ-rAb3&index=8",
              title: "#08 [c++] - Variable Scope (Local vs Global)",
              time: '10 دقايق 8 ثانيه',
            ),
          ],
        ),
        PayVideos(
          title: "اهم مفاهيم C++ - تعلم لغة Dart و اهمية تعلم البرمجة بلغة C++",
          payVideos2: [
            PayVideos2(
              url:
                  "https://www.youtube.com/watch?v=F56Bo4I0GhA&list=PLCInYL3l2AajFAiw4s1U4QbGszcQ-rAb3&index=9",
              title: "#09 [c++] - Selection Statement(if-if else -if else if)",
              time: '31 دقايق 35 ثانيه',
            ),
            PayVideos2(
              url:
                  "https://www.youtube.com/watch?v=taov2H_-nlU&list=PLCInYL3l2AajFAiw4s1U4QbGszcQ-rAb3&index=10",
              title: "#10 [c++] - Logical Operators(AND,OR,NOT) / Shortest if",
              time: '18 دقايق 7 ثانيه',
            ),
            PayVideos2(
              url:
                  "https://www.youtube.com/watch?v=-MTeqw7gZf0&list=PLCInYL3l2AajFAiw4s1U4QbGszcQ-rAb3&index=11",
              title: "#11 [c++] - Switch Statement",
              time: '14 دقايق 26 ثانيه',
            ),
          ],
        ),
      ],
    ),
  ];

  List<LearningProgramsModel> learningProgramsList = [
    LearningProgramsModel(
      title: 'دورة تعليم بايثون من الصفر حتى الاحتراف',
      desc:
          'في هذه الدورة العملية، ستتعلم أساسيات لغة بايثون، إحدى أشهر وأسهل لغات البرمجة، والمستخدمة في مجالات متعددة مثل تطوير الويب، تحليل البيانات، الذكاء الاصطناعي، والأتمتة.',
      image: 'assets/img/python.jpg',
      coursesCount: 1,
      whatYouLearn: [
        WhatYouLearn(title: 'مقدمة إلى البرمجة ومفاهيمها الأساسية'),
        WhatYouLearn(title: 'تثبيت بيئة العمل وكتابة أول كود بايثون'),
        WhatYouLearn(title: 'المتغيرات، الشروط، الحلقات، والدوال'),
        WhatYouLearn(title: 'التعامل مع القوائم، السلاسل، والقواميس'),
        WhatYouLearn(title: 'البرمجة الكائنية (OOP) بأسلوب مبسط'),
        WhatYouLearn(title: 'مشاريع تطبيقية صغيرة لترسيخ الفهم'),
      ],
      learningProgramsCourses: [
        LearningProgramsCourses(
          image: "assets/img/python.jpg",
          title: "دورة تعليم بايثون من الصفر حتى الاحتراف",
          name: "اسلام هشام محفوظ",
        ),
      ],
      doctors: [
        Doctors(
          image: "assets/img/doctor.jpg",
          name: "اسلام هشام محفوظ",
          coursesCount: 1,
          followersCount: 100,
          title: 'دورة تعليم بايثون من الصفر حتى الاحتراف',
        ),
      ],
    ),
    LearningProgramsModel(
      title: 'دورة تعليم PHP',
      desc:
          "هل حلمت يومًا ببناء موقع إلكتروني كامل بيدك؟ مع دورة PHP للمبتدئين، ستنتقل من لا شيء إلى برمجة صفحات ويب ديناميكية وتفاعلية بكل ثقة! 🌐 ما هي PHP؟ PHP هي لغة برمجة مخصصة لتطوير مواقع الويب، وتُستخدم في ملايين المواقع حول العالم، مثل فيسبوك وWordPress! تعلّمها يعني أنك تضع قدمك الأولى في عالم تطوير الويب الاحترافي",
      image: 'assets/img/php.png',
      coursesCount: 1,
      whatYouLearn: [
        WhatYouLearn(title: 'ما هي PHP ولماذا تُستخدم'),
        WhatYouLearn(title: 'إعداد بيئة العمل (XAMPP / MAMP) وكتابة أول كود'),
        WhatYouLearn(title: 'المتغيرات، الشروط، الحلقات، الدوال'),
        WhatYouLearn(title: 'التعامل مع النماذج (Forms) ومعالجة البيانات'),
        WhatYouLearn(title: "ربط PHP مع قواعد البيانات (MySQL)"),
        WhatYouLearn(title: 'إنشاء تطبيق ويب بسيط خطوة بخطوة'),
      ],
      learningProgramsCourses: [
        LearningProgramsCourses(
          image: "assets/img/php.png",
          title: 'دورة تعليم PHP',
          name: "اسامه الزيرو",
        ),
      ],
      doctors: [
        Doctors(
          image: "assets/img/elzero.jpg",
          name: "اسامه الزيرو",
          coursesCount: 1,
          followersCount: 500,
          title: 'دورة تعليم PHP',
        ),
      ],
    ),
    LearningProgramsModel(
      title: 'دورة تعليم Dart',
      desc:
          "هل ترغب بتطوير تطبيقات موبايل عالية الأداء بواجهة مذهلة؟ رحلتك تبدأ من هنا، مع تعلّم لغة Dart – اللبنة الأساسية لإتقان Flutter وبناء تطبيقات iOS وAndroid من كود واحد!",
      image: 'assets/img/dart.jpg',
      coursesCount: 1,
      whatYouLearn: [
        WhatYouLearn(title: "مقدمة عن Dart ولماذا هي مهمة للمطورين"),
        WhatYouLearn(title: "إعداد بيئة التطوير (DartPad أو VS Code)"),
        WhatYouLearn(title: 'المتغيرات وأنواع البيانات'),
        WhatYouLearn(title: "الشروط والحلقات"),
        WhatYouLearn(title: "الدوال والمصفوفات (Lists)"),
        WhatYouLearn(title: 'الـ Maps و Sets'),
      ],
      learningProgramsCourses: [
        LearningProgramsCourses(
          image: "assets/img/dart.jpg",
          title: 'دورة تعليم Dart',
          name: "ثروت سامي",
        ),
      ],
      doctors: [
        Doctors(
          image: "assets/img/tharwatsamy.jpg",
          name: "ثروت سامي",
          coursesCount: 1,
          followersCount: 1000,
          title: 'دورة تعليم Dart',
        ),
      ],
    ),
    LearningProgramsModel(
      title: 'دورة تعليم C++',
      desc:
          "هل تبحث عن لغة برمجة تمنحك فهمًا عميقًا لأساسيات البرمجة وتفتح لك أبواب مجالات مثل برمجة الألعاب، أنظمة التشغيل، والبرمجيات عالية الأداء؟ دورة C++ للمبتدئين هي انطلاقتك المثالية نحو عالم البرمجة القوية والاحترافية!",
      image: 'assets/img/cplusplus.jpg',
      coursesCount: 1,
      whatYouLearn: [
        WhatYouLearn(title: "مقدمة إلى C++ ولماذا تُعد مهمة"),
        WhatYouLearn(title: "إعداد بيئة التطوير (CodeBlocks / Visual Studio)"),
        WhatYouLearn(title: 'المتغيرات، الأنواع، العمليات الحسابية والمنطقية'),
        WhatYouLearn(title: "الجمل الشرطية والحلقات"),
        WhatYouLearn(title: "الدوال والمصفوفات"),
        WhatYouLearn(title: 'المؤشرات (Pointers) وإدارة الذاكرة'),
      ],
      learningProgramsCourses: [
        LearningProgramsCourses(
          image: "assets/img/cplusplus.jpg",
          title: 'دورة تعليم C++',
          name: "عادل نسيم",
        ),
      ],
      doctors: [
        Doctors(
          image: "assets/img/adelnseem.jpg",
          name: "عادل نسيم",
          coursesCount: 1,
          followersCount: 500,
          title: 'دورة تعليم C++',
        ),
      ],
    ),
  ];

  List<Course> selectedCourses = CacheHelper.getSelectedCourses();
  void addOrRemoveSelectedCourse(Course course) async {
    if (selectedCourses.any((c) => c.title == course.title)) {
      CacheHelper.removeSelectedCourse(course.title);
    } else {
      CacheHelper.addSelectedCourse(course);
    }
    selectedCourses = CacheHelper.getSelectedCourses();
    emit(CourseSelected());
  }

  List<Course> completedCourses = CacheHelper.getCompletedCourses();
  void addCompletedCourse(Course course) async {
    CacheHelper.addCompletedCourse(course);
    completedCourses = CacheHelper.getCompletedCourses();
    emit(CourseCompleted());
  }

  List<Course> savedCourses = CacheHelper.getSavedCourses();
  void addOrRemoveSavedCourse(Course course) async {
    if (savedCourses.any((c) => c.title == course.title)) {
      CacheHelper.removeSavedCourse(course.title);
    } else {
      CacheHelper.addSavedCourse(course);
    }
    savedCourses = CacheHelper.getSavedCourses();
    emit(CourseSaved());
  }

  String? currentPlayingVideoUrl;
  void setCurrentPlayingVideo(String url) {
    currentPlayingVideoUrl = url;
    emit(ChangeVideoState());
  }

  void rateCourse(Course course, double rate) async {
    emit(RateLoadingState());
    Future.delayed(const Duration(seconds: 2), () {
      course.rate = rate;
      CacheHelper.addSelectedCourse(course);
      CacheHelper.addSelectedCourse(course);
      selectedCourses = CacheHelper.getSelectedCourses();
      emit(RateSuccessState());
    });
  }
}
