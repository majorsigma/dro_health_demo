import 'package:dro_health_home_task/bloc/cart/cart_bloc.dart';
import 'package:dro_health_home_task/bloc/search/search_bloc.dart';
import 'package:dro_health_home_task/models/cart_item.dart';
import 'package:dro_health_home_task/utils/dro_utils.dart';
import 'package:dro_health_home_task/widgets/dro_favorite_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import 'package:dro_health_home_task/models/product.dart';
import 'package:dro_health_home_task/utils/dro_colors.dart';
import 'package:dro_health_home_task/widgets/delivery_location.dart';
import 'package:dro_health_home_task/widgets/search_field.dart';

class SearchPage extends StatefulWidget {
  final String searchTerm;
  const SearchPage({
    Key? key,
    required this.searchTerm,
  }) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.text = widget.searchTerm;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CartBloc, CartState>(
      listener: (context, state) {
        if (state is CartItemAddedFailedState) {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: DroColors.purple,
              content: const Text(
                "Item already exist in your cart",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          );
        }
      },
      child: Scaffold(
        appBar: _buildAppBar(),
        body: Column(
          children: [
            const DeliveryLocationWidget(),
            Expanded(
              child: Container(
                color: Colors.white,
                child: ListView(
                  shrinkWrap: true,
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                  children: [
                    BlocBuilder<SearchBloc, SearchState>(
                      builder: (context, state) {
                        if (state is SearchSuccessfulState) {
                          final products = state.searchResult;

                          if (products.isEmpty) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset("assets/images/error404.png"),
                                Text(
                                  "No result found for \"${_controller.text}\"",
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            );
                          }

                          return GridView.count(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisCount: 2,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 20,
                            childAspectRatio:
                                MediaQuery.of(context).orientation ==
                                        Orientation.portrait
                                    ? 0.62
                                    : 1.1,
                            children: List.generate(
                              products.length,
                              (index) {
                                final product = products[index];
                                return _buildAddToCardContainer(product);
                              },
                            ),
                          );
                        } else if (state is SearchLoadingState) {
                          return GridView.count(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisCount: 2,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 20,
                            childAspectRatio: .62,
                            children: List.generate(3, (index) {
                              return DroUtils.buildShimmer(
                                width: 170,
                                height: 200,
                                borderRadius: BorderRadius.circular(10),
                              );
                            }),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    )
                  ],
                ),
              ),
            )
          ],
        ),
        floatingActionButton: _buildFAB(),
      ),
    );
  }

  Widget _buildFAB() {
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        if (state is CartSuccessfulState) {
          final cartItems = state.cartItems;

          if (cartItems.isEmpty) {
            return _buildEmptyCartWidget();
          } else {
            return InkWell(
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(color: Colors.white, width: 3),
                      gradient: const LinearGradient(
                        tileMode: TileMode.mirror,
                        stops: [0.1, 0.7],
                        colors: [
                          Color(0xFFFE806F),
                          Color(0xFFE5366A),
                        ],
                      ),
                    ),
                    child: const Icon(
                      Icons.shopping_cart_outlined,
                      color: Colors.white,
                    ),
                  ),
                  Positioned(
                    top: -6,
                    right: 8,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: DroColors.yellow,
                      ),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Text(
                            cartItems.length.toString(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              onTap: () =>
                  Navigator.of(context).pushReplacementNamed('/cart_page'),
            );
          }
        }
        return _buildEmptyCartWidget();
      },
    );
  }

  Container _buildEmptyCartWidget() {
    return Container(
      width: 50,
      height: 50,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: Colors.white, width: 3),
        gradient: const LinearGradient(
          tileMode: TileMode.mirror,
          stops: [0.1, 0.7],
          colors: [
            Color(0xFFFE806F),
            Color(0xFFE5366A),
          ],
        ),
      ),
      child: const Icon(Icons.shopping_cart_outlined, color: Colors.white),
    );
  }

  Container _buildAddToCardContainer(Product product) {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(196, 196, 196, 1.1),
            offset: Offset(0, 6),
            blurRadius: 6,
            spreadRadius: 3,
          )
        ],
      ),
      child: Column(
        children: [
          Image.asset(
            product.imageSource.toString(),
            height: 125,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10.0,
                  vertical: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name.toString(),
                      maxLines: 2,
                      softWrap: true,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          product.type.toString(),
                          style: const TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 6.0,
                          ),
                          child: Icon(
                            Icons.circle,
                            size: 6,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          "${product.mass.toString()} mg",
                          style: const TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            SvgPicture.asset(
                              "assets/icons/naira.svg",
                            ),
                            Text(
                              NumberFormat.simpleCurrency(
                                decimalDigits: 2,
                                name: "",
                              ).format(product.price),
                              style: const TextStyle(
                                color: Color(0xFF363636),
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const DroFavoriteButton(),
                      ],
                    ),
                    _buildAddToCardButton(product)
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Center _buildAddToCardButton(Product product) {
    return Center(
      child: TextButton(
        child: const Text(
          "ADD TO CART",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        style: ButtonStyle(
          padding: MaterialStateProperty.all(
            const EdgeInsets.symmetric(horizontal: 28),
          ),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(
                color: DroColors.purple,
                width: 3,
              ),
            ),
          ),
        ),
        onPressed: () {
          final item = CartItem(
            product: product,
            quantity: 1,
          );
          BlocProvider.of<CartBloc>(context).add(
            AddItemToCartEvent(cartItem: item),
          );
        },
      ),
    );
  }

  PreferredSize _buildAppBar() {
    return PreferredSize(
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
          image: DecorationImage(
            image: AssetImage(
              "assets/images/app_bar.png",
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(
            top: 58.0,
            left: 24,
            right: 24,
            bottom: 20,
          ),
          child: Column(
            children: [
              Row(
                children: [
                  InkWell(
                    child: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                    ),
                    onTap: () => Navigator.of(context).pop(),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Pharmarcy",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Stack(
                          children: [
                            Image.asset("assets/icons/truck.png"),
                            Positioned(
                              top: 0,
                              right: 2,
                              child: Container(
                                height: 7,
                                width: 7,
                                decoration: BoxDecoration(
                                  color: DroColors.yellow,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: SearchField(controller: _controller)),
                  const SizedBox(width: 20),
                  BlocBuilder<SearchBloc, SearchState>(
                    builder: (context, state) {
                      if (state is SearchSuccessfulState) {
                        final result = state.searchResult;
                        if (result.isEmpty) {
                          return const Text(
                            "Cancel",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          );
                        } else {
                          return const SizedBox(width: 50);
                        }
                      }
                        return const SizedBox(width: 50);
                    },
                  )
                ],
              ),
            ],
          ),
        ),
      ),
      preferredSize: const Size.fromHeight(150),
    );
  }
}
