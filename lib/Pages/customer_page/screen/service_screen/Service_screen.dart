import 'package:flutter/material.dart';
import 'package:roomspot/Models/room.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:roomspot/Pages/customer_page/customer_navbar_page.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:roomspot/Pages/customer_page/screen/service_screen/component/service_row.dart';


class ServiceScreen extends StatefulWidget {
  static const path = '/home_service';
  const ServiceScreen({super.key});

  @override
  State<ServiceScreen> createState() => _ServiceScreenState();
}

class _ServiceScreenState extends State<ServiceScreen> {
  late List<Room> roomService = [];
  bool _isLoading = false;
  void _fetchServices() async {
    setState(() {
      _isLoading = true; // Bắt đầu tải
    });
    try {
      final response = await http.get(
        Uri.parse('https://674151fde4647499008d5b55.mockapi.io/getAllPost'),
      );
      if (response.statusCode == 200) {
        // Parse JSON từ response body
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          roomService = data.map((item) => Room.fromMap(item)).toList();
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error fetching data: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchServices();
  }

  @override
  Widget build(BuildContext context) {
    return CustomerHomePage(
        child: Scaffold(
      appBar: AppBar(
        title: const Text('Dịch vụ cho thuê phòng'),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: _isLoading
          ?  Center(
        child : LoadingAnimationWidget.staggeredDotsWave(
          color: Colors.blue,
          size: 50,
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: roomService.length,
        itemBuilder: (context, index) {
          final room = roomService[index];
          return ServiceRoom(

          );
        },
      ),
        ),
    );
  }
}


