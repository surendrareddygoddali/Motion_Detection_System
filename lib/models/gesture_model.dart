class GestureModel {
  final String? name;
  final String? audio;
  final String? description;
  final String? location;
  final String? userId;
  final String? url;

  GestureModel({
    this.name,
    this.audio,
    this.description,
    this.location,
    this.userId,
    this.url,
  });

  factory GestureModel.fromJson(Map<String, dynamic> json) => GestureModel(
    name: json['name'],
    audio: json['audio'],
    description: json['description'],
    location: json['location'],
    userId: json['userId'],
    url: json['url']
  );

  Map<String, dynamic> toJson(GestureModel gesture) => {
    'name': gesture.name,
    'audio': gesture.audio,
    'description': gesture.description,
    'location': gesture.location,
    'userId': gesture.userId,
    'url': gesture.url,
  };
}
