class Food {
   String? id;
   String? name;
   String? price;
   String? image;
   String? vendorId;
   int? quantity;
   

  Food( {
    required this.id,
    required this.name,
    required this.price,
    required this.image,
    required this.vendorId, required int this.quantity
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'quantity': quantity,
      'vendorId': vendorId,
      'image': image,
    };
  }

}
