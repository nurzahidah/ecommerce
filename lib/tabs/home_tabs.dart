import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/constants.dart';
import 'package:e_commerce/screens/product_page.dart';
import 'package:e_commerce/widgets/custom_action_bar.dart';
import 'package:e_commerce/widgets/product_card.dart';
import 'package:flutter/material.dart';

class HomeTab extends StatelessWidget {
  final CollectionReference _productsRef =
      FirebaseFirestore.instance.collection("Products");
  
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
         FutureBuilder<QuerySnapshot>(
           future: _productsRef.get(),
           builder: (context, snapshot){
             if (snapshot.hasError){
               return Scaffold(
                 body: Center(
                   child: Text("Error: ${snapshot.error}"),
                 ),
               );
             }

             //collection Data ready to display
             if(snapshot.connectionState == ConnectionState.done){
               //display the data inside a list view
               return ListView(
                 padding: EdgeInsets.only(
                   top: 100.0,
                   bottom: 12.0,
                 ),
                 children: snapshot.data.docs.map((document){
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
         }
         ),
          CustomActionBar(
            hasBackArrow: false,
            title: "Home",
          ),
        ],
      ),
    );
  }
}
