import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor:  Colors.black,
        // ignore: unnecessary_null_comparison
        title: const Text(
          'Profile',
          style: TextStyle(
            color: Colors.white, // Color for the second part of the text
          ),
        ),
        automaticallyImplyLeading: true,

        leading: IconButton(
          icon: const Icon(Icons.arrow_circle_left_outlined,size: 40,),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        iconTheme: const IconThemeData(
          color: Colors.white, // Change this color to your desired color.
        ),
      ),
      body: const ProfileWidget(),
    );
  }
}

class ProfileWidget extends StatefulWidget {
  const ProfileWidget({super.key});

  @override
  State<ProfileWidget> createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  File? galleryFile;
  final picker = ImagePicker();
  bool isVisible = false;

  void toggleVisibility() {
    setState(() {
      isVisible = !isVisible;
    });
  }

  String profileName = "John Doe"; // Initial profile name
  String profileEmail = "ravi@gmail.com"; // Initial profile name
  String profileContact = "6397199758"; // Initial profile name
  String profileDesignation = "Developer"; // Initial profile name
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _designationController = TextEditingController();
  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    _nameController.text = profileName;
    _emailController.text = profileEmail;
    _contactController.text = profileContact;
    _designationController.text = profileDesignation;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 5.0),
            child: Stack(fit: StackFit.loose, children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    width: 140.0,
                    height: 140.0,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(
                          100.0), // Adjust the value to control the roundness
                      child: galleryFile == null
                          ? Image.network(
                              'https://c.saavncdn.com/807/Kabir-Singh-Hindi-2019-20190614075009-500x500.jpg',
                              fit: BoxFit.cover,
                            )
                          : ClipOval(
                              child: Image.file(
                                galleryFile!,
                                width: 150.0,
                                height: 150.0,
                                fit: BoxFit.cover,
                              ),
                            ),
                    ),
                  )
                ],
              ),
              Padding(
                  padding: const EdgeInsets.only(top: 100.0, right: 100.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      InkWell(
                          onTap: () {
                            _showPicker(context: context);
                          },
                          child: const CircleAvatar(
                            backgroundColor: Colors.red,
                            radius: 15.0,
                            child: Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                            ),
                          )),
                    ],
                  )),
            ]),
          ),
          const SizedBox(height: 10),
          const Text(
            'Ravikant Saini',
            style: TextStyle(color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          ListTile(
            trailing: isEditing
                ? IconButton(
                    icon: const Icon(
                      Icons.check,
                      color: Colors.redAccent,
                    ),
                    onPressed: () {
                      setState(() {
                        profileName = _nameController.text;
                        profileEmail = _emailController.text;
                        profileContact = _contactController.text;
                        isEditing = false;
                      });
                    },
                  )
                : IconButton(
                    icon: const Icon(
                      Icons.edit,
                      color: Colors.redAccent,
                    ),
                    onPressed: () {
                      toggleVisibility();
                      setState(() {
                        isEditing = true;
                      });
                    },
                  ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 5.0),
            child: Divider(
              color: Colors.grey, // Set the color of the divider
              thickness: 1.0, // Set the thickness of the divider
              height: 1, // Set the height of the divider
            ),
          ),
          ListTile(
            leading: const Icon(Icons.account_circle,size: 30,color: Colors.white,),
            title: Text(
              'Name',
              style: GoogleFonts.poppins(
                textStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                    fontWeight: FontWeight.normal),
              ),
            ),
            subtitle: isEditing
                ? TextFormField(
                    controller: _nameController,
                    keyboardType: TextInputType.name,
                    decoration: const InputDecoration(
                      hintText: 'Enter your name',
                    ),
                  )
                : Text(
                    profileName,
                    style: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.normal),
                    ),
                  ),
          ),
          const Divider(
            color: Colors.grey, // Set the color of the divider
            thickness: 1.0, // Set the thickness of the divider
            height: 1, // Set the height of the divider
          ),
          ListTile(
            leading: const Icon(Icons.email,size: 30,color: Colors.white,),
            title: Text(
              'Email',
              style: GoogleFonts.poppins(
                textStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                    fontWeight: FontWeight.normal),
              ),
            ),
            subtitle: isEditing
                ? TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      hintText: 'Enter your name',
                    ),
                  )
                : Text(
                    profileEmail,
                    style: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.normal),
                    ),
                  ),
          ),
          const Divider(
            color: Colors.grey, // Set the color of the divider
            thickness: 1.0, // Set the thickness of the divider
            height: 1, // Set the height of the divider
          ),
          ListTile(
            leading: const Icon(Icons.call,size: 30,color: Colors.white,),
            title: Text(
              'Contact',
              style: GoogleFonts.poppins(
                textStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                    fontWeight: FontWeight.normal),
              ),
            ),
            subtitle: isEditing
                ? TextFormField(
                    controller: _contactController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: 'Enter your name',
                    ),
                  )
                : Text(
                    profileContact,
                    style: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.normal),
                    ),
                  ),
          ),
          const Divider(
            color: Colors.grey, // Set the color of the divider
            thickness: 1.0, // Set the thickness of the divider
            height: 1, // Set the height of the divider
          ),
          ListTile(
            leading: Icon(Icons.account_circle,size: 30,color: Colors.white,),
            title: Text(
              'Designation',
              style: GoogleFonts.poppins(
                textStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                    fontWeight: FontWeight.normal),
              ),
            ),
            subtitle: isEditing
                ? TextFormField(
                    controller: _designationController,
                    keyboardType: TextInputType.name,
                    decoration: const InputDecoration(
                      hintText: 'Enter your name',
                    ),
                  )
                : Text(
                    profileDesignation,
                    style: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.normal),
                    ),
                  ),
          ),
          const Divider(
            color: Colors.grey, // Set the color of the divider
            thickness: 1.0, // Set the thickness of the divider
            height: 1, // Set the height of the divider
          ),
          SizedBox(height: 20),
          Visibility(
            visible: isVisible,
            child: Padding(
              padding: const EdgeInsets.only(top: 28.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Update Profile',
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                        color: Colors.black,
                        fontSize: 19,
                        fontWeight: FontWeight.normal),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    ));
  }

  void _showPicker({
    required BuildContext context,
  }) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Photo Library'),
                onTap: () {
                  getImage(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Camera'),
                onTap: () {
                  getImage(ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future getImage(
    ImageSource img,
  ) async {
    final pickedFile = await picker.pickImage(source: img);
    XFile? xfilePick = pickedFile;
    setState(
      () {
        if (xfilePick != null) {
          galleryFile = File(pickedFile!.path);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(// is this context <<<
              const SnackBar(content: Text('Nothing is selected')));
        }
      },
    );
  }
}
