import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MainScreen extends StatefulWidget {
  MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final api_url = "https://psgc.gitlab.io/api";

  List<Map<String, String>> regions = [];
  List provinces = [];
  List cities = [];
  List Barangay = [];

  bool isLoading = false;
  bool isProvinceLoading = false;
  bool isCitiesLoaded = false;
  bool isBarangay = false;

  var provinceCtrl = TextEditingController();

  var cityCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadRegions();
  }

  // void openApi() async {
  void loadRegions() async {
    var url = Uri.parse("$api_url/regions");
    var response = await http.get(url);
    if (response.statusCode != 200) {
      return;
    }
    var result = jsonDecode(response.body) as List;
    result.forEach((item) {
      regions.add({'code': item['code'], 'name': item['name']});
    });
    print(regions);
    setState(() {
      isLoading = true;
    });
  }

  void loadProvinces(String regionCode) async {
    var url = Uri.parse("$api_url/regions/$regionCode/provinces/");
    var response = await http.get(url);
    if (response.statusCode != 200) {
      return;
    }
    var result = jsonDecode(response.body) as List;
    provinces.clear();
    result.forEach((item) {
      provinces.add({'code': item['code'], 'name': item['name']});
    });
    // print(regions);
    setState(() {
      isProvinceLoading = true;
    });
  }

  void loadCities(String provinceCode) async {
    var url = Uri.parse("$api_url/provinces/$provinceCode/municipalities/");
    var response = await http.get(url);
    if (response.statusCode != 200) {
      return;
    }
    var result = jsonDecode(response.body) as List;
    // provinces.clear();
    result.forEach((item) {
      cities.add({'code': item['code'], 'name': item['name']});
    });
    // print(regions);
    setState(() {
      isCitiesLoaded = true;
    });
  }

  void loadBarangay(String cityCode) async {
    var url = Uri.parse("$api_url/municipalities/$cityCode/barangays/");
    var response = await http.get(url);
    if (response.statusCode != 200) {
      return;
    }
    var result = jsonDecode(response.body) as List;
    // provinces.clear();
    result.forEach((item) {
      Barangay.add({'code': item['code'], 'name': item['name']});
    });
    // print(regions);
    setState(() {
      isBarangay = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          (isLoading == false)
              ? CircularProgressIndicator()
              : Column(
                children: [
                  // ElevatedButton(onPressed: loadRegions, child: Text("Open API")),
                  // if(isLoading == false){
                  //    CircularProgressIndicator();
                  // }

                  // else
                  DropdownMenu(
                    onSelected: (value) {
                      if (value != null) {
                        loadProvinces(value);
                      }
                      provinceCtrl.clear();
                    },
                    dropdownMenuEntries:
                        regions.map((item) {
                          return DropdownMenuEntry(
                            value: item["code"],
                            label: item["name"].toString(),
                          );
                        }).toList(),
                  ),
                  if (isProvinceLoading)
                    DropdownMenu(
                      onSelected: (value) {
                        loadCities(value);
                      },
                      controller: provinceCtrl,
                      dropdownMenuEntries:
                          provinces.map((item) {
                            return DropdownMenuEntry(
                              value: item["code"],
                              label: item["name"].toString(),
                            );
                          }).toList(),
                    ),

                  if (isCitiesLoaded)
                    DropdownMenu(
                      onSelected: (value) {
                        loadBarangay(value);
                      },
                      controller: cityCtrl,
                      dropdownMenuEntries:
                          cities.map((item) {
                            return DropdownMenuEntry(
                              value: item["code"],
                              label: item["name"].toString(),
                            );
                          }).toList(),
                    ),
                  if (isBarangay)
                    DropdownMenu(
                      // onSelected: (value) {
                      //   loadBarangay(value);
                      // },
                      // controller: cityCtrl,
                      dropdownMenuEntries:
                          Barangay.map((item) {
                            return DropdownMenuEntry(
                              value: item["code"],
                              label: item["name"].toString(),
                            );
                          }).toList(),
                    ),
                ],
              ),
    );
  }
}
