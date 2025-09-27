import 'package:flutter/material.dart';
import '../../../core/models/property_model.dart';

class SearchFilters extends StatefulWidget {
  final Function(Map<String, dynamic>) onFiltersApplied;

  const SearchFilters({
    super.key,
    required this.onFiltersApplied,
  });

  @override
  State<SearchFilters> createState() => _SearchFiltersState();
}

class _SearchFiltersState extends State<SearchFilters> {
  double _minPrice = 0;
  double _maxPrice = 10000000;
  String _selectedCity = '';
  PropertyType? _selectedPropertyType;
  ListingType? _selectedListingType;

  final List<String> _cities = [
    'Lagos',
    'Abuja',
    'Port Harcourt',
    'Kano',
    'Ibadan',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Price Range
        const Text(
          'Price Range',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        
        RangeSlider(
          values: RangeValues(_minPrice, _maxPrice),
          min: 0,
          max: 10000000,
          divisions: 50,
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
            Text(
              '₦${(_minPrice / 1000).toStringAsFixed(0)}K',
              style: const TextStyle(fontSize: 12),
            ),
            Text(
              '₦${(_maxPrice / 1000).toStringAsFixed(0)}K',
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // City Filter
        const Text(
          'City',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        
        SizedBox(
          height: 40,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _cities.length,
            itemBuilder: (context, index) {
              final city = _cities[index];
              final isSelected = _selectedCity == city;
              
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: FilterChip(
                  label: Text(city),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      _selectedCity = selected ? city : '';
                    });
                  },
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 16),

        // Property Type Filter
        const Text(
          'Property Type',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: PropertyType.values.take(6).map((type) {
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

        const SizedBox(height: 16),

        // Listing Type Filter
        const Text(
          'Listing Type',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        
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

        const SizedBox(height: 16),

        // Apply Button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              final filters = <String, dynamic>{};
              
              if (_minPrice > 0) filters['minPrice'] = _minPrice;
              if (_maxPrice < 10000000) filters['maxPrice'] = _maxPrice;
              if (_selectedCity.isNotEmpty) filters['city'] = _selectedCity;
              if (_selectedPropertyType != null) filters['propertyType'] = _selectedPropertyType;
              if (_selectedListingType != null) filters['listingType'] = _selectedListingType;

              widget.onFiltersApplied(filters);
            },
            child: const Text('Apply Filters'),
          ),
        ),
      ],
    );
  }
}
