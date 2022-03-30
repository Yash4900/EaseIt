import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class MultipleImageViewer extends StatefulWidget {
  final List<String> imageFiles;

  const MultipleImageViewer({Key key, @required this.imageFiles})
      : super(key: key);

  @override
  State<MultipleImageViewer> createState() => _MultipleImageViewerState();
}

class _MultipleImageViewerState extends State<MultipleImageViewer> {
  List<Tab> listOfTabs = [];
  List<Widget> listOfPhotoView = [];

  void createListOfTabs(List<String> imageFiles) {
    listOfTabs = [];
    for (String file in imageFiles) {
      listOfTabs.add(
        Tab(
          child: Padding(
            padding: const EdgeInsets.all(3.0),
            child: Container(
              width: 70,
              height: 100,
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(file),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }
  }

  void createListOfPhotoView(List<String> imageFiles) {
    listOfPhotoView = [];
    for (String file in imageFiles) {
      listOfPhotoView.add(
        Container(
          padding: EdgeInsets.all(3),
          child: PhotoView(
            imageProvider: NetworkImage(file),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    //print(widget.imageFiles);
    createListOfTabs(widget.imageFiles);
    createListOfPhotoView(widget.imageFiles);
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(
            Icons.close,
            color: Colors.white,
            size: 25,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: DefaultTabController(
          length: widget.imageFiles.length,
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              children: [
                Expanded(
                  flex: 10,
                  child: Padding(
                    padding: EdgeInsets.all(5),
                    child: TabBarView(
                      children: listOfPhotoView,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: TabBar(
                    indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      //color: Colors.redAccent,
                      border: Border.all(
                        width: 3,
                        color: Color(0xff1a73e8),
                      ),
                    ),
                    indicatorPadding: EdgeInsets.zero,
                    labelPadding: EdgeInsets.zero,
                    padding: EdgeInsets.zero,
                    isScrollable: true,
                    tabs: listOfTabs,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
