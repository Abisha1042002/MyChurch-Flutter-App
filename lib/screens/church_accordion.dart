import 'package:flutter/material.dart';
import 'package:accordion/accordion.dart';
import 'package:my_church/screens/daily_bible_verse_upload.dart';
import 'package:my_church/screens/events_list.dart';
import 'package:my_church/screens/marriage_list.dart';

class ChurchAccordion extends StatefulWidget {
  const ChurchAccordion({super.key});

  @override
  State<ChurchAccordion> createState() => ChurchAccordionState();
}

class ChurchAccordionState extends State<ChurchAccordion> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 10, spreadRadius: 2),
          ],
          image: const DecorationImage(
            image: AssetImage("assets/church.png"), // 🎨 Set Background Image
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.7), // 🌟 Light Overlay Effect
            borderRadius: BorderRadius.circular(20),
          ),
          child: Accordion(
            maxOpenSections: 1,
            headerBackgroundColorOpened: Colors.brown[300],
            headerBackgroundColor: Colors.brown[200],
            scaleWhenAnimating: true,
            openAndCloseAnimation: true,
            paddingListBottom: 10,
            children: [
              // 📖 History of CSI
              AccordionSection(
                header: _buildHeader(Icons.book, "History of St.Thomas Church"),
                content: const Padding(
                  padding: EdgeInsets.all(25),
                  child: Text(
                    "Canon Rev. S. Paul Manickam, wished to establish a church in the college Road, Perumalpuram when he was doing pastoral ministry in Palayamkottai between 1956 to 1959. Some money was collected for the purpose. However, he could not do that at that time. In 1965, after his retirement from the pastoral ministry, he settled in Perumalpuram and began the work of establishing a church in Perumalpuram.   At first, a land was gifted by a person called Paulpillai and the service was conducted in a thatched house with seven Christian families. In the same year, the Bishop Rt. Rev. A.G. Jebaraj B.A., B.D laid the foundation stone for a church on 21st December 1965 being the day of St. Thomas. Thanks to the great services of Canon Rev. S. Paul Manickam, Mr. Artimas and Mrs. Leela Gnanaraj. By their tireless service and with the donations of the people, the St Thomas Church was built within four years. The St. Thomas Church was dedicated by the Bishop Rt. Rev. A.G. Jebaraj B.A., B.D. on 20.12.69. At the time of dedication, the church did not have the flooring.  The flooring work and the mandapam were added in the succeeding years. Perumalpuram became a Pastorate independent from Kulavanigarpuram on 1-7-84. The St. Thomas Church celebrated the Silver Jubilee on 21.12.94.  During the period of Rev. Gandhi Selwyn the Church was extended with two balconies and four rooms which were dedicated by this Bishop Rt. Rev. Jason S. Dharmaraj M.A., B.D., D.Th. on 1.2.98. On every 21st December, at the St. Thomas day the Church celebrates Dedication Festival and Asanam. Harvest Festival is celebrated in the month of November.  Ekklesia is the church’s magazine that carries the monthly schedule of the church.  It also includes a message of the promise and a bible study.",
                    textAlign: TextAlign.justify,
                    style: TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                ),
                headerPadding: const EdgeInsets.symmetric(vertical: 35, horizontal: 25),
                headerBorderRadius: 20,
                contentBorderRadius: 20,
                headerBackgroundColor: Colors.brown[300],
                headerBackgroundColorOpened: Colors.brown[500],
              ),

              // 📜 Daily Bible Verse
              AccordionSection(
                header: _buildHeader(Icons.auto_stories, "Daily Bible Verse"),
                content: const Padding(
                  padding: EdgeInsets.all(25),
                  child: BibleVerseWidget(), // Call BibleVerseWidget here
                ),
                headerPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
                headerBorderRadius: 20,
                contentBorderRadius: 20,
                headerBackgroundColor: Colors.brown[300],
                headerBackgroundColorOpened: Colors.brown[500],
              ),

              // 🎉 Upcoming Church Events
      AccordionSection(
          header: _buildHeader(Icons.event, "Upcoming Church Events"),
      content: SizedBox(
        height: 350, // Adjust height as needed
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10), // Avoid overflow
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // Align to left
              children: const [
                EventListPage(), // ⚡ Fetch and display events here
              ],
            ),
          ),
        ),
      ),
      headerPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
      headerBorderRadius: 20,
      contentBorderRadius: 20,
      headerBackgroundColor: Colors.brown[300],
      headerBackgroundColorOpened: Colors.brown[500],
    ),
              AccordionSection(
                header: _buildHeader(Icons.event, "Marriage Events"),
                content: const SizedBox(
                  height: 350, // Adjust height as needed
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10), // Avoid overflow
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start, // Align to left
                        children: [
                          MarriageListPage() // ⚡ Fetch and display events here
                        ],
                      ),
                    ),
                  ),
                ),
                headerPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
                headerBorderRadius: 20,
                contentBorderRadius: 20,
                headerBackgroundColor: Colors.brown[300],
                headerBackgroundColorOpened: Colors.brown[500],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 📌 Function to create a header with an icon
  Widget _buildHeader(IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, color: Colors.white, size: 30),
        const SizedBox(width: 20),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 5,
          ),
        ),
      ],
    );
  }
}