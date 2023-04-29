import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../Models/currency.dart';
import '../../helper/currency_api_helper.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  List currencyList = ['CAD', 'EUR', 'INR', 'JPY', 'USD'];

  bool isIOS = false;
  String? from;
  String? To;
  String API = "https://api.exchangerate.host/convert?from=USD&to=INR&amount=1";

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController amountController = TextEditingController();

  int iosConvertFromVal = 0;
  int iosConvertToVal = 0;

  @override
  Widget build(BuildContext context) {
    return (isIOS == false)
        ? MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: AppBar(
                title: const Text(
                  "Currency Converter",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1,
                      fontSize: 22),
                ),
                backgroundColor: Colors.yellow.shade800,
                centerTitle: true,
                actions: [
                  Switch(
                    value: isIOS,
                    onChanged: (val) {
                      setState(() {
                        isIOS = !isIOS;
                      });
                    },
                  ),
                ],
              ),
              body: Center(
                child: Column(
                  children: [
                    const SizedBox(height: 60),
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Form(
                        key: formKey,
                        child: TextFormField(
                          controller: amountController,
                          validator: (val) {
                            if (val!.isEmpty) {
                              return "Enter Amount First";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            label: const Text(
                              "Enter Amount",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                                fontSize: 17,
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Column(
                      children: [
                        Container(
                          alignment: Alignment.topLeft,
                          child: Text("     From",style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold,),),
                        ),
                        SizedBox(height: 5,),
                        Container(
                          height: 60,
                          width: 300,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border:
                            Border.all(color: Colors.yellow.shade800, width: 2),
                            color: Colors.yellow.shade100,
                          ),
                          child: DropdownButton(
                            hint: from == null
                                ? const Text('Currency')
                                : Text(
                              "$from",
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                              ),
                            ),
                            isExpanded: true,
                            iconSize: 30.0,
                            dropdownColor: Colors.yellow.shade100,
                            style: TextStyle(
                                color: Colors.yellow.shade800,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                            items: ['CAD', 'EUR', 'INR', 'JPY', 'USD'].map(
                                  (val) {
                                return DropdownMenuItem<String>(
                                  value: val,
                                  child: Text(val),
                                );
                              },
                            ).toList(),
                            onChanged: (val) {
                              setState(
                                    () {
                                  from = val as String?;
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Column(
                      children: [
                        Container(
                          alignment: Alignment.topLeft,
                          child: Text("     To",style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold,),),
                        ),
                        SizedBox(height: 5,),
                        Container(
                          height: 60,
                          width: 300,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border:
                            Border.all(color: Colors.yellow.shade800, width: 2),
                            color: Colors.yellow.shade100,
                          ),
                          child: DropdownButton(
                            hint: To == null
                                ? const Text('Currency')
                                : Text(
                              "$To",
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 15),
                            ),
                            isExpanded: true,
                            iconSize: 30.0,
                            dropdownColor: Colors.yellow.shade100,
                            style: TextStyle(
                                color: Colors.yellow.shade800,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                            items: ['CAD', 'EUR', 'INR', 'JPY', 'USD'].map(
                                  (val) {
                                return DropdownMenuItem<String>(
                                  value: val,
                                  child: Text(val),
                                );
                              },
                            ).toList(),
                            onChanged: (val) {
                              setState(
                                    () {
                                  To = val as String?;
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    Container(
                      height: 50,
                      width: 250,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.yellow.shade100,
                        borderRadius: BorderRadius.circular(15),
                       border: Border.all(color: Colors.yellow.shade800,)),
                      child: FutureBuilder(
                        future: CurrencyApiHelper.currencyApiHelper
                            .fetchCurrencyData(API: API),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Text("Error: ${snapshot.error}");
                          } else if (snapshot.hasData) {
                            Currency? res = snapshot.data as Currency?;

                            return Text(
                              "${res!.convertAmount}",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.yellow.shade800,
                                  fontSize: 18),
                            );
                          }

                          return const CircularProgressIndicator();
                        },
                      ),
                    ),
                    const SizedBox(height: 30),
                    InkWell(
                      onTap: () {
                        setState(() {
                          if (formKey.currentState!.validate()) {
                            String amount = amountController.text;
                            String convertFrom = from.toString();
                            String convertTo = To.toString();

                            API =
                            "https://api.exchangerate.host/convert?from=$convertFrom&to=$convertTo&amount=$amount";
                          }
                        });
                      },
                      child: Container(
                        height: 40,
                        width: 160,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.yellow.shade800,width: 2,),
                            borderRadius: BorderRadius.circular(10)),
                        alignment: Alignment.center,
                        child: Text(
                          "Convert",
                          style: TextStyle(
                              color: Colors.yellow.shade800,
                              fontSize: 20,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        : CupertinoApp(
            debugShowCheckedModeBanner: false,
            home: CupertinoPageScaffold(
              backgroundColor: CupertinoColors.white,
              navigationBar: CupertinoNavigationBar(
                backgroundColor: CupertinoColors.white,
                middle: const Text(
                  "Currency Convertor",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 28,
                  ),
                ),
                trailing: CupertinoSwitch(
                  activeColor: Colors.teal,
                  onChanged: (val) {
                    setState(() {
                      isIOS = val;
                    });
                  },
                  value: isIOS,
                ),
              ),
              child: Center(
                child: Column(
                  children: [
                    const SizedBox(height: 100),
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Form(
                        key: formKey,
                        child: CupertinoTextFormFieldRow(
                          controller: amountController,
                          style: const TextStyle(color: Colors.black),
                          validator: (val) {
                            if (val!.isEmpty) {
                              return "Enter Amount";
                            }
                            return null;
                          },
                          placeholder: "Enter Amount",
                          placeholderStyle: const TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w400),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Colors.teal,
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      height: 150,
                      width: 300,
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.teal, width: 3),
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.teal.shade100,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            height: 40,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                color: Colors.black,
                              ),
                            ),
                            child: CupertinoButton(
                              padding: const EdgeInsets.all(0),
                              child: from == null
                                  ? const Text(
                                      'Dropdown',
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 15),
                                    )
                                  : Text(
                                      "$from",
                                      style: const TextStyle(
                                          color: Colors.black, fontSize: 15),
                                    ),
                              onPressed: () {
                                showCupertinoModalPopup(
                                    context: context,
                                    barrierDismissible: true,
                                    builder: (context) {
                                      return Container(
                                        height: 500,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.black,
                                          ),
                                        ),
                                        child: CupertinoPicker(
                                          backgroundColor: Colors.black87,
                                          scrollController:
                                              FixedExtentScrollController(
                                            initialItem: iosConvertFromVal,
                                          ),
                                          itemExtent: 35,
                                          children: currencyList.map((val) {
                                            return DropdownMenuItem<String>(
                                              value: val,
                                              alignment: Alignment.center,
                                              child: Text(val),
                                            );
                                          }).toList(),
                                          onSelectedItemChanged: (val) {
                                            List data = currencyList;
                                            setState(() {
                                              iosConvertFromVal =
                                                  data.indexOf(data[val]);
                                              from = data[val];
                                            });
                                          },
                                        ),
                                      );
                                    });
                              },
                            ),
                          ),
                          Container(
                            height: 40,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                color: Colors.black,
                              ),
                            ),
                            child: CupertinoButton(
                              padding: const EdgeInsets.all(0),
                              child: from == null
                                  ? const Text(
                                      'Dropdown',
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 15),
                                    )
                                  : Text(
                                      "$To",
                                      style: const TextStyle(
                                          color: Colors.black, fontSize: 15),
                                    ),
                              onPressed: () {
                                showCupertinoModalPopup(
                                    context: context,
                                    builder: (context) {
                                      return Container(
                                        height: 500,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.white,
                                          ),
                                        ),
                                        child: CupertinoPicker(
                                          scrollController:
                                              FixedExtentScrollController(
                                            initialItem: iosConvertToVal,
                                          ),
                                          itemExtent: 35,
                                          children: currencyList.map((val) {
                                            return DropdownMenuItem<String>(
                                              value: val,
                                              alignment: Alignment.center,
                                              child: Text(val),
                                            );
                                          }).toList(),
                                          onSelectedItemChanged: (val) {
                                            setState(() {
                                              iosConvertToVal = currencyList
                                                  .indexOf(currencyList[val]);
                                              from = currencyList[val];
                                            });
                                          },
                                        ),
                                      );
                                    });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 50),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          if (formKey.currentState!.validate()) {
                            String amount = amountController.text;
                            String convertFrom = from.toString();
                            String convertTo = To.toString();

                            API =
                                "https://api.exchangerate.host/convert?from=$convertFrom&to=$convertTo&amount=$amount";
                          }
                        });
                      },
                      child: Container(
                        height: 50,
                        width: 250,
                        decoration: BoxDecoration(
                            color: Colors.teal.shade100,
                            borderRadius: BorderRadius.circular(10)),
                        alignment: Alignment.center,
                        child: const Text("Convert Amount"),
                      ),
                    ),
                    const SizedBox(height: 50),
                    Container(
                      height: 50,
                      width: 250,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.teal, width: 1.5)),
                      child: FutureBuilder(
                        future: CurrencyApiHelper.currencyApiHelper
                            .fetchCurrencyData(API: API),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Text("Error: ${snapshot.error}");
                          } else if (snapshot.hasData) {
                            Currency? res = snapshot.data as Currency?;

                            return Text("${res!.convertAmount}");
                          }

                          return const CircularProgressIndicator();
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
  }
}
