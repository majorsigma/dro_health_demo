import 'package:dro_health_home_task/models/cart_item.dart';
import 'package:dro_health_home_task/models/cart_item_response.dart';
import 'package:dro_health_home_task/models/category.dart';
import 'package:dro_health_home_task/models/product.dart';

class DroRepository {
  // List of hardcorded categories
  static List<Category> categories = [
    Category(
      id: 1,
      title: "Headache",
      imageSource: "assets/images/headache.jpeg",
    ),
    Category(
      id: 2,
      title: "Supplements",
      imageSource: "assets/images/supplements.jpg",
    ),
    Category(
      id: 3,
      title: "Infants",
      imageSource: "assets/images/baby_boy.jpg",
    ),
    Category(
      id: 4,
      title: "Cough",
      imageSource: "assets/images/coughing_guy.webp",
    )
  ];

  // List of products
  static List<Product> products =  [
    Product(
        id: 1,
        name: "Paracetamol",
        type: "Tablet",
        mass: "500",
        price: 350,
        imageSource: "assets/images/emzor_paracetamol.jpeg",
        manufacturer: "Emzor Pharmaceuticals",
        manufacturerLogo: "assets/images/emzor.png"),
    Product(
        id: 2,
        name: "Doliprane",
        type: "Capsule",
        mass: "1000",
        price: 1150,
        imageSource: "assets/images/doliprane_paracetamol.jpeg",
        manufacturer: "Dolaprane",
        manufacturerLogo: "assets/images/dolaprine.png"),
    Product(
      id: 3,
      name: "Paracetamol",
      type: "Tablet",
      mass: "500",
      price: 500,
      imageSource: "assets/images/ratiopharm_paracetamol.jpg",
      manufacturer: "Ratiopharm",
      manufacturerLogo: "assets/images/ratiopharm_paracetamol.jpg",
    ),
    Product(
      id: 4,
      name: "Ibuprofen",
      type: "Tablet",
      mass: "200",
      price: 700,
      imageSource: "assets/images/ibuprofen.jpg",
      manufacturer: "Numark",
      manufacturerLogo: "assets/images/numark.png",
    ),
    Product(
      id: 5,
      name: "Panadol",
      type: "Tablet",
      mass: "500",
      price: 350,
      imageSource: "assets/images/panadol_extra.jpeg",
      manufacturer: "gsk",
      manufacturerLogo: "assets/images/gsk.png",
    ),
    Product(
      id: 6,
      name: "Ibuprofen",
      type: "Tablet",
      mass: "400",
      price: 500,
      imageSource: "assets/images/ibuprofen-2.jpeg",
      manufacturer: "Numark",
      manufacturerLogo: "assets/images/numark.png",
    ),
    Product(
      id: 6,
      name: "Emzor Paracetamol",
      type: "Syrup",
      mass: "400",
      price: 900,
      imageSource: "assets/images/paracetamol_syrup.png",
       manufacturer: "Emzor Pharmaceuticals",
        manufacturerLogo: "assets/images/emzor.png"
    ),
  ];

  static final List<CartItem> cartItems = [];

  /// Fetch call Dro Health Product categories and return them as a future.
  static Future<List<Category>?> fetchAllCategories() {
    // simulates the fetching of categories from the server
    return Future.delayed(
      const Duration(seconds: 3),
      () => categories,
    );
  }

  /// Fetch call Dro Health Products. A Future of products is returned
  static fetchAllProducts() {
    // simulates the fetching of all products from the server
    return Future.delayed(
      const Duration(seconds: 3),
      () => products,
    );
  }

  static Future<List<CartItem>?> fetchAllCartItems() {
    return Future.delayed(
      const Duration(seconds: 0),
      () => cartItems,
    );
  }

  static Future<CartItemResponse> addItemToCart(CartItem cartItem) {
    return Future.delayed(
      const Duration(seconds: 0),
      () {
        if (cartItems.contains(cartItem)) {
          final cartItemsResponse =
              CartItemResponse(status: "error", cartItems: cartItems);
          return cartItemsResponse;
        } else {
          cartItems.add(cartItem);
          final cartItemsResponse =
              CartItemResponse(status: "success", cartItems: cartItems);
          return cartItemsResponse;
        }
      },
    );
  }

  static Future<List<CartItem>?> removeItemFromCart(CartItem cartItem) {
    return Future.delayed(
      const Duration(seconds: 0),
      () {
        cartItems.remove(cartItem);

        return cartItems;
      },
    );
  }

  static searchForProduct({required String searchTerm}) {
    return Future.delayed(
      const Duration(seconds: 0),
      () {
        final searchResult = products.where(
          (product) {
            return product.name!
                .toLowerCase()
                .contains(searchTerm.toLowerCase());
          },
        ).toList();

        return searchResult;
      },
    );
  }
}
