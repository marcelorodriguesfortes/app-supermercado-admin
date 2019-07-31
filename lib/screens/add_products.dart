import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../db/category.dart';
import '../db/brand.dart';


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
  String _currentCategory = "test";
  String _currentBrand;



  @override
  void initState() {
    _getCategories();
    //_getBrands();
    getCategoriesDropdown();
    //_currentCategory = categoriesDropDown[0].value;
  }

  getCategoriesDropdown(){
    List<DropdownMenuItem<String>> items = new List();
    for (int i = 0; i < categories.length; i++){
      categoriesDropDown.insert(0, DropdownMenuItem(
        child: Text(categories[i]['category']),
        value: categories[i]['category'],
      )
      );
    }
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
                        padding: const EdgeInsets.fromLTRB(14.0, 30.0, 14.0, 30.0),
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
                        padding: const EdgeInsets.fromLTRB(14.0, 30.0, 14.0, 30.0),
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
                        padding: const EdgeInsets.fromLTRB(14.0, 30.0, 14.0, 30.0),
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

            Expanded(
              child: ListView.builder(
                  itemCount: categories.length,
                  itemBuilder: (context, index){
                    return ListTile(
                      title: Text(categories[index]['category']),
                    );
                  }),
            )
            /*Center(
              child: DropdownButton(
                  value: _currentCategory,
                  items: categoriesDropDown,
                  onChanged: changeSelectedCategory),
            )*/
          ],
        ),
      ),
    );
  }

   _getCategories() async {
    List<DocumentSnapshot> data = await _categoryService.getCategories();
    setState(() {
      categories = data;
    });
   }

  changeSelectedCategory(String selectedCategory) {
      setState(() {
        _currentCategory = selectedCategory;
      });
  }
}
