import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/products_grid.dart';
import '../widgets/badge.dart';
import '../providers/shopping_cart_provider.dart';
import './cart_screen.dart';
import '../widgets/app_drawer.dart';
import '../providers/products_provider.dart';

enum FilterOptions {
  Favorites,
  All,
}

class ProductOverviewScreen extends StatefulWidget {
  @override
  _ProductOverviewScreenState createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  var _showOnlyFavorites = false;
  var _isLoading = false;
  // var _isInit = true;

  @override
  void initState() {
    _isLoading = true;
    Provider.of<ProductsProvider>(
      context,
      listen: false,
    ).fetchProducts().then((_) {
      setState(() {
        _isLoading = false;
      });
    });
    // Provider.of<ProductsProvider>(context).fetchProducts(); //NO FUNCIONA A MENOS QUE COLOQUES listen: false
    // Future.delayed(Duration.zero).then((_) { //FUNCIONA PERO NO ES LO IDEAL
    //   Provider.of<ProductsProvider>(context).fetchProducts();
    // });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // if (_isInit) {//ESTO ES OTRO WORKAROUND PARA CARGAR LOS PRODUCTOS AL INICIO
    //   Provider.of<ProductsProvider>(context).fetchProducts();
    // }
    // _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shoppy'),
        actions: <Widget>[
          PopupMenuButton(
            icon: Icon(
              Icons.more_vert,
            ),
            onSelected: (FilterOptions selectedValue) {
              setState(() {
                if (selectedValue == FilterOptions.Favorites) {
                  _showOnlyFavorites = true;
                } else {
                  _showOnlyFavorites = false;
                }
              });
            },
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text(
                  'Only Favorites',
                ),
                value: FilterOptions.Favorites,
              ),
              PopupMenuItem(
                child: Text(
                  'Show All',
                ),
                value: FilterOptions.All,
              ),
            ],
          ),
          Consumer<ShoppingCartProvider>(
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
              icon: Icon(
                Icons.shopping_cart,
              ),
            ),
            builder: (_, cartData, ch) => Badge(
              child: ch,
              value: cartData.itemCount.toString(),
            ),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ProductsGrid(_showOnlyFavorites),
    );
  }
}
