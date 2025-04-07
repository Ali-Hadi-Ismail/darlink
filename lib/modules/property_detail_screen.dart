import 'package:darlink/models/propertyData.dart';
import 'package:flutter/material.dart';

class PropertyDetailsScreen extends StatefulWidget {
  final PropertyData property;

  const PropertyDetailsScreen({
    Key? key,
    required this.property,
  }) : super(key: key);

  @override
  _PropertyDetailsScreenState createState() => _PropertyDetailsScreenState();
}

class _PropertyDetailsScreenState extends State<PropertyDetailsScreen> {
  bool amenitiesExpanded = false;
  bool interiorExpanded = false;
  bool constructionExpanded = false;
  bool isSaved = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1E1E38),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              _buildPropertyCard(),
              _buildAgentCard(),
              _buildExpandableSection(
                'Amenities',
                widget.property.amenities,
                amenitiesExpanded,
                () => setState(() => amenitiesExpanded = !amenitiesExpanded),
              ),
              _buildExpandableSection(
                'Interior Details',
                widget.property.interiorDetails,
                interiorExpanded,
                () => setState(() => interiorExpanded = !interiorExpanded),
              ),
              _buildExpandableSection(
                'Construction Details',
                widget.property.constructionDetails,
                constructionExpanded,
                () => setState(
                    () => constructionExpanded = !constructionExpanded),
              ),
              _buildLocationSection(),
              _buildSaveButton(),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Icon(Icons.arrow_back_ios, color: Colors.white70, size: 20),
          ),
          SizedBox(width: 16),
          Text(
            'Property Details',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Spacer(),
          GestureDetector(
            onTap: () {
              setState(() {
                isSaved = !isSaved;
              });
            },
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isSaved
                    ? Color(0xFF9E78FF).withOpacity(0.2)
                    : Color(0xFF3D3A60),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                isSaved ? Icons.bookmark : Icons.bookmark_outline,
                color: isSaved ? Color(0xFF9E78FF) : Colors.white70,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPropertyCard() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Color(0xFF2D2D4A),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Property Image
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Image.asset(
                widget.property.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.grey.shade800,
                  child:
                      Center(child: Icon(Icons.image_not_supported, size: 50)),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.property.title,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Text(
                      '\$${widget.property.price.toInt()}',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF9E78FF),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.location_on, size: 16, color: Colors.white70),
                    SizedBox(width: 4),
                    Text(
                      widget.property.address,
                      style: TextStyle(color: Colors.white70),
                    ),
                    Spacer(),
                    Text(
                      '(${widget.property.area}sqft)',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _buildPropertyFeature(Icons.bed,
                        '${widget.property.bedrooms} Bed', Colors.red.shade300),
                    SizedBox(width: 24),
                    _buildPropertyFeature(
                        Icons.bathtub,
                        '${widget.property.bathrooms} Bath',
                        Colors.red.shade300),
                    SizedBox(width: 24),
                    _buildPropertyFeature(
                        Icons.kitchen,
                        '${widget.property.kitchens} Kitchen',
                        Colors.red.shade300),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPropertyFeature(IconData icon, String text, Color color) {
    return Row(
      children: [
        Icon(icon, size: 18, color: color),
        SizedBox(width: 4),
        Text(text, style: TextStyle(color: Colors.white70)),
      ],
    );
  }

  Widget _buildAgentCard() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF2D2D4A),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: Colors.grey.shade800,
            child: Text(
              widget.property.ownerName.substring(0, 1),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.property.ownerName,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  widget.property.ownerRole,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  widget.property.ownerQuote,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  children: List.generate(
                    5,
                    (index) => Icon(
                      Icons.star,
                      size: 16,
                      color: index < widget.property.ownerRating
                          ? Colors.amber
                          : Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpandableSection(
      String title, List<String> items, bool isExpanded, VoidCallback onTap) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.white12, width: 1),
        ),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ),
          if (isExpanded)
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 3.5,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Color(0xFF3D3A60),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Color(0xFF4A44C9), width: 1),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 18,
                          height: 18,
                          decoration: BoxDecoration(
                            color: Color(0xFF9E78FF).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Icon(
                            Icons.check,
                            size: 12,
                            color: Color(0xFF9E78FF),
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            items[index],
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildLocationSection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Text(
              'Location Map & Details',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              height: 180,
              width: double.infinity,
              color: Color(0xFF272743),
              child: Center(
                child: Icon(Icons.map, size: 50, color: Colors.grey),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            isSaved = !isSaved;
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: isSaved ? Colors.green : Color(0xFF4A44C9),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          isSaved ? 'Saved' : 'Save',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

// Example of how to navigate to this screen from your home screen:
/*
Navigator.push(
  context, 
  MaterialPageRoute(
    builder: (context) => PropertyDetailsScreen(
      property: myPropertyData,
    ),
  ),
);
*/
