import 'package:darlink/constants/colors/app_color.dart';
import 'package:darlink/modules/chat_screen.dart';
import 'package:flutter/material.dart';

class MessageScreen extends StatelessWidget {
  const MessageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backGroundColor,
      appBar: AppBar(
        title: const Text(
          'Messages',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: backGroundColor,
        centerTitle: false,
      ),
      body: Column(
        children: [
          _rowWithEdit(context),
          SizedBox(height: 10),
          Expanded(
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  _ContactCard(),
                  _ContactCard(),
                  _ContactCard(),
                  _ContactCard(),
                  _ContactCard(),
                  _ContactCard(),
                  _ContactCard(),
                  _ContactCard(),
                  _ContactCard(),
                  _ContactCard(),
                  _ContactCard(),
                  _ContactCard(),
                  _ContactCard(),
                  _ContactCard(),
                  _ContactCard(),
                  _ContactCard(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Row _rowWithEdit(BuildContext context) {
    return Row(
      children: [
        Container(
          margin: EdgeInsets.all(15),
          width: MediaQuery.of(context).size.width * 0.7,
          child: _searchContactMessage(),
        ),
        ElevatedButton(
          onPressed: () {},
          style: ButtonStyle(
            padding: WidgetStatePropertyAll(
              EdgeInsets.all(15),
            ),
            backgroundColor: MaterialStateProperty.all(
              Colors.green.shade800.withOpacity(0.7),
            ),
          ),
          child: Icon(
            Icons.mode_edit_rounded,
            color: Colors.green.shade300,
            size: 30,
          ),
        )
      ],
    );
  }

  TextFormField _searchContactMessage() {
    return TextFormField(
      decoration: InputDecoration(
        hintText: "Search ...",
        hintStyle: TextStyle(color: Colors.grey[400]),
        filled: true,
        fillColor: Colors.grey[800],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        prefixIcon: const Icon(Icons.search, color: Colors.white),
      ),
      style: const TextStyle(color: Colors.white),
    );
  }
}

class _ContactCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      hoverDuration: Durations.long1,
      onTap: () async {
        await Future.delayed(const Duration(milliseconds: 300));
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen(),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CircleAvatar(
              maxRadius: 30,
              child: Icon(Icons.person),
            ),
            SizedBox(
              width: 15,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Robert Fox",
                  style: TextStyle(color: Colors.white),
                ),
                Text(
                  "Okay , take care dear ",
                  style: TextStyle(color: Colors.white),
                )
              ],
            ),
            Spacer(),
            Column(
              children: [
                Text(
                  "12:30Am",
                  style: TextStyle(color: Colors.white),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
