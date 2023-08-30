class Driver {
  String id;
  String name;
  String cpf;
  String? idCar;
  String phoneNumber;
  List<String> images = [];

  Driver({
    this.id = "",
    required this.name,
    required this.cpf,
    required this.idCar,
    required this.phoneNumber,
    required this.images,
  });

  Driver.empty({this.id = "", this.name = "", this.cpf = "", this.phoneNumber = "", this.idCar});

  String getFirstImage() {
    return images.isEmpty ? "" : images.first;
  }

  factory Driver.fromSnapshot(Map<dynamic, dynamic> data) {
    return Driver(
      id: data['id'] ?? '',
      name: data['name'] ?? '',
      idCar: data['idCar'],
      cpf: data['cpf'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
      images: (data['images'] ?? []).cast<String>(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'idCar': idCar,
      'name': name,
      'cpf': cpf,
      'phoneNumber': phoneNumber,
      'images': images,
    };
  }
}
