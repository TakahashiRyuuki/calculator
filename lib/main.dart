import 'package:flutter/material.dart';
import 'NextPage.dart';

import 'DataBase.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:decimal/decimal.dart';
import 'package:provider/provider.dart';

List<String> numberList = [];
List<String> formulaList = [];
List<String> resultList = [];

Color c = const Color(0xFF92B92C);

const MaterialColor customSwatch = const MaterialColor(
  0xFF00bfff,
  const <int, Color>{
    50: const Color(0xFFF4F8E7),
    100: const Color(0xFFE4EEC4),
    200: const Color(0xFFD2E39C),
    300: const Color(0xFFBFD774),
    400: const Color(0xFFB2CF57),
    500: const Color(0xFFA4C639),
    600: const Color(0xFF9CC033),
    700: const Color(0xFF92B92C),
    800: const Color(0xFF89B124),
    900: const Color(0xFF78A417),
  },
);
IconData iconData1 = Icons.dark_mode;
bool iconchange = false;

String appImage = 'images/wood.jpg';

/* ====================================================================

                         メイン

  ===================================================================== */
void main() async {
  await dotenv.load(fileName: ".env");
  runApp(MyApp());
}

/* ====================================================================

                         クラス

  ===================================================================== */

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MyTheme(),
      child: Consumer<MyTheme>(
        builder: (context, theme, _) {
          return MaterialApp(
            //右上デバック帯削除
            debugShowCheckedModeBanner: false,
            theme: theme.current,
            home: MyCalculator(),
          );
        },
      ),
    );
  }
}

class MyTheme extends ChangeNotifier {
  ThemeData current = ThemeData(
    primarySwatch: customSwatch,
    scaffoldBackgroundColor: Color(0xFFdeb068),
  );
  bool _isDark = false;

  toggle() {
    _isDark = !_isDark;
    current = _isDark
        ? ThemeData.dark()
        : ThemeData(
            primarySwatch: customSwatch,
            scaffoldBackgroundColor: Color(0xFFdeb068),
          );
    iconchange = !iconchange;
    iconData1 =
        iconchange ? iconData1 = Icons.light_mode : iconData1 = Icons.dark_mode;

    appImage = iconchange ? appImage = '' : appImage = 'images/wood.jpg';
    // iconchange ? iconData1 = Icons.light_mode : iconData1 = Icons.dark_mode;

    notifyListeners();
  }
}

class MyCalculator extends StatefulWidget {
  @override
  State<MyCalculator> createState() => _MyCalculatorState();
}

class _MyCalculatorState extends State<MyCalculator> {
/* -------------------------------------------------------------------
                         MyCal変数 
  -------------------------------------------------------------------- */

  final double _buttonFont = 30; //ボタンフォントサイズ 定数
  final int _digitLengths = 8; //桁数 定数

  List<String> deciTemp = ["", "", "", "", "", "", ""];
  String decimal = "";
  String _scOutput = "0"; //画面出力される
  String _decimalTemp = ""; //小数点一時置き場
  String inputValue = ""; //入力値を受け取る
  double _decimalCalTmp = 0; //小数点計算用
  double _decimalCalTmp2 = 0;
  double _decimalCalTmp3 = 0;
  String _decimalCal = "";
  bool deci = false;
  int count = 1;
  int _numCounter = 1;
  int _currentNumber = 0; //画面出力される変数だったもの
  int _dataOperation = 0; // 入力値を操作していたもの
  int _tempNum = 0; //二項演算一時置き場
  int operatorSign = 0; //演算子引数
  int _tempSign = 0; //演算子識別
  double _divConversion = 0; //除算　型変換

  //DB格納用
  String formula = "";
  String answer = "";

  bool pushJudge = false;

  final DataBase database = DataBase(); //インスタンス化

  int tmpFormula = 0;

/* -------------------------------------------------------------------
                         MyCalメソッド
  -------------------------------------------------------------------- */

//処理繰り返す為にリセット
  void _resetRepeat() {
    count = 1;
    deciTemp = ["", "", "", "", "", "", ""];
    //-------------
    inputValue = "";
    _decimalTemp = "";
    _dataOperation = 0;
    _numCounter = 1;
    operatorSign = 0;
    _tempNum = 0;
    _tempSign = 0;
    _divConversion = 0;
    formula = "";
    answer = "";
  }

//全消し
  void _allClear() {
    setState(() {
      count = 1;
      deciTemp = ["", "", "", "", "", "", ""];
      pushJudge = false;
      inputValue = "";
      _scOutput = "0";
      _decimalTemp = "";
      _currentNumber = 0;
      _dataOperation = 0;
      _numCounter = 1;
      operatorSign = 0;
      _tempNum = 0;
      _tempSign = 0;
      _divConversion = 0;
      decimal = "";
      _decimalCalTmp = 0;
      _decimalCalTmp2 = 0;
      _decimalCal = "";
      formula = "";
      answer = "";
      tmpFormula = 0;
    });
  }

//画面にセット桁数//
  void _setNum(inputValue) {
    _digitCount(inputValue);
    int hoge = 0;

    if (pushJudge == false && _numCounter <= _digitLengths) {
      setState(() {
        hoge = int.parse(inputValue);
        _dataOperation = _dataOperation * 10 + hoge;
        _currentNumber = _dataOperation;
        _scOutput = _currentNumber.toString();
      });
    } else if (pushJudge == true) {
      for (count <= 6;;) {
        deciTemp[count] = inputValue;
        count++;
        break;
      }
      setState(() {
        _scOutput = deciTemp.join();
        _decimalCal = deciTemp.join();
      });
    }
  }

//小数点ボタン処理
  void _decimalButton(decimal) {
    if (pushJudge == true) {
      //
    } else if (pushJudge == false) {
      _decimalTemp = _dataOperation.toString();
      _decimalTemp = _decimalTemp + ".";
      deciTemp[0] = _decimalTemp;
      setState(() {
        _scOutput = _decimalTemp;
        pushJudge = true;
      });
    }
  }

//桁数カウント
  void _digitCount(inputValue) {
    if (_numCounter == 1 && inputValue == "0") {
      //

    } else {
      _numCounter++;
    }
  }

  double decimalCalculation(double tmp, double tmp2, int tempSign) {
    var tmp3;

    double deciResult = 0;

    switch (tempSign) {
      case 4: //waru
        {}
        break;

      case 3: //kakeru
        {}
        break;

      case 2: //hiku
        {
          String hogehoge = tmp.toString();
          String hogehoge2 = tmp2.toString();

          tmp3 = Decimal.parse(hogehoge) - Decimal.parse(hogehoge2);

          tmp3 = tmp3.toString();

          deciResult = double.parse(tmp3);
        }
        break;

      case 1: //tasu
        {
          //  tmp3 = d(tmp.toString()) + d(tmp2.toString());
        }
        break;
    }

    return deciResult;
  }

//+/-ボタン処理
  void _pmConversion() {
    setState(() {
      _currentNumber = _dataOperation * -1;
      _dataOperation = _currentNumber;
      _scOutput = _dataOperation.toString();
    });
  }

  //演算子ボタン処理--除算4乗算3減算2加算1
  void operatorButton(operatorSign) {
    if (_tempNum == 0 && pushJudge == false) {
      _tempNum = _dataOperation;
      _tempSign = operatorSign;
      _dataOperation = 0;
    } else if (pushJudge == true) {
      _tempSign = operatorSign;
      deciTemp = ["", "", "", "", "", "", ""];
      count = 1;
      pushJudge = false;
      _dataOperation = 0;
      _decimalCalTmp = double.parse(_scOutput);
    } else {
      _tempSign = operatorSign;
    }
  }

  void decimalSeparation(double decimal) {
    double decimal2 = 0;
    int integer = 0;

    integer = decimal.toInt();
    decimal2 = decimal - integer;

    if (decimal2 == 0 || decimal2 == 0.0) {
      deci = false;
    } else if (decimal2 >= 0.1 || decimal2 <= -0.1) {
      deci = true;
    } else if (decimal2 >= 0.01 || decimal2 <= -0.01) {
      deci = true;
    }
  }

  //＝ボタンの処理
  void _ansDecision() {
    if (pushJudge == true) {
      _decimalCalTmp2 = double.parse(_decimalCal);
      _decimalCalTmp;
    }

    switch (_tempSign) {
      case 4:
        {
          if (pushJudge == true) {
            if (_tempNum == 0) {
              _decimalCalTmp3 = _decimalCalTmp / _decimalCalTmp2;
              formula = _decimalCalTmp.toString() +
                  "÷" +
                  _decimalCalTmp2.toString() +
                  "=";
              decimalSeparation(_decimalCalTmp3);
              if (deci == false) {
                setState(() {
                  _scOutput = _decimalCalTmp3.toStringAsFixed(0);
                  answer = _scOutput;

                  database.DataBaseInsert(formula, answer);
                  _resetRepeat();
                  _decimalCalTmp = _decimalCalTmp3;
                });
              } else {
                setState(() {
                  _divConversion =
                      double.parse(_decimalCalTmp3.toStringAsFixed(7));
                  _scOutput = _divConversion.toString();
                  answer = _scOutput;

                  database.DataBaseInsert(formula, answer);
                  _resetRepeat();
                  _decimalCalTmp = _decimalCalTmp3;
                });
              }
            } else {
              _decimalCalTmp3 = _tempNum / _decimalCalTmp2;
              formula =
                  _tempNum.toString() + "÷" + _decimalCalTmp2.toString() + "=";
              decimalSeparation(_decimalCalTmp3);
              if (deci == false) {
                setState(() {
                  _scOutput = _decimalCalTmp3.toStringAsFixed(0);
                  answer = _scOutput;

                  database.DataBaseInsert(formula, answer);
                  _resetRepeat();
                  _decimalCalTmp = _decimalCalTmp3;
                });
              } else {
                setState(() {
                  _divConversion =
                      double.parse(_decimalCalTmp3.toStringAsFixed(7));
                  _scOutput = _divConversion.toString();
                  answer = _scOutput;

                  database.DataBaseInsert(formula, answer);
                  _resetRepeat();
                  _decimalCalTmp = _decimalCalTmp3;
                });
              }
            }
          } else if (pushJudge == false) {
            if (_decimalCalTmp == 0.0) {
              if (_dataOperation != 0) {
                _decimalCalTmp = _dataOperation.toDouble();
                _decimalCalTmp2 = _tempNum.toDouble();
                _divConversion = _decimalCalTmp2 / _decimalCalTmp;
                formula =
                    _tempNum.toString() + "÷" + _dataOperation.toString() + "=";
                decimalSeparation(_divConversion);
                if (deci == false) {
                  setState(() {
                    _scOutput = _divConversion.toStringAsFixed(0);
                    answer = _scOutput;

                    database.DataBaseInsert(formula, answer);
                    _resetRepeat();
                  });
                } else {
                  setState(() {
                    _divConversion =
                        double.parse(_divConversion.toStringAsFixed(7));
                    _scOutput = _divConversion.toString();
                    answer = _scOutput;

                    database.DataBaseInsert(formula, answer);
                    _resetRepeat();
                  });
                }
              } else {
                setState(() {
                  _scOutput = "エラー";
                  answer = _scOutput;

                  database.DataBaseInsert("ゼロ除算", answer);
                  _resetRepeat();
                });
              }
            } else {
              if (_dataOperation != 0) {
                _divConversion = _decimalCalTmp / _dataOperation;
                formula = _decimalCalTmp.toString() +
                    "÷" +
                    _dataOperation.toString() +
                    "=";
                decimalSeparation(_divConversion);
                if (deci == false) {
                  setState(() {
                    _scOutput = _divConversion.toStringAsFixed(0);
                    answer = _scOutput;

                    database.DataBaseInsert(formula, answer);
                    _resetRepeat();
                  });
                } else if (deci == true) {
                  setState(() {
                    _divConversion =
                        double.parse(_divConversion.toStringAsFixed(7));
                    _scOutput = _divConversion.toString();
                    answer = _scOutput;

                    database.DataBaseInsert(formula, answer);
                    _resetRepeat();
                  });
                }
              } else {
                setState(() {
                  _scOutput = "エラー";
                  answer = _scOutput;

                  database.DataBaseInsert("ゼロ除算", answer);
                  _resetRepeat();
                });
              }
            }
          }
        }
        _resetRepeat();
        _dataOperation = _currentNumber;
        break;

      case 3:
        {
          //乗算
          if (pushJudge == true) {
            if (_tempNum == 0) {
              _decimalCalTmp3 = _decimalCalTmp * _decimalCalTmp2;
              formula = _decimalCalTmp.toString() +
                  "×" +
                  _decimalCalTmp2.toString() +
                  "=";
              decimalSeparation(_decimalCalTmp3);
              if (deci == false) {
                setState(() {
                  _scOutput = _decimalCalTmp3.toStringAsFixed(0);
                  answer = _scOutput;

                  database.DataBaseInsert(formula, answer);
                  _resetRepeat();
                  _decimalCalTmp = _decimalCalTmp3;
                });
              } else {
                _decimalCalTmp3 =
                    double.parse(_decimalCalTmp3.toStringAsFixed(7));
                setState(() {
                  _scOutput = _decimalCalTmp3.toString();
                  answer = _scOutput;

                  database.DataBaseInsert(formula, answer);
                  _resetRepeat();
                });

                _resetRepeat();
                _decimalCalTmp = _decimalCalTmp3;
              }
            } else {
              decimalSeparation(_decimalCalTmp3);
              if (deci == false) {
                _decimalCalTmp3 = _tempNum * _decimalCalTmp2;
                formula = _tempNum.toString() +
                    "×" +
                    _decimalCalTmp2.toString() +
                    "=";
                setState(() {
                  _scOutput = _decimalCalTmp3.toString();
                  answer = _scOutput;

                  database.DataBaseInsert(formula, answer);
                  _resetRepeat();
                  _decimalCalTmp = _decimalCalTmp3;
                });
              } else {
                _decimalCalTmp3 = _tempNum * _decimalCalTmp2;
                formula = _tempNum.toString() +
                    "×" +
                    _decimalCalTmp2.toString() +
                    "=";
                setState(() {
                  _decimalCalTmp3 =
                      double.parse(_decimalCalTmp3.toStringAsFixed(7));
                  _scOutput = _decimalCalTmp3.toString();
                  answer = _scOutput;

                  database.DataBaseInsert(formula, answer);
                  _resetRepeat();
                  _decimalCalTmp = _decimalCalTmp3;
                });
              }
            }
          } else if (pushJudge == false) {
            if (_tempNum == 0) {
              _decimalCalTmp2 = _dataOperation.toDouble();
              _decimalCalTmp3 = _decimalCalTmp * _decimalCalTmp2;
              tmpFormula = _decimalCalTmp2.toInt();
              formula =
                  _decimalCalTmp.toString() + "×" + tmpFormula.toString() + "=";
              decimalSeparation(_decimalCalTmp3);
              if (deci == false) {
                setState(() {
                  _scOutput = _decimalCalTmp3.toStringAsFixed(0);
                  answer = _scOutput;

                  database.DataBaseInsert(formula, answer);
                  _resetRepeat();
                  _decimalCalTmp = _decimalCalTmp3;
                });
              } else {
                setState(() {
                  _decimalCalTmp3 =
                      double.parse(_decimalCalTmp3.toStringAsFixed(7));
                  _scOutput = _decimalCalTmp3.toString();
                  answer = _scOutput;

                  database.DataBaseInsert(formula, answer);
                  _resetRepeat();
                  _decimalCalTmp = _decimalCalTmp3;
                });
              }
            } else {
              setState(() {
                _currentNumber = _tempNum * _dataOperation;
                formula =
                    _tempNum.toString() + "×" + _dataOperation.toString() + "=";
                _scOutput = _currentNumber.toString();
                answer = _scOutput;

                database.DataBaseInsert(formula, answer);
                _resetRepeat();
                _dataOperation = _currentNumber;
              });
            }
          }
        }
        break;

      case 2:
        {
          //引き算
          if (pushJudge == true) {
            if (_tempNum == 0) {
              _decimalCalTmp3 = _decimalCalTmp - _decimalCalTmp2;
              _decimalCalTmp3 = decimalCalculation(
                  _decimalCalTmp, _decimalCalTmp2, _tempSign);

              formula = _decimalCalTmp.toString() +
                  "-" +
                  _decimalCalTmp2.toString() +
                  "=";
              decimalSeparation(_decimalCalTmp3);
              if (deci == false) {
                setState(() {
                  _scOutput = _decimalCalTmp3.toStringAsFixed(0);
                  answer = _scOutput;

                  database.DataBaseInsert(formula, answer);
                  _resetRepeat();
                  _decimalCalTmp = _decimalCalTmp3;
                });
              } else {
                setState(() {
                  _decimalCalTmp3 =
                      double.parse(_decimalCalTmp3.toStringAsFixed(7));
                  _scOutput = _decimalCalTmp3.toString();
                  answer = _scOutput;

                  database.DataBaseInsert(formula, answer);
                  _resetRepeat();
                  _decimalCalTmp = _decimalCalTmp3;
                });
              }
            } else {
              _decimalCalTmp3 = _tempNum - _decimalCalTmp2;
              formula =
                  _tempNum.toString() + "-" + _decimalCalTmp2.toString() + "=";
              decimalSeparation(_decimalCalTmp3);
              if (deci == false) {
                setState(() {
                  _scOutput = _decimalCalTmp3.toStringAsFixed(0);
                  answer = _scOutput;

                  database.DataBaseInsert(formula, answer);
                  _resetRepeat();
                  _decimalCalTmp = _decimalCalTmp3;
                });
              } else {
                setState(() {
                  _decimalCalTmp3 =
                      double.parse(_decimalCalTmp3.toStringAsFixed(7));
                  _scOutput = _decimalCalTmp3.toString();
                  answer = _scOutput;

                  database.DataBaseInsert(formula, answer);
                  _resetRepeat();
                  _decimalCalTmp = _decimalCalTmp3;
                });
              }
            }
          } else if (pushJudge == false) {
            if (_tempNum == 0) {
              _decimalCalTmp2 = _dataOperation.toDouble();
              _decimalCalTmp3 = _decimalCalTmp - _decimalCalTmp2;
              formula = _decimalCalTmp.toString() +
                  "-" +
                  _decimalCalTmp2.toStringAsFixed(0) +
                  "=";
              decimalSeparation(_decimalCalTmp3);
              if (deci == false) {
                setState(() {
                  _scOutput = _decimalCalTmp3.toStringAsFixed(0);
                  answer = _scOutput;

                  database.DataBaseInsert(formula, answer);
                  _resetRepeat();
                  _decimalCalTmp = _decimalCalTmp3;
                });
              } else {
                setState(() {
                  _decimalCalTmp3 =
                      double.parse(_decimalCalTmp3.toStringAsFixed(7));
                  _scOutput = _decimalCalTmp3.toString();
                  answer = _scOutput;

                  database.DataBaseInsert(formula, answer);
                  _resetRepeat();
                  _decimalCalTmp = _decimalCalTmp3;
                });
              }
            } else {
              setState(() {
                _currentNumber = _tempNum - _dataOperation;
                formula =
                    _tempNum.toString() + "-" + _dataOperation.toString() + "=";
                _scOutput = _currentNumber.toString();
                answer = _scOutput;

                database.DataBaseInsert(formula, answer);
                _resetRepeat();
                _dataOperation = _currentNumber;
              });
            }
          }
        }
        break;

      case 1:
        {
          //加算
          if (pushJudge == true) {
            if (_tempNum == 0) {
              _decimalCalTmp3 = _decimalCalTmp2 + _decimalCalTmp;
              formula = _decimalCalTmp.toString() +
                  "+" +
                  _decimalCalTmp2.toString() +
                  "=";

              decimalSeparation(_decimalCalTmp3);
              if (deci == false) {
                setState(() {
                  _scOutput = _decimalCalTmp3.toStringAsFixed(0);
                  answer = _scOutput;

                  database.DataBaseInsert(formula, answer);
                  _resetRepeat();
                  _decimalCalTmp = _decimalCalTmp3;
                });
              } else {
                setState(() {
                  _decimalCalTmp3 =
                      double.parse(_decimalCalTmp3.toStringAsFixed(7));
                  _scOutput = _decimalCalTmp3.toString();
                  answer = _scOutput;

                  database.DataBaseInsert(formula, answer);
                  _resetRepeat();
                  _decimalCalTmp = _decimalCalTmp3;
                });
              }
            } else {
              _decimalCalTmp3 = _decimalCalTmp2 + _tempNum;
              formula =
                  _tempNum.toString() + "+" + _decimalCalTmp2.toString() + "=";
              decimalSeparation(_decimalCalTmp3);
              if (deci == false) {
                setState(() {
                  _scOutput = _decimalCalTmp3.toStringAsFixed(0);
                  answer = _scOutput;

                  database.DataBaseInsert(formula, answer);
                  _resetRepeat();
                  _decimalCalTmp = _decimalCalTmp3;
                });
              } else {
                setState(() {
                  _decimalCalTmp3 =
                      double.parse(_decimalCalTmp3.toStringAsFixed(7));
                  _scOutput = _decimalCalTmp3.toString();
                  answer = _scOutput;

                  database.DataBaseInsert(formula, answer);
                  _resetRepeat();
                  _decimalCalTmp = _decimalCalTmp3;
                });
              }
            }
          } else if (pushJudge == false) {
            if (_tempNum == 0) {
              _decimalCalTmp2 = _dataOperation.toDouble();
              _decimalCalTmp3 = _decimalCalTmp + _decimalCalTmp2;
              formula = _decimalCalTmp.toString() +
                  "+" +
                  _decimalCalTmp2.toStringAsFixed(0) +
                  "=";
              decimalSeparation(_decimalCalTmp3);
              if (deci == false) {
                setState(() {
                  _scOutput = _decimalCalTmp3.toStringAsFixed(0);
                  answer = _scOutput;

                  database.DataBaseInsert(formula, answer);
                  _resetRepeat();
                  _decimalCalTmp = _decimalCalTmp3;
                });
              } else {
                setState(() {
                  _decimalCalTmp3 =
                      double.parse(_decimalCalTmp3.toStringAsFixed(7));
                  _scOutput = _decimalCalTmp3.toString();
                  answer = _scOutput;

                  database.DataBaseInsert(formula, answer);
                  _resetRepeat();
                  _decimalCalTmp = _decimalCalTmp3;
                });
              }
            } else {
              setState(() {
                _currentNumber = _tempNum + _dataOperation;
                formula =
                    _tempNum.toString() + "+" + _dataOperation.toString() + "=";
                _scOutput = _currentNumber.toString();
                answer = _scOutput;

                database.DataBaseInsert(formula, answer);
                _resetRepeat();
                _dataOperation = _currentNumber;
              });
            }
          }
        }
        break;
    }
  }

  //*------------------------------------------------------*//

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: AppBar(
          centerTitle: true,
          title: const Text("電卓アプリ(仮)"),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(appImage), fit: BoxFit.cover),
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.history),
              iconSize: 35,
              onPressed: () {
                database.DataBaseReceiving();
                Future.delayed(Duration(seconds: 1)).then((_) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => NextPage()),
                  );
                });

                //ロード
              },
            )
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
          image: AssetImage(appImage),
          fit: BoxFit.cover,
        )),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black26),
                    borderRadius: BorderRadius.circular(0),
                    color: Colors.white24),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    _scOutput,
                    style: TextStyle(
                      fontSize: 64.0,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: (Column(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(5, 4, 5, 0),
                    child: Row(
                      //1列
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 100, //横幅
                              height: 85, //高さ

                              child: ElevatedButton(
                                child: Container(
                                  child: Icon(
                                    iconData1,
                                    size: 50,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  textStyle: TextStyle(
                                    fontSize: _buttonFont,
                                  ),
                                  foregroundColor: Colors.black54,
                                  backgroundColor:
                                      Color.fromARGB(210, 255, 255, 255),
                                  shape: const CircleBorder(
                                    side: BorderSide(
                                      color: Colors.black38,
                                      width: 1,
                                      style: BorderStyle.solid,
                                    ),
                                  ),
                                ),
                                onPressed: () {
                                  Provider.of<MyTheme>(context, listen: false)
                                      .toggle();
                                },
                              ),
                            ),
                            SizedBox(
                              width: 100, //横幅
                              height: 95, //高さ
                              child: ElevatedButton(
                                child: Text('AC'),
                                style: ElevatedButton.styleFrom(
                                  textStyle: TextStyle(
                                    fontSize: _buttonFont,
                                  ),
                                  foregroundColor: Colors.black54,
                                  backgroundColor:
                                      Color.fromARGB(210, 255, 255, 255),
                                  shape: const CircleBorder(
                                    side: BorderSide(
                                      color: Colors.black38,
                                      width: 1,
                                      style: BorderStyle.solid,
                                    ),
                                  ),
                                ),
                                onPressed: () {
                                  _allClear();
                                },
                              ),
                            ),
                            SizedBox(
                                width: 100, //横幅
                                height: 95, //高さ
                                child: ElevatedButton(
                                  child: Text("+/-"),
                                  style: ElevatedButton.styleFrom(
                                    textStyle: TextStyle(
                                      fontSize: _buttonFont,
                                    ),
                                    foregroundColor: Colors.black54,
                                    backgroundColor:
                                        Color.fromARGB(210, 255, 255, 255),
                                    shape: const CircleBorder(
                                      side: BorderSide(
                                        color: Colors.black38,
                                        width: 1,
                                        style: BorderStyle.solid,
                                      ),
                                    ),
                                  ),
                                  onPressed: () {
                                    _pmConversion();
                                  },
                                )),
                            SizedBox(
                                width: 100, //横幅
                                height: 95, //高さ
                                child: ElevatedButton(
                                  child: Text("÷"),
                                  style: ElevatedButton.styleFrom(
                                    textStyle: TextStyle(
                                      fontSize: 35,
                                    ),
                                    foregroundColor: Colors.black54,
                                    backgroundColor: Colors.green[200],
                                    shape: const CircleBorder(
                                      side: BorderSide(
                                        color: Colors.black38,
                                        width: 1,
                                        style: BorderStyle.solid,
                                      ),
                                    ),
                                  ),
                                  onPressed: () {
                                    operatorButton(4);
                                    _numCounter = 1;
                                  },
                                )),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(5, 5, 5, 0),
                    child: Row(
                      //2列
                      children: [
                        SizedBox(
                          width: 100, //横幅
                          height: 95, //高さ
                          child: ElevatedButton(
                            child: Text("7"),
                            style: ElevatedButton.styleFrom(
                              textStyle: TextStyle(
                                fontSize: _buttonFont,
                              ),
                              foregroundColor: Colors.white70,
                              backgroundColor:
                                  Color.fromARGB(60, 255, 255, 255),
                              shape: const CircleBorder(
                                side: BorderSide(
                                  color: Colors.black38,
                                  width: 1,
                                  style: BorderStyle.solid,
                                ),
                              ),
                            ),
                            onPressed: () {
                              _setNum("7");
                            },
                          ),
                        ),
                        SizedBox(
                          width: 100, //横幅
                          height: 95, //高さ
                          child: ElevatedButton(
                            child: Text("8"),
                            style: ElevatedButton.styleFrom(
                              textStyle: TextStyle(
                                fontSize: _buttonFont,
                              ),
                              foregroundColor: Colors.white70,
                              backgroundColor:
                                  Color.fromARGB(60, 255, 255, 255),
                              shape: const CircleBorder(
                                side: BorderSide(
                                  color: Colors.black38,
                                  width: 1,
                                  style: BorderStyle.solid,
                                ),
                              ),
                            ),
                            onPressed: () {
                              _setNum("8");
                            },
                          ),
                        ),
                        SizedBox(
                          width: 100, //横幅
                          height: 95, //高さ
                          child: ElevatedButton(
                            child: Text("9"),
                            style: ElevatedButton.styleFrom(
                              textStyle: TextStyle(
                                fontSize: _buttonFont,
                              ),
                              foregroundColor: Colors.white70,
                              backgroundColor:
                                  Color.fromARGB(60, 255, 255, 255),
                              shape: const CircleBorder(
                                side: BorderSide(
                                  color: Colors.black38,
                                  width: 1,
                                  style: BorderStyle.solid,
                                ),
                              ),
                            ),
                            onPressed: () {
                              _setNum("9");
                            },
                          ),
                        ),
                        SizedBox(
                          width: 100, //横幅
                          height: 95, //高さ
                          child: ElevatedButton(
                            child: Text("✕"),
                            style: ElevatedButton.styleFrom(
                              textStyle: TextStyle(
                                fontSize: 26,
                              ),
                              foregroundColor: Colors.black54,
                              backgroundColor: Colors.green[200],
                              shape: const CircleBorder(
                                side: BorderSide(
                                  color: Colors.black38,
                                  width: 1,
                                  style: BorderStyle.solid,
                                ),
                              ),
                            ),
                            onPressed: () {
                              operatorButton(3);
                              _numCounter = 1;
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(5, 5, 5, 0),
                    child: Row(
                      //3列
                      children: [
                        SizedBox(
                          width: 100, //横幅
                          height: 95, //高さ
                          child: ElevatedButton(
                            child: Text("4"),
                            style: ElevatedButton.styleFrom(
                              textStyle: TextStyle(
                                fontSize: _buttonFont,
                              ),
                              foregroundColor: Colors.white70,
                              backgroundColor:
                                  Color.fromARGB(60, 255, 255, 255),
                              shape: const CircleBorder(
                                side: BorderSide(
                                  color: Colors.black38,
                                  width: 1,
                                  style: BorderStyle.solid,
                                ),
                              ),
                            ),
                            onPressed: () {
                              _setNum("4");
                            },
                          ),
                        ),
                        SizedBox(
                          width: 100, //横幅
                          height: 95, //高さ
                          child: ElevatedButton(
                            child: Text("5"),
                            style: ElevatedButton.styleFrom(
                              textStyle: TextStyle(
                                fontSize: _buttonFont,
                              ),
                              foregroundColor: Colors.white70,
                              backgroundColor:
                                  Color.fromARGB(60, 255, 255, 255),
                              shape: const CircleBorder(
                                side: BorderSide(
                                  color: Colors.black38,
                                  width: 1,
                                  style: BorderStyle.solid,
                                ),
                              ),
                            ),
                            onPressed: () {
                              _setNum("5");
                            },
                          ),
                        ),
                        SizedBox(
                          width: 100, //横幅
                          height: 95, //高さ
                          child: ElevatedButton(
                            child: Text("6"),
                            style: ElevatedButton.styleFrom(
                              textStyle: TextStyle(
                                fontSize: _buttonFont,
                              ),
                              foregroundColor: Colors.white70,
                              backgroundColor:
                                  Color.fromARGB(60, 255, 255, 255),
                              shape: const CircleBorder(
                                side: BorderSide(
                                  color: Colors.black38,
                                  width: 1,
                                  style: BorderStyle.solid,
                                ),
                              ),
                            ),
                            onPressed: () {
                              _setNum("6");
                            },
                          ),
                        ),
                        SizedBox(
                          width: 100, //横幅
                          height: 95, //高さ
                          child: ElevatedButton(
                            child: Text("―"),
                            style: ElevatedButton.styleFrom(
                              textStyle: TextStyle(
                                fontSize: _buttonFont,
                              ),
                              foregroundColor: Colors.black54,
                              backgroundColor: Colors.green[200],
                              shape: const CircleBorder(
                                side: BorderSide(
                                  color: Colors.black38,
                                  width: 1,
                                  style: BorderStyle.solid,
                                ),
                              ),
                            ),
                            onPressed: () {
                              operatorButton(2);
                              _numCounter = 1;
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(5, 5, 5, 0),
                    child: Row(
                      //4列
                      children: [
                        SizedBox(
                          width: 100, //横幅
                          height: 95, //高さ
                          child: ElevatedButton(
                            child: Text("1"),
                            style: ElevatedButton.styleFrom(
                              textStyle: TextStyle(
                                fontSize: _buttonFont,
                              ),
                              foregroundColor: Colors.white70,
                              backgroundColor:
                                  Color.fromARGB(60, 255, 255, 255),
                              shape: const CircleBorder(
                                side: BorderSide(
                                  color: Colors.black38,
                                  width: 1,
                                  style: BorderStyle.solid,
                                ),
                              ),
                            ),
                            onPressed: () {
                              _setNum("1");
                            },
                          ),
                        ),
                        SizedBox(
                          width: 100, //横幅
                          height: 95, //高さ
                          child: ElevatedButton(
                            child: Text("2"),
                            style: ElevatedButton.styleFrom(
                              textStyle: TextStyle(
                                fontSize: _buttonFont,
                              ),
                              foregroundColor: Colors.white70,
                              backgroundColor:
                                  Color.fromARGB(60, 255, 255, 255),
                              shape: const CircleBorder(
                                side: BorderSide(
                                  color: Colors.black38,
                                  width: 1,
                                  style: BorderStyle.solid,
                                ),
                              ),
                            ),
                            onPressed: () {
                              _setNum("2");
                            },
                          ),
                        ),
                        SizedBox(
                          width: 100, //横幅
                          height: 95, //高さ
                          child: ElevatedButton(
                            child: Text("3"),
                            style: ElevatedButton.styleFrom(
                              textStyle: TextStyle(
                                fontSize: _buttonFont,
                              ),
                              foregroundColor: Colors.white70,
                              backgroundColor:
                                  Color.fromARGB(60, 255, 255, 255),
                              shape: const CircleBorder(
                                side: BorderSide(
                                  color: Colors.black38,
                                  width: 1,
                                  style: BorderStyle.solid,
                                ),
                              ),
                            ),
                            onPressed: () {
                              _setNum("3");
                            },
                          ),
                        ),
                        SizedBox(
                          width: 100, //横幅
                          height: 95, //高さ
                          child: ElevatedButton(
                            child: Text("+"),
                            style: ElevatedButton.styleFrom(
                              textStyle: TextStyle(
                                fontSize: 40,
                              ),
                              foregroundColor: Colors.black54,
                              backgroundColor: Colors.green[200],
                              shape: const CircleBorder(
                                side: BorderSide(
                                  color: Colors.black38,
                                  width: 1,
                                  style: BorderStyle.solid,
                                ),
                              ),
                            ),
                            onPressed: () {
                              operatorButton(1);
                              _numCounter = 1;
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(5, 5, 5, 0),
                    child: Row(
                      //4列
                      children: [
                        SizedBox(
                          width: 200, //横幅
                          height: 95, //高さ
                          child: ElevatedButton(
                            child: Text("0"),
                            style: ElevatedButton.styleFrom(
                              textStyle: TextStyle(
                                fontSize: _buttonFont,
                              ),
                              foregroundColor: Colors.white70,
                              backgroundColor:
                                  Color.fromARGB(60, 255, 255, 255),
                              shape: const StadiumBorder(
                                side: BorderSide(
                                  color: Colors.black38,
                                  width: 1,
                                  style: BorderStyle.solid,
                                ),
                              ),
                            ),
                            onPressed: () {
                              _setNum("0");
                            },
                          ),
                        ),
                        SizedBox(
                          width: 100, //横幅
                          height: 95, //高さ
                          child: ElevatedButton(
                            child: Text("."),
                            style: ElevatedButton.styleFrom(
                              textStyle: TextStyle(
                                fontSize: 55,
                              ),
                              foregroundColor: Colors.white70,
                              backgroundColor:
                                  Color.fromARGB(60, 255, 255, 255),
                              shape: const CircleBorder(
                                side: BorderSide(
                                  color: Colors.black38,
                                  width: 1,
                                  style: BorderStyle.solid,
                                ),
                              ),
                            ),
                            onPressed: () {
                              _decimalButton(".");
                            },
                          ),
                        ),
                        SizedBox(
                          width: 100, //横幅
                          height: 95, //高さ
                          child: ElevatedButton(
                            child: Text("="),
                            style: ElevatedButton.styleFrom(
                              textStyle: TextStyle(
                                fontSize: 45,
                              ),
                              foregroundColor: Colors.black54,
                              backgroundColor: Colors.green[200],
                              shape: const CircleBorder(
                                side: BorderSide(
                                  color: Colors.black38,
                                  width: 1,
                                  style: BorderStyle.solid,
                                ),
                              ),
                            ),
                            onPressed: () {
                              _ansDecision();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )),
            )
          ],
        ),
      ),
    );
  }
}
