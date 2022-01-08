// ignore_for_file: unnecessary_const

//import 'dart:html';

import 'package:api_to_sqlite/src/models/employee_model.dart';
import 'package:api_to_sqlite/src/providers/db_provider.dart';
import 'package:api_to_sqlite/src/providers/employee_api_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var isLoading = false;
  String search_value = "", email_value = "", name_value = "", lastname_value = "", avatar_value = "";
  bool custom = false, _selectedinicialitzat = true, _llistaInicialitzada = false;
  List<List<int>> _selected = [];

  Color button_color = const Color.fromARGB(255, 254, 84, 74);
  Color second_color = const Color.fromARGB(255, 250, 137, 25);

  //final List<int> _list = List.generate(20, (i) => i);
  //final List<bool> _selected;// = List.generate(20, (i) => false); // Fill it with false initially
  //List<bool> _selected = List.generate(snapshot.data.length, (i) => false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Api to sqlite'),
        centerTitle: true,
        /*backgroundColor:*/
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                button_color,
                second_color,
              ],
            )          
          ),
        ),
        actions: <Widget>[
          Container(
            padding: const EdgeInsets.only(right: 10.0),
            child: IconButton(
              icon: const Icon(Icons.settings_input_antenna),
              onPressed: () async {
                await _loadFromApi();
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.only(right: 10.0),
            child: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () async {
                await _deleteData();
              },
            ),
          ),
        ],
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                valueColor:AlwaysStoppedAnimation(button_color /*Color.fromARGB(255, 34, 34, 34)*/),
                //backgroundColor: button_color,
              ),
            )
          : _cutomsearch(custom),
          backgroundColor: const Color.fromARGB(255, 245, 245, 245),
          //_selectedinicialitzat = false,
          ////////////////////////////////////////////////////////////////////////
          ///        FIX THIS BOOL VALUE
          ////////////////////////////////////////////////////////////////////////
          //reset search value

      floatingActionButtonLocation: 
      FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: second_color,
        child: Icon(_returnicon(),/*Icons.add*/), onPressed: () {_returnscreen(context);},),
      bottomNavigationBar: BottomAppBar(
        color: button_color,
        shape: const CircularNotchedRectangle(),
        notchMargin: 4.0,
        //gradient at this moment is not working for this version of flutter
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                _setVariablestoZero();
                //DBProvider.db.getAllEmployees();
                setState(() {});
              },
            ),
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () async {
                await _showTodoSearchSheet(context);
              },
            ),
          ],
        ),
      ),
      // bottomNavigationBar: BottomAppBar(
      //   child: Row(
      //     mainAxisSize: MainAxisSize.max,
      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //     children: <Widget>[
      //       IconButton(icon: const Icon(Icons.menu), onPressed: () {},),
      //       IconButton(icon: const Icon(Icons.search), onPressed: () {},),
      //     ],
      //   ),
      // ),
    );
  }

  // _closevariable() {
  //   _selectedinicialitzat = false;
  // }

  IconData _returnicon() {
    //_selected check if it has any values

    bool sortir = false;
    for (var i = 0; i < _selected.length && sortir == false; i++) {
      if (_selected[i][0] == 1) {
        sortir = true;
      }
    }

    if (sortir) {
      return Icons.delete;
    }
    return Icons.add;
  }

  _loadFromApi() async {
    setState(() {
      isLoading = true;
    });

    custom == false;
    var apiProvider = EmployeeApiProvider();
    await apiProvider.getAllEmployees();

    // wait for 2 seconds to simulate loading of data
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      isLoading = false;
    });
  }

  _deleteData() async {
    setState(() {
      isLoading = true;
    });

    await DBProvider.db.deleteAllEmployees();

    // wait for 1 second to simulate loading of data
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      isLoading = false;
    });

    // ignore: avoid_print
    print('All employees deleted');
  }

  _cutomsearch(bool custom) {
    if (custom == false || search_value == "") {

      return _buildEmployeeListView();

    } else if (custom == true) {

      //custom == false;
      return _buildEmployeeListViewQuery(search_value);
    }
  }

  _buildEmployeeListView() {
    return FutureBuilder(
      future: DBProvider.db.getAllEmployees(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              valueColor:AlwaysStoppedAnimation(button_color /*Color.fromARGB(255, 34, 34, 34)*/),
              //backgroundColor: button_color,
            ),
          );
        } else if (snapshot.data.length == 0) {
          return Center(
            child: Image.asset('assets/imgs/DataNotFound.png', width: 100, height: 100, color: button_color,),//Text("No Data"),
          );
        } else {

          // if (custom == false) {
          //   _selected = List.generate(snapshot.data.length, (i) => 0);
          //   custom == true;
          // }

          if (snapshot.data.length != _selected.length && custom == false) {
            //_selected = List.generate(snapshot.data.length, (i) => 0);
            _selected = List.generate(snapshot.data.length, (i) => List.filled(2, 0, growable: false), growable: true);
            _llistaInicialitzada = true;
          }

          return ListView.builder( //ListView.separated(itemBuilder: itemBuilder, separatorBuilder: separatorBuilder, itemCount: itemCount)
            // separatorBuilder: (context, index) => const Divider(
            //   color: Colors.black12,
            // ),
            itemCount: (snapshot.data.length),
            //itemExtent: 90,
            padding: const EdgeInsets.all(16),
            itemBuilder: (BuildContext context, int index) {
              // if (snapshot.data.length != _selected.length && custom == false) {
              //   _selected[index][1] = snapshot.data[index].id;
              // }
              for (var i = 0; i < snapshot.data.length && _llistaInicialitzada == true; i++) {
                _selected[i][1] = snapshot.data[i].id;
              }
              _llistaInicialitzada = false;
              return Container (
                height: 100,
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide()),
                  color: Colors.transparent,
                ),
                child: ListTile(
                  //Container(height: 5,),
                  //Divider(color: Colors.red,);
                  contentPadding: const EdgeInsets.fromLTRB(10.0, 6.0, 10.0, 6.0),
                  leading: Text(
                    "${index + 1}",
                    style: const TextStyle(fontSize: 20.0),
                  ),
                  title: Text("${snapshot.data[index].firstName} ${snapshot.data[index].lastName}"),
                  subtitle: Text('${snapshot.data[index].email}'),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                  //tileColor: _colorpicker(_selected[index]), //_selected[index] ? Colors.blue : Colors.transparent,

                  //tileColor: _selected[index] ? Colors.blue : null, // If current item is selected show blue color
                  //onTap: () => _selected[index] = !_selected[index], // Reverse bool value
                  //tileColor: isSelected ? Colors.blue : null,
                  //tileColor: _extracttruorfalse(snapshot.data[index].checkBox) ? Colors.blue : null, // If current item is selected show blue color
                  tileColor: _changecolor(_selected[index][0]), // If current item is selected show blue color
                  trailing: _changeIcon(_selected[index][0]),
                  //onTap: () => setState(() => snapshot.data[index].checkBox = _changeboolstate(context, snapshot.data[index].checkBox, snapshot.data[index].id)),
                  onTap: () => setState(() => _selected[index][0] = _changeboolstate(context, _selected[index][0])),
                  onLongPress: () async {_moreDetails(context, snapshot.data[index].firstName, snapshot.data[index].lastName, snapshot.data[index].avatar, snapshot.data[index].email);},
                  // onTap: () => setState(() => _selected[index] = !_selected[index]),
                ),
              );
              // return ListTile(
              //   //Divider(color: Colors.red,);
              //   contentPadding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 16.0),
              //   leading: Text(
              //     "${index + 1}",
              //     style: const TextStyle(fontSize: 20.0),
              //   ),
              //   title: Text("Name: ${snapshot.data[index].firstName} ${snapshot.data[index].lastName}"),
              //   subtitle: Text('EMAIL: ${snapshot.data[index].email}'),
              //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
              //   //tileColor: _colorpicker(_selected[index]), //_selected[index] ? Colors.blue : Colors.transparent,

              //   //tileColor: _selected[index] ? Colors.blue : null, // If current item is selected show blue color
              //   //onTap: () => _selected[index] = !_selected[index], // Reverse bool value
              //   //tileColor: isSelected ? Colors.blue : null,
              //   //tileColor: _extracttruorfalse(snapshot.data[index].checkBox) ? Colors.blue : null, // If current item is selected show blue color
              //   tileColor: _changecolor(_selected[index][0]), // If current item is selected show blue color
              //   trailing: _changeIcon(_selected[index][0]),
              //   //onTap: () => setState(() => snapshot.data[index].checkBox = _changeboolstate(context, snapshot.data[index].checkBox, snapshot.data[index].id)),
              //   onTap: () => setState(() => _selected[index][0] = _changeboolstate(context, _selected[index][0])),
                
              //   // onTap: () => setState(() => _selected[index] = !_selected[index]),
              // );
            }
          );

          /*return ListView.separated(
            separatorBuilder: (context, index) => const Divider(
              color: Colors.black12,
            ),
            itemCount: snapshot.data.length,
            itemBuilder: (BuildContext context, int index) {


              return ListTile(
                leading: Text(
                  "${index + 1}",
                  style: const TextStyle(fontSize: 20.0),
                ),
                title: Text(
                    "Name: ${snapshot.data[index].firstName} ${snapshot.data[index].lastName} "),
                subtitle: Text('EMAIL: ${snapshot.data[index].email}'),
              );
            },
          );*/
        }
      },
    );
  }

  _getIdFromExistingRecordsToList(List<List<int>> _selected) {
    //fer mes o menys el mateix que en: _buildEmployeeListViewQuery
    //select Id from Employee
    //return list with values

    Future<List<Employee?>> _temp = DBProvider.db.getAllEmployeesId();
    
    // if (_temp.) {
    //   for (var i = 0; i < _temp.length; i++) {
    //     _selected[i][1] = _temp[i];
    //   }
    //   return _selected;
    // } else {
    //   return const Center(
    //     child: CircularProgressIndicator(valueColor:AlwaysStoppedAnimation<Color>(Colors.red),),
    //   );
    // }

    //for(i) value in new list store in old list same position
    //use for (i) because foreach starts with order inverted
    //////////////////////////////////////////////////////////////////
    // return FutureBuilder(
    //   future: DBProvider.db.getAllEmployeesId(),
    //   builder: (BuildContext context, AsyncSnapshot snapshot) {
    //     if (!snapshot.hasData) {
    //       return const Center(
    //         child: CircularProgressIndicator(valueColor:AlwaysStoppedAnimation<Color>(Colors.red),),
    //       );
    //     } else {
    //       for (var i = 0; i < snapshot.data.; i++) {
            
    //       }
    //       itemCount: snapshot.data.length,
    //       itemBuilder: (BuildContext context, int index) {
    //         return ListTile(
    //           leading: Text(
    //             "${index + 1}",
    //             style: const TextStyle(fontSize: 20.0),
    //           ),
    //           title: Text("Name: ${snapshot.data[index].firstName} ${snapshot.data[index].lastName}"),
    //           subtitle: Text('EMAIL: ${snapshot.data[index].email}'),
    //           tileColor: _changecolor(_selected[snapshot.data[index].id-1][0]),
    //           onTap: () => setState(() => _selected[snapshot.data[index].id - 1][0] = _changeboolstate(context, _selected[snapshot.data[index].id - 1][0])),
    //         );
    //       },
    //     }
    //   },
    // );
  }

  void _setVariablestoZero() {
    //custom = false;
    _selectedinicialitzat = true;
    search_value = "";
    return;
  }

  Future _showTodoSearchSheet(BuildContext context) async {
    final _todoSearchDescriptionFormController = TextEditingController();
    showModalBottomSheet(
      context: context,
      builder: (builder) {
        return Padding(
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            color: const Color.fromARGB(255, 245, 245, 245),
            child: Container(
              height: 230,
              decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 245, 245, 245),
                  borderRadius: const BorderRadius.only(
                      topLeft: const Radius.circular(10.0),
                      topRight: const Radius.circular(10.0))),
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 15, top: 25.0, right: 15, bottom: 30),
                child: ListView(
                  children: <Widget>[
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: TextFormField(
                            cursorColor: button_color,
                            controller: _todoSearchDescriptionFormController,
                            textInputAction: TextInputAction.newline,
                            maxLines: 4,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w400),
                            autofocus: true,
                            decoration: InputDecoration(
                              hintText: 'Cercar en tot el llistat...',
                              labelText: 'Cercar',
                              labelStyle: TextStyle(
                                  color: button_color,
                                  fontWeight: FontWeight.w500),
                              enabledBorder: UnderlineInputBorder(      
                                borderSide: BorderSide(color: button_color),   
                              ),  
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: button_color),
                              ),
                              border: UnderlineInputBorder(
                                borderSide: BorderSide(color: button_color),
                              ),
                            ),
                            validator: (String? value) {
                              return value!.contains('@')
                                  ? 'No utilitzis el caràcter @.'
                                  : null;
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 5, top: 15),
                          child: CircleAvatar(
                            backgroundColor: button_color,
                            radius: 18,
                            child: IconButton(
                              icon: const Icon(
                                Icons.search,
                                size: 22,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                /*This will get all todos
                                that contains similar string
                                in the textform
                                */
                                search_value = _todoSearchDescriptionFormController.value.text;
                                // DBProvider.db.getAllEmployeesQuery(
                                //     query:
                                //         _todoSearchDescriptionFormController
                                //             .value.text);
                                //dismisses the bottomsheet
                                custom = true;
                                _selectedinicialitzat = true;
                                Navigator.pop(context);
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }
    );
  }

  void _returnscreen(BuildContext context) {
    bool sortir = false;

    for (var i = 0; i < _selected.length && sortir == false; i++) {
      if (_selected[i][0] == 1) {
        sortir = true;
      }
    }

    if (sortir) {
      return _showDeleteUser(context);
    }
    return _showAddNewUser(context);
  }

  void _showDeleteUser(BuildContext context) {
    Widget cancelButton = TextButton(
      child: Text("Cancel", style: TextStyle(color: button_color,),),
      onPressed: () {Navigator.pop(context);},
    );
    Widget continueButton = TextButton(
      child: Text("Continue", style: TextStyle(color: button_color,),),
      onPressed: () {
        _deleteSelectedUsers(context);
        _setVariablestoZero();
        setState(() {});
        Navigator.pop(context);
        setState(() {});
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text("Delete Users", style: TextStyle(color: button_color,),),
      content: Text("Would you like to delete all the selected users from the device?", style: TextStyle(color: second_color,),),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  _deleteSelectedUsers(BuildContext context) async {
    //no puc fer el foreach ja que els valors de quin usuari es cada un es la posicio del array
    // _selected.forEach((user_selected) {
    //   //funcio eliminar id usuari

    //   int j = DBProvider.db.deleteSelectedEmployee(user_selected);
    // });
    int total_sortides = 0;

    for (var i = 0; i < _selected.length; i++) {
      if (_selected[i][0] != 0) {
        _selected[i][0] = 2;
        custom = false;
        DBProvider.db.deleteSelectedEmployee(_selected[i][1]);

        List<String> temp = await DBProvider.db.getUserData(_selected[i][1]);

        var apiProvider = EmployeeApiProvider();
        Response outputinfo = await apiProvider.deleteEmployee(_selected[i][1], temp[0]/*email*/, temp[1]/*name*/, temp[2]/*surname*/, temp[3]/*avatar*/);

        if (outputinfo.statusCode == 200) {total_sortides++;}
      }
    }

    _alertDialogDelete(context, total_sortides);
  }

  void _showAddNewUser(BuildContext context) {
    final _userlistemail = TextEditingController();
    final _userlistfirstname = TextEditingController();
    final _userlistlastname = TextEditingController();
    final _avatar = TextEditingController();
    //FIX THIS BOOL
    custom = true;
    showModalBottomSheet<dynamic>(
      isScrollControlled: true,
      context: context,
      builder: (builder) {
        return Padding(
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            color: Colors.transparent,
            child: Container(
              height: 400,
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                      topLeft: const Radius.circular(10.0),
                      topRight: const Radius.circular(10.0))),
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 15, top: 15, right: 15, bottom: 15),
                child: ListView( 
                  children: <Widget>[
                    Text('Introdueix el nou Usuari', style: TextStyle(color: button_color, fontWeight: FontWeight.w500, fontSize: 18),),
                    //Column(
                      //mainAxisSize: MainAxisSize.max,
                      //mainAxisAlignment: MainAxisAlignment.start,
                      //crossAxisAlignment: CrossAxisAlignment.center,
                      //children: <Widget>[
                        Expanded(
                          child: TextFormField(
                            controller: _userlistemail,
                            textInputAction: TextInputAction.newline,
                            cursorColor: button_color,
                            maxLines: 2,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w400),
                            autofocus: true,
                            decoration: InputDecoration(
                              hintText: 'Correu Electronic',
                              labelText: 'Correu',
                              labelStyle: TextStyle(
                                  color: button_color,
                                  fontWeight: FontWeight.w500),
                              enabledBorder: UnderlineInputBorder(      
                                borderSide: BorderSide(color: button_color),   
                              ),  
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: button_color),
                              ),
                              border: UnderlineInputBorder(
                                borderSide: BorderSide(color: button_color),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: TextFormField(
                            controller: _userlistfirstname,
                            textInputAction: TextInputAction.newline,
                            cursorColor: button_color,
                            maxLines: 1,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w400),
                            autofocus: true,
                            decoration: InputDecoration(
                              hintText: 'Nom',
                              labelText: 'Nom',
                              labelStyle: TextStyle(
                                  color: button_color,
                                  fontWeight: FontWeight.w500),
                              enabledBorder: UnderlineInputBorder(      
                                borderSide: BorderSide(color: button_color),   
                              ),  
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: button_color),
                              ),
                              border: UnderlineInputBorder(
                                borderSide: BorderSide(color: button_color),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: TextFormField(
                            controller: _userlistlastname,
                            textInputAction: TextInputAction.newline,
                            cursorColor: button_color,
                            maxLines: 1,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w400),
                            autofocus: true,
                            decoration: InputDecoration(
                              hintText: 'Primer i/o Segon Cognom',
                              labelText: 'Cognom',
                              labelStyle: TextStyle(
                                  color: button_color,
                                  fontWeight: FontWeight.w500),
                              enabledBorder: UnderlineInputBorder(      
                                borderSide: BorderSide(color: button_color),   
                              ),  
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: button_color),
                              ),
                              border: UnderlineInputBorder(
                                borderSide: BorderSide(color: button_color),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: TextFormField(
                            controller: _avatar,
                            textInputAction: TextInputAction.newline,
                            cursorColor: button_color,
                            maxLines: 2,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w400),
                            autofocus: true,
                            decoration: InputDecoration(
                              hintText: 'Avatar Web Link',
                              labelText: 'Avatar',
                              labelStyle: TextStyle(
                                  color: button_color,
                                  fontWeight: FontWeight.w500),
                              enabledBorder: UnderlineInputBorder(      
                                borderSide: BorderSide(color: button_color),   
                              ),  
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: button_color),
                              ),
                              border: UnderlineInputBorder(
                                borderSide: BorderSide(color: button_color),
                              ),
                            ),
                            // validator: (String? value) {
                            //   return value!.contains('@')
                            //       ? 'No utilitzis el caràcter @.'
                            //       : null;
                            // },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 5, top: 15),
                          child: CircleAvatar(
                            backgroundColor: button_color,
                            radius: 18,
                            child: IconButton(
                              icon: const Icon(
                                Icons.add,
                                size: 22,
                                color: Colors.white,
                              ),
                              onPressed: () async {
                                  email_value = _userlistemail.value.text;
                                  name_value = _userlistfirstname.value.text;
                                  lastname_value = _userlistlastname.value.text;
                                  avatar_value = _avatar.value.text;
                                if (!email_value.isEmpty && !name_value.isEmpty && !lastname_value.isEmpty) {
                                  ///////////////////////////////////////////////
                                  //_selected.add([0,0]);
                                  ///////////////////////////////////////////////
                                  
                                  // DBProvider.db.getAllEmployeesQuery(
                                  //     query:
                                  //         _todoSearchDescriptionFormController
                                  //             .value.text);
                                  //dismisses the bottomsheet
                                  //AFEGIR VALUS BASE DE DADES
                                  DBProvider.db.insertNewEmployee(email_value, name_value, lastname_value, avatar_value);
                                  
                                  
                                  //Future<List<Employee>> llista = DBProvider.db.getNewUserId(name_value);
                                  int? temp = await DBProvider.db.getNewUserId(name_value);

                                  var apiProvider = EmployeeApiProvider();
                                  Response outputinfo = await apiProvider.postNewEmployee(temp, email_value, name_value, lastname_value, avatar_value);
                                  //upload values to API
                                  //AFEGIR VALORS API
                                  Navigator.pop(context);
                                  _alertDialog(context, outputinfo);
                                  setState(() {custom = false;});
                                }
                              },
                            ),
                          ),
                        )
                      //],
                    //),
                  ],
                ),
              ),
            ),
          ),
        );
      }
    );
  }

  _alertDialogDelete(BuildContext context, int total_deleted) {
    Widget okButton = TextButton(
        child: Text("OK", style: TextStyle(color: button_color),),
        onPressed: () { Navigator.pop(context); },
      );

      String title = "", content = "";

      if (total_deleted >= 1) {
        title = "Data Deleted";
        content = "Total employees deleted from the BD and the API: " + total_deleted.toString();
      } else {
        title = "Error";
        content = "Something failed while deleting from the API/BD";
      }

      AlertDialog alert = AlertDialog(
        title: Text(title, style: TextStyle(color: button_color),),
        content: Text(content, style: TextStyle(color: second_color),),
        actions: [
          okButton,
        ],
      );

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
  }

  _alertDialog(BuildContext context, Response objecte) {
    Widget okButton = TextButton(
        child: Text("OK", style: TextStyle(color: button_color),),
        onPressed: () { Navigator.pop(context); },
      );

      String title = "", content = "";

      if (objecte.statusCode == 200) {
        title = "User Created";
        content = "The employee was correctly added to the BD and uploaded to the API";
      } else {
        title = "Error";
        content = "Something failed while uploading to the API/saving the user to the BD";
      }

      AlertDialog alert = AlertDialog(
        title: Text(title, style: TextStyle(color: button_color),),
        content: Text(content, style: TextStyle(color: second_color),),
        actions: [
          okButton,
        ],
      );

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
  }

  _buildEmployeeListViewQuery(valor) {
    return FutureBuilder(
      future: DBProvider.db.getAllEmployeesQuery(query: valor),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        // if (_selectedinicialitzat) {
        //   List <bool>_selected = List.generate(snapshot.data.length, (i) => false);
        //             //_selectedinicialitzat = false;
        // }
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              valueColor:AlwaysStoppedAnimation(button_color /*Color.fromARGB(255, 34, 34, 34)*/),
              //backgroundColor: button_color,
            ),
          );
        } else if (snapshot.data.length == 0) {
          return Center(
            child: Image.asset('assets/imgs/DataNotFound.png', width: 100, height: 100, color: button_color,),
          );
        } else {
          return ListView.builder(
            // separatorBuilder: (context, index) => const Divider(
            //   color: Colors.black12,
            // ),
            itemCount: snapshot.data.length,
            padding: const EdgeInsets.all(16),
            itemBuilder: (BuildContext context, int index) {
              return Container(
                height: 100,
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide()),
                  color: Colors.transparent,
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.fromLTRB(10.0, 6.0, 10.0, 6.0),
                  leading: Text(
                  "${index + 1}",
                  style: const TextStyle(fontSize: 20.0),
                  ),
                  title: Text("Name: ${snapshot.data[index].firstName} ${snapshot.data[index].lastName}"),
                  subtitle: Text('EMAIL: ${snapshot.data[index].email}'),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),

                  //tileColor: _colorpicker(_selected[index]), //_selected[index] ? Colors.blue : Colors.transparent,

                  //tileColor: _selected[index] ? Colors.blue : null, // If current item is selected show blue color
                  //onTap: () => _selected[index] = !_selected[index], // Reverse bool value
                  //tileColor: isSelected ? Colors.blue : null,
                  //tileColor: _extracttruorfalse(snapshot.data[index].checkBox) ? Colors.blue : null, // If current item is selected show blue color
                  tileColor: _changecolorFilter(_selected, snapshot.data[index].id), // If current item is selected show blue color
                  trailing: _changeIconFilter(_selected, snapshot.data[index].id),

                  //onTap: () => setState(() => snapshot.data[index].checkBox = _changeboolstate(context, snapshot.data[index].checkBox, snapshot.data[index].id)),
                  onTap: () => setState(() => _changeboolstateFilter(context, _selected, snapshot.data[index].id)),
                  
                  // onTap: () => setState(() => _selected[index] = !_selected[index]),
                ),
              );
              // return ListTile(
              //   //contentPadding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
              //   leading: Text(
              //     "${index + 1}",
              //     style: const TextStyle(fontSize: 20.0),
              //   ),
              //   title: Text("Name: ${snapshot.data[index].firstName} ${snapshot.data[index].lastName}"),
              //   subtitle: Text('EMAIL: ${snapshot.data[index].email}'),

              //   //tileColor: _colorpicker(_selected[index]), //_selected[index] ? Colors.blue : Colors.transparent,

              //   //tileColor: _selected[index] ? Colors.blue : null, // If current item is selected show blue color
              //   //onTap: () => _selected[index] = !_selected[index], // Reverse bool value
              //   //tileColor: isSelected ? Colors.blue : null,
              //   //tileColor: _extracttruorfalse(snapshot.data[index].checkBox) ? Colors.blue : null, // If current item is selected show blue color
              //   tileColor: _changecolorFilter(_selected, snapshot.data[index].id), // If current item is selected show blue color
              //   trailing: _changeIconFilter(_selected, snapshot.data[index].id),

              //   //onTap: () => setState(() => snapshot.data[index].checkBox = _changeboolstate(context, snapshot.data[index].checkBox, snapshot.data[index].id)),
              //   onTap: () => setState(() => _changeboolstateFilter(context, _selected, snapshot.data[index].id)),
                
              //   // onTap: () => setState(() => _selected[index] = !_selected[index]),
              // );
            },
          );
          
          /////////////////////////////////////////////////////////////////////////////////////////////////

          /*return ListView.separated(
            separatorBuilder: (context, index) => const Divider(
              color: Colors.black12,
            ),
            itemCount: snapshot.data.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                leading: Text(
                  "${index + 1}",
                  style: const TextStyle(fontSize: 20.0),
                ),
                title: Text(
                    "Name: ${snapshot.data[index].firstName} ${snapshot.data[index].lastName} "),
                subtitle: Text('EMAIL: ${snapshot.data[index].email}'),
              );
            },
          );*/ 
        }
      },
    );
  }

  Icon _changeIcon(int valor) {
    if (valor == 1) {
      return const Icon(Icons.check_box);
    } else {
      return const Icon(Icons.check_box_outline_blank);
    }
  }

  Icon _changeIconFilter(_selected, int id) {
    for (var i = 0; i < _selected.length; i++) {
      if (_selected[i][1] == id && _selected[i][0] == 1) {
        return const Icon(Icons.check_box);
      }
    }
    return const Icon(Icons.check_box_outline_blank);
  }

  Color _changecolor(int valor) {
    if (valor == 1) {
      return const Color.fromARGB(255, 230, 230, 230);
    } else {
      return Colors.transparent;
    }
  }

  Color _changecolorFilter(_selected, int id) {
    for (var i = 0; i < _selected.length; i++) {
      if (_selected[i][1] == id && _selected[i][0] == 1) {
        return const Color.fromARGB(255, 230, 230, 230);
      }
    }
    return Colors.transparent;
  }

  // bool _extracttruorfalse(int valor) {
  //   if (valor == 1) {
  //     return true;
  //   } else {
  //     return false;
  //   }
  // }

  int _changeboolstate(BuildContext context, int valor) {//String valor, int id) {
    //canviar també el valor en la base de dades
    if (valor == 0) {
      return 1;
    } else {
      return 0;
    }
  }

    _changeboolstateFilter(BuildContext context, _selected, int id) {//String valor, int id) {
    // //canviar també el valor en la base de dades
    // for (var i = 0; i < _selected.length; i++) {
    //   if (_selected[i][1] == id) {
    //     if (_selected[i][0] == 1) {
    //       return 1;
    //     }
    //   }
    // }
    // //return 0;

    for (var i = 0; i < _selected.length; i++) {
      if (_selected[i][1] == id && _selected[i][0] == 0) {
        _selected[i][0] = 1;
      } else if (_selected[i][1] == id && _selected[i][0] == 1) {
        _selected[i][0] = 0;
      }
    }
  }

  // _colorpicker(bool pressionat) {
  //   if (pressionat == true) {
  //     return Colors.blue;
  //   } else {
  //     return Colors.transparent;
  //   }
  // }

  Widget _checkbox(BuildContext context) {
    bool isChecked = false;
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Colors.blue;
      }
      return Colors.red;
    }

    return Checkbox(
      checkColor: Colors.white,
      fillColor: MaterialStateProperty.resolveWith(getColor),
      value: isChecked,
      onChanged: (bool? value) {
        setState(() {
          isChecked = value!;
        });
      },
    );
  }

  _moreDetails(BuildContext context, String name, String surname, String imageurl, String email) {
    Widget okButton = TextButton(
      child: Text("Close", style: TextStyle(color: button_color),),
      onPressed: () {Navigator.pop(context);},
    );

    // set up the AlertDialog
    Dialog alert = Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(10),
      //title: Text(name + " " + surname, style: TextStyle(color: button_color)),
      child: Stack(
        overflow: Overflow.visible,
        alignment: Alignment.center,
        children: <Widget>[
          Container(
            width: double.infinity,
            height: 230,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: const Color.fromARGB(255, 245, 245, 245),
            ),
            padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
            child: Column(
              children: [
                const SizedBox(height: 20),
                Text(name + " " + surname, style: TextStyle(color: second_color, fontSize: 20),),
                const SizedBox(height: 5),
                Text("Email: " + email),
                // Text("Email: " + email),
                // Image.network(
                //   imageurl,
                //   errorBuilder: (context, exception, stackTrace) {
                //     return const Text('Your error widget...');
                //   },
                // ),
                Container(
                  //height: 10,
                  margin: const EdgeInsets.only(left: 0.0, right: 0.0, bottom: 0.0, top: 25.0),
                  child: okButton,
                ),
              ],
            )
          ),
          Positioned(
            top: -75,
            child: Image.network(
              imageurl, 
              width: 150, 
              height: 150,
              errorBuilder: (context, exception, stackTrace) {
                return Image.asset('assets/imgs/ImageNotFound.png', width: 150, height: 150, color: button_color,);
              },
            )
          ),
        ],
      ),
      
      // content: SizedBox(
      //   height: 500,
      //   child: Column(
      //     children: [
      //       Text("Email: " + email),
      //       Image.network(
      //         imageurl,
      //         errorBuilder: (context, exception, stackTrace) {
      //           return const Text('Your error widget...');
      //         },
      //       ),
      //     ],
      //   )
      // ),
      // actions: [
      //   okButton,
      // ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  // _returnImage() {
  //   try {
  //     throw 42;
  //   } on Exception catch (_) {
  //     print('never reached');
  //   }
  // }
}