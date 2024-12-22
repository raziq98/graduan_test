import 'dart:io';

import 'package:flutter/material.dart';
import 'package:graduan_test/model/user_model.dart';
import 'package:graduan_test/services/user_data/user_data.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late UserData _currentUser;
  bool _isEdit = false;
  bool isLoading = false;
  final _formkey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _currentUser = UserData(id: 0, name: '', email: '', emailVerifiedAt: '', createdAt: '', updatedAt: '');
    _loadData();
    isLoading = true;
  }

  Future<void> _loadData() async{
    final data = await UserDataService().getUserdata(context);
    setState((){
      _currentUser = data;
      _nameController.text = _currentUser.name;
    });
  }

  Future<void> _saveData() async {
    if (_formkey.currentState!.validate()) {
      final params = {
        'name': _nameController.text,
      };
      setState(() {
        _isEdit = false;
      });
      if(_nameController.text != _currentUser.name){
        final status = await UserDataService().updateUserData(context, params);
        if(status == 'Updated'){
          Navigator.pushReplacementNamed(context, '/profile');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile',
        ),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          height: height + height - (height * 0.6),
          width: width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 20,
              ),
              detailSection(),
              const SizedBox(
                height: 22,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: _isEdit ? 'Save' : 'Edit',
        onPressed: () {
          if (!_isEdit) {
            setState(() {
              _isEdit = true;
            });
          } else {
            setState(() {
              _isEdit = false;
            });
            _saveData();
          }
        },
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        backgroundColor: _isEdit ? Colors.greenAccent : Colors.amberAccent,
        child: Icon(
          _isEdit ? Icons.save_alt_outlined : Icons.edit,
          color: Colors.black,
        ),
      ),
    );
  }

  Padding detailSection() {
    return Padding(
      padding: const EdgeInsets.only(left: 25, right: 25, top: 50),
      child: Form(
        key: _formkey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            detailField(_currentUser.name ?? '', 'Name', _isEdit,
                _nameController, true),
            const SizedBox(
              height: 15,
            ),
            detailField(_currentUser.email ?? '', 'Email', _isEdit,
                TextEditingController(), false),
            const SizedBox(
              height: 15,
            ),
            detailField(_currentUser.emailVerifiedAt ?? '', 'Email verified at', _isEdit,
                TextEditingController(), false),
            const SizedBox(
              height: 15,
            ),
            detailField(_currentUser.createdAt ?? '', 'Account created at', _isEdit,
                TextEditingController(), false),
            const SizedBox(
              height: 15,
            ),
            detailField(_currentUser.updatedAt ?? '', 'Account updated at', _isEdit,
                TextEditingController(), false),
            const SizedBox(
              height: 15,
            ),
          ],
        ),
      ),
    );
  }

  TextFormField detailField(String text, String texthint, bool? isEdit,
      TextEditingController? controller, bool isEditable) {
    controller!.text = text;
    return TextFormField(
      controller: controller,
      enabled: isEdit == true
          ? isEditable
              ? true
              : false
          : false,
      autofocus: true,
      decoration: InputDecoration(
        label: Text(
          texthint,
        ),
        fillColor: const Color.fromARGB(255, 111, 26, 214),
        disabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
              color: Color.fromARGB(255, 232, 125, 251), width: 3),
          borderRadius: BorderRadius.circular(15),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: isEdit == true
                  ? Colors.greenAccent
                  : const Color.fromARGB(255, 232, 125, 251),
              width: 3),
          borderRadius: BorderRadius.circular(15),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.greenAccent, width: 3),
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      readOnly: isEdit == false ? true : false,
    );
  }
}
