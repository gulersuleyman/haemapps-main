import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:epi_extensions/epi_extensions.dart';
import 'package:epi_firebase_auth/epi_firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:models/models.dart';
import 'package:user/data/categories.dart';
import 'package:user/widgets/epi_text_field.dart';
import 'package:user/widgets/wave_dots.dart';
import 'package:uuid/uuid.dart';

class EditProfileScreen extends StatefulWidget {
  final PartnerUser partner;
  final bool directed;

  const EditProfileScreen({super.key, required this.partner, this.directed = false});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  bool isLoading = false;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController yemeksepetiController = TextEditingController();
  final TextEditingController getirController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController otherCategoryController = TextEditingController();
  XFile? imageFile;
  bool hasImageSelected = false;

  @override
  void initState() {
    super.initState();
    nameController.text = widget.partner.name;
    yemeksepetiController.text = widget.partner.yemeksepetiLink ?? '';
    getirController.text = widget.partner.getirLink ?? '';
    categoryController.text = widget.partner.category ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final List<String> categories = allCategories..sort();

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: context.mediumHorizontalPadding,
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    bool hasChangesMade;

                    if (nameController.text != widget.partner.name) {
                      hasChangesMade = true;
                    } else if (yemeksepetiController.text != (widget.partner.yemeksepetiLink ?? '')) {
                      hasChangesMade = true;
                    } else if (getirController.text != (widget.partner.getirLink ?? '')) {
                      hasChangesMade = true;
                    } else if (categoryController.text != widget.partner.category) {
                      hasChangesMade = true;
                    } else if (hasImageSelected) {
                      hasChangesMade = true;
                    } else {
                      hasChangesMade = false;
                    }

                    if (hasChangesMade) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Değişiklikler Kaydedilmedi'),
                            content: const Text('Geri dönmeden önce değişiklikleri kaydetmek ister misiniz?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Kaydetmeden Çık'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  onSubmit();
                                },
                                child: const Text('Kaydet'),
                              ),
                            ],
                          );
                        },
                      );
                    } else {
                      Navigator.of(context).pop();
                    }
                  },
                  icon: const Icon(Icons.arrow_back, size: 30),
                ),
                context.smallGap,
                const Text('Hesap Bilgileri', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ],
            ),
            if (widget.directed) context.mediumGap,
            if (widget.directed)
              Text(
                'Hesap Bilgilerini Tamamlayın',
                style: context.theme.textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),
              ),
            if (widget.directed) context.mediumGap,
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
                              child: CachedNetworkImage(
                                imageUrl: widget.partner.imageUrl!,
                                width: double.infinity,
                                height: 200,
                                fit: BoxFit.cover,
                              ),
                            )
                          : const Icon(Icons.account_circle_rounded, size: 50),
                ),
                context.smallGap,
                IgnorePointer(
                  ignoring: isLoading,
                  child: TextButton(
                    onPressed: selectImage,
                    child: const Text('Fotoğrafı Değiştir'),
                  ),
                ),
              ],
            ),
            context.smallGap,
            EpiTextField(
              enabled: !isLoading,
              title: 'İşletme Adı',
              placeholder: 'İşletme Adı',
              controller: nameController,
            ),
            context.smallGap,
            EpiTextField(
              enabled: !isLoading,
              title: 'Kategori',
              placeholder: 'İşletme Kategorisi',
              readOnly: true,
              controller: categoryController,
              onTap: () {
                if (isLoading) {
                  return;
                }

                showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return ListView(
                      children: [
                        ...categories.map((String category) {
                          return ListTile(
                            title: Text(category),
                            onTap: () {
                              setState(() {
                                categoryController.text = category;
                              });
                              Navigator.of(context).pop();
                            },
                          );
                        }),
                        ListTile(
                          title: const Text('Diğer (Lütfen belirtin)'),
                          onTap: () {
                            setState(() {
                              categoryController.text = 'Diğer (Lütfen belirtin)';
                            });
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            context.smallGap,
            if (categoryController.text == 'Diğer (Lütfen belirtin)')
              EpiTextField(
                enabled: !isLoading,
                title: 'Diğer Kategori',
                placeholder: 'Diğer Kategori',
                controller: otherCategoryController,
              ),
            context.smallGap,
            if (foodCategories.contains(categoryController.text))
              EpiTextField(
                enabled: !isLoading,
                title: 'Yemeksepeti Linki',
                placeholder: 'Yemeksepeti profilinizin linkini girin',
                controller: yemeksepetiController,
              ),
            context.smallGap,
            if (shopCategories.contains(categoryController.text) || foodCategories.contains(categoryController.text))
              EpiTextField(
                enabled: !isLoading,
                title: 'Getir Linki',
                placeholder: 'Getir profilinizin linkini girin',
                controller: getirController,
              ),
            context.smallGap,
            context.smallGap,
            IgnorePointer(
              ignoring: isLoading,
              child: FilledButton(
                onPressed: () async {
                  await onSubmit();
                },
                child: isLoading ? const WaveDots(color: Colors.white) : const Text('Kaydet'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> onSubmit() async {
    if (nameController.text.isEmpty || categoryController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('İsim ve kategori boş olamaz')));
      return;
    }

    if (categoryController.text == 'Diğer (Lütfen belirtin)' && otherCategoryController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Kategori boş olamaz')));
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
      'getirLink': getirController.text.isEmpty ? null : getirController.text,
      'yemeksepetiLink': yemeksepetiController.text.isEmpty ? null : yemeksepetiController.text,
      'category': categoryController.text == 'Diğer (Lütfen belirtin)' ? otherCategoryController.text : categoryController.text,
    });

    setState(() => isLoading = false);
    Navigator.of(context).pop();
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
