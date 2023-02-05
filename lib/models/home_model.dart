class HomeModel {
  bool status;
  HomeDataModel data;
  HomeModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = HomeDataModel.fromJson(json['data']);
  }
}

class HomeDataModel {
  List<BannerModel> banners = [];
  List<ProductModel> products = [];
  HomeDataModel.fromJson(Map<String, dynamic> json) {
    json['banners'].forEach((element) {
      banners.add(BannerModel.fromJson(element));
    });

    json['products'].forEach((element) {
      products.add(ProductModel.fromJson(element));
    });
  }
}

class BannerModel {
  int id;
  String image;
  BannerModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
  }
}

class ProductModel {
  int id;
  dynamic price;
  dynamic old_price;
  dynamic discount;
  String image;
  String name;
  bool in_favorite;
  bool in_cart;
  ProductModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    price = json['price'];
    old_price = json['old_price'];
    discount = json['discount'];
    image = json['image'];
    name = json['name'];
    in_favorite = json['in_favorites'];
    in_cart = json['in_cart'];
  }
}

class BookModel {
  String bookId;
  String bookTitle;
  String bookContent;
  String bookImage;
  String bookAbout;
  String bookCategory;
  String status;

  BookModel(
      {this.bookId,
      this.bookTitle,
      this.bookContent,
      this.bookImage,
      this.bookAbout,
      this.bookCategory,
      this.status});

  BookModel.fromJson(Map<String, dynamic> json) {
    bookId = json['book_id'];
    bookTitle = json['book_title'];
    bookContent = json['book_content'];
    bookImage = json['book_image'];
    bookAbout = json['book_about'];
    bookCategory = json['book_category'];
    status = json['status'];
  }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   data['book_id'] = this.bookId;
  //   data['book_title'] = this.bookTitle;
  //   data['book_content'] = this.bookContent;
  //   data['book_image'] = this.bookImage;
  //   data['book_about'] = this.bookAbout;
  //   data['book_category'] = this.bookCategory;
  //   data['status'] = this.status;
  //   return data;
  // }
}
