import 'package:flutter/material.dart';
// import 'package:socket_and_push/model/user.dart';
import 'package:websocket_futter_chat_app/model/user.dart';
import 'package:websocket_futter_chat_app/common/common.dart';
import 'package:websocket_futter_chat_app/screens/chat_screen.dart';
import 'package:websocket_futter_chat_app/service/database_helper.dart';

class CreateAccount extends StatefulWidget {
  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  DataBaseHelper _dataBaseHelper = DataBaseHelper();
  String dateOfBirth = "";
  final List<String> genderList = [
    'Male',
    'Female',
    'Genderfluid',
    'Trans Woman',
    'Trans Man'
  ];
  final List<String> sexualOrintationList = [
    'Homosexual',
    'Hetrosexual',
    'Bisexual',
    'Pansexual',
    'Asexual'
  ];
  String gender = '';
  String sexualOrintation = '';
  void pickDate(context) async {
    var resuilt = await showDatePicker(
        context: context,
        initialDatePickerMode: DatePickerMode.year,
        initialDate: DateTime.now(),
        firstDate: DateTime.parse('1800-07-20'),
        lastDate: DateTime.now());
    if (resuilt != null) {
      setState(() {
        dateOfBirth = resuilt.toString();
      });
    }
    print(resuilt);
  }

  createAccount() async {
    User user = User(
        color: 'blue',
        dateOfBirth: dateOfBirth,
        gender: gender,
        userId: "123",
        sexualOrintation: sexualOrintation);

    await _dataBaseHelper.saveUser(user.toMap());
  }

  pp() async {
    // print((await _dataBaseHelper.getUser()).gender);
    print("await _dataBaseHelper.getUser()");
  }

  @override
  void initState() {
    super.initState();
    pp();
  }

  @override
  Widget build(BuildContext context) {
    // pp();
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Account'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              FlatButton(
                  color: Colors.amber,
                  onPressed: () {
                    pickDate(context);
                  },
                  child: Text('Select Date of birth')),
              SizedBox(height: 10),
              Text("DOB: $dateOfBirth"),
              SizedBox(height: 10),
              Row(
                children: <Widget>[
                  Text('Gender: '),
                  SizedBox(width: 10),
                  Expanded(
                    child: ButtonTheme(
                      alignedDropdown: true,
                      child: DropdownButtonFormField<String>(
                          decoration:
                              dropDownDecoration(hintText: 'select genger'),
                          // value: '1',

                          items: genderList
                              .map((String value) => DropdownMenuItem(
                                    child: Text(value),
                                    value: value.toString(),
                                  ))
                              .toList(),
                          onChanged: (String vakue) {
                            setState(() {
                              gender = vakue;
                            });
                          }),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: <Widget>[
                  Text('Sexual Orientation: '),
                  SizedBox(width: 10),
                  Expanded(
                    child: ButtonTheme(
                      alignedDropdown: true,
                      child: DropdownButtonFormField<String>(
                          decoration: dropDownDecoration(
                              hintText: 'sexual srientation'),
                          // value: '1',

                          items: sexualOrintationList
                              .map((String value) => DropdownMenuItem(
                                    child: Text(value),
                                    value: value.toString(),
                                  ))
                              .toList(),
                          onChanged: (String vakue) {
                            setState(() {
                              sexualOrintation = vakue;
                            });
                          }),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Center(
                  child: RaisedButton(
                color: Colors.amber,
                onPressed: () {
                  createAccount();
                },
                child: Text('Create Account'),
              )),
              SizedBox(
                height: 20,
              ),
              Center(
                  child: RaisedButton(
                color: Colors.amber,
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ChatScreen()));
                },
                child: Text('ENTER ROOMS'),
              ))
            ],
          ),
        ),
      ),
    );
  }
}
