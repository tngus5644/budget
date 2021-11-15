

class IncomeModel{
  String name;
  String price;
  String user;
  String date;
  String div;
  IncomeModel({this.name, this.price, this.user, this.date, this.div});

  IncomeModel.fromJson(Map<String, dynamic> json) {
    price = json['price'];
    name = json['name'];
    user = json['user'];
    date = json['date'];
    div = json['div'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['price'] = this.price;
    data['name'] = this.name;
    data['user'] = this.user;
    data['date'] = this.date;
    data['div'] = this.div;
    return data;
  }


}