import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../db/category.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../db/product.dart';
import 'admin.dart';

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
  File _image;
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
      appBar: new AppBar(
        iconTheme: IconThemeData(color: Colors.grey),
        backgroundColor: Colors.white,
        title: InkWell(child: Text('Adicionar produtos',style: TextStyle(color: Colors.grey),),
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => new Admin()));
          },
        ),
        elevation: 0.0,
      ),
      body: Form(
        key: _formKey,
        child: isLoading? CircularProgressIndicator() : Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(98,8,98,8),
                    child: OutlineButton(
                        borderSide: BorderSide(color: grey.withOpacity(0.8), width: 2.5, ),

                        onPressed: () {
                          _selectImage(ImagePicker.pickImage(source: ImageSource.gallery));
                        },

                        child: displayChild()
                    ),
                  ),
                ),

              ],
            ),


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
                  padding: const EdgeInsets.fromLTRB(13,32,12,22),
                  child: Text(
                    'Categoria: ',
                    style: TextStyle(color: blue,fontSize: 16.0),
                  ),
                ),
                DropdownButton(
                    items: categoriesDropDown,
                    onChanged: changeSelectedCategory,
                    value: _currentCategory),
              ],
            ),



            Padding(
              padding:
              const EdgeInsets.fromLTRB(44.0, 18.0, 44.0, 18.0),
              child: Material(
                  borderRadius: BorderRadius.circular(20.0),
                  color: Colors.blue,
                  elevation: 0.0,
                  child: MaterialButton(
                    onPressed: () async{
                      validateAndUpload();
                    },
                    minWidth: MediaQuery.of(context).size.width,
                    child: Text(
                      "Adicionar produto",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15.0),
                    ),
                  )),
            ),

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

  void _selectImage(Future<File> pickImage) async {
    File tempImg = await pickImage;
    setState(() {
      _image = tempImg;
    });

  }

  Widget displayChild() {
    if (_image == null) {
      return Padding(
        padding: const EdgeInsets.all(20),
        child: new Icon(
          Icons.photo_camera,
          color: grey,
        ),
      );
    } else {
      return Image.file(_image,height: 140,);
    }
  }


  void validateAndUpload() async {
    if (_formKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });
      if (_image != null) {
        if (selectedSizes.isNotEmpty) {
          String imageUrl1;

          final FirebaseStorage storage = FirebaseStorage.instance;

          final String picture1 = "${DateTime.now().millisecondsSinceEpoch.toString()}1.jpg";
          StorageUploadTask task1 = storage.ref().child(picture1).putFile(_image);


          //obtendo a URL das imagens para poder utilizar no app
          task1.onComplete.then((snapshot) async {
            imageUrl1 = await snapshot.ref.getDownloadURL();

            String imagem = imageUrl1;

            _productService.uploadProduct(
                productName: productNameController.text,
                price: double.parse(priceController.text),
                image: imagem,
                quantity: int.parse(quantityController.text)
            );

            _formKey.currentState.reset();
            setState(() {
              isLoading = false;
            });

            //Fluttertoast.showToast(msg: "Produtos adicionados");
            Navigator.pop(context);
          });

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
