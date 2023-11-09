class ArticleModel {
  int? id;
  int? userId;
  String? title;
  String? createTime;
  String? updateTime;
  bool? isOriginal;
  String? author;
  String? cover;
  String? summary;
  int? price;
  String? downloadUrl;
  int? buyCount;
  bool? showFlag;
  String? auditStatus;
  String? reason;
  ArticleModel(
      {this.id,
        this.userId,
        this.title,
        this.createTime,
        this.updateTime,
        this.isOriginal,
        this.author,
        this.cover,
        this.summary,
        this.price,
        this.downloadUrl,
        this.buyCount,
        this.showFlag,
        this.auditStatus,
        this.reason});
  ArticleModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    title = json['title'];
    createTime = json['createTime'];
    updateTime = json['updateTime'];
    isOriginal = json['isOriginal'];
    author = json['author'];
    cover = json['cover'];
    summary = json['summary'];
    price = json['price'];
    downloadUrl = json['downloadUrl'];
    buyCount = json['buyCount'];
    showFlag = json['showFlag'];
    auditStatus = json['auditStatus'];
    reason = json['reason'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userId'] = this.userId;
    data['title'] = this.title;
    data['createTime'] = this.createTime;
    data['updateTime'] = this.updateTime;
    data['isOriginal'] = this.isOriginal;
    data['author'] = this.author;
    data['cover'] = this.cover;
    data['summary'] = this.summary;
    data['price'] = this.price;
    data['downloadUrl'] = this.downloadUrl;
    data['buyCount'] = this.buyCount;
    data['showFlag'] = this.showFlag;
    data['auditStatus'] = this.auditStatus;
    data['reason'] = this.reason;
    return data;
  }
}