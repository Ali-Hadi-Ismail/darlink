import 'package:flutter/material.dart';

void showFilterBottomSheet(BuildContext context) {
  // Define the initial range values
  RangeValues sizeRange = const RangeValues(0, 10000);
  RangeValues priceRange = const RangeValues(0, 30000);

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setModalState) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.75,
            decoration: const BoxDecoration(
              color: Color(0xFF1A1F33),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Filter',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Property Size Filter
                  const Text(
                    'Property Size',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${sizeRange.start.toInt()} sqft',
                        style: TextStyle(
                          color: Colors.cyan.shade300,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        '${sizeRange.end.toInt()} sqft',
                        style: TextStyle(
                          color: Colors.cyan.shade300,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  SliderTheme(
                    data: SliderThemeData(
                      thumbColor: Colors.cyan.shade300,
                      activeTrackColor: Colors.cyan.shade300,
                      inactiveTrackColor: Colors.grey.shade800,
                    ),
                    child: RangeSlider(
                      values: sizeRange,
                      min: 0,
                      max: 10000,
                      onChanged: (RangeValues values) {
                        setModalState(() {
                          sizeRange = values;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Property Price Filter
                  const Text(
                    'Property Price',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$${priceRange.start.toInt()}',
                        style: TextStyle(
                          color: Colors.cyan.shade300,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        '\$${priceRange.end.toInt()}',
                        style: TextStyle(
                          color: Colors.cyan.shade300,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  SliderTheme(
                    data: SliderThemeData(
                      thumbColor: Colors.cyan.shade300,
                      activeTrackColor: Colors.cyan.shade300,
                      inactiveTrackColor: Colors.grey.shade800,
                    ),
                    child: RangeSlider(
                      values: priceRange,
                      min: 0,
                      max: 30000,
                      onChanged: (RangeValues values) {
                        setModalState(() {
                          priceRange = values;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Reset and Apply Buttons
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: GestureDetector(
                          onTap: () {
                            setModalState(() {
                              sizeRange = const RangeValues(0, 10000);
                              priceRange = const RangeValues(0, 30000);
                            });
                          },
                          child: Container(
                            height: 48,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.indigo.shade300),
                            ),
                            child: Center(
                              child: Text(
                                'Reset',
                                style: TextStyle(
                                  color: Colors.indigo.shade300,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        flex: 3,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            height: 48,
                            decoration: BoxDecoration(
                              color: const Color(0xFF5D5FEF),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Center(
                              child: Text(
                                'Check availability',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}
