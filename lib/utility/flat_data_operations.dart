import 'package:flutter/cupertino.dart';

class FlatDataOperations {
  List<String> hierarchy;
  dynamic structure;
  Map<String, String> flatNum;
  Map<int, String> respectiveEndingTag = {
    1: "st",
    2: "nd",
    3: "rd",
    4: "th",
    5: "th",
    6: "th",
    7: "th",
    8: "th",
    9: "th",
    0: "th",
  };

  FlatDataOperations({@required this.hierarchy, this.structure, this.flatNum});

  String updatedString(value) {
    //print("updateString");
    if (int.tryParse(value) != null) {
      int Num = int.parse(value);
      Num = Num % 10;
      String expectedEnding = respectiveEndingTag[Num];
      //print("Value $value , expectedEnding: $expectedEnding");
      value = value + expectedEnding;
      //print("Updated String");
      return value;
    }
    //print("UpdatedString");
    return value;
  }

  String returnStringFormOfFlatMap() {
    String finalStringToReturn = "";
    for (int i = hierarchy.length - 1; i >= 0; i--) {
      if (i != 0) {
        if (hierarchy[i] == "Flat") {
          finalStringToReturn += flatNum[hierarchy[i]] + ", ";
        } else if (hierarchy[i] == "Floor") {
          finalStringToReturn +=
              updatedString(flatNum[hierarchy[i]]) + " " + hierarchy[i] + ", ";
        } else {
          finalStringToReturn +=
              flatNum[hierarchy[i]] + " " + hierarchy[i] + ", ";
        }
      } else {
        finalStringToReturn += flatNum[hierarchy[i]] + " " + hierarchy[i];
      }
    }
    return finalStringToReturn;
  }

  List<String> getInitialCombination() {
    List<String> initialCombination = [];
    if (structure is List) {
      return initialCombination;
    } else if (structure is Map) {
      dynamic temp = structure;
      for (int i = 0; i < hierarchy.length; i++) {
        if (temp is Map) {
          initialCombination.add(temp.keys.toList()[0]);
          temp = temp[temp.keys.toList()[0]];
        } else {}
      }
      print(initialCombination);
      return initialCombination;
    } else {
      return null;
    }
  }

  void findingCombinations() {
    RecursiveFindValues r = RecursiveFindValues();
    //print("hierarchy: $hierarchy \n structure: $structure");
    r.findAllFormations(hierarchy, structure, 0, {});
    //for (int i = 0; i < r.allCombinations.length; i++) {
    //  print(r.allCombinations[i]);
    //}
  }
}

class RecursiveFindValues {
  List<Map<String, String>> _allCombinations = [];

  List<Map<String, String>> get allCombinations => _allCombinations;

  void findAllFormations(List<String> hierarchy, dynamic structure, int level,
      Map<String, String> toBeAddedinLastIteration) {
    //print("&&&&&&&& In findAllFormations for level : $level &&&&&&&&&");
    //print("toBeAddedInLastIteration: $toBeAddedinLastIteration");
    //Map<String, String> toBeAddedInLastIteration;
    if (level < hierarchy.length) {
      String key = hierarchy[level];
      //print("Key Selected is $key");
      if (structure is Map) {
        List<String> allKeys = List<String>.from(structure.keys);
        for (String i in allKeys) {
          //print("Key Value Pair: $key , $i");
          toBeAddedinLastIteration[key] = i;
          findAllFormations(
              hierarchy, structure[i], level + 1, toBeAddedinLastIteration);
        }
      } else if (structure is List) {
        List<String> tempStructure = List<String>.from(structure);
        for (int i = 0; i < tempStructure.length; i++) {
          Map<String, String> tempMap = {...toBeAddedinLastIteration};
          //print("List Value $i");
          tempMap[key] = tempStructure[i];
          //print(
          //    "To be added in last iteration in loop for $i is $toBeAddedinLastIteration");
          _allCombinations.add(tempMap);
          //print(
          //    "length is: ${_allCombinations.length} AllCombinations list: $_allCombinations ");
        }
      } else {
        return;
      }
    }

    //print("END In findAllFormations for level : $level END");
  }
}
