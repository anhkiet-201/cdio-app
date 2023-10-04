class PageableResponseModel {
  int? pageIndex;
  int? totalPages;
  bool? hasNextPage;
  List<Map<String, dynamic>>? items;
  bool? status;
  String? message;

  PageableResponseModel(
      {this.pageIndex,
        this.totalPages,
        this.hasNextPage,
        this.items,
        this.status,
        this.message});

  PageableResponseModel.fromJson(Map<String, dynamic> json) {
    pageIndex = json['page_index'];
    totalPages = json['total_pages'];
    hasNextPage = json['has_next_page'];
    if (json['items'] != null) {
      items = <Map<String, dynamic>>[];
      json['items'].forEach((v) {
        items!.add(v);
      });
    }
    status = json['status'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['page_index'] = pageIndex;
    data['total_pages'] = totalPages;
    data['has_next_page'] = hasNextPage;
    data['items'] = items;
    data['status'] = status;
    data['message'] = message;
    return data;
  }
}