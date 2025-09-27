import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/property_model.dart';
import '../../../core/config/theme_config.dart';
import '../../../core/utils/navigation_utils.dart';

class FilterPage extends ConsumerStatefulWidget {
  const FilterPage({super.key});

  @override
  ConsumerState<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends ConsumerState<FilterPage> {
  double _minPrice = 0;
  double _maxPrice = 10000000;
  String _selectedCity = '';
  String _selectedState = '';
  PropertyType? _selectedPropertyType;
  ListingType? _selectedListingType;
  int? _minBedrooms;
  int? _maxBedrooms;
  int? _minBathrooms;
  int? _maxBathrooms;

  final List<String> _cities = [
    'Lagos',
    'Abuja',
    'Port Harcourt',
    'Kano',
    'Ibadan',
    'Benin City',
    'Kaduna',
    'Jos',
  ];

  final List<String> _states = [
    'Lagos',
    'Abuja FCT',
    'Rivers',
    'Kano',
    'Oyo',
    'Edo',
    'Kaduna',
    'Plateau',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => NavigationUtils.safePop(context),
        ),
        title: const Text(
          'Filters',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          TextButton(
            onPressed: _clearFilters,
            child: const Text('Clear'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Price Range
            _buildSectionHeader('Price Range'),
            const SizedBox(height: 16),
            
            RangeSlider(
              values: RangeValues(_minPrice, _maxPrice),
              min: 0,
              max: 10000000,
              divisions: 100,
              labels: RangeLabels(
                '₦${_minPrice.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                '₦${_maxPrice.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
              ),
              onChanged: (values) {
                setState(() {
                  _minPrice = values.start;
                  _maxPrice = values.end;
                });
              },
            ),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('₦${_minPrice.toStringAsFixed(0)}'),
                Text('₦${_maxPrice.toStringAsFixed(0)}'),
              ],
            ),

            const SizedBox(height: 32),

            // Location
            _buildSectionHeader('Location'),
            const SizedBox(height: 16),
            
            DropdownButtonFormField<String>(
              value: _selectedCity.isEmpty ? null : _selectedCity,
              decoration: const InputDecoration(
                labelText: 'City',
                border: OutlineInputBorder(),
              ),
              items: _cities.map((city) {
                return DropdownMenuItem(
                  value: city,
                  child: Text(city),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCity = value ?? '';
                });
              },
            ),
            const SizedBox(height: 16),
            
            DropdownButtonFormField<String>(
              value: _selectedState.isEmpty ? null : _selectedState,
              decoration: const InputDecoration(
                labelText: 'State',
                border: OutlineInputBorder(),
              ),
              items: _states.map((state) {
                return DropdownMenuItem(
                  value: state,
                  child: Text(state),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedState = value ?? '';
                });
              },
            ),

            const SizedBox(height: 32),

            // Property Type
            _buildSectionHeader('Property Type'),
            const SizedBox(height: 16),
            
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: PropertyType.values.map((type) {
                final isSelected = _selectedPropertyType == type;
                return FilterChip(
                  label: Text('${type.emoji} ${type.displayName}'),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      _selectedPropertyType = selected ? type : null;
                    });
                  },
                );
              }).toList(),
            ),

            const SizedBox(height: 32),

            // Listing Type
            _buildSectionHeader('Listing Type'),
            const SizedBox(height: 16),
            
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: ListingType.values.map((type) {
                final isSelected = _selectedListingType == type;
                return FilterChip(
                  label: Text(type.displayName),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      _selectedListingType = selected ? type : null;
                    });
                  },
                );
              }).toList(),
            ),

            const SizedBox(height: 32),

            // Bedrooms
            _buildSectionHeader('Bedrooms'),
            const SizedBox(height: 16),
            
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<int>(
                    value: _minBedrooms,
                    decoration: const InputDecoration(
                      labelText: 'Min Bedrooms',
                      border: OutlineInputBorder(),
                    ),
                    items: List.generate(6, (index) {
                      return DropdownMenuItem(
                        value: index,
                        child: Text(index == 0 ? 'Any' : '$index'),
                      );
                    }),
                    onChanged: (value) {
                      setState(() {
                        _minBedrooms = value;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<int>(
                    value: _maxBedrooms,
                    decoration: const InputDecoration(
                      labelText: 'Max Bedrooms',
                      border: OutlineInputBorder(),
                    ),
                    items: List.generate(6, (index) {
                      return DropdownMenuItem(
                        value: index,
                        child: Text(index == 0 ? 'Any' : '$index'),
                      );
                    }),
                    onChanged: (value) {
                      setState(() {
                        _maxBedrooms = value;
                      });
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Bathrooms
            _buildSectionHeader('Bathrooms'),
            const SizedBox(height: 16),
            
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<int>(
                    value: _minBathrooms,
                    decoration: const InputDecoration(
                      labelText: 'Min Bathrooms',
                      border: OutlineInputBorder(),
                    ),
                    items: List.generate(6, (index) {
                      return DropdownMenuItem(
                        value: index,
                        child: Text(index == 0 ? 'Any' : '$index'),
                      );
                    }),
                    onChanged: (value) {
                      setState(() {
                        _minBathrooms = value;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<int>(
                    value: _maxBathrooms,
                    decoration: const InputDecoration(
                      labelText: 'Max Bathrooms',
                      border: OutlineInputBorder(),
                    ),
                    items: List.generate(6, (index) {
                      return DropdownMenuItem(
                        value: index,
                        child: Text(index == 0 ? 'Any' : '$index'),
                      );
                    }),
                    onChanged: (value) {
                      setState(() {
                        _maxBathrooms = value;
                      });
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: _clearFilters,
                child: const Text('Clear All'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: _applyFilters,
                child: const Text('Apply Filters'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: ThemeConfig.textPrimary,
      ),
    );
  }

  void _clearFilters() {
    setState(() {
      _minPrice = 0;
      _maxPrice = 10000000;
      _selectedCity = '';
      _selectedState = '';
      _selectedPropertyType = null;
      _selectedListingType = null;
      _minBedrooms = null;
      _maxBedrooms = null;
      _minBathrooms = null;
      _maxBathrooms = null;
    });
  }

  void _applyFilters() {
    final filters = <String, dynamic>{};
    
    if (_minPrice > 0) filters['minPrice'] = _minPrice;
    if (_maxPrice < 10000000) filters['maxPrice'] = _maxPrice;
    if (_selectedCity.isNotEmpty) filters['city'] = _selectedCity;
    if (_selectedState.isNotEmpty) filters['state'] = _selectedState;
    if (_selectedPropertyType != null) filters['propertyType'] = _selectedPropertyType;
    if (_selectedListingType != null) filters['listingType'] = _selectedListingType;
    if (_minBedrooms != null && _minBedrooms! > 0) filters['minBedrooms'] = _minBedrooms;
    if (_maxBedrooms != null && _maxBedrooms! > 0) filters['maxBedrooms'] = _maxBedrooms;
    if (_minBathrooms != null && _minBathrooms! > 0) filters['minBathrooms'] = _minBathrooms;
    if (_maxBathrooms != null && _maxBathrooms! > 0) filters['maxBathrooms'] = _maxBathrooms;

    // TODO: Apply filters to property list
    Navigator.of(context).pop(filters);
  }
}
