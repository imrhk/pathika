class PlaceSearchResponse {
  List<Place> candidates;
  String status;

  PlaceSearchResponse({this.candidates, this.status});

  PlaceSearchResponse.fromJson(Map<String, dynamic> json) {
    if (json['candidates'] != null) {
      candidates = new List<Place>();
      json['candidates'].forEach((v) {
        candidates.add(new Place.fromJson(v));
      });
    }
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.candidates != null) {
      data['candidates'] = this.candidates.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    return data;
  }
}

class Place {
  String formattedAddress;
  String name;
  List<Photos> photos;
  String placeId;

  Place({this.formattedAddress, this.name, this.photos, this.placeId});

  Place.fromJson(Map<String, dynamic> json) {
    formattedAddress = json['formatted_address'];
    name = json['name'];
    if (json['photos'] != null) {
      photos = new List<Photos>();
      json['photos'].forEach((v) {
        photos.add(new Photos.fromJson(v));
      });
    }
    placeId = json['place_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['formatted_address'] = this.formattedAddress;
    data['name'] = this.name;
    if (this.photos != null) {
      data['photos'] = this.photos.map((v) => v.toJson()).toList();
    }
    data['place_id'] = this.placeId;
    return data;
  }
}

class Photos {
  int height;
  List<String> htmlAttributions;
  String photoReference;
  int width;

  Photos({this.height, this.htmlAttributions, this.photoReference, this.width});

  Photos.fromJson(Map<String, dynamic> json) {
    height = json['height'];
    htmlAttributions = json['html_attributions'].cast<String>();
    photoReference = json['photo_reference'];
    width = json['width'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['height'] = this.height;
    data['html_attributions'] = this.htmlAttributions;
    data['photo_reference'] = this.photoReference;
    data['width'] = this.width;
    return data;
  }
}

class PlacePhotosResponse {
  List<String> htmlAttributions;
  Result result;
  String status;

  PlacePhotosResponse({this.htmlAttributions, this.result, this.status});

  PlacePhotosResponse.fromJson(Map<String, dynamic> json) {
    if (json['html_attributions'] != null) {
      htmlAttributions = new List<String>();
      json['html_attributions'].forEach((v) {
        htmlAttributions.add(v);
      });
    }
    result =
    json['result'] != null ? new Result.fromJson(json['result']) : null;
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.result != null) {
      data['result'] = this.result.toJson();
    }
    data['status'] = this.status;
    return data;
  }
}

class Result {
  List<Photos> photos;

  Result({this.photos});

  Result.fromJson(Map<String, dynamic> json) {
    if (json['photos'] != null) {
      photos = new List<Photos>();
      json['photos'].forEach((v) {
        photos.add(new Photos.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.photos != null) {
      data['photos'] = this.photos.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
