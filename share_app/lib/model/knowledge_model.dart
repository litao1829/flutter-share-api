class KnowledgeModel {
  String? cover;
  String? tag;
  String? name;
  String? description;
  int? readCount;
  int? userId;
  bool? pay;
  int? code;

  KnowledgeModel(
      {this.cover,
      this.tag,
      this.name,
      this.description,
      this.readCount,
        this.pay,
        this.code,
      this.userId});

  KnowledgeModel.fromJson(Map<String, dynamic> json) {
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
