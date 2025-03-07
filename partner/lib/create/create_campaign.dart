import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:epi_extensions/epi_extensions.dart';
import 'package:epi_firebase_auth/epi_firebase_auth.dart';
import 'package:epi_http/epi_http.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fl_location/fl_location.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire_plus/geoflutterfire_plus.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:models/models.dart';
import 'package:partner/bloc/bloc_extensions.dart';
import 'package:partner/data/categories.dart';
import 'package:partner/services/location.dart';
import 'package:partner/widgets/epi_text_field.dart';
import 'package:partner/widgets/wave_dots.dart';
import 'package:uuid/uuid.dart';

class CreateCampaign extends StatefulWidget {
  static const String path = '/create_campaign';

  const CreateCampaign({super.key});

  @override
  State<CreateCampaign> createState() => _CreateCampaignState();
}

class _CreateCampaignState extends State<CreateCampaign> {
  bool isLoading = false;
  DateTime? endDate;
  TimeOfDay? endTime;
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();
  final TextEditingController endTimeController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController otherCategoryController = TextEditingController();
  XFile? imageFile;
  List<XFile> multipeImageFiles = [];
  bool hasImageSelected = false;
  bool hasMultipleImagesSelected = false;

  @override
  Widget build(BuildContext context) {
    final List<String> categories = allCategories..sort();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kampanya Oluştur'),
        actions: [
          IgnorePointer(
            ignoring: isLoading,
            child: TextButton.icon(
              onPressed: onSubmit,
              label: Text(isLoading ? '' : 'Kaydet'),
              icon: isLoading ? const WaveDots() : const Icon(Icons.save),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: context.mediumPadding,
        children: [
          Row(
            children: [
              Text(
                'Fotoğraf',
                style: context.theme.textTheme.bodyMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: context.theme.colorScheme.onSurface,
                ),
              ),
              context.tinyGap,
              TextButton(
                onPressed: () async {
                  await selectImage();
                },
                child: Text(hasImageSelected ? 'Değiştir' : 'Ekle'),
              ),
            ],
          ),
          if (hasImageSelected)
            Row(
              children: [
                Image.file(
                  File(imageFile!.path),
                  width: 130,
                  height: 130,
                  fit: BoxFit.cover,
                ),
                const Spacer(),
              ],
            ),
          context.smallGap,
          if (hasImageSelected)
            Text(
              'Ek Fotoğraflar (İsteğe Bağlı)',
              style: context.theme.textTheme.bodyMedium!.copyWith(
                fontWeight: FontWeight.bold,
                color: context.theme.colorScheme.onSurface,
              ),
            ),
          context.smallGap,
          GridView(
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            children: [
              if (hasMultipleImagesSelected)
                ...multipeImageFiles.map((XFile image) {
                  return Stack(
                    children: [
                      Image.file(
                        File(image.path),
                        width: 130,
                        height: 130,
                        fit: BoxFit.cover,
                      ),
                      Positioned(
                        right: 5,
                        top: 5,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              multipeImageFiles.remove(image);
                              if (multipeImageFiles.isEmpty) {
                                hasMultipleImagesSelected = false;
                              }
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: context.theme.colorScheme.onSurface,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Icon(
                                Icons.close,
                                color: context.theme.colorScheme.surface,
                                size: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }),
              if (multipeImageFiles.length < 4 && hasImageSelected)
                Container(
                  width: 130,
                  height: 130,
                  decoration: BoxDecoration(
                    border: Border.all(color: context.theme.colorScheme.onSurface),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextButton(
                    onPressed: () async {
                      final List<XFile> images = await ImagePicker().pickMultiImage(limit: 4);
                      if (images.isNotEmpty) {
                        setState(() {
                          multipeImageFiles = [...multipeImageFiles, ...images];
                          hasMultipleImagesSelected = true;
                        });
                      }
                    },
                    child: const Icon(Icons.add),
                  ),
                ),
            ],
          ),
          context.smallGap,
          EpiTextField(
            controller: titleController,
            title: 'Kampanya Başlığı:',
            placeholder: 'Başlık',
          ),
          context.smallGap,
          EpiTextField(
            controller: descriptionController,
            title: 'Kampanya Açıklaması:',
            placeholder: 'Açıklama',
            maxLines: 5,
          ),
          context.smallGap,
          EpiTextField(
            controller: categoryController,
            title: 'Kategori:',
            placeholder: 'Kategori',
            readOnly: true,
            onTap: () {
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
                        title: const Text('Happy Hour'),
                        onTap: () {
                          setState(() {
                            categoryController.text = 'Happy Hour';
                          });
                          Navigator.of(context).pop();
                        },
                      ),
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
              controller: otherCategoryController,
              title: 'Kategori:',
              placeholder: 'Lütfen diğer kategoriyi belirtin',
            ),
          context.smallGap,
          EpiTextField(
            controller: productNameController,
            title: 'Ürün Adı:',
            placeholder: 'Ürün Adı',
          ),
          context.smallGap,
          EpiTextField(
            controller: endDateController,
            title: 'Bitiş Tarihi:',
            placeholder: 'Tarih Seç',
            readOnly: true,
            onTap: () {
              showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 365)),
              ).then((DateTime? value) {
                if (value != null) {
                  endDateController.text = '${value.day}/${value.month}/${value.year}';
                  endDate = value;
                }
              });
            },
          ),
          context.smallGap,
          EpiTextField(
            controller: endTimeController,
            title: 'Bitiş Saati:',
            placeholder: 'Saat Seç',
            readOnly: true,
            onTap: () {
              showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
              ).then((TimeOfDay? value) {
                if (value != null) {
                  endTime = value;
                  endTimeController.text = '${endTime!.hour.toString().padLeft(2, '0')}:${endTime!.minute.toString().padLeft(2, '0')}';
                }
              });
            },
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

  Future<void> onSubmit() async {
    if (titleController.text.isEmpty || descriptionController.text.isEmpty || endDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Lütfen tüm alanları doldurun.')));
      return;
    }

    setState(() => isLoading = true);

    final EpiResponse<Location?> location = await LocationService.instance.getLocation();

    if (location.status != Status.success || location.data == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Konum bilgisi alınamadı.')));
      setState(() => isLoading = false);
      return;
    }

    final lat = location.data!.latitude;
    final lan = location.data!.longitude;

    final GeoFirePoint geoFirePoint = GeoFirePoint(GeoPoint(lat, lan));
    final PartnerUser? partnerUser = context.getPartnerUser;

    if (partnerUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Kullanıcı bilgisi alınamadı.')));
      setState(() => isLoading = false);
      return;
    } else {
      String? imageUrl;
      if (hasImageSelected) {
        imageUrl = await uploadImage(imageFile);
      }

      final List<String> multipleImageUrls = [];

      if (hasMultipleImagesSelected) {
        for (final XFile image in multipeImageFiles) {
          final String? url = await uploadImage(image);
          if (url != null) {
            multipleImageUrls.add(url);
          }
        }
      }

      DateTime combinedEndDateTime;
      if (endTime != null) {
        combinedEndDateTime = DateTime(
          endDate!.year,
          endDate!.month,
          endDate!.day,
          endTime!.hour,
          endTime!.minute,
        );
      } else {
        combinedEndDateTime = endDate!;
      }

      await FirebaseFirestore.instance.collection('campaigns').add(
            Campaign(
              title: titleController.text,
              description: descriptionController.text,
              start: Timestamp.now(),
              end: Timestamp.fromDate(combinedEndDateTime),
              companyID: EpiFirebaseAuth.instance.currentUser!.uid,
              companyName: partnerUser.name,
              geo: geoFirePoint.data,
              isVisible: true,
              category: otherCategoryController.text.isEmpty ? categoryController.text : otherCategoryController.text,
              productName: productNameController.text,
              image: imageUrl,
              multipleImages: multipleImageUrls,
            ).toMap(),
          );

      context.pop();
    }
  }

  Future<String?> uploadImage(XFile? imageFile) async {
    if (imageFile == null) {
      return null;
    }

    final String userID = EpiFirebaseAuth.instance.currentUser!.uid;
    final String fileName = const Uuid().v4();
    final Reference reference = FirebaseStorage.instance.ref().child('user').child(userID).child(fileName);

    // Read the image file into a Uint8List
    final Uint8List imageData = await imageFile.readAsBytes();

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
