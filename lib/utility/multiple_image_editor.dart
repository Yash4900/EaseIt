import 'package:ease_it/utility/toast.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:ease_it/utility/pick_image.dart';
import 'dart:io';
import 'dart:math';

class MultipleImageEditor extends StatefulWidget {
  List<File> imageFiles;
  MultipleImageEditor({Key key, @required this.imageFiles}) : super(key: key);

  @override
  State<MultipleImageEditor> createState() => _MultipleImageEditorState();
}

class _MultipleImageEditorState extends State<MultipleImageEditor>
    with TickerProviderStateMixin {
  List<Widget> listOfPhotoView = [];
  List<Tab> listOfTabs = [];
  TabController _tabController;

  void didUpdateWidget(covariant MultipleImageEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.imageFiles.length != _tabController.length) {
      final oldIndex = _tabController.index;
      _tabController.dispose();
      _tabController = TabController(
        length: widget.imageFiles.length,
        initialIndex: max(0, min(oldIndex, widget.imageFiles.length - 1)),
        vsync: this,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.imageFiles.length > 5) {
      List<File> temp = [];
      for (int i = 0; i < 5; i++) {
        temp.add(widget.imageFiles[i]);
      }
      widget.imageFiles = temp;
      // showAlertDialog(context, 'Alert',
      //     'Are you sure you want to leave? Your changes will be discarded');
      // ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(content: Text("Only selecting first 5 images")));
      //showToast(
      //    context, "general", "Info", "ONly first 5 images were considered");
      WidgetsBinding.instance.addPostFrameCallback((_) => showToast(
          context, "general", "Info", "Only first 5 images were considered"));
    }
    _tabController =
        TabController(vsync: this, length: widget.imageFiles.length);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void createListOfTabs(List<File> imageFiles) {
    listOfTabs = [];
    for (File file in imageFiles) {
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
                    image: FileImage(file),
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

  void createListOfPhotoView(List<File> imageFiles) {
    listOfPhotoView = [];
    for (File file in imageFiles) {
      listOfPhotoView.add(
        Container(
          padding: EdgeInsets.all(3),
          child: PhotoView(
            imageProvider: FileImage(file),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
            Navigator.pop(context, widget.imageFiles);
          },
        ),
        actions: [
          widget.imageFiles.length == 5
              ? IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () async {
                    List<File> temp =
                        await PickImage().showMultiPicker(context, 50);
                    if (temp != null && temp.isNotEmpty) {
                      widget.imageFiles = [];
                      if (temp.length > 5) {
                        for (int i = 0; i < 5; i++) {
                          widget.imageFiles.add(temp[i]);
                        }
                        showToast(context, "general", "Info",
                            "Only 5 images were selected");
                      } else {
                        for (int i = 0; i < temp.length; i++) {
                          widget.imageFiles.add(temp[i]);
                        }
                      }
                      setState(() {
                        didUpdateWidget(
                          MultipleImageEditor(imageFiles: widget.imageFiles),
                        );
                      });
                    } else {
                      setState(() {});
                    }
                  },
                )
              : IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () async {
                    List<File> temp =
                        await PickImage().showMultiPicker(context, 50);
                    if (temp != null && temp.isNotEmpty) {
                      int prevLength = widget.imageFiles.length;
                      for (int i = 0;
                          i < temp.length && widget.imageFiles.length < 5;
                          i++) {
                        widget.imageFiles.add(temp[i]);
                      }
                      setState(() {
                        didUpdateWidget(
                          MultipleImageEditor(imageFiles: widget.imageFiles),
                        );
                      });
                      if (temp.length + prevLength > 5) {
                        showToast(context, "general", "Info",
                            "Only 5 images were selected");
                      }
                    } else {
                      setState(() {});
                    }
                  },
                ),
          IconButton(
            onPressed: () {
              int currentIndex = _tabController.index;
              if (widget.imageFiles.length == 1) {
                widget.imageFiles.removeAt(currentIndex);
                Navigator.pop(context, widget.imageFiles);
              } else {
                widget.imageFiles.removeAt(currentIndex);
                setState(() {
                  didUpdateWidget(
                    MultipleImageEditor(imageFiles: widget.imageFiles),
                  );
                });
              }
            },
            icon: Icon(
              Icons.delete,
              color: Colors.white,
              size: 25,
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.crop_outlined,
              color: Colors.white,
              size: 25,
            ),
            onPressed: () async {
              int currentIndex = _tabController.index;
              File tempCroppedImage = await ImageCropper.cropImage(
                sourcePath: widget.imageFiles[currentIndex].path,
                androidUiSettings: AndroidUiSettings(
                  toolbarTitle: 'Crop Image',
                  toolbarColor: Color(0xff1a73e8),
                  toolbarWidgetColor: Colors.white,
                  lockAspectRatio: true,
                ),
              );
              if (tempCroppedImage != null)
                setState(
                    () => widget.imageFiles[currentIndex] = tempCroppedImage);
            },
          ),
        ],
      ),
      body: SafeArea(
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
                    controller: _tabController,
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: TabBar(
                  controller: _tabController,
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
                  isScrollable: true,
                  tabs: listOfTabs,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
