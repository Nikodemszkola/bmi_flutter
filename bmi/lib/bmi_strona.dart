import 'package:flutter/material.dart';

class BmiPage extends StatefulWidget {
  @override
  _BmiPageState createState() => _BmiPageState();
}

class _BmiPageState extends State<BmiPage> {
  final TextEditingController heightController = TextEditingController();
  final TextEditingController weightController = TextEditingController();

  String result = "";

  String bmiCategory(double bmi) {
    if (bmi < 18.5) return "Niedowaga";
    if (bmi < 25) return "Waga prawidłowa";
    if (bmi < 30) return "Nadwaga";
    return "Otyłość";
  }

  void calculateBMI() {
    final h = double.tryParse(heightController.text);
    final w = double.tryParse(weightController.text);

    if (h == null || w == null || h <= 0 || w <= 0) {
      setState(() {
        result = "Wprowadź poprawne dane!";
      });
      return;
    }

    final bmi = w / ((h / 100) * (h / 100));
    final category = bmiCategory(bmi);

    setState(() {
      result = "Twoje BMI: ${bmi.toStringAsFixed(2)}\n$category";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFEFEF),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Kalkulator BMI",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 20),

              Container(
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 20,
                      offset: Offset(4, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Wzrost (cm)", style: TextStyle(fontSize: 16)),
                    const SizedBox(height: 5),

                    TextField(
                      controller: heightController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xFFF2F2F2),
                        contentPadding: const EdgeInsets.all(10),
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(color: Color(0xFFCCCCCC)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),

                    const Text("Waga (kg)", style: TextStyle(fontSize: 16)),
                    const SizedBox(height: 5),

                    TextField(
                      controller: weightController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xFFF2F2F2),
                        contentPadding: const EdgeInsets.all(10),
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(color: Color(0xFFCCCCCC)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),

                    SizedBox(
                      width: double.infinity,
                      height: 45,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4CAF50),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        onPressed: calculateBMI,
                        child: const Text(
                          "Oblicz BMI",
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    Center(
                      child: Text(
                        result,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
