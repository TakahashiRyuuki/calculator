import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'DataBase.dart';
import 'main.dart';

import 'package:decimal/decimal.dart';

class NextPage extends StatefulWidget {
  const NextPage({super.key});

  @override
  State<NextPage> createState() => _NextPageState();
}

class _NextPageState extends State<NextPage> {
  DataBase data = DataBase();

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        // appbar
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(70),
          child: AppBar(
              centerTitle: true,
              title: const Text("計算履歴"),
              flexibleSpace: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(appImage), fit: BoxFit.cover),
                ),
              ),
              actions: [
                IconButton(
                  icon: Icon(Icons.delete),
                  iconSize: 30,
                  onPressed: () {
                    if (numberList.isEmpty) {
                      showCupertinoDialog(
                        context: context,
                        builder: (context) {
                          return CupertinoAlertDialog(
                            title: Text('削除する履歴がありません。'),
                            actions: [
                              CupertinoDialogAction(
                                isDestructiveAction: true,
                                child: Text('はい'),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          );
                        },
                      );
                    } else {
                      showCupertinoDialog(
                        context: context,
                        builder: (context) {
                          return CupertinoAlertDialog(
                            title: Text('履歴の削除'),
                            content: Text('全て削除してもよろしいですか?'),
                            actions: [
                              CupertinoDialogAction(
                                isDestructiveAction: true,
                                child: Text('はい'),
                                onPressed: () {
                                  setState(() {
                                    data.allDataBaseDelete();
                                    numberList.clear();
                                    formulaList.clear();
                                    resultList.clear();
                                  });
                                  Navigator.pop(context);
                                },
                              ),
                              CupertinoDialogAction(
                                child: Text('いいえ'),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                ),
              ]),
        ),
        body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(appImage),
                fit: BoxFit.cover,
              ),
            ),
            child: ListView.builder(
              itemCount: numberList.length,
              itemBuilder: (BuildContext context, int index) {
                return Dismissible(
                  background: Container(
                    color: Colors.red,
                    child: Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (direction) {
                    setState(() {
                      data.DataBaseDelete(index);
                      formulaList.removeAt(index);
                      resultList.removeAt(index);
                      numberList.removeAt(index);
                    });
                  },
                  key: UniqueKey(),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(2.5),
                    title: Text(
                      '${formulaList[index]}',
                      style: TextStyle(
                        fontSize: 17,
                      ),
                    ),
                    subtitle: Text(
                      '${resultList[index]}',
                      style: TextStyle(fontSize: 30),
                    ),
                  ),
                );
              },
            )));
  }
}
