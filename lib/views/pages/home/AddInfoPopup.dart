import 'package:flutter/material.dart';
import 'package:mimichat/services/UserService.dart';
import 'package:mimichat/utils/AppStateManager.dart';

class AddInfoPopup extends StatefulWidget {
  @override
  _AddInfoPopupState createState() => _AddInfoPopupState();
}

class _AddInfoPopupState extends State<AddInfoPopup> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _birthDateController = TextEditingController();
  final _bioController = TextEditingController();
  var user = AppStateManager.currentUser;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Additional Information'),
      content: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.5,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                  child: TextFormField(
                    controller: _firstNameController,
                    keyboardType: TextInputType.text,
                    decoration: decor(label: "First Name"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your first name';
                      }
                      return null;
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                  child: TextFormField(
                    controller: _lastNameController,
                    keyboardType: TextInputType.text,
                    decoration: decor(label: "Last Name"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your last name';
                      }
                      return null;
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                  child: TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: decor(label: "Phone"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your phone number';
                      }
                      return null;
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                  child: TextFormField(
                    controller: _birthDateController,
                    keyboardType: TextInputType.datetime,
                    decoration: decor(label: "Date of Birth"),
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                      );
                      if (pickedDate != null) {
                        setState(() {
                          _birthDateController.text =
                              "${pickedDate.toLocal()}".split(' ')[0];
                        });
                      }
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your birth date';
                      }
                      return null;
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                  child: TextFormField(
                    controller: _bioController,
                    keyboardType: TextInputType.multiline,
                    decoration: decor(label: "Bio"),
                    maxLines: 3,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a bio';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              var s = _birthDateController.text;
              var date = DateTime.tryParse(s);
              user!.firstName = _firstNameController.text;
              user!.lastName = _lastNameController.text;
              user!.phone = _phoneController.text;
              user!.birthDate =
                  (date!.toUtc().millisecondsSinceEpoch).toString();
              user!.bio = _bioController.text;

              await UserService.updateUserInfo(user!).then((val) {
                if (val) {
                  setState(() {
                    print("state was set");
                    Navigator.of(context).pop();
                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                        'Failed to update user info, please try again later.'),
                  ));
                  Navigator.of(context).pop();
                }
              });
            }
          },
          child: Text('Submit'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _birthDateController.dispose();
    _bioController.dispose();
    super.dispose();
  }
}

InputDecoration decor({required String label}) {
  return InputDecoration(
      filled: true,
      labelText: label,
      fillColor: Color(0xfffcfcfd),
      contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      hintStyle: TextStyle(fontWeight: FontWeight.w400),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          borderSide: BorderSide(
              color: Color(0xffe6ebf5), style: BorderStyle.solid, width: 0)),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          borderSide: BorderSide(
              color: Color(0xffe6ebf5), style: BorderStyle.solid, width: 0)));
}
