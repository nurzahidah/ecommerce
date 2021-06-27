import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/constants.dart';
import 'package:e_commerce/services/firebase_services.dart';
import 'package:e_commerce/widgets/custom_input.dart';
import 'package:e_commerce/widgets/product_card.dart';
import 'package:flutter/material.dart';

class SearchTab extends StatefulWidget {
  @override
  _SearchTabState createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  FireBaseServices _fireBaseServices = FireBaseServices();
  String _searchString = "";

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          if (_searchString.isEmpty)
            Center(
              child: Container(
                  child: Text(
                "Search Results",
                style: Constants.regularDarkText,
                ),
              ),
            )
          else
            FutureBuilder<QuerySnapshot>(
                future: _fireBaseServices.productsRef
                    .orderBy("search_string")
                    .startAt([_searchString]).endAt(
                        ["$_searchString\uf8ff"]).get(),
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
                        top: 120.0,
                        bottom: 12.0,
                      ),
                      children: snapshot.data.docs.map((document) {
                        return ProductCard(
                          title: document.data()['name'],
                          imageUrl: document.data()['images'][0],
                          price: "\RM${document.data()['price']}",
                          productId: document.id,
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
          Padding(
            padding: const EdgeInsets.only(
              top: 40.0,
            ),
            child: CustomInput(
              hintText: "Search Here",
              onSubmitted: (value) {
                  setState(() {
                    _searchString = value.toLowerCase();
                  });
              },
            ),
          ),
        ],
      ),
    );
  }
}
