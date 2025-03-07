import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:epi_extensions/epi_extensions.dart';
import 'package:epi_firebase_auth/epi_firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geoflutterfire_plus/geoflutterfire_plus.dart';
import 'package:get_storage/get_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:models/models.dart';
import 'package:user/partner_bloc/bloc_extensions.dart';
import 'package:user/partner_bloc/partner/partner_bloc.dart';
import 'package:user/partner_screens/create/empty_time_picker.dart';
import 'package:user/services/location.dart';
import 'package:user/widgets/epi_text_field.dart';
import 'package:user/widgets/wave_dots.dart';
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
  final TextEditingController endDateController = TextEditingController();
  final TextEditingController endTimeController = TextEditingController();
  final TextEditingController productNameController = TextEditingController();
  bool includeYemeksepeti = false;
  bool includeGetir = false;

  XFile? imageFile;
  List<XFile> multipeImageFiles = [];
  bool hasImageSelected = false;
  bool hasMultipleImagesSelected = false;

  @override
  void initState() {
    super.initState();
    final value = DateTime.now();
    endDateController.text = '${value.day}/${value.month}/${value.year}';
    endDate = value;
  }

  @override
  Widget build(BuildContext context) {
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
      body: BlocBuilder<PartnerBloc, PartnerState>(
        builder: (context, state) {
          if (state is PartnerLoaded) {
            final partner = state.partner;

            return ListView(
              padding: context.mediumPadding,
              children: [
                Row(
                  children: [
                    Text(
                      'Fotoğraf',
                      style: context.theme.textTheme.bodyLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: context.theme.colorScheme.onSurface,
                      ),
                    ),
                    context.smallGap,
                    IgnorePointer(
                      ignoring: isLoading,
                      child: FilledButton(
                        onPressed: () async {
                          await selectImage();
                        },
                        child: Text(
                          hasImageSelected ? 'Değiştir' : 'Ekle',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                context.smallGap,
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
                              child: IgnorePointer(
                                ignoring: isLoading,
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
                        child: IgnorePointer(
                          ignoring: isLoading,
                          child: TextButton(
                            onPressed: () async {
                              final bool? isCameraSource = await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Fotoğraf Ekle'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop(true);
                                        },
                                        child: const Text('Kamerayı Aç'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop(false);
                                        },
                                        child: const Text('Galeriden Seç'),
                                      ),
                                    ],
                                  );
                                },
                              );

                              if (isCameraSource == null) {
                                return;
                              }

                              if (isCameraSource) {
                                final image = await ImagePicker().pickImage(source: ImageSource.camera);

                                if (image != null) {
                                  setState(() {
                                    multipeImageFiles = [...multipeImageFiles, image];
                                    hasMultipleImagesSelected = true;
                                  });
                                }
                              } else {
                                final List<XFile> images = await ImagePicker().pickMultiImage(limit: 4);
                                if (images.isNotEmpty) {
                                  setState(() {
                                    multipeImageFiles = [...multipeImageFiles, ...images];
                                    hasMultipleImagesSelected = true;
                                  });
                                }
                              }
                            },
                            child: const Icon(Icons.add),
                          ),
                        ),
                      ),
                  ],
                ),
                context.smallGap,
                EpiTextField(
                  enabled: !isLoading,
                  controller: productNameController,
                  title: 'Ürün Adı:',
                  placeholder: 'Ürün Adı',
                ),
                context.smallGap,
                EpiTextField(
                  enabled: !isLoading,
                  controller: titleController,
                  title: 'Kampanya Başlığı:',
                  placeholder: 'Başlık',
                ),
                context.smallGap,
                EpiTextField(
                  enabled: !isLoading,
                  controller: endDateController,
                  title: 'Bitiş Tarihi:',
                  placeholder: 'Tarih Seç',
                  readOnly: true,
                  onTap: () {
                    if (isLoading) {
                      return;
                    }

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
                CustomTimeInput(
                  title: 'Bitiş Saati:',
                  placeholder: 'Saat Seç',
                  isLoading: isLoading,
                  onTimeSelected: (TimeOfDay? time) {
                    if (time != null) {
                      endTime = time;
                    }
                  },
                ),
                context.smallGap,
                Row(
                  children: [
                    if (partner.yemeksepetiLink != null && partner.yemeksepetiLink != '')
                      IgnorePointer(
                        ignoring: isLoading,
                        child: Checkbox(
                          value: includeYemeksepeti,
                          onChanged: (bool? value) {
                            setState(() {
                              includeYemeksepeti = value!;
                            });
                          },
                        ),
                      ),
                    if (partner.yemeksepetiLink != null && partner.yemeksepetiLink != '') const Text('Yemeksepeti'),
                    context.mediumGap,
                    if (partner.getirLink != null && partner.getirLink != '')
                      IgnorePointer(
                        ignoring: isLoading,
                        child: Checkbox(
                          value: includeGetir,
                          onChanged: (bool? value) {
                            setState(() {
                              includeGetir = value!;
                            });
                          },
                        ),
                      ),
                    if (partner.getirLink != null && partner.getirLink != '') const Text('Getir'),
                  ],
                ),
              ],
            );
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Future<void> selectImage() async {
    final bool? isCameraSource = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Fotoğraf Ekle'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Kamerayı Aç'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Galeriden Seç'),
            ),
          ],
        );
      },
    );

    if (isCameraSource == null) {
      return;
    }

    final XFile? image = await ImagePicker().pickImage(
      source: isCameraSource ? ImageSource.camera : ImageSource.gallery,
    );
    if (image != null) {
      setState(() {
        imageFile = image;
        hasImageSelected = true;
      });
    }
  }

  Future<void> onSubmit() async {
    if (titleController.text.isEmpty || endDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Lütfen tüm alanları doldurun.')));
      return;
    }

    setState(() => isLoading = true);

    final Map<String, dynamic>? geo = GetStorage().read('geo');

    if (geo == null) {
      await LocationService.instance.getLocation();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Konum bilgisi alınamadı.')));
      setState(() => isLoading = false);
      return;
    }

    final lat = geo['lat'];
    final lan = geo['lon'];

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

      final bool isPro = EpiFirebaseAuth.instance.currentUser?.displayName == 'pro';

      await FirebaseFirestore.instance.collection('campaigns').add(
            Campaign(
              title: titleController.text,
              description: '',
              start: Timestamp.now(),
              end: Timestamp.fromDate(combinedEndDateTime),
              companyID: EpiFirebaseAuth.instance.currentUser!.uid,
              companyName: partnerUser.name,
              geo: geoFirePoint.data,
              isVisible: isPro,
              category: partnerUser.category ?? '',
              productName: productNameController.text,
              image: imageUrl,
              multipleImages: multipleImageUrls,
              yemeksepetiLink: includeYemeksepeti ? partnerUser.yemeksepetiLink : null,
              getirLink: includeGetir ? partnerUser.getirLink : null,
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
