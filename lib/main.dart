import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens/product_detail_screen.dart';
import './providers/products_provider.dart';
import './providers/shopping_cart_provider.dart';
import './screens/cart_screen.dart';
import './providers/orders_provider.dart';
import './screens/orders_screen.dart';
import './screens/user_products_screen.dart';
import './screens/edit_product_screen.dart';
import './screens/auth_screen.dart';
import './screens/products_overview_screen.dart';
import './providers/auth_provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: AuthProvider(),
        ),
        ChangeNotifierProxyProvider<AuthProvider, ProductsProvider>(
          update: (ctx, auth, previousProducts) => ProductsProvider(
            auth.token,
            auth.userId,
            previousProducts == null ? [] : previousProducts.items,
          ),
          create: (_) => ProductsProvider('', '', []), //forma empanadoza de funcionar
        ),
        ChangeNotifierProxyProvider<AuthProvider, OrdersProvider>(
          update: (ctx, auth, previousProducts) => OrdersProvider(
            auth.token,
            auth.userId,
            previousProducts == null ? [] : previousProducts.orders,
          ),
          create: (_) => OrdersProvider('', '', []), //forma empanadoza de funcionar
        ),
        ChangeNotifierProvider.value(
          value: ShoppingCartProvider(),
        ),
      ],
      child: Consumer<AuthProvider>(
        builder: (ctx, authData, _) => MaterialApp(
          title: 'MyShop',
          theme: ThemeData(
            primarySwatch: Colors.purple,
            accentColor: Colors.deepOrange,
            fontFamily: 'Lato',
          ),
          home: authData.isAuth ? ProductOverviewScreen() : AuthScreen(),
          routes: {
            ProductOverviewScreen.routeName: (ctx) => ProductOverviewScreen(),
            ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
            CartScreen.routeName: (ctx) => CartScreen(),
            OrdersScreen.routeName: (ctx) => OrdersScreen(),
            UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
            EditProductScreen.routeName: (ctx) => EditProductScreen(),
            AuthScreen.routeName: (ctx) => AuthScreen(),
          },
        ),
      ),
    );
  }
}
