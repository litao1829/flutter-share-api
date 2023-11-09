class SubmitModel {
  String? cover;
  String? tag;
  String? name;
  String? description;
  int? readCount;
  int? userId;
  int? code;

  SubmitModel(
      {this.cover,
      this.tag,
      this.name,
      this.description,
      this.readCount,
        this.code,
      this.userId});

  SubmitModel.fromJson(Map<String, dynamic> json) {
    cover = json['cover'];
    tag = json['tag'];
    name = json['name'];
    description = json['description'];
    readCount = json['readCount'];
    userId = json['userId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cover'] = this.cover;
    data['tag'] = this.tag;
    data['name'] = this.name;
    data['description'] = this.description;
    data['readCount'] = this.readCount;
    data['userId'] = this.userId;
    return data;
  }
}
