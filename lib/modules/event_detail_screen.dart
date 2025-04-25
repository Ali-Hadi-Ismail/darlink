import 'package:darlink/constants/colors/app_color.dart';
import 'package:flutter/material.dart';

class EventPage extends StatelessWidget {
  final List<Map<String, String>> events = [
    {
      'title': 'Book Fair',
      'date': 'May 15, 2025',
      'location': 'Beirut, Biel',
      'description':
          'Come explore thousands of books from international and local publishers.',
      'image':
          'https://www.globaltimes.cn/Portals/0/attachment/2022/2022-11-13/1bc337f2-f660-4614-b897-58bf1498a6e5.jpeg'
    },
    {
      'title': 'Anything Goes Bel Arabi - Award Winning Broadway Musical',
      'date': 'May 18, 2025',
      'location': 'Casino du Liban',
      'description':
          'Enjoy a spectacular Broadway musical performed entirely in Arabic.',
      'image':
          'https://cdn.ticketingboxoffice.com/uploadImages/ProducersEventsPics/Producers-Events-T-1405-638715148217700146.jpg'
    },
    {
      'title': 'Let us Walk in a Brighter Beirut',
      'date': 'May 26, 2025',
      'location': 'Corniche Ain El Mraisseh',
      'description':
          'Join us for a walk to support a greener and brighter Beirut!',
      'image':
          'https://images-ihjoz-com.s3.amazonaws.com/events/cover/6964/event_cover_WhatsApp_Image_2023-04-27_at_12.18.09_PM.jpg'
    },
    {
      'title': 'معرض الصناعة في لبنان',
      'date': 'May 8-13, 2025',
      'location': 'Beirut, Biel',
      'description': 'اكتشف المنتجات الصناعية اللبنانية من مختلف القطاعات.',
      'image':
          'https://lebanon.shafaqna.com/wp-content/uploads/2023/06/dsc_0306.jpg'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Events',
          style: TextStyle(color: textColor, fontSize: 28),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurpleAccent.withOpacity(0.4),
        elevation: 0,
      ),
      backgroundColor: backGroundColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: events.length,
          itemBuilder: (context, index) {
            final event = events[index];
            return AnimatedContainer(
              duration: Duration(milliseconds: 500 + index * 100),
              curve: Curves.easeOutBack,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EventDetailPage(event: event),
                    ),
                  );
                },
                child: EventCard(
                  title: event['title']!,
                  date: event['date']!,
                  location: event['location']!,
                  imageUrl: event['image']!,
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          print('Add Event Button Pressed');
        },
        label: const Text('Add Event'),
        icon: const Icon(Icons.add),
        backgroundColor: Colors.deepPurpleAccent,
      ),
    );
  }
}

class EventCard extends StatelessWidget {
  final String title;
  final String date;
  final String location;
  final String imageUrl;

  const EventCard({
    required this.title,
    required this.date,
    required this.location,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      margin: const EdgeInsets.only(bottom: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Hero(
            tag: imageUrl,
            child: FadeInImage.assetNetwork(
              placeholder: 'assets/images/placeholder.jpg',
              image: imageUrl,
              height: 220,
              width: double.infinity,
              fit: BoxFit.cover,
              imageErrorBuilder: (context, error, stackTrace) => Container(
                height: 220,
                color: Colors.grey[800],
                alignment: Alignment.center,
                child: const Text('Image failed to load',
                    style: TextStyle(color: Colors.white)),
              ),
            ),
          ),
          Container(
            height: 220,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.black.withOpacity(0.6), Colors.transparent],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
          ),
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    shadows: [Shadow(blurRadius: 4, color: Colors.black)],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.calendar_today,
                        size: 14, color: Colors.white70),
                    const SizedBox(width: 4),
                    Text(date,
                        style: const TextStyle(
                            color: Colors.white70, fontSize: 12)),
                    const SizedBox(width: 12),
                    const Icon(Icons.location_on,
                        size: 14, color: Colors.white70),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        location,
                        style: const TextStyle(
                            color: Colors.white70, fontSize: 12),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class EventDetailPage extends StatelessWidget {
  final Map<String, String> event;

  const EventDetailPage({required this.event});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(event['title'] ?? 'Event Details'),
        backgroundColor: Colors.deepPurpleAccent.withOpacity(0.4),
        elevation: 0,
      ),
      backgroundColor: const Color(0xFF1E1A3D),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: event['image'] ?? '',
              child: Image.network(
                event['image'] ?? '',
                width: double.infinity,
                height: 250,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const SizedBox(
                  height: 250,
                  child: Center(child: Text('Image not available')),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event['title'] ?? '',
                    style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, color: Colors.white70),
                      const SizedBox(width: 8),
                      Text(event['date'] ?? '',
                          style: const TextStyle(color: Colors.white70)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: Colors.white70),
                      const SizedBox(width: 8),
                      Expanded(
                          child: Text(event['location'] ?? '',
                              style: const TextStyle(color: Colors.white70))),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    event['description'] ?? 'No description available.',
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
