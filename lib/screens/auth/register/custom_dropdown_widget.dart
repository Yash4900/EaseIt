import 'package:flutter/material.dart';
import 'package:ease_it/screens/auth/register/flat_data.dart';

class CustomDropDown extends StatefulWidget {
  List<String> options;
  final String typeText;
  FlatData flatVariable;
  final Function update;

  CustomDropDown({
    Key key,
    @required this.options,
    @required this.typeText,
    @required this.flatVariable,
    @required this.update,
  }) : super(key: key);

  @override
  _CustomDropDownState createState() => _CustomDropDownState();
}

class _CustomDropDownState extends State<CustomDropDown> {
  String temp;
  bool changedOnce = false;
  int storeCurrentWidgetLevel;

  void update() {
    print(
        "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ In update DropDownWidget ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^");
    print("In update first");
    setState(() {
      temp = widget.flatVariable.flatValue[storeCurrentWidgetLevel - 1];
      print("Valeur is ${storeCurrentWidgetLevel - 1}");
      widget.options =
          widget.flatVariable.getILevelInHierarchy(storeCurrentWidgetLevel + 1);
      print(widget.options);
      print(
          "In update for $storeCurrentWidgetLevel actual index value  ${storeCurrentWidgetLevel - 1}");
    });
    print(
        "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ In update DropDownWidget ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^");
  }

  @override
  void initState() {
    print(
        "&&&&&&&&&&&&&&&&&&&&&& initState() CustomDropDown Widget &&&&&&&&&&&&&&&&&&&&&&");
    super.initState();
    print("In initState()");
    storeCurrentWidgetLevel = widget.flatVariable.currentLevel;
    print("Store value: $storeCurrentWidgetLevel");
    print("Options ${widget.options}");
    print(
        "&&&&&&&&&&&&&&&&&&&&&& initState() CustomDropDown Widget &&&&&&&&&&&&&&&&&&&&&&");
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      hint: Text(widget.typeText),
      isExpanded: true,
      icon: Icon(Icons.keyboard_arrow_down),
      value: temp,
      items: widget.options.map((String option) {
        return DropdownMenuItem<String>(
          child: Text(
            option,
            style: TextStyle(fontSize: 15),
          ),
          value: option,
        );
      }).toList(),
      onChanged: (String value) {
        print(
            "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! In onchanged CustomDropdDownWidget !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
        widget.flatVariable.clearFlatValueArray(storeCurrentWidgetLevel);
        widget.flatVariable.flatValue.removeAt(storeCurrentWidgetLevel - 1);
        widget.flatVariable.flatValue
            .insert(storeCurrentWidgetLevel - 1, value);
        print("-" * 50);
        print("In dropdown widget");
        print("Value of current level ${widget.flatVariable.currentLevel}");
        print("${widget.flatVariable.flatValue}");
        print("$storeCurrentWidgetLevel in the current dropdown widget");
        print(
            "Current Level $storeCurrentWidgetLevel and total levels ${widget.flatVariable.totalLevels}");
        if (widget.flatVariable.currentLevel ==
            widget.flatVariable.totalLevels) {
          widget.flatVariable.addInAllUpdateFunction(update);
        }
        if (widget.flatVariable.currentLevel <
                widget.flatVariable.totalLevels &&
            widget.flatVariable.flatWidgetForm.length <
                storeCurrentWidgetLevel + 1) {
          print(
              "Inside if condition for: $storeCurrentWidgetLevel and current Level: ${widget.flatVariable.currentLevel}");
          widget.flatVariable.addInAllUpdateFunction(update);
          widget.flatVariable.incrementCurrentLevel();
          widget.flatVariable.addInFlatWidgetForm(CustomDropDown(
            options: widget.flatVariable
                .getILevelInHierarchy(storeCurrentWidgetLevel),
            typeText:
                widget.flatVariable.getTypeText(storeCurrentWidgetLevel + 1),
            flatVariable: widget.flatVariable,
            update: widget.update,
          ));
        }
        print("-" * 50);
        setState(() => temp = value);
        widget.flatVariable.runAllUpdate();
        widget.update();
        print(
            "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! In onchanged CustomDropdDownWidget !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
      },
    );
  }
}
