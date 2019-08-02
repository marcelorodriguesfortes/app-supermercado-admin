import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../db/category.dart';
import '../db/brand.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

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
  BrandService _brandService = BrandService();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController productNameController = TextEditingController();
  List<DocumentSnapshot> brands = <DocumentSnapshot>[];
  List<DocumentSnapshot> categories = <DocumentSnapshot>[];
  List<DropdownMenuItem<String>> categoriesDropDown = <DropdownMenuItem<String>>[];
  List<DropdownMenuItem<String>> brandsDropDown = <DropdownMenuItem<String>>[];
  String _currentCategory;
  String _currentBrand;



  @override
  void initState() {
    _getCategories();
  }

  List<DropdownMenuItem<String>> getCategoriesDropdown(){
    List<DropdownMenuItem<String>> items = new List();
    for (int i = 0; i < categories.length; i++){
      setState(() {
        items.insert(0, DropdownMenuItem(
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
        leading: Icon(Icons.close, color: black,),
        title: Text("add products", style: TextStyle(color: black),),
      ),
      body: Form(
          key: _formKey,
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: OutlineButton(
                      borderSide: BorderSide(color: grey.withOpacity(0.8), width: 2.5),
                      onPressed:(){},
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(14.0, 60.0, 14.0, 60.0),
                        child: new Icon(Icons.add, color: grey,),
                      ),
                    ),
                  ),
                ),

                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: OutlineButton(
                      borderSide: BorderSide(color: grey.withOpacity(0.8), width: 2.5),
                      onPressed:(){},
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(14.0, 60.0, 14.0, 60.0),
                        child: new Icon(Icons.add, color: grey,),
                      ),
                    ),
                  ),
                ),

                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: OutlineButton(
                      borderSide: BorderSide(color: grey.withOpacity(0.8), width: 2.5),
                      onPressed:(){},
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(14.0, 60.0, 14.0, 60.0),
                        child: new Icon(Icons.add, color: grey,),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text('Digite o nome do produto: ',
              style: TextStyle(color: blue),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextFormField(
                controller: productNameController,
                decoration: InputDecoration(
                  hintText: "Nome do produto"
                ),
                validator: (value){
                 if(value.isEmpty){
                   return 'Digite um nome para o produto';
                 }else if(value.length > 10){
                   return 'O nome do produto não pode ultrapassar 10 caracteres';
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
                child: Text('Category: ' , style: TextStyle(color: blue),),
              ),
              DropdownButton(
                items: categoriesDropDown,
                onChanged: changeSelectedCategory,
                value: _currentCategory
              ),
            ],
          ),
            
            FlatButton(
                color: blue,
                textColor: white,
                onPressed: (){}, 
                child: Text('Adicionar Produto')
            )
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
      if (categories[0].exists)
          _currentCategory = categories[0].data['category'];
      else
        _currentCategory = "erro";
    });
   }

  changeSelectedCategory(String selectedCategory) {
      setState(() {
        _currentCategory = selectedCategory;
      });
  }
}
