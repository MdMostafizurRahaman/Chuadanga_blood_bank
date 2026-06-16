import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/donor.dart';
import '../services/api_service.dart';

class DashboardScreen extends StatefulWidget {
  final Map<String, dynamic> donorJson;
  const DashboardScreen({super.key, required this.donorJson});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late Donor _donor;
  List<Donor> _donors = [];
  List<String> _upazilas = [];
  String? _selectedUpazila;
  String? _selectedBloodGroup;
  bool _loading = true;

  final List<String> _bloodGroups = ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'];

  @override
  void initState() {
    super.initState();
    _donor = Donor.fromJson(widget.donorJson);
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      _upazilas = await ApiService.getUpazilas();
      await _searchDonors();
    } catch (e) {
      //
    }
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _searchDonors() async {
    try {
      final results = await ApiService.searchDonors(
        bloodGroup: _selectedBloodGroup,
        upazila: _selectedUpazila,
      );
      if (mounted) setState(() => _donors = results);
    } catch (e) {
      //
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Available Donors'),
        backgroundColor: Colors.red,
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Center(
              child: Text(_donor.name, style: const TextStyle(fontSize: 13)),
            ),
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  color: Colors.red.shade50,
                  child: Row(
                    children: [
                      Icon(Icons.person, color: Colors.red.shade700),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Welcome, ${_donor.name}', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red.shade800)),
                          Text('${_donor.bloodGroup} | ${_donor.upazila}', style: TextStyle(fontSize: 12, color: Colors.red.shade600)),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          initialValue: _selectedUpazila,
                          decoration: InputDecoration(
                            labelText: 'Upazila',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          ),
                          items: [const DropdownMenuItem(value: null, child: Text('All Upazila'))]
                              ..addAll(_upazilas.map((u) => DropdownMenuItem(value: u, child: Text(u)))),
                          onChanged: (v) {
                            setState(() => _selectedUpazila = v);
                            _searchDonors();
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          initialValue: _selectedBloodGroup,
                          decoration: InputDecoration(
                            labelText: 'Blood Group',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          ),
                          items: [const DropdownMenuItem(value: null, child: Text('All Groups'))]
                              ..addAll(_bloodGroups.map((bg) => DropdownMenuItem(value: bg, child: Text(bg)))),
                          onChanged: (v) {
                            setState(() => _selectedBloodGroup = v);
                            _searchDonors();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: _donors.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
                              const SizedBox(height: 12),
                              Text('No donors found', style: TextStyle(fontSize: 16, color: Colors.grey[600])),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          itemCount: _donors.length,
                          itemBuilder: (context, index) {
                            final donor = _donors[index];
                            return Card(
                              margin: const EdgeInsets.only(bottom: 8),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: Colors.red.shade50,
                                  child: Text(
                                    donor.bloodGroup,
                                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red.shade700, fontSize: 12),
                                  ),
                                ),
                                title: Text(donor.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                                subtitle: Text('${donor.upazila} | ${donor.phone}'),
                                trailing: ElevatedButton(
                                  onPressed: () {
                                    final uri = Uri.parse('tel:${donor.phone}');
                                    launchUrl(uri, mode: LaunchMode.externalApplication);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(horizontal: 12),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  ),
                                  child: const Text('Call', style: TextStyle(fontSize: 12)),
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}
