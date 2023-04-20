import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_html/flutter_html.dart';

class AboutUs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(8))),
        backgroundColor: Color.fromARGB(255, 244, 4, 4),
        toolbarHeight: 40,
        centerTitle: true,
        title: Text(
          'About Us',
          style: TextStyle(
              color: Color.fromARGB(255, 247, 247, 247), fontSize: 20),
        ),
        automaticallyImplyLeading: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Divider(
              thickness: 1,
              color: Colors.grey,
            ),
            SizedBox(
              height: 20,
            ),
            CarouselSlider(
              options: CarouselOptions(height: 400.0),
              items: [
                body(context),
                gavin(context),
                tyler(context),
                jaideep(context),
                waheed(context)
              ].map((i) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.symmetric(horizontal: 5.0),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 151, 151, 151),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: i,
                    );
                  },
                );
              }).toList(),
            ),
            SizedBox(
              height: 20,
            ),
            Divider(
              thickness: 1,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  Container body(BuildContext context) {
    return Container(
        child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Text(
            'Welcome to Recipeal!',
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
          ),
          SizedBox(height: 15),
          SizedBox(height: 15),
          Text(
            'We are students at Wayne State University working on our Senior Capstone Project \n\n As someone who loves to cook, I know how frusterating and convoluted finding recipes has become. \n\nOur goal is to provide you with recipes of all types, in a quick and easy fashion. We hope to replace traditional recipe finding methods, and to become your personal cookbook. \n\nDevelopers: Gavin Fromm, Tyler Groat, Jaideep Chunduri, Waheedalam Laskar\n\nSchool: Wayne State University\n\nClass: CSC 4996 Section 010',
            style: TextStyle(
                fontSize: 15, color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    ));
  }

  Container gavin(BuildContext context) {
    return Container(
        child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Center(
        child: Column(
          children: [
            Text(
              'Gavin Fromm',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.white),
            ),
            SizedBox(height: 15),
            SizedBox(height: 15),
            Text(
              'Major: Computer Science \n\n Email: Gv5314@wayne.edu',
              style: TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    ));
  }

  Container tyler(BuildContext context) {
    return Container(
        child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Text(
            'Tyler Groat',
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
          ),
          SizedBox(height: 15),
          SizedBox(height: 15),
          Text(
            'Major: Computer Science \n\n Email: Gh5295@wayne.edu',
            style: TextStyle(
                fontSize: 15, color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    ));
  }

  Container jaideep(BuildContext context) {
    return Container(
        child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Text(
            'Jaideep Chunduri',
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
          ),
          SizedBox(height: 15),
          SizedBox(height: 15),
          Text(
            'Major: Computer Science \n\n Email: Gn8681@wayne.edu',
            style: TextStyle(
                fontSize: 15, color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    ));
  }

  Container waheed(BuildContext context) {
    return Container(
        child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Text(
            'Waheedalam Laskar',
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
          ),
          SizedBox(height: 15),
          SizedBox(height: 15),
          Text(
            'Major: Computer Science \n\n Email: Go3487@wayne.edu',
            style: TextStyle(
                fontSize: 15, color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    ));
  }
}


//-------------------------------------------
// Center body() {
//   return Center(
//     child: Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
//       ),
//       height: 500,
//       width: 375,
//       child: Card(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//         color: Color.fromARGB(255, 83, 83, 83),
//         child: Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: Column(
//             children: [
//               SizedBox(
//                 height: 10,
//               ),
//               Text(
//                 'Welcome to Recipeal!',
//                 style: TextStyle(
//                     fontSize: 24,
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold),
//               ),
//               SizedBox(
//                 height: 20,
//               ),
//               Text(
//                 'We are students at Wayne State University working on our Senior Capstone Project.',
//                 style: TextStyle(
//                     fontSize: 18,
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold),
//               ),
//               SizedBox(
//                 height: 20,
//               ),
//               Text(
//                 'As someone who loves to cook, I know how frusterating and convoluted finding recipes has become. Our goal is to provide you with recipes of all types, in a quick and easy fashion.',
//                 style: TextStyle(
//                     fontSize: 18,
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold),
//               ),
//               SizedBox(
//                 height: 20,
//               ),
//               Text(
//                 'We hope to replace traditional recipe finding methods, and to become your personal cookbook.',
//                 style: TextStyle(
//                     fontSize: 18,
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold),
//               ),
//               SizedBox(
//                 height: 20,
//               ),
//               Text(
//                 'Developers: Gavin Fromm, Tyler Groat, Jaideep Chunduri, Waheedalam Laskar',
//                 style: TextStyle(
//                     fontSize: 18,
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold),
//               ),
//               SizedBox(
//                 height: 10,
//               ),
//               Text(
//                 'School: Wayne State University',
//                 style: TextStyle(
//                     fontSize: 18,
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold),
//               ),
//               SizedBox(
//                 height: 5,
//               ),
//               Text(
//                 'Class: CSC 4996 Section 010',
//                 style: TextStyle(
//                     fontSize: 18,
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold),
//               ),
//             ],
//           ),
//         ),
//       ),
//     ),
//   );
// }

// AppBar appBar() {
//   return AppBar(
//     shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(bottom: Radius.circular(8))),
//     backgroundColor: Color.fromARGB(255, 244, 4, 4),
//     toolbarHeight: 40,
//     centerTitle: true,
//     title: Text(
//       'About Us',
//       style: TextStyle(color: Color.fromARGB(255, 247, 247, 247), fontSize: 20),
//     ),
//     automaticallyImplyLeading: true,
//   );
// }
