import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../db/category.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../db/product.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddProducts extends StatefulWidget {
  @override
  _AddProductsState createState() => _AddProductsState();
}

class _AddProductsState extends State<AddProducts> {
  Color white = Colors.white;
  Color black = Colors.black;
  Color blue = Colors.blue;
  Color grey = Colors.grey;
  CategoryService _categoryService = CategoryService();
  ProductService _productService = ProductService();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController productNameController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  List<DocumentSnapshot> brands = <DocumentSnapshot>[];
  List<DocumentSnapshot> categories = <DocumentSnapshot>[];
  List<DropdownMenuItem<String>> categoriesDropDown =
      <DropdownMenuItem<String>>[];
  List<DropdownMenuItem<String>> brandsDropDown = <DropdownMenuItem<String>>[];
  String _currentCategory;
  List<String> selectedSizes = <String>[];
  File _image1;
  File _image2;
  File _image3;
  bool isLoading = false;

  @override
  void initState() {
    _getCategories();
  }

  List<DropdownMenuItem<String>> getCategoriesDropdown() {
    List<DropdownMenuItem<String>> items = new List();
    for (int i = 0; i < categories.length; i++) {
      setState(() {
        items.insert(
            0,
            DropdownMenuItem(
              child: Text(categories[i].data['category']),
              value: categories[i].data['category'],
            ));
      });
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.1,
        backgroundColor: white,
        leading: Icon(
          Icons.close,
          color: black,
        ),
        title: Text(
          "add products",
          style: TextStyle(color: black),
        ),
      ),
      body: Form(
        key: _formKey,
        child: isLoading? CircularProgressIndicator() : Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: OutlineButton(
                        borderSide: BorderSide(
                            color: grey.withOpacity(0.8), width: 2.5),
                        onPressed: () {
                          _selectImage(
                              ImagePicker.pickImage(
                                  source: ImageSource.gallery),
                              1);
                        },
                        child: displayChild1()),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: OutlineButton(
                        borderSide: BorderSide(
                            color: grey.withOpacity(0.8), width: 2.5),
                        onPressed: () {
                          _selectImage(
                              ImagePicker.pickImage(
                                  source: ImageSource.gallery),
                              2);
                        },
                        child: displayChild2()),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: OutlineButton(
                        borderSide: BorderSide(
                            color: grey.withOpacity(0.8), width: 2.5),
                        onPressed: () {
                          _selectImage(
                              ImagePicker.pickImage(
                                  source: ImageSource.gallery),
                              3);
                        },
                        child: displayChild3()),
                  ),
                )
              ],
            ),

            /*Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                'Digite o nome do produto: ',
                style: TextStyle(color: blue),
              ),
            ),*/

            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextFormField(
                controller: productNameController,
                decoration: InputDecoration(hintText: "Nome do produto"),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Digite um nome para o produto';
                  } else if (value.length > 10) {
                    return 'O nome do produto não pode ultrapassar 10 caracteres';
                  }
                  return null;
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextFormField(
                controller: quantityController,
                keyboardType: TextInputType.numberWithOptions(),
                decoration: InputDecoration(
                  hintText: "Quantidade",
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Digite um nome para o produto';
                  }
                  return null;
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextFormField(
                controller: priceController,
                keyboardType: TextInputType.numberWithOptions(),
                decoration: InputDecoration(
                  hintText: "Preço",
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Digite o preço do produto';
                  }
                  return null;
                },
              ),
            ),

//               Selected category
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Category: ',
                    style: TextStyle(color: blue),
                  ),
                ),
                DropdownButton(
                    items: categoriesDropDown,
                    onChanged: changeSelectedCategory,
                    value: _currentCategory),
              ],
            ),

            Row(
              children: <Widget>[
                Checkbox(
                    value: selectedSizes.contains('28'),
                    onChanged: (value) => changeSelectedSize('28')),
                Text("28"),
                Checkbox(
                    value: selectedSizes.contains('32'),
                    onChanged: (value) => changeSelectedSize('32')),
                Text("32"),
                Checkbox(
                    value: selectedSizes.contains('36'),
                    onChanged: (value) => changeSelectedSize('36')),
                Text("36"),
                Checkbox(
                    value: selectedSizes.contains('40'),
                    onChanged: (value) => changeSelectedSize('40')),
                Text("40"),
              ],
            ),

            FlatButton(
                color: blue,
                textColor: white,
                child: Text('Adicionar Produto'),
                onPressed: () {
                  validateAndUpload();
                })
          ],
        ),
      ),
    );
  }

  _getCategories() async {
    List<DocumentSnapshot> data = await _categoryService.getCategories();
    setState(() {
      categories = data;
      categoriesDropDown = getCategoriesDropdown();
      _currentCategory = categories[1].data['category'];
    });
  }

  changeSelectedCategory(String selectedCategory) {
    setState(() {
      _currentCategory = selectedCategory;
    });
  }

  void changeSelectedSize(String size) {
    if (selectedSizes.contains(size)) {
      setState(() {
        selectedSizes.remove(size);
      });
    } else {
      setState(() {
        selectedSizes.insert(0, size);
      });
    }
  }

  void _selectImage(Future<File> pickImage, int imageNumber) async {
    File tempImg = await pickImage;

    switch (imageNumber) {
      case 1:
        setState(() {
          _image1 = tempImg;
        });
        break;

      case 2:
        setState(() {
          _image2 = tempImg;
        });
        break;

      case 3:
        setState(() {
          _image3 = tempImg;
        });
        break;
    }
  }

  Widget displayChild1() {
    if (_image1 == null) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(14.0, 30.0, 14.0, 30.0),
        child: new Icon(
          Icons.add,
          color: grey,
        ),
      );
    } else {
      return Image.file(_image1);
    }
  }

  Widget displayChild2() {
    if (_image2 == null) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(14.0, 30.0, 14.0, 30.0),
        child: new Icon(
          Icons.add,
          color: grey,
        ),
      );
    } else {
      return Image.file(_image2);
    }
  }

  Widget displayChild3() {
    if (_image3 == null) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(14.0, 30.0, 14.0, 30.0),
        child: new Icon(
          Icons.add,
          color: grey,
        ),
      );
    } else {
      return Image.file(_image3);
    }
  }

  void validateAndUpload() async {
    if (_formKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });
      if (_image1 != null && _image2 != null && _image3 != null) {
        if (selectedSizes.isNotEmpty) {
          /*String imageUrl1;
          String imageUrl2;
          String imageUrl3;

          final FirebaseStorage storage = FirebaseStorage.instance;

          final String picture1 =
              "1${DateTime.now().millisecondsSinceEpoch.toString()}.jpg";
          StorageUploadTask task1 =
              storage.ref().child(picture1).putFile(_image1);

          final String picture2 =
              "2${DateTime.now().millisecondsSinceEpoch.toString()}.jpg";
          StorageUploadTask task2 =
              storage.ref().child(picture1).putFile(_image2);

          final String picture3 =
              "3${DateTime.now().millisecondsSinceEpoch.toString()}.jpg";
          StorageUploadTask task3 =
              storage.ref().child(picture1).putFile(_image3);

          StorageTaskSnapshot snapshot1 =
              await task1.onComplete.then((snapshot) => snapshot);
          StorageTaskSnapshot snapshot2 =
              await task2.onComplete.then((snapshot) => snapshot);

          //obtendo a URL das imagens para poder utilizar no app
          task3.onComplete.then((snapshot3) async {
            imageUrl1 = await snapshot1.ref.getDownloadURL();
            imageUrl2 = await snapshot2.ref.getDownloadURL();
            imageUrl3 = await snapshot3.ref.getDownloadURL();

            List<String> imageList = [imageUrl1, imageUrl2, imageUrl3];

            _productService.uploadProduct(productName: productNameController.text);



            _formKey.currentState.reset();
            setState(() {
              isLoading = false;
            });
            Fluttertoast.showToast(msg: "Produtos adicionados");
            Navigator.pop(context);
          });*/
          _productService.uploadProduct(productName: productNameController.text);



          _formKey.currentState.reset();
          setState(() {
            isLoading = false;
          });
          Fluttertoast.showToast(msg: "Produtos adicionados");
          Navigator.pop(context);

        } else {
          setState(() {
            isLoading = false;
          });
          Fluttertoast.showToast(msg: "Selecione ao menos um tamanho");
        }
      } else {
        setState(() {
          isLoading = false;
        });
        Fluttertoast.showToast(msg: "Todas as imagens devem ser preenchidas");
      }
    }
  }
}
