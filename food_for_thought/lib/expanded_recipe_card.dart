import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:expandable/expandable.dart';

class ExpandedRecipeCard extends StatelessWidget {
  final String title;
  final int servings;
  final List<dynamic> ingredients;
  final String preparationSteps;
  final int cookTime;
  final String thumbnailUrl;
  ExpandedRecipeCard({
    required this.title,
    required this.servings,
    required this.ingredients,
    required this.preparationSteps,
    required this.cookTime,
    required this.thumbnailUrl,
  });
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Card(
        elevation: 0,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 18, vertical: 20),
          width: MediaQuery.of(context).size.width,
          height: 300,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.6),
                offset: Offset(
                  0.0,
                  10.0,
                ),
                blurRadius: 10.0,
                spreadRadius: -6.0,
              ),
            ],
            image: DecorationImage(
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.35),
                BlendMode.multiply,
              ),
              image: NetworkImage(thumbnailUrl),
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.0),
                  child: Text(
                    title,
                    style: TextStyle(
                        fontSize: 19,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.all(5),
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 18,
                          ),
                          SizedBox(width: 7),
                          Text(
                            'Serves $servings',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(5),
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.schedule,
                            color: Colors.white,
                            size: 18,
                          ),
                          SizedBox(width: 7),
                          Text('$cookTime minutes',
                              style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // back: Container(
        //     margin: EdgeInsets.symmetric(horizontal: 18, vertical: 20),
        //     width: MediaQuery.of(context).size.width,
        //     height: 300,
        //     decoration: BoxDecoration(
        //       color: Colors.white,
        //       borderRadius: BorderRadius.circular(15),
        //       boxShadow: [
        //         BoxShadow(
        //           color: Colors.black.withOpacity(0.6),
        //           offset: Offset(
        //             0.0,
        //             10.0,
        //           ),
        //           blurRadius: 10.0,
        //           spreadRadius: -6.0,
        //         ),
        //       ],
        //     ),
        //     child: SingleChildScrollView(
        //       child: Column(
        //         children: [
        //           Center(
        //             child: Padding(
        //               padding:
        //                   EdgeInsets.symmetric(horizontal: 5.0, vertical: 10),
        //               child: Container(
        //                 width: 300,
        //                 child: Text(
        //                   title,
        //                   style: TextStyle(
        //                       fontSize: 22,
        //                       color: Colors.black,
        //                       fontWeight: FontWeight.bold),
        //                   overflow: TextOverflow.ellipsis,
        //                   maxLines: 2,
        //                   textAlign: TextAlign.center,
        //                 ),
        //               ),
        //             ),
        //           ),
        //           Container(
        //             height: 175,
        //             width: 275,
        //             decoration: BoxDecoration(
        //               color: Colors.black,
        //               borderRadius: BorderRadius.circular(15),
        //               boxShadow: [
        //                 BoxShadow(
        //                   color: Colors.black.withOpacity(0.6),
        //                   offset: Offset(
        //                     0.0,
        //                     10.0,
        //                   ),
        //                   blurRadius: 10.0,
        //                   spreadRadius: -6.0,
        //                 ),
        //               ],
        //               image: DecorationImage(
        //                 colorFilter: ColorFilter.mode(
        //                   Colors.black.withOpacity(0.35),
        //                   BlendMode.multiply,
        //                 ),
        //                 image: NetworkImage(thumbnailUrl),
        //                 fit: BoxFit.cover,
        //               ),
        //             ),
        //           ),
        //           Column(
        //             children: [
        //               Text(
        //                 '\nIngredients',
        //                 style: TextStyle(
        //                     fontWeight: FontWeight.bold,
        //                     fontSize: 18,
        //                     decoration: TextDecoration.underline),
        //               ),
        //               SizedBox(
        //                 height: 20,
        //               ),
        //               for (int i = 1; i <= ingredients.length - 1; i++) ...[
        //                 Container(
        //                   width: 200,
        //                   child: Text(("$i. ${ingredients[i]['original']}\n"),
        //                       style: TextStyle()),
        //                 )
        //               ],
        //               Text(
        //                 '\nPreparation Steps',
        //                 style: TextStyle(
        //                     fontWeight: FontWeight.bold,
        //                     fontSize: 18,
        //                     decoration: TextDecoration.underline),
        //               ),
        //               SizedBox(
        //                 height: 15,
        //               ),
        //               Container(
        //                 width: 350,
        //                 child: Html(
        //                   data: preparationSteps,
        //                 ),
        //               ),
        //               SizedBox(
        //                 height: 15,
        //               ),
        //             ],
        //           ),
        //         ],
        //       ),
        //     )),
      ),
    );
  }
}
