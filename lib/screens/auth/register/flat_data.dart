import 'package:flutter/material.dart';
import 'package:ease_it/screens/auth/register/custom_dropdown_widget.dart';

class FlatData {
  Map<String, dynamic> _structure; //Stores the structure of the society
  List<Widget> _flatWidgetForm; //Stores the widget to be displayed in the form
  Map<String, String> _flatNum; //Stores the flatNumof the user
  List<String>
      _flatValue; //Another List just to store the flat nuber of the user
  List<Function> _allUpdateFunctions; //To update all thw widgets simultaneously
  int _totalLevels; //To store total levels of hierarchy in the society
  int _currentLevel; //To store the current level of hierarchy we are dealing with

  Map<dynamic, dynamic> get structure => _structure;
  List<Widget> get flatWidgetForm => _flatWidgetForm;
  Map<dynamic, dynamic> get flatNum => _flatNum;
  List<String> get flatValue => _flatValue;
  List<Function> get allUpdateFunctions => _allUpdateFunctions;
  int get totalLevels => _totalLevels;
  int get currentLevel => _currentLevel;

  set setStructure(Map<String, dynamic> structure) => _structure = structure;
  set setFlatWidgetForm(List<Widget> flatWidgetForm) =>
      _flatWidgetForm = flatWidgetForm;
  set setFlatNum(Map<dynamic, dynamic> flatNum) => _flatNum = flatNum;
  set setFlatValue(List<String> flatValue) => _flatValue = flatValue;
  set setAllUpdateFunctions(List<Function> allUpdateFunctions) =>
      _allUpdateFunctions = allUpdateFunctions;
  set setTotalLevels(int totalLevels) => _totalLevels = totalLevels;
  set setCurrentLevel(int currentLevel) => _currentLevel = currentLevel;

  void incrementCurrentLevel() => _currentLevel++;
  void decrementCurrentLevel() => _currentLevel--;

  void setTotalLevelValue() => _totalLevels = _structure["Hierarchy"].length;

  void clearStructure() {
    if (_structure != null) _structure.clear();
  }

  void clearFlatWidgetForm() {
    if (_flatWidgetForm != null) _flatWidgetForm.clear();
  }

  void clearFlatNum() {
    if (_flatNum != null) _flatNum.clear();
  }

  void clearFlatValue() {
    if (_flatValue != null) _flatValue.clear();
  }

  void clearUpdateFunctions() {
    if (_allUpdateFunctions != null) _allUpdateFunctions.clear();
  }

  void addInFlatWidgetForm(CustomDropDown inpWidget) {
    _flatWidgetForm.add(inpWidget);
  }

  void addInAllUpdateFunction(Function func) {
    _allUpdateFunctions.add(func);
  }

  String getTypeText(int i) {
    return _structure["Hierarchy"][i - 1];
  }

  List<String> getILevelInHierarchy(int i) {
    dynamic temp = _structure["structure"];
    print("-" * 50);
    print("Flat Data widget");
    print("To find hierarchy of $i");
    int k;
    List<String> optionList;
    for (k = 1; k <= i; ++k) {
      if (k - 1 >= 0 && _flatValue[k - 1] != null) {
        temp = temp[_flatValue[k - 1]];
        print("For next Iteration $temp");
      }
      if (temp is Map) {
        print("Flat value array: $_flatValue");
        optionList = List<String>.from(temp.keys.toList());
        print("$optionList for value $k");
        print("New temp formed: $temp");
      } else {
        optionList = List<String>.from(temp.toList());
      }
    }
    print("-" * 50);
    return optionList;
  }

  void clearFlatValueArray(int i) {
    int k;
    print("-" * 50);
    print("Inside Clear Flat Value Array");
    print("K $k");
    print("Total levels: $_totalLevels");
    for (k = i; k < _totalLevels; ++k) {
      _flatValue[k] = null;
    }
    print("-" * 50);
  }

  void setFlatNumValue() {
    for (int i = 0; i < _structure["Hierarchy"].length; ++i)
      _flatNum[_structure["Hierarchy"]] = null;
  }

  void runAllUpdate() {
    print("In update");
    if (_allUpdateFunctions != null) {
      for (Function i in _allUpdateFunctions) {
        if (i != null) {
          i();
        }
      }
    }
  }
}
