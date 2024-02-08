import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class AddSonglistScreen extends StatefulWidget {
  @override
  _AddPlaylistScreenState createState() => _AddPlaylistScreenState();
}

class _AddPlaylistScreenState extends State<AddSonglistScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController subtitleController = TextEditingController();
  TextEditingController artistController = TextEditingController();
  TextEditingController imageUrlController = TextEditingController();
  TextEditingController songUrlController = TextEditingController();
  String localFilePath = "";
  String? _filePath;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  final _defaultFileNameController = TextEditingController();
  final _dialogTitleController = TextEditingController();
  final _initialDirectoryController = TextEditingController();
  final _fileExtensionController = TextEditingController();
  String? _fileName;
  String? _saveAsFileName;
  List<PlatformFile>? _paths;
  String? _directoryPath;
  String? _extension;
  bool _isLoading = false;
  bool _lockParentWindow = false;
  bool _userAborted = false;
  bool _multiPick = false;
  FileType _pickingType = FileType.any;

  @override
  void initState() {
    super.initState();
    _fileExtensionController
        .addListener(() => _extension = _fileExtensionController.text);
  }

  void _pickFiles() async {
    _resetState();
    try {
      _directoryPath = null;
      _paths = (await FilePicker.platform.pickFiles(
        type: _pickingType,
        allowMultiple: _multiPick,
        onFileLoading: (FilePickerStatus status) => print(status),
        allowedExtensions: (_extension?.isNotEmpty ?? false)
            ? _extension?.replaceAll(' ', '').split(',')
            : null,
        dialogTitle: _dialogTitleController.text,
        initialDirectory: _initialDirectoryController.text,
        lockParentWindow: _lockParentWindow,
      ))
          ?.files;
    } on PlatformException catch (e) {
      _logException('Unsupported operation' + e.toString());
    } catch (e) {
      _logException(e.toString());
    }
    if (!mounted) return;
    setState(() {
      _isLoading = false;
      _fileName =
      _paths != null ? _paths!.map((e) => e.name).toString() : '...';
      _userAborted = _paths == null;
    });
  }

  void _logException(String message) {
    print(message);
    _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
    _scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
  void _resetState() {
    if (!mounted) {
      return;
    }
    setState(() {
      _isLoading = true;
      _directoryPath = null;
      _fileName = null;
      _paths = null;
      _saveAsFileName = null;
      _userAborted = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Add Playlist',style: TextStyle(color: Colors.white),),
        leading: IconButton(
          icon: Icon(Icons.arrow_circle_left_outlined,color: Colors.white,size: 40,),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [

            ConstrainedBox(
              constraints: const BoxConstraints.tightFor(width: 400.0),
              child: SwitchListTile.adaptive(
                title: Text(
                  'Pick multiple files',
                  textAlign: TextAlign.left,
                  style: TextStyle(color: Colors.white),
                ),
                onChanged: (bool value) =>
                    setState(() => _multiPick = value),
                value: _multiPick,
              ),
            ),
            Container(
              child: Column(
                children: [
                  TextFormField(
                    controller: titleController,
                    decoration: InputDecoration(
                      labelText: 'Song Title',
                      labelStyle: TextStyle(color: Colors.white),
                      hintStyle: TextStyle(color: Colors.white),
                      hoverColor: Colors.transparent,
                    ),
                    style: TextStyle(color: Colors.white),

                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Container(
                child: Column(
                  children: [
                    TextFormField(
                      controller: subtitleController,
                      decoration: InputDecoration(
                        labelText: 'Song Subtitle',
                        labelStyle: TextStyle(color: Colors.white),
                        hintStyle: TextStyle(color: Colors.white),
                        hoverColor: Colors.transparent,
                      ),
                      style: TextStyle(color: Colors.white),

                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Container(
                child: Column(
                  children: [
                    TextFormField(
                      controller: artistController,
                      decoration: InputDecoration(
                        labelText: 'Artist Name',
                        labelStyle: TextStyle(color: Colors.white),
                        hintStyle: TextStyle(color: Colors.white),
                        hoverColor: Colors.transparent,
                      ),
                      style: TextStyle(color: Colors.white),

                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Container(
                child: Column(
                  children: [
                    TextFormField(
                      controller: imageUrlController,
                      decoration: InputDecoration(
                        labelText: 'Song Image URL',
                        labelStyle: TextStyle(color: Colors.white),
                        hintStyle: TextStyle(color: Colors.white),
                        hoverColor: Colors.transparent,
                      ),
                      style: TextStyle(color: Colors.white),

                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Container(
                child: Column(
                  children: [
                    TextFormField(
                      controller: songUrlController,
                      decoration: InputDecoration(
                        labelText: 'Song URL',
                        labelStyle: TextStyle(color: Colors.white),
                        hintStyle: TextStyle(color: Colors.grey),
                        hoverColor: Colors.transparent,
                      ),
                      style: TextStyle(color: Colors.white),

                    ),
                  ],
                ),
              ),
            ),

            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 150,
                    child: Builder(
                      builder: (BuildContext context) => _isLoading
                          ? Row(
                        children: [
                          Expanded(
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 40.0,
                                ),
                                child: const CircularProgressIndicator(),
                              ),
                            ),
                          ),
                        ],
                      )
                          : _userAborted
                          ? Row(
                        children: [
                          Expanded(
                            child: Center(
                              child: SizedBox(
                                width: 300,
                                child: ListTile(
                                  leading: Icon(
                                    Icons.error_outline,
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 40.0),
                                  title: const Text(
                                    'User has aborted the dialog',
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                          : _directoryPath != null
                          ? ListTile(
                        title: const Text('Directory path'),
                        subtitle: Text(_directoryPath!),
                      )
                          : _paths != null
                          ? Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 20.0,
                        ),
                        height:
                        MediaQuery.of(context).size.height *
                            0.50,
                        child: Scrollbar(
                            child: ListView.separated(
                              itemCount:
                              _paths != null && _paths!.isNotEmpty
                                  ? _paths!.length
                                  : 1,
                              itemBuilder:
                                  (BuildContext context, int index) {
                                final bool isMultiPath =
                                    _paths != null &&
                                        _paths!.isNotEmpty;
                                final String name = '' +
                                    (isMultiPath
                                        ? _paths!
                                        .map((e) => e.name)
                                        .toList()[index]
                                        : _fileName ?? '...');
                                final path = kIsWeb
                                    ? null
                                    : _paths!
                                    .map((e) => e.path)
                                    .toList()[index]
                                    .toString();

                                return ListTile(
                                  title: Text(
                                    name,style: TextStyle(color: Colors.white),
                                  ),

                                  subtitle: Text(path ?? ''),
                                );
                              },
                              separatorBuilder:
                                  (BuildContext context, int index) =>
                              const Divider(),
                            )),
                      )
                          : _saveAsFileName != null
                          ? ListTile(
                        title: const Text('Save file'),
                        subtitle: Text(_saveAsFileName!),
                      )
                          : const SizedBox(),
                    ),
                  ),
                  SizedBox(
                    width: 120,
                    child: FloatingActionButton.extended(
                        onPressed: () => _pickFiles(),
                        label:
                        Text(_multiPick ? 'Pick files' : 'Pick file'),
                        icon: const Icon(Icons.description)),
                  ),
                  SizedBox(height: 16),

                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 38.0),
              child: SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: () async {
                    // You can add your logic to store data, save file, etc.

                    // Example: Saving song file to local storage
                    await _saveSongFileToStorage();

                    // TODO: Add logic to save playlist data (title, subtitle, artist, image, url)
                  },
                  child: Text('Add to Playlist',style: TextStyle(color: Colors.black)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveSongFileToStorage() async {
    // Example: Saving an empty file to local storage
    try {
      Directory appDocumentsDirectory = await getApplicationDocumentsDirectory();
      String filePath = '${appDocumentsDirectory.path}/sample_song.mp3';

      File file = File(filePath);
      await file.create();

      setState(() {
        localFilePath = filePath;
      });
    } catch (e) {
      print('Error saving file: $e');
    }
  }
}

