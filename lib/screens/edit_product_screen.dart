import 'package:flutter/material.dart';
import 'package:online_shop/models/product.dart';
import 'package:online_shop/providers/products_provider.dart';
import 'package:provider/provider.dart';

class EditProductScreen extends StatefulWidget {
  static const ROUTE_NAME = '/edit-product';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _imageUrlController = TextEditingController();
  final _formGlobalKey = GlobalKey<FormState>();
  var isEditMode = false;
  var isLoading = false;
  var isError = false;
  var editedProduct =
      Product(id: null, title: '', description: '', imageUrl: '', price: 0);

  @override
  void dispose() {
    super.dispose();
    _imageUrlController.dispose();
  }

  void _saveForm() async{
    if (!_formGlobalKey.currentState.validate()) return;

    _formGlobalKey.currentState.save();
    setState(() {
      isLoading = true;
    });

    if (editedProduct.id != null) {
      await Provider.of<ProductsProvider>(context, listen: false)
          .editProduct(editedProduct);

      showSnackBar("Product edited successfully");

    } else {
      editedProduct.id = DateTime.now().toString();
      await Provider.of<ProductsProvider>(context, listen: false)
          .addProduct(editedProduct)
          .catchError((error) {
            print(error.toString());
            isError = true;
        showSnackBar("Something went wrong");
      });

    }

    setState(() {
      isLoading = false;
      Navigator.of(context).pop();
    });
  }

  void showSnackBar(String content) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(content),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context).settings.arguments as String;
    if (productId != null) {
      editedProduct = Provider.of<ProductsProvider>(context, listen: false)
          .getProduct(productId);
      _imageUrlController.text = editedProduct.imageUrl;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Product"),
        actions: [IconButton(icon: Icon(Icons.save), onPressed: _saveForm)],
      ),
      body: Stack(children: [
        Padding(
          padding: EdgeInsets.all(14.0),
          child: Form(
            key: _formGlobalKey,
            child: ListView(
              children: [
                TextFormField(
                  initialValue: editedProduct.title,
                  decoration: InputDecoration(
                      labelText: 'Title',
                      border: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).primaryColor,
                              width: .5))),
                  textInputAction: TextInputAction.next,
                  onSaved: (val) {
                    editedProduct.title = val;
                  },
                  validator: (val) {
                    if (val.isEmpty) return "This failed is required";
                    return null;
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  initialValue: editedProduct.price.toString(),
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      labelText: 'Price',
                      border: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).primaryColor,
                              width: .5))),
                  textInputAction: TextInputAction.next,
                  onSaved: (val) {
                    editedProduct.price = double.parse(val);
                  },
                  validator: (val) {
                    if (val.isEmpty) return "This failed is required";
                    return null;
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  initialValue: editedProduct.description,
                  keyboardType: TextInputType.multiline,
                  maxLines: 4,
                  decoration: InputDecoration(
                      labelText: 'Description',
                      border: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).primaryColor,
                              width: .5))),
                  onSaved: (val) {
                    editedProduct.description = val;
                  },
                  validator: (val) {
                    if (val.isEmpty) return "This failed is required";
                    return null;
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  // initialValue: isEditMode ? editProduct.imageUrl.toString() :' ',
                  onSaved: (val) {
                    editedProduct.imageUrl = val;
                  },
                  controller: _imageUrlController,
                  keyboardType: TextInputType.url,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) {
                    _saveForm();
                  },
                  validator: (val) {
                    if (val.isEmpty) return "This failed is required";
                    return null;
                  },
                  decoration: InputDecoration(
                      labelText: 'Image Url',
                      border: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).primaryColor,
                              width: .5))),
                ),
                isLoading
                    ? Align(
                        child: CircularProgressIndicator(),
                        alignment: Alignment.center,
                      )
                    : Container(),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
