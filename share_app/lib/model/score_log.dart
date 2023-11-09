class ScoreLog {
  int? id;
  int? userId;
  int? value;
  String? description;
  String? event;
  String? createTime;

  ScoreLog(
      {this.id,
        this.userId,
        this.value,
        this.description,
        this.event,
        this.createTime});

  ScoreLog.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    value = json['value'];
    description = json['description'];
    event = json['event'];
    createTime = json['createTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userId'] = this.userId;
    data['value'] = this.value;
    data['description'] = this.description;
    data['event'] = this.event;
    data['createTime'] = this.createTime;
    return data;
  }
}