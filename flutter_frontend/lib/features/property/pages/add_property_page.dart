import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/models/property_model.dart';
import '../../../core/config/theme_config.dart';
import '../../../core/providers/property_provider.dart';
import '../../../core/services/api_service.dart';
import '../../../core/utils/navigation_utils.dart';
import '../widgets/image_upload_widget.dart';

class AddPropertyPage extends ConsumerStatefulWidget {
  const AddPropertyPage({super.key});

  @override
  ConsumerState<AddPropertyPage> createState() => _AddPropertyPageState();
}

class _AddPropertyPageState extends ConsumerState<AddPropertyPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _postalCodeController = TextEditingController();
  final _bedroomsController = TextEditingController();
  final _bathroomsController = TextEditingController();
  final _squareFeetController = TextEditingController();
  final _yearBuiltController = TextEditingController();
  final _parkingSpacesController = TextEditingController();

  PropertyType _selectedPropertyType = PropertyType.APARTMENT;
  ListingType _selectedListingType = ListingType.RENT;
  bool _isFurnished = false;
  bool _isPetFriendly = false;
  bool _hasPool = false;
  bool _hasGarden = false;
  bool _hasGym = false;
  bool _hasSecurity = false;
  
  List<File> _selectedImages = [];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _postalCodeController.dispose();
    _bedroomsController.dispose();
    _bathroomsController.dispose();
    _squareFeetController.dispose();
    _yearBuiltController.dispose();
    _parkingSpacesController.dispose();
    super.dispose();
  }

  Future<void> _submitProperty() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      // Parse price with proper validation
      final priceText = _priceController.text.trim();
      if (priceText.isEmpty) {
        throw Exception('Price is required');
      }
      
      final price = double.tryParse(priceText);
      if (price == null) {
        throw Exception('Please enter a valid price');
      }

      final property = PropertyModel(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        price: price,
        propertyType: _selectedPropertyType,
        listingType: _selectedListingType,
        address: _addressController.text.trim(),
        city: _cityController.text.trim(),
        state: _stateController.text.trim(),
        postalCode: _postalCodeController.text.trim(),
        bedrooms: int.tryParse(_bedroomsController.text),
        bathrooms: int.tryParse(_bathroomsController.text),
        squareFeet: int.tryParse(_squareFeetController.text),
        yearBuilt: int.tryParse(_yearBuiltController.text),
        parkingSpaces: int.tryParse(_parkingSpacesController.text),
        isFurnished: _isFurnished,
        isPetFriendly: _isPetFriendly,
        hasPool: _hasPool,
        hasGarden: _hasGarden,
        hasGym: _hasGym,
        hasSecurity: _hasSecurity,
      );

      // Debug logging
      print('Creating property with data:');
      property.debugLog();

      // Upload images if any
      List<PropertyImageModel> propertyImages = [];
      if (_selectedImages.isNotEmpty) {
        print('Uploading ${_selectedImages.length} images...');
        final imageUrls = await ref.read(apiServiceProvider).uploadImages(_selectedImages);
        print('Uploaded images: $imageUrls');
        
        // Create PropertyImageModel objects
        propertyImages = imageUrls.map((url) => PropertyImageModel(
          imageUrl: url,
          isPrimary: imageUrls.indexOf(url) == 0, // First image is primary
          sortOrder: imageUrls.indexOf(url),
        )).toList();
      }

      // Create property with images
      final propertyWithImages = PropertyModel(
        id: property.id,
        title: property.title,
        description: property.description,
        price: property.price,
        propertyType: property.propertyType,
        listingType: property.listingType,
        propertyStatus: property.propertyStatus,
        address: property.address,
        city: property.city,
        state: property.state,
        postalCode: property.postalCode,
        latitude: property.latitude,
        longitude: property.longitude,
        bedrooms: property.bedrooms,
        bathrooms: property.bathrooms,
        squareFeet: property.squareFeet,
        lotSize: property.lotSize,
        yearBuilt: property.yearBuilt,
        parkingSpaces: property.parkingSpaces,
        isFurnished: property.isFurnished,
        isPetFriendly: property.isPetFriendly,
        hasPool: property.hasPool,
        hasGarden: property.hasGarden,
        hasGym: property.hasGym,
        hasSecurity: property.hasSecurity,
        isVerified: property.isVerified,
        isFeatured: property.isFeatured,
        viewCount: property.viewCount,
        likeCount: property.likeCount,
        createdAt: property.createdAt,
        updatedAt: property.updatedAt,
        user: property.user,
        images: propertyImages,
        reviews: property.reviews,
        averageRating: property.averageRating,
        reviewCount: property.reviewCount,
      );

      // Submit property to API
      await ref.read(propertyListProvider.notifier).addProperty(propertyWithImages);
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Property added successfully!'),
            backgroundColor: ThemeConfig.secondaryColor,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
        context.go('/dashboard');
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error adding property: $e'),
            backgroundColor: ThemeConfig.errorColor,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeConfig.backgroundColor,
      appBar: AppBar(
        backgroundColor: ThemeConfig.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: ThemeConfig.textPrimary,
          ),
          onPressed: () => NavigationUtils.safePop(context),
        ),
        title: const Text(
          'Add Property',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: ThemeConfig.textPrimary,
            letterSpacing: -0.3,
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            child: ElevatedButton(
              onPressed: _submitProperty,
              style: ElevatedButton.styleFrom(
                backgroundColor: ThemeConfig.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Save',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.2,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              minHeight: 0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
              // Basic Information
              _buildSectionHeader('Basic Information'),
              const SizedBox(height: 16),
              
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Property Title *',
                  hintText: 'e.g., Beautiful 3BR Apartment in Victoria Island',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a property title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description *',
                  hintText: 'Describe your property...',
                ),
                maxLines: 4,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              // Responsive layout for price and listing type
              LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth < 600) {
                    // Stack vertically on small screens
                    return Column(
                      children: [
                        TextFormField(
                          controller: _priceController,
                          decoration: const InputDecoration(
                            labelText: 'Price *',
                            hintText: '0',
                            prefixText: '₦',
                          ),
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a price';
                            }
                            final trimmedValue = value.trim();
                            if (trimmedValue.isEmpty) {
                              return 'Please enter a price';
                            }
                            final price = double.tryParse(trimmedValue);
                            if (price == null) {
                              return 'Please enter a valid price (numbers only)';
                            }
                            if (price <= 0) {
                              return 'Price must be greater than 0';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<ListingType>(
                          value: _selectedListingType,
                          decoration: const InputDecoration(
                            labelText: 'Listing Type *',
                          ),
                          items: ListingType.values.map((type) {
                            return DropdownMenuItem(
                              value: type,
                              child: Text(type.displayName),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedListingType = value!;
                            });
                          },
                        ),
                      ],
                    );
                  } else {
                    // Side by side on larger screens
                    return Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _priceController,
                            decoration: const InputDecoration(
                              labelText: 'Price *',
                              hintText: '0',
                              prefixText: '₦',
                            ),
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a price';
                              }
                              final trimmedValue = value.trim();
                              if (trimmedValue.isEmpty) {
                                return 'Please enter a price';
                              }
                              final price = double.tryParse(trimmedValue);
                              if (price == null) {
                                return 'Please enter a valid price (numbers only)';
                              }
                              if (price <= 0) {
                                return 'Price must be greater than 0';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: DropdownButtonFormField<ListingType>(
                            value: _selectedListingType,
                            decoration: const InputDecoration(
                              labelText: 'Listing Type *',
                            ),
                            items: ListingType.values.map((type) {
                              return DropdownMenuItem(
                                value: type,
                                child: Text(type.displayName),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedListingType = value!;
                              });
                            },
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),
              const SizedBox(height: 16),
              
              DropdownButtonFormField<PropertyType>(
                value: _selectedPropertyType,
                decoration: const InputDecoration(
                  labelText: 'Property Type *',
                ),
                items: PropertyType.values.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text('${type.emoji} ${type.displayName}'),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedPropertyType = value!;
                  });
                },
              ),

              const SizedBox(height: 32),

              // Location Information
              _buildSectionHeader('Location Information'),
              const SizedBox(height: 16),
              
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(
                  labelText: 'Address *',
                  hintText: 'Street address',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              // Responsive layout for city and state
              LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth < 500) {
                    // Stack vertically on small screens
                    return Column(
                      children: [
                        TextFormField(
                          controller: _cityController,
                          decoration: const InputDecoration(
                            labelText: 'City *',
                            hintText: 'Lagos',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a city';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _stateController,
                          decoration: const InputDecoration(
                            labelText: 'State *',
                            hintText: 'Lagos',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a state';
                            }
                            return null;
                          },
                        ),
                      ],
                    );
                  } else {
                    // Side by side on larger screens
                    return Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _cityController,
                            decoration: const InputDecoration(
                              labelText: 'City *',
                              hintText: 'Lagos',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a city';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            controller: _stateController,
                            decoration: const InputDecoration(
                              labelText: 'State *',
                              hintText: 'Lagos',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a state';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),
              const SizedBox(height: 16),
              
              TextFormField(
                controller: _postalCodeController,
                decoration: const InputDecoration(
                  labelText: 'Postal Code',
                  hintText: '100001',
                ),
              ),

              const SizedBox(height: 32),

              // Property Details
              _buildSectionHeader('Property Details'),
              const SizedBox(height: 16),
              
              // Responsive layout for bedrooms and bathrooms
              LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth < 500) {
                    // Stack vertically on small screens
                    return Column(
                      children: [
                        TextFormField(
                          controller: _bedroomsController,
                          decoration: const InputDecoration(
                            labelText: 'Bedrooms',
                            hintText: '3',
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value != null && value.isNotEmpty) {
                              final bedrooms = int.tryParse(value.trim());
                              if (bedrooms == null) {
                                return 'Please enter a valid number';
                              }
                              if (bedrooms < 0) {
                                return 'Bedrooms cannot be negative';
                              }
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _bathroomsController,
                          decoration: const InputDecoration(
                            labelText: 'Bathrooms',
                            hintText: '2',
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value != null && value.isNotEmpty) {
                              final bathrooms = int.tryParse(value.trim());
                              if (bathrooms == null) {
                                return 'Please enter a valid number';
                              }
                              if (bathrooms < 0) {
                                return 'Bathrooms cannot be negative';
                              }
                            }
                            return null;
                          },
                        ),
                      ],
                    );
                  } else {
                    // Side by side on larger screens
                    return Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _bedroomsController,
                            decoration: const InputDecoration(
                              labelText: 'Bedrooms',
                              hintText: '3',
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value != null && value.isNotEmpty) {
                                final bedrooms = int.tryParse(value.trim());
                                if (bedrooms == null) {
                                  return 'Please enter a valid number';
                                }
                                if (bedrooms < 0) {
                                  return 'Bedrooms cannot be negative';
                                }
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            controller: _bathroomsController,
                            decoration: const InputDecoration(
                              labelText: 'Bathrooms',
                              hintText: '2',
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value != null && value.isNotEmpty) {
                                final bathrooms = int.tryParse(value.trim());
                                if (bathrooms == null) {
                                  return 'Please enter a valid number';
                                }
                                if (bathrooms < 0) {
                                  return 'Bathrooms cannot be negative';
                                }
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),
              const SizedBox(height: 16),
              
              // Responsive layout for square feet and year built
              LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth < 500) {
                    // Stack vertically on small screens
                    return Column(
                      children: [
                        TextFormField(
                          controller: _squareFeetController,
                          decoration: const InputDecoration(
                            labelText: 'Square Feet',
                            hintText: '1200',
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value != null && value.isNotEmpty) {
                              final squareFeet = int.tryParse(value.trim());
                              if (squareFeet == null) {
                                return 'Please enter a valid number';
                              }
                              if (squareFeet <= 0) {
                                return 'Square feet must be greater than 0';
                              }
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _yearBuiltController,
                          decoration: const InputDecoration(
                            labelText: 'Year Built',
                            hintText: '2020',
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value != null && value.isNotEmpty) {
                              final year = int.tryParse(value.trim());
                              if (year == null) {
                                return 'Please enter a valid year';
                              }
                              final currentYear = DateTime.now().year;
                              if (year < 1800 || year > currentYear + 1) {
                                return 'Please enter a valid year (1800-${currentYear + 1})';
                              }
                            }
                            return null;
                          },
                        ),
                      ],
                    );
                  } else {
                    // Side by side on larger screens
                    return Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _squareFeetController,
                            decoration: const InputDecoration(
                              labelText: 'Square Feet',
                              hintText: '1200',
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value != null && value.isNotEmpty) {
                                final squareFeet = int.tryParse(value.trim());
                                if (squareFeet == null) {
                                  return 'Please enter a valid number';
                                }
                                if (squareFeet <= 0) {
                                  return 'Square feet must be greater than 0';
                                }
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            controller: _yearBuiltController,
                            decoration: const InputDecoration(
                              labelText: 'Year Built',
                              hintText: '2020',
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value != null && value.isNotEmpty) {
                                final year = int.tryParse(value.trim());
                                if (year == null) {
                                  return 'Please enter a valid year';
                                }
                                final currentYear = DateTime.now().year;
                                if (year < 1800 || year > currentYear + 1) {
                                  return 'Please enter a valid year (1800-${currentYear + 1})';
                                }
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),
              const SizedBox(height: 16),
              
              TextFormField(
                controller: _parkingSpacesController,
                decoration: const InputDecoration(
                  labelText: 'Parking Spaces',
                  hintText: '2',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    final parking = int.tryParse(value.trim());
                    if (parking == null) {
                      return 'Please enter a valid number';
                    }
                    if (parking < 0) {
                      return 'Parking spaces cannot be negative';
                    }
                  }
                  return null;
                },
              ),

              const SizedBox(height: 32),

              // Amenities
              _buildSectionHeader('Amenities'),
              const SizedBox(height: 16),
              
              _buildAmenityCheckbox('Furnished', _isFurnished, (value) {
                setState(() {
                  _isFurnished = value!;
                });
              }),
              _buildAmenityCheckbox('Pet Friendly', _isPetFriendly, (value) {
                setState(() {
                  _isPetFriendly = value!;
                });
              }),
              _buildAmenityCheckbox('Swimming Pool', _hasPool, (value) {
                setState(() {
                  _hasPool = value!;
                });
              }),
              _buildAmenityCheckbox('Garden', _hasGarden, (value) {
                setState(() {
                  _hasGarden = value!;
                });
              }),
              _buildAmenityCheckbox('Gym', _hasGym, (value) {
                setState(() {
                  _hasGym = value!;
                });
              }),
              _buildAmenityCheckbox('Security', _hasSecurity, (value) {
                setState(() {
                  _hasSecurity = value!;
                });
              }),

              const SizedBox(height: 32),

              // Property Images
              _buildSectionHeader('Property Images'),
              const SizedBox(height: 16),
              ImageUploadWidget(
                images: _selectedImages,
                onImagesChanged: (images) {
                  setState(() {
                    _selectedImages = images;
                  });
                },
                maxImages: 10,
              ),

              const SizedBox(height: 32),

              // Submit Button
              ElevatedButton(
                onPressed: _submitProperty,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Add Property',
                  style: TextStyle(fontSize: 16),
                ),
              ),

              const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: ThemeConfig.textPrimary,
          letterSpacing: -0.5,
        ),
      ),
    );
  }

  Widget _buildAmenityCheckbox(
    String title,
    bool value,
    Function(bool?) onChanged,
  ) {
    return CheckboxListTile(
      title: Text(title),
      value: value,
      onChanged: onChanged,
      contentPadding: EdgeInsets.zero,
    );
  }
}
