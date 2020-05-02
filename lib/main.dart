import 'package:covid_19/constant.dart';
import 'package:covid_19/widgets/counter.dart';
import 'package:covid_19/widgets/my_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Covid 19',
      theme: ThemeData(
          scaffoldBackgroundColor: kBackgroundColor,
          fontFamily: "Poppins",
          textTheme: TextTheme(
            body1: TextStyle(color: kBodyTextColor),
          )),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoading = true;
  String val = "All Regions(India)";
  int numInfected, numDeath, numRecovered;
  var DATA;

  Future<void> _fetchData(String region) async {
    setState(() {
      val = region;
      _isLoading = true;
    });
    final url = "https://api.rootnet.in/covid19-in/stats/latest";
    final response = await http.get(url);
    if (response == null) return;
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    final extractedDataFiltered = extractedData['data'] as Map<String, dynamic>;
    final regional = extractedDataFiltered['regional'] as List<dynamic>;
    final summary =
        extractedDataFiltered['unofficial-summary'] as List<dynamic>;
    final overallData = summary[0];
    DATA = summary;
    print(summary);
    if (region == "All Regions(India)") {
      numInfected = overallData['total'];
      numDeath = overallData['deaths'];
      numRecovered = overallData['recovered'];
    } else {
      for (final item in regional) {
        if (item['loc'] == region) {
          numInfected = item['totalConfirmed'];
          numDeath = item['deaths'];
          numRecovered = item['discharged'];
          break;
        }
      }
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    Future.delayed(Duration.zero).then((_) async {
      setState(() {
        _isLoading = true;
      });
      await _fetchData("All Regions(India)");
      setState(() {
        _isLoading = false;
        print("stopped");
      });
    });
    super.initState();
  }

  static DateTime now = DateTime.now();
  String formattedDate = DateFormat('dd/MM/yyyy').format(now);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            MyHeader(
              image: "assets/icons/Drcorona.svg",
              textTop: "STAY HOME",
              textBottom: "STAY SAFE !",
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              height: 60,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: Color(0xFFE5E5E5),
                ),
              ),
              child: Row(
                children: <Widget>[
                  SvgPicture.asset("assets/icons/maps-and-flags.svg"),
                  SizedBox(width: 20),
                  Expanded(
                    child: DropdownButton(
                      isExpanded: true,
                      underline: SizedBox(),
                      icon: SvgPicture.asset("assets/icons/dropdown.svg"),
                      value: val,
                      items: [
                        "All Regions(India)",
                        "Andaman and Nicobar Islands",
                        "Andhra Pradesh",
                        "Arunachal Pradesh",
                        "Assam",
                        "Bihar",
                        "Chandigarh",
                        "Chhattisgarh",
                        "Delhi",
                        "Goa",
                        "Gujarat",
                        "Haryana",
                        "Himachal Pradesh",
                        "Jammu and Kashmir",
                        "Jharkhand",
                        "Karnataka",
                        "Kerala",
                        "Ladakh",
                        "Madhya Pradesh",
                        "Maharashtra",
                        "Manipur",
                        "Meghalaya",
                        "Mizoram",
                        "Odisha",
                        "Puducherry",
                        "Punjab",
                        "Rajasthan",
                        "Tamil Nadu",
                        "Telengana",
                        "Tripura",
                        "Uttarakhand",
                        "Uttar Pradesh",
                        "West Bengal",
                      ].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (value) {
                        _fetchData(value);
                        print(_isLoading);
                        print(DATA);
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "Case Update\n",
                              style: kTitleTextstyle,
                            ),
                            TextSpan(
                              text: "Newest update " + formattedDate,
                              style: TextStyle(
                                color: kTextLightColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Counter(
                          color: kInfectedColor,
                          number: numInfected,
                          title: "Infected",
                          isLoading: _isLoading,
                        ),
                        Counter(
                          color: kDeathColor,
                          number: numDeath,
                          title: "Deaths",
                          isLoading: _isLoading,
                        ),
                        Counter(
                          color: kRecovercolor,
                          number: numRecovered,
                          title: "Recovered",
                          isLoading: _isLoading,
                        ),
                      ],
                    ),
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
