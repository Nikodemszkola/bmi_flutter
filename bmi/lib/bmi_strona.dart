
import 'package:flutter/material.dart';

class BmiPage extends StatefulWidget {
  @override
  _BmiPageState createState() => _BmiPageState();
}

class _BmiPageState extends State<BmiPage> {
  final TextEditingController heightCm = TextEditingController();
  final TextEditingController heightFt = TextEditingController();
  final TextEditingController heightIn = TextEditingController();
  final TextEditingController weight = TextEditingController();
  final TextEditingController waist = TextEditingController();
  final TextEditingController hips = TextEditingController();

  String unit = 'cm';
  String gender = 'male';
  String activity = '1.2';
  String goal = 'maintain';

  double? bmi;
  double? bmr;
  double? tdee;
  double? whr;
  double? whtr;

  double getHeightMeters() {
    if (unit == 'cm') {
      return (double.tryParse(heightCm.text) ?? 0) / 100;
    } else {
      final ft = double.tryParse(heightFt.text) ?? 0;
      final inch = double.tryParse(heightIn.text) ?? 0;
      return ((ft * 12 + inch) * 2.54) / 100;
    }
  }

    String bmiCategory(double bmi) {
    if (bmi < 18.5) return "Niedowaga";
    if (bmi < 25) return "Waga prawidłowa";
    if (bmi < 30) return "Nadwaga";
    return "Otyłość";
  }
  void calculate() {
    final h = getHeightMeters();
    final w = double.tryParse(weight.text) ?? 0;
    final waistVal = double.tryParse(waist.text) ?? 0;
    final hipsVal = double.tryParse(hips.text) ?? 0;

    if (h == 0 || w == 0) return;

    final bmiCalc = w / (h * h);
    final heightCmVal = h * 100;

    double bmrCalc;
    if (gender == 'male') {
      bmrCalc = 10 * w + 6.25 * heightCmVal - 5 * 30 + 5;
    } else {
      bmrCalc = 10 * w + 6.25 * heightCmVal - 5 * 30 - 161;
    }

    final tdeeCalc = bmrCalc * double.parse(activity);

    double tdeeAdjusted = tdeeCalc;
    if (goal == 'cut') tdeeAdjusted -= 500;
    if (goal == 'bulk') tdeeAdjusted += 300;

    setState(() {
      bmi = bmiCalc;
      bmr = bmrCalc;
      tdee = tdeeAdjusted;
      whr = (waistVal > 0 && hipsVal > 0) ? waistVal / hipsVal : null;
      whtr = waistVal > 0 ? waistVal / heightCmVal : null;
    });
  }

  Widget card(Widget child) {
    return Container(
      padding: EdgeInsets.all(18),
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 12)
        ],
      ),
      child: child,
    );
  }

  List<Widget> formularzWidgets() {
    return [
      card(Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Jednostki', style: TextStyle(fontWeight: FontWeight.bold)),
        DropdownButton<String>(
          value: unit,
          items: [
            DropdownMenuItem(value: 'cm', child: Text('cm / kg')),
            DropdownMenuItem(value: 'ft', child: Text('ft / in')),
          ],
          onChanged: (v) => setState(() => unit = v!),
        ),

        if (unit == 'cm')
          TextField(controller: heightCm, decoration: InputDecoration(labelText: 'Wzrost (cm)')),

        if (unit == 'ft')
          Row(children: [
            Expanded(child: TextField(controller: heightFt, decoration: InputDecoration(labelText: 'ft'))),
            SizedBox(width: 10),
            Expanded(child: TextField(controller: heightIn, decoration: InputDecoration(labelText: 'in'))),
          ]),

        TextField(controller: weight, decoration: InputDecoration(labelText: 'Waga (kg)')),
      ])),

      card(Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Profil', style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 6),
        Text('Wpływa na zapotrzebowanie kaloryczne (BMR i TDEE)', style: TextStyle(color: Colors.grey)),

        DropdownButton<String>(
          value: gender,
          items: [
            DropdownMenuItem(value: 'male', child: Text('Mężczyzna')),
            DropdownMenuItem(value: 'female', child: Text('Kobieta')),
          ],
          onChanged: (v) => setState(() => gender = v!),
        ),

        DropdownButton<String>(
          value: activity,
          items: [
            DropdownMenuItem(value: '1.2', child: Text('Siedzący tryb życia')),
            DropdownMenuItem(value: '1.55', child: Text('Umiarkowana aktywność')),
            DropdownMenuItem(value: '1.9', child: Text('Wysoka aktywność')),
          ],
          onChanged: (v) => setState(() => activity = v!),
        ),

        DropdownButton<String>(
          value: goal,
          items: [
            DropdownMenuItem(value: 'maintain', child: Text('Utrzymanie wagi')),
            DropdownMenuItem(value: 'cut', child: Text('Redukcja (-500 kcal)')),
            DropdownMenuItem(value: 'bulk', child: Text('Masa (+300 kcal)')),
          ],
          onChanged: (v) => setState(() => goal = v!),
        ),
      ])),

      card(Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Obwody', style: TextStyle(fontWeight: FontWeight.bold)),
        TextField(controller: waist, decoration: InputDecoration(labelText: 'Talia (cm)')),
        TextField(controller: hips, decoration: InputDecoration(labelText: 'Biodra (cm)')),
      ])),

      ElevatedButton(
        onPressed: calculate,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 233, 1, 1),
          padding: EdgeInsets.all(16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: Text('Oblicz', style: TextStyle(fontSize: 16)),
      ),
    ];
  }

  Widget resultPanel() {
    return card(Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Wyniki', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        SizedBox(height: 12),

        Text('BMI: ${bmi?.toStringAsFixed(1) ?? '-'}'),
        Text('BMR: ${bmr?.toStringAsFixed(0) ?? '-'} kcal'),
        Text('TDEE: ${tdee?.toStringAsFixed(0) ?? '-'} kcal'),
        Text('WHR: ${whr?.toStringAsFixed(2) ?? '-'}'),
        Text('WHtR: ${whtr?.toStringAsFixed(2) ?? '-'}'),

        SizedBox(height: 20),

        Divider(),

        SizedBox(height: 10),

        Text('Co oznaczają wyniki?', style: TextStyle(fontWeight: FontWeight.bold)),

        SizedBox(height: 8),

        Text('BMI – wskaźnik masy ciała (czy waga jest prawidłowa).'),
        Text('BMR – kalorie potrzebne do życia bez aktywności.'),
        Text('TDEE – dzienne zapotrzebowanie kaloryczne.'),
        Text('WHR – stosunek talii do bioder (rozmieszczenie tłuszczu).'),
        Text('WHtR – talia do wzrostu (ryzyko zdrowotne).'),
        
        SizedBox(height: 20),
          if (bmi != null)
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.indigo.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                "Ocena: ${bmiCategory(bmi!)}",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.indigo,
                ),
              ),
            ),
      ],
      
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F7FB),
      appBar: AppBar(
        title: Text('BMI Pro'),
        backgroundColor: Colors.indigo,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < 800) {
              return ListView(
                children: [
                  ...formularzWidgets(),
                  resultPanel(),
                ],
              );
            } else {
              return Row(
                children: [
                  Expanded(flex: 2, child: ListView(children: formularzWidgets())),
                  SizedBox(width: 16),
                  Expanded(child: resultPanel()),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
