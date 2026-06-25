class PayVideos2 {
  final String url;
  final String title;
  final String time;

  PayVideos2({required this.url, required this.title, required this.time});

  factory PayVideos2.fromJson(Map<String, dynamic> json) {
    return PayVideos2(
      url: json['url'],
      title: json['title'],
      time: json['time'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'url': url, 'title': title, 'time': time};
  }
}

class PayVideos {
  final String title;
  final List<PayVideos2> payVideos2;

  PayVideos({required this.title, required this.payVideos2});

  factory PayVideos.fromJson(Map<String, dynamic> json) {
    return PayVideos(
      title: json['title'],
      payVideos2:
          (json['payVideos2'] as List)
              .map((e) => PayVideos2.fromJson(e))
              .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'payVideos2': payVideos2.map((e) => e.toJson()).toList(),
    };
  }
}

class FreeVideos {
  final String url;
  final String title;
  final String time;

  FreeVideos({required this.url, required this.title, required this.time});

  factory FreeVideos.fromJson(Map<String, dynamic> json) {
    return FreeVideos(
      url: json['url'],
      title: json['title'],
      time: json['time'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'url': url, 'title': title, 'time': time};
  }
}

class Course {
  final String youTubeLink;
  final String image;
  final String image2;
  final String title;
  final String name;
  final int price;
  final int time;
  final String lang;
  final String type;
  final String desc;
  final String doctorDesc;
  final int videosNum;
  double rate;
  final List<FreeVideos> freeVideos;
  final List<PayVideos> payVideos;

  Course({
    required this.youTubeLink,
    required this.image,
    required this.title,
    required this.name,
    required this.price,
    required this.time,
    required this.lang,
    required this.type,
    required this.desc,
    required this.doctorDesc,
    required this.videosNum,
    required this.rate,
    required this.image2,
    required this.freeVideos,
    required this.payVideos,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      youTubeLink: json['youTubeLink'],
      image: json['image'],
      title: json['title'],
      name: json['name'],
      price: json['price'],
      time: json['time'],
      lang: json['lang'],
      type: json['type'],
      desc: json['desc'],
      doctorDesc: json['doctorDesc'],
      videosNum: json['videosNum'],
      image2: json['image2'],
      rate: json['rate'],
      freeVideos:
          (json['freeVideos'] as List)
              .map((e) => FreeVideos.fromJson(e))
              .toList(),
      payVideos:
          (json['payVideos'] as List)
              .map((e) => PayVideos.fromJson(e))
              .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'youTubeLink': youTubeLink,
      'image': image,
      'title': title,
      'name': name,
      'price': price,
      'time': time,
      'lang': lang,
      'type': type,
      'desc': desc,
      'doctorDesc': doctorDesc,
      'videosNum': videosNum,
      'image2': image2,
      'rate': rate,
      'freeVideos': freeVideos.map((e) => e.toJson()).toList(),
      'payVideos': payVideos.map((e) => e.toJson()).toList(),
    };
  }
}
