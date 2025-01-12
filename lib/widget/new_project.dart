import 'dart:io';
import 'package:filesystem_picker/filesystem_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

import '../bloc/init_screen/init_screen_bloc.dart';
import '../repository/I18n.dart';
import '../repository/my_colors.dart';

class NewProject extends StatelessWidget {
  NewProject({super.key});

  final _formKey = GlobalKey<FormState>();
  TextEditingController _projectFolderController = TextEditingController();
  TextEditingController _projectNameController = TextEditingController();
  FocusNode _projectFolderFocusNode = FocusNode();
  FocusNode _projectNameFocusNode = FocusNode();
  FocusNode _nextFocusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return AlertDialog(
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                I18n.translate("newProject")!,
                style: TextStyle(
                  fontSize: 25.dp,
                ),
              ),
              BlocListener<InitScreenBloc, InitScreenState>(
                listener: (context, state) {
                  if (state is ProjectFolderInitScreenState) {
                    _projectFolderController.text = state.folder;
                  }
                  _projectFolderController.text = _projectFolderController.text;
                  if (state is ProjectRandomNameInitScreenState) {
                    _projectNameController.text = state.name;
                  }
                  _projectNameController.text = _projectNameController.text;
                },
                child: Container(
                  height: 0.0,
                  width: 0.0,
                ),
              ),
              Container(
                width: 20.w,
                child: Text(
                  I18n.translate("selectFolderToSaveProject")!,
                  textAlign: TextAlign.justify,
                ),
              ),
              Container(
                width: 20.w,
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        //disable editing text
                        focusNode: _projectFolderFocusNode,
                        controller: _projectFolderController,
                        obscureText: false,
                        decoration: InputDecoration(
                          labelText: I18n.translate("projectFolder")!,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return I18n.translate("fieldIsRequired")!;
                          }
                          return null;
                        },
                        onEditingComplete: () => FocusScope.of(context)
                            .requestFocus(_projectNameFocusNode),
                      ),
                    ),
                    IconButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                          MyColors.BlueD,
                        ),
                      ),
                      icon: Icon(
                        Icons.search,
                      ),
                      onPressed: () async {
                        BlocProvider.of<InitScreenBloc>(context)
                            .add(selectProjectFolderInitScreen());
                      },
                    ),
                  ],
                ),
              ),
              Container(
                width: 20.w,
                child: Text(
                  I18n.translate("setProjectName")!,
                  textAlign: TextAlign.justify,
                ),
              ),
              Container(
                width: 20.w,
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        //disable editing text
                        focusNode: _projectNameFocusNode,
                        controller: _projectNameController,
                        obscureText: false,
                        decoration: InputDecoration(
                          labelText: I18n.translate("projectName")!,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return I18n.translate("fieldIsRequired")!;
                          }
                          return null;
                        },
                        onEditingComplete: () =>
                            FocusScope.of(context).requestFocus(_nextFocusNode),
                      ),
                    ),
                    TextButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                          MyColors.BlueD,
                        ),
                      ),
                      child: Text(
                        I18n.translate("generate")!,
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      onPressed: () async {
                        BlocProvider.of<InitScreenBloc>(context)
                            .add(randomProjectNameInitScreen());
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: <Widget>[
        ElevatedButton(
          focusNode: _nextFocusNode,
          child: Text(I18n.translate("next")!),
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              BlocProvider.of<InitScreenBloc>(context).add(
                  validateProjectLocationInitScreen(
                      projectName: _projectNameController.text,
                      projectFolder: _projectFolderController.text));
              Navigator.of(context).pop();
            }
          },
        ),
        ElevatedButton(
          child: Text(I18n.translate("cancel")!),
          onPressed: () {
            BlocProvider.of<InitScreenBloc>(context)
                .add(cancelNewProjectInitScreen());
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
