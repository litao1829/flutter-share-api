class ArticleDetail {
  Share? share;
  String? nickname;
  String? avatarUrl;

  ArticleDetail({this.share, this.nickname, this.avatarUrl});

  ArticleDetail.fromJson(Map<String, dynamic> json) {
    share = json['share'] != null ? new Share.fromJson(json['share']) : null;
    nickname = json['nickname'];
    avatarUrl = json['avatarUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.share != null) {
      data['share'] = this.share!.toJson();
    }
    data['nickname'] = this.nickname;
    data['avatarUrl'] = this.avatarUrl;
    return data;
  }
}

class Share {
  int? id;
  int? userId;
  String? title;
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
  String? createTime;
  String? updateTime;

  Share(
      {this.id,
        this.userId,
        this.title,
        this.isOriginal,
        this.author,
        this.cover,
        this.summary,
        this.price,
        this.downloadUrl,
        this.buyCount,
        this.showFlag,
        this.auditStatus,
        this.reason,
        this.createTime,
        this.updateTime});

  Share.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    title = json['title'];
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
    createTime = json['createTime'];
    updateTime = json['updateTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userId'] = this.userId;
    data['title'] = this.title;
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
    data['createTime'] = this.createTime;
    data['updateTime'] = this.updateTime;
    return data;
  }
}