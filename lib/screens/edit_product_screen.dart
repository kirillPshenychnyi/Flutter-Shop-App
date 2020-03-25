import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/model/providers/product.dart';
import 'package:shop_app/model/providers/products.dart';

class EditProductScreen extends StatefulWidget {
  static const String ROUTE = '/EDIT_PRODUCT';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class ProductFormData {
  String description = '';
  String imageUrl = '';
  String title = '';
  double price = 0.0;

  void reset() {
    price = 0.0;
    imageUrl = '';
    description = '';
    title = '';
    price = 0;
  }
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocus = FocusNode();
  final _descriptionFocus = FocusNode();
  final _imageUrlContoller = TextEditingController();
  final _imageUrlFocus = FocusNode();

  final _formKey = GlobalKey<FormState>();
  ProductFormData _formData = new ProductFormData();

  String _id;

  bool _isLoading = false;

  @override
  void initState() {
    _imageUrlFocus.addListener(_updateImageView);
    super.initState();
  }

  @override
  void dispose() {
    _imageUrlFocus.removeListener(_updateImageView);

    _priceFocus.dispose();
    _descriptionFocus.dispose();
    _imageUrlFocus.dispose();

    super.dispose();
  }

  void _updateImageView() {
    if (validateImageUrl(_imageUrlContoller.text) != null) {
      setState(() {});
    }
  }

  Future<void> _saveForm() async {
    bool isValid = _formKey.currentState.validate();

    if (!isValid) {
      return;
    }

    _formKey.currentState.save();

    setState(() {
      _isLoading = true;
    });

    Products products = Provider.of<Products>(context, listen: false);

    try {
      if (_id != null) {
        products.updateItem(_id, _formData.title, _formData.description,
            _formData.imageUrl, _formData.price);
      } else {
        products.addItem(_formData.title, _formData.description,
            _formData.imageUrl, _formData.price);
      }
    } catch (error) {
      await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                title: Text('An error occured!'),
                content: Text('Something went wrong'),
                actions: <Widget>[
                  FlatButton(
                    child: Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              ));
    }

    setState(() {
      _isLoading = false;
    });

    Navigator.of(context).pop();
  }

  String validateImageUrl(String urlValue) {
    if (urlValue.isEmpty) {
      return 'Image URL must not be empty';
    }

    if (!urlValue.startsWith('http') && !urlValue.startsWith('https')) {
      return 'Image URL must start with http/https';
    }

    if (!urlValue.endsWith('.png') &&
        !urlValue.endsWith('.jpg') &&
        !urlValue.endsWith('.jpeg')) {
      return 'Image URL must point to a valid image (png/jpg/jpeg)';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    _id = ModalRoute.of(context).settings.arguments as String;
    Product editedProduct;

    if (_id != null) {
      editedProduct =
          Provider.of<Products>(context, listen: false).findById(_id);
      _imageUrlContoller.text = editedProduct.imageUrl;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit product'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Form(
                key: _formKey,
                child: ListView(
                  children: <Widget>[
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Title'),
                      initialValue:
                          editedProduct != null ? editedProduct.title : '',
                      textInputAction: TextInputAction.next,
                      onSaved: (title) {
                        _formData.title = title;
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Title must not be empty.';
                        }
                        return null;
                      },
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_priceFocus);
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Price'),
                      initialValue: editedProduct != null
                          ? editedProduct.price.toString()
                          : '',
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      focusNode: _priceFocus,
                      onSaved: (price) {
                        _formData.price = double.parse(price);
                      },
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_descriptionFocus);
                      },
                      validator: (value) {
                        double price = double.tryParse(value);
                        if (price == null) {
                          return 'Price should be a valid double field.';
                        }

                        if (price <= 0.0) {
                          return 'Price should be greater that 0.0.';
                        }

                        return null;
                      },
                    ),
                    TextFormField(
                        decoration: InputDecoration(labelText: 'Description'),
                        initialValue: editedProduct != null
                            ? editedProduct.description
                            : '',
                        keyboardType: TextInputType.multiline,
                        maxLines: 3,
                        onSaved: (description) {
                          _formData.description = description;
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Description must not be empty.';
                          }

                          if (value.length < 10) {
                            return 'Description must conatain at least 10 characters.';
                          }

                          return null;
                        },
                        focusNode: _descriptionFocus),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Container(
                          width: 100,
                          height: 100,
                          margin: EdgeInsets.only(right: 10, top: 8),
                          decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.grey),
                          ),
                          child: _imageUrlContoller.text.isEmpty
                              ? Text('Enter image URL')
                              : Image.network(_imageUrlContoller.text),
                        ),
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(labelText: 'Image URL'),
                            focusNode: _imageUrlFocus,
                            keyboardType: TextInputType.url,
                            controller: _imageUrlContoller,
                            onFieldSubmitted: (_) {
                              _saveForm();
                            },
                            validator: validateImageUrl,
                            onSaved: (url) {
                              String error = validateImageUrl(url);
                              if (error == null) {
                                _formData.imageUrl = url;
                              }
                            },
                            textInputAction: TextInputAction.done,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
      ),
    );
  }
}
