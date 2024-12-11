import 'package:app/utils/appcolors.dart';
import 'package:app/utils/texttheme.dart';
import 'package:flutter/material.dart';

class CommunityPage extends StatefulWidget {
  @override
  _CommunityPageState createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  final List<Map<String, dynamic>> _initialCommunities = [
    {
      'name': 'AgroConnect',
      'location': 'Texas, USA',
      'members': 1200,
      'nextDelivery': '15th Dec',
      'stockPercent': 75
    },
    {
      'name': 'Harvest Helpers',
      'location': 'Ontario, Canada',
      'members': 950,
      'nextDelivery': '20th Dec',
      'stockPercent': 60
    },
    {
      'name': 'GreenGrowers',
      'location': 'Queensland, Australia',
      'members': 800,
      'nextDelivery': '25th Dec',
      'stockPercent': 85
    },
    {
      'name': 'EcoFarmers',
      'location': 'Kerala, India',
      'members': 1500,
      'nextDelivery': '30th Dec',
      'stockPercent': 50
    },
  ];

  List<Map<String, dynamic>> communities = [];
  final TextEditingController _searchController = TextEditingController();
  String _sortBy = 'Members';
  final List<String> _sortOptions = ['Members', 'Stock', 'Name'];

  @override
  void initState() {
    super.initState();
    _initializeCommunities();
  }

  void _initializeCommunities() {
    communities = List.from(_initialCommunities);
  }

  void _filterCommunities(String query) {
    setState(() {
      communities = _initialCommunities.where((community) {
        final nameMatch = community['name']
            .toString()
            .toLowerCase()
            .contains(query.toLowerCase());
        final locationMatch = community['location']
            .toString()
            .toLowerCase()
            .contains(query.toLowerCase());
        return nameMatch || locationMatch;
      }).toList();

      // Re-apply sorting
      _sortCommunities(_sortBy);
    });
  }

  void _sortCommunities(String sortBy) {
    setState(() {
      _sortBy = sortBy;
      switch (sortBy) {
        case 'Members':
          communities.sort((a, b) => b['members'].compareTo(a['members']));
          break;
        case 'Stock':
          communities
              .sort((a, b) => b['stockPercent'].compareTo(a['stockPercent']));
          break;
        case 'Name':
          communities.sort((a, b) => a['name'].compareTo(b['name']));
          break;
      }
    });
  }

  void _addCommunity() {
    showDialog(
      context: context,
      builder: (context) {
        final TextEditingController nameController = TextEditingController();
        final TextEditingController locationController = TextEditingController();
        return AlertDialog(
          title: Text('Add New Community'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  controller: locationController,
                  decoration: InputDecoration(labelText: 'Location'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  communities.add({
                    'name': nameController.text,
                    'location': locationController.text,
                    'members': 1,
                    'nextDelivery': Null,
                    'stockPercent': Null,
                  });
                  _sortCommunities(_sortBy);
                });
                Navigator.pop(context);
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kBackground,
      appBar: AppBar(
        title: Text(
          'Community',
          textAlign: TextAlign.center,
          style: TextPref.opensans.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 28,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.kBackground,
        foregroundColor: Colors.black,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: _searchController,
                    onChanged: _filterCommunities,
                    decoration: InputDecoration(
                      hintText: 'Search communities...',
                      prefixIcon: Icon(Icons.search, color: Colors.brown),
                      filled: true,
                      fillColor: Colors.yellow[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.yellow[200],
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: _sortBy,
                        icon: Icon(Icons.sort, color: Colors.brown),
                        dropdownColor: Colors.yellow[200],
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            _sortCommunities(newValue);
                          }
                        },
                        items: _sortOptions
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                value,
                                style: TextStyle(color: Colors.brown),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: communities.length,
              itemBuilder: (context, index) {
                final community = communities[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 6.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.yellow[50],
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.yellow.withOpacity(0.3),
                          blurRadius: 6,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                community['name'],
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.teal[900],
                                ),
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.person,
                                    size: 18,
                                    color: Colors.teal[700],
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${community['members']}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.teal[700],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            community['location'],
                            style: TextStyle(color: Colors.teal[700]),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Next Delivery:',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.teal[900],
                                ),
                              ),
                              Text(
                                community['nextDelivery'],
                                style: TextStyle(
                                  color: Colors.teal[700],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Stock Required:',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.teal[900],
                                ),
                              ),
                              Text(
                                '${community['stockPercent']}%',
                                style: TextStyle(
                                  color: Colors.teal[700],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addCommunity,
        child: Icon(Icons.add),
        backgroundColor: Colors.teal,
      ),
    );
  }
}
