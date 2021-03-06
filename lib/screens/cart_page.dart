import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/constants.dart';
import 'package:e_commerce/screens/product_page.dart';
import 'package:e_commerce/services/firebase_services.dart';
import 'package:e_commerce/widgets/custom_action_bar.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  FireBaseServices _fireBaseServices = FireBaseServices();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: new Container(
        color: Colors.white,
        child: Row(
          children: <Widget>[
            Expanded(
                child: ListTile(
              title: new Text("Total:"),
              subtitle: new Text("\RM200"),
            )),
            Expanded(
              child: new MaterialButton(
                onPressed: () {},
                child: new Text(
                  "Check out",
                  style: TextStyle(color: Colors.white),
                ),
                color: Colors.red,
              ),
            )
          ],
        ),
      ),
      body: Stack(
        children: [
          FutureBuilder<QuerySnapshot>(
              future: _fireBaseServices.usersRef
                  .doc(_fireBaseServices.getUserId())
                  .collection("Cart")
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Scaffold(
                    body: Center(
                      child: Text("Error: ${snapshot.error}"),
                    ),
                  );
                }

                //collection Data ready to display
                if (snapshot.connectionState == ConnectionState.done) {
                  //display the data inside a list view
                  return ListView(
                    padding: EdgeInsets.only(
                      top: 100.0,
                      bottom: 12.0,
                    ),
                    children: snapshot.data.docs.map((document) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProductPage(
                                        productId: document.id,
                                      )));
                        },
                        child: FutureBuilder(
                          future: _fireBaseServices.productsRef
                              .doc(document.id)
                              .get(),
                          builder: (context, productSnap) {
                            if (productSnap.hasError) {
                              return Container(
                                child: Center(
                                  child: Text("${productSnap.error}"),
                                ),
                              );
                            }
                            if (productSnap.connectionState ==
                                ConnectionState.done) {
                              Map _productMap = productSnap.data.data();
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16.0,
                                  horizontal: 24.0,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 90,
                                      height: 90,
                                      child: ClipRRect(
                                        borderRadius:
                                        BorderRadius.circular(8.0),
                                        child: Image.network(
                                          "${_productMap['images'][0]}",
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(
                                        left: 16.0,
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.start,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "${_productMap['name']}",
                                            style: TextStyle(
                                                fontSize: 18.0,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 4.0,
                                            ),
                                            child: Text(
                                              "\RM${_productMap['price']}",
                                              style: TextStyle(
                                                  fontSize: 16.0,
                                                  color: Theme
                                                      .of(context)
                                                      .accentColor,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                          Text(
                                            "Size - ${document.data()['size']}",
                                            style: TextStyle(
                                                fontSize: 16.0,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ],
                                      ),
                                    ),

                                  ],
                                ),
                              );
                            }
                            return Container(
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            );
                          },
                        ),
                      );
                    }).toList(),
                  );
                }

                //loading state
                return Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }),
          CustomActionBar(
            hasBackArrow: true,
            title: "Cart",
          ),
        ],
      ),
    );
  }
}
