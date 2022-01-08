import 'package:api_to_sqlite/src/pages/home_page.dart';
import 'package:flutter/material.dart';

class WelcomePage extends StatelessWidget {
  Color button_color = const Color.fromARGB(255, 254, 84, 74);
  Color second_color = const Color.fromARGB(255, 250, 137, 25);
  Color shadow_color = const Color.fromARGB(150, 254, 84, 74);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        //color: Colors.black,
          
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            stops: [
              0, 
              0.45, 
              0.90, 
            ],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Color(0xFF8887e8), 
              Color(0xFFcb228b), 
              Color(0xFFf69309), 
            ],
          )
        ),
        child: Stack(
          children: [
            // Positioned.fill(
            //   child: Image.asset('assets/imgs/background1.jpg', fit: BoxFit.cover),
            // ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(50.0)),
                    child: Container(
                      width: 300,
                      height: 70,
                      //color: button_color,
                      alignment: Alignment.center,
                      child: const Text(
                        'Marc Chamorro Mollon',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                        ),
                      ),
                      decoration: BoxDecoration(                      
                        gradient: LinearGradient(colors: [button_color, second_color]),
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  const Text(
                    'API & SQLite Application',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const Text(
                    'Salesians de Sarria 2021-2022',
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 40),
                  Padding(
                    padding: const EdgeInsets.all(1),
                    child: SizedBox(
                      height: 50,
                      width: 200,
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const HomePage()),
                          );
                        },
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.all(10),
                          backgroundColor: Colors.transparent,
                          elevation: 4,//MaterialStateProperty.all(3), //Defines Elevation
                          shadowColor: shadow_color,//MaterialStateProperty.all(color), //Defines sh
                          primary: button_color,
                          side: BorderSide(
                             width: 5.0,
                             color: button_color
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                        child: const Text(
                          'API',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Padding(
                  //   padding: const EdgeInsets.all(1),
                  //   child: SizedBox(
                  //     height: 50,
                  //     width: 200,
                  //     child: TextButton(
                  //       onPressed: () {
                  //         Navigator.push(
                  //           context,
                  //           MaterialPageRoute(builder: (context) => const HomePage()),
                  //         );
                  //       },
                  //       style: TextButton.styleFrom(
                  //         padding: const EdgeInsets.all(10),
                  //         backgroundColor: Colors.transparent,
                  //         primary: button_color,
                  //         side: BorderSide(
                  //            width: 5.0,
                  //            color: button_color
                  //         ),
                  //         shape: RoundedRectangleBorder(
                  //           borderRadius: BorderRadius.circular(50),
                  //         ),
                  //       ),
                  //       child: const Text(
                  //         'API',
                  //         style: TextStyle(
                  //           color: Colors.white,
                  //           fontSize: 15.0,
                  //           fontWeight: FontWeight.bold,
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ],
        ),
      )
    );
  }
}

// import 'package:api_to_sqlite/src/pages/home_page.dart';
// import 'package:flutter/material.dart';

// class WelcomePage extends StatelessWidget {
//   Color button_color = const Color.fromARGB(200, 184, 255, 5);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         color: Colors.black,
//         child: Stack(
//           children: [
//             Positioned.fill(
//               child: Image.asset('assets/imgs/background1.jpg', fit: BoxFit.cover),
//             ),
//             Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   ClipRRect(
//                     borderRadius: const BorderRadius.all(Radius.circular(50.0)),
//                     child: Container(
//                       width: 300,
//                       height: 70,
//                       color: button_color,
//                       alignment: Alignment.center,
//                       child: const Text(
//                         'Marc Chamorro Mollon',
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 20.0,
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 40),
//                   const Text(
//                     'API & SQLite Application',
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                     ),
//                   ),
//                   const Text(
//                     'Salesians de Sarria 2021-2022',
//                     style: TextStyle(
//                       fontWeight: FontWeight.normal,
//                       color: Colors.white,
//                     ),
//                   ),
//                   const SizedBox(height: 40),
//                   Padding(
//                     padding: const EdgeInsets.all(20),
//                     child: SizedBox(height: 50, width: 200,
//                       child: TextButton(
//                         onPressed: () {},
//                         style: TextButton.styleFrom(
//                           padding: const EdgeInsets.all(10),
//                           backgroundColor: button_color,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(50),
//                           ),
//                         ),
//                         child: const Text(
//                           'API',
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 15.0,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.all(1),
//                     child: SizedBox(height: 50, width: 200,
//                       child: TextButton(
//                         onPressed: () {},
//                         style: TextButton.styleFrom(
//                           padding: const EdgeInsets.all(10),
//                           backgroundColor: Colors.transparent,
//                           side: const BorderSide(
//                             width: 5.0,
//                             color: Colors.blue
//                           ),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(50),
//                           ),
//                         ),
//                         child: const Text(
//                           'API',
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 15.0,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             )
//           ],
//         ),
//       )
//     );
//   }
// }
