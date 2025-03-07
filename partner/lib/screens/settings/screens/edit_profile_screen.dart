import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:epi_extensions/epi_extensions.dart';
import 'package:epi_firebase_auth/epi_firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:models/models.dart';
import 'package:partner/widgets/epi_text_field.dart';
import 'package:partner/widgets/wave_dots.dart';
import 'package:uuid/uuid.dart';

class EditProfileScreen extends StatefulWidget {
  final PartnerUser partner;

  const EditProfileScreen({super.key, required this.partner});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  bool isLoading = false;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController menuLinkController = TextEditingController();
  XFile? imageFile;
  bool hasImageSelected = false;

  @override
  void initState() {
    super.initState();
    nameController.text = widget.partner.name;
    menuLinkController.text = widget.partner.menuLink ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hesap Bilgileri'),
      ),
      body: ListView(
        padding: context.mediumHorizontalPadding,
        children: [
          Row(
            children: [
              Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  color: !hasImageSelected ? context.theme.colorScheme.surfaceContainer : null,
                  shape: BoxShape.circle,
                ),
                child: hasImageSelected
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Image.file(
                          File(imageFile!.path),
                          width: double.infinity,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                      )
                    : widget.partner.imageUrl != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Image.network(
                              widget.partner.imageUrl!,
                              width: double.infinity,
                              height: 200,
                              fit: BoxFit.cover,
                            ),
                          )
                        : const Icon(Icons.account_circle_rounded, size: 50),
              ),
              context.smallGap,
              TextButton(
                onPressed: selectImage,
                child: const Text('Fotoğrafı Değiştir'),
              ),
            ],
          ),
          context.smallGap,
          EpiTextField(
            title: 'İşletme Adı',
            placeholder: 'İşletme Adı',
            controller: nameController,
          ),
          context.smallGap,
          EpiTextField(
            title: 'Menü Linki',
            placeholder: 'Bu alana menü linkinizi ekleyebilirsiniz',
            controller: menuLinkController,
          ),
          context.smallGap,
          FilledButton(
            onPressed: () async {
              if (nameController.text.isEmpty) {
                return;
              }

              setState(() => isLoading = true);

              final userID = EpiFirebaseAuth.instance.currentUser!.uid;

              String? imageUrl;
              if (hasImageSelected) {
                imageUrl = await uploadImage();
              }

              await FirebaseFirestore.instance.collection('partners').doc(userID).update({
                'name': nameController.text,
                'imageUrl': imageUrl ?? widget.partner.imageUrl,
                'menuLink': menuLinkController.text.isEmpty ? null : menuLinkController.text,
              });

              setState(() => isLoading = false);
              Navigator.of(context).pop();
            },
            child: isLoading ? const WaveDots(color: Colors.white) : const Text('Kaydet'),
          ),
        ],
      ),
    );
  }

  Future<void> selectImage() async {
    final XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        imageFile = image;
        hasImageSelected = true;
      });
    }
  }

  Future<String?> uploadImage() async {
    if (imageFile == null) {
      return null;
    }

    final String userID = EpiFirebaseAuth.instance.currentUser!.uid;
    final String fileName = const Uuid().v4();
    final Reference reference = FirebaseStorage.instance.ref().child('profile_images').child(userID).child(fileName);

    // Read the image file into a Uint8List
    final Uint8List imageData = await imageFile!.readAsBytes();

    // Define the metadata for the upload
    final SettableMetadata metadata = SettableMetadata(
      contentType: 'image/png', // Specify the content type
    );

    // Upload the image to Firebase Storage with the defined metadata
    final UploadTask uploadTask = reference.putData(imageData, metadata);

    // Wait for the upload to complete
    await uploadTask.whenComplete(() {});

    // Get the download URL
    final String downloadURL = await reference.getDownloadURL();

    return downloadURL;
  }
}
