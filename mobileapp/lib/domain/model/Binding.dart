class Binding {
  Geo geo;
  ItemLabel itemLabel;

  Binding({this.geo, this.itemLabel});

  Binding.fromJson(Map<String, dynamic> json) {
    geo = json['geo'] != null ? new Geo.fromJson(json['geo']) : null;
    itemLabel = json['itemLabel'] != null
        ? new ItemLabel.fromJson(json['itemLabel'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.geo != null) {
      data['geo'] = this.geo.toJson();
    }
    if (this.itemLabel != null) {
      data['itemLabel'] = this.itemLabel.toJson();
    }
    return data;
  }
}

class Geo {
  String datatype;
  String type;
  String value;

  Geo({this.datatype, this.type, this.value});

  Geo.fromJson(Map<String, dynamic> json) {
    datatype = json['datatype'];
    type = json['type'];
    value =
        json['value'].toString().replaceAll('Point(', '').replaceAll(')', '');
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['datatype'] = this.datatype;
    data['type'] = this.type;
    data['value'] = this.value;
    return data;
  }
}

class ItemLabel {
  String xmlLang;
  String type;
  String value;

  ItemLabel({this.xmlLang, this.type, this.value});

  ItemLabel.fromJson(Map<String, dynamic> json) {
    xmlLang = json['xml:lang'];
    type = json['type'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['xml:lang'] = this.xmlLang;
    data['type'] = this.type;
    data['value'] = this.value;
    return data;
  }
}
