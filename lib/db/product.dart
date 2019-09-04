import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class ProductService{
  Firestore _firestore = Firestore.instance;
  String ref = 'products';

  void uploadProduct({String productName, double price, String image, String category}){
    var id = Uuid();
    String productId = id.v1();
    _firestore.collection(ref).document(productId).setData({'name': productName, 'price': price, 'image': image, 'category' : category});
  }
}