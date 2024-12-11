import 'package:flutter/material.dart';
class SubscriptionPage extends StatefulWidget {
  const SubscriptionPage({super.key});

  @override
  State<SubscriptionPage> createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Subscription Page"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            PremiumCard(
              title: 'Premium (3 months)',
              subtitle: 'Free for 1 month (for first time users only)',
              description: '- get supplies with a consistent cost\n - Scheduled delivery for 3 months',
              buttonLabel: 'GET 1 MONTH FREE',
              detailText: 'Monthly subscription fee applies after. Offer not available to users who already tried Premium or to users in Quebec. Terms and conditions apply. Offer ends 31 December 2021.',
              colorTop: Colors.green,
              colorBottom: Colors.teal,
            ),
            SizedBox(height: 20),
            PremiumCard(
              title: 'Premium (6 months)',
              subtitle: 'Free for 1 month',
              description: '- get supplies with a consistent cost\n - Scheduled delivery for 3 months',
              buttonLabel: 'TRY 1 MONTH FREE',
              detailText: 'Monthly subscription fee applies after. Offer not available to users who already tried Premium or to users in Quebec. Terms and conditions apply. Offer ends 31 December 2021.',
              colorTop: Colors.deepOrange,
              colorBottom: Colors.orange,
            ),
          ],
        ),
      ),
    );

      // ListView(
      //   children: [
      //     Container(
      //       height: 20,
      //       padding: EdgeInsets.all(16),
      //   margin: EdgeInsets.all(40),
      //   decoration: BoxDecoration(
      //     color: Colors.green[200], // Background color
      //     border: Border.all(
      //       color: Colors.green,  // Border color
      //       width: 2.0,          // Border width
      //     ),
      //     borderRadius: BorderRadius.circular(10), // Optional: rounded corners
      //     ),
      //
      //     ),
      //   ],
      // )

  }
}

class PremiumCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String description;
  final String buttonLabel;
  final String detailText;
  final Color colorTop;
  final Color colorBottom;

  const PremiumCard({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.buttonLabel,
    required this.detailText,
    required this.colorTop,
    required this.colorBottom,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 4,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [colorTop, colorBottom],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
              SizedBox(height: 4),
              Text(subtitle, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
              SizedBox(height: 8),
              Text(description, style: TextStyle(fontSize: 16, color: Colors.white)),
              SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,

                ),
                child: Text(buttonLabel),
              ),
              SizedBox(height: 8),
              Text(
                detailText,
                style: TextStyle(fontSize: 12, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}