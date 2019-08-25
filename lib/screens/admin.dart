import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../db/category.dart';
import '../db/brand.dart';
import 'add_products.dart';

enum Page { dashboard, manage }

class Admin extends StatefulWidget {
  @override
  _AdminState createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  Page _selectedPage = Page.dashboard;
  MaterialColor active = Colors.blue;
  MaterialColor notActive = Colors.grey;
  TextEditingController categoryController = TextEditingController();
  TextEditingController brandController = TextEditingController();
  GlobalKey<FormState> _categoryFormKey = GlobalKey();
  GlobalKey<FormState> _brandFormKey = GlobalKey();
  BrandService _brandService = BrandService();
  CategoryService _categoryService = CategoryService();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(
            children: <Widget>[
              Expanded(
                  child: FlatButton.icon(
                      onPressed: () {
                        setState(() => _selectedPage = Page.dashboard);
                      },
                      icon: Icon(
                        Icons.dashboard,
                        color: _selectedPage == Page.dashboard
                            ? active
                            : notActive,
                      ),
                      label: Text('Informações'))),
              Expanded(
                  child: FlatButton.icon(
                      onPressed: () {
                        setState(() => _selectedPage = Page.manage);
                      },
                      icon: Icon(
                        Icons.sort,
                        color:
                            _selectedPage == Page.manage ? active : notActive,
                      ),
                      label: Text('Gerenciar'))),
            ],
          ),
          elevation: 0.0,
          backgroundColor: Colors.white,
        ),
        body: _loadScreen());
  }

  Widget _loadScreen() {
    switch (_selectedPage) {
      case Page.dashboard:
        return Column(
          children: <Widget>[

            Expanded(
              child: GridView(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 5.0),
                    child: Card(
                      child: ListTile(
                          title: Padding(
                            padding: const EdgeInsets.fromLTRB(8,18,8,8),
                            child: Text("Usuários",textAlign: TextAlign.center, style: TextStyle(color: Colors.grey),),
                          ),
                          subtitle: Column(
                            children: <Widget>[
                              Text(
                                '7',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: active, fontSize: 60.0),
                              ),
                            ],
                          )),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 5.0),
                    child: Card(
                      child: ListTile(
                          title: Padding(
                            padding: const EdgeInsets.fromLTRB(8,18,8,8),
                            child: Text("Categorias",textAlign: TextAlign.center, style: TextStyle(color: Colors.grey),),
                          ),
                          subtitle: Column(
                            children: <Widget>[
                              Text(
                                '3',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: active, fontSize: 60.0),
                              ),
                            ],
                          )),
                    ),
                  ),


                  Padding(
                    padding: const EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 5.0),
                    child: Card(
                      child: ListTile(
                          title: Padding(
                            padding: const EdgeInsets.fromLTRB(8,18,8,8),
                            child: Text("Produtos",textAlign: TextAlign.center, style: TextStyle(color: Colors.grey),),
                          ),
                          subtitle: Column(
                            children: <Widget>[
                              Text(
                                '120',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: active, fontSize: 60.0),
                              ),
                            ],
                          )),
                    ),
                  ),

                ],
              ),
            ),
          ],
        );
        break;
      case Page.manage:
        return ListView(
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.add),
              title: Text("Adicionar produto"),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => AddProducts() ));
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.change_history),
              title: Text("Lista de produtos"),
              onTap: () {},
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.add_circle),
              title: Text("Adicionar categoria"),
              onTap: () {
                _categoryAlert();
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.category),
              title: Text("Lista de categoria"),
              onTap: () {},
            ),
            Divider(),
          ],
        );
        break;
      default:
        return Container();
    }
  }

  void _categoryAlert() {
    var alert = new AlertDialog(
      content: Form(
        key: _categoryFormKey,
        child: TextFormField(
          controller: categoryController,
          validator: (value){
            if(value.isEmpty){
              return 'Categoria não pode ser nula';
            }
          },
          decoration: InputDecoration(
            hintText: "Adicione categoria"
          ),
        ),
      ),
      actions: <Widget>[
        FlatButton(onPressed: (){
          if(categoryController.text != null){
            _categoryService.createCategory(categoryController.text);
          }
          Fluttertoast.showToast(msg: 'Categoria criada!');
          Navigator.pop(context);
        }, child: Text('Adicionar')),
        FlatButton(onPressed: (){
          Navigator.pop(context);
        }, child: Text('Cancelar')),

      ],
    );

    showDialog(context: context, builder: (_) => alert);
  }

  void _brandAlert() {
    var alert = new AlertDialog(
      content: Form(
        key: _brandFormKey,
        child: TextFormField(
          controller: brandController,
          validator: (value){
            if(value.isEmpty){
              return 'Marca não pode ser nula';
            }
          },
          decoration: InputDecoration(
              hintText: "Adicionar marca"
          ),
        ),
      ),
      actions: <Widget>[
        FlatButton(onPressed: (){
          if(brandController.text != null){
            _brandService.createBrand(brandController.text);
          }
          Fluttertoast.showToast(msg: 'Marca adicionada!');
          Navigator.pop(context);
        }, child: Text('Adicionar')),
        FlatButton(onPressed: (){
          Navigator.pop(context);
        }, child: Text('Cancelar')),

      ],
    );

    showDialog(context: context, builder: (_) => alert);
  }
}
