import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: const MyHomePage(title: 'merge_app'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _indexOfDroppedItem = 0;
  bool _isDragging = false;

  void _acceptDraggedItem(int fromIndex,toIndex) {
    setState(() {
      try{
        if(elements.firstWhere((element) => element.index==fromIndex).weight==elements.firstWhere((element) => element.index==toIndex).weight){
          elements[toIndex] = Element(elements[toIndex].weight*2, Colors.lime, toIndex,(elements[toIndex].weight*2).toString());
          elements.removeAt(fromIndex);
        }
      }catch(_){
        return;
      }

    });
  }

  void _setIsDragging() {
    setState(() {
      _isDragging = true;
    });
  }

  void _resetIsDragging() {
    setState(() {
      _isDragging = false;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  List<Element> elements = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: [
            GridView.count(
              shrinkWrap: true,
              primary: false,
              crossAxisCount: 4,
              children: List.generate(
                16,
                (index) {
                  return Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: elements.any((element) => element.index == index)
                        ? Draggable<int>(
                            data: index,
                            childWhenDragging: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.blue,
                                  ),
                                  borderRadius:
                                      const BorderRadius.all(Radius.circular(20))),
                            ),
                            onDragStarted: () {
                              _setIsDragging();
                            },
                            onDraggableCanceled: (_, __) {
                              _resetIsDragging();
                            },
                            onDragCompleted: () {
                              print('SKONCZONE');
                              _resetIsDragging();
                            },
                            feedback: Container(
                              width: 100,
                              height: 100,
                              decoration: const BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: elements.firstWhere((element) => element.index == index).color,
                                  border: Border.all(
                                    color: Colors.red,
                                  ),
                                  borderRadius:
                                      const BorderRadius.all(Radius.circular(10))),
                              child: DragTarget<int>(
                                builder: (
                                    BuildContext context,
                                    List<dynamic> accepted,
                                    List<dynamic> rejected,
                                    ) {
                                  return Container(
                                    child: Text(elements.firstWhere((element) => element.index == index).text),
                                      );
                                },
                                onAccept: (int data) {
                                  _acceptDraggedItem(data,index);
                                },
                              ),
                            ),
                          )
                        : DragTarget<int>(
                            builder: (
                              BuildContext context,
                              List<dynamic> accepted,
                              List<dynamic> rejected,
                            ) {
                              return Container(
                                  decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.green,
                                ),
                                borderRadius: BorderRadius.all(_isDragging
                                    ? const Radius.circular(20)
                                    : const Radius.circular(10)),
                              ));
                            },
                            onAccept: (int data) {
                              _acceptDraggedItem(data,index);
                            },
                          ),
                  );
                },
              )

            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: MaterialButton(
                    onPressed: () => {
                      setState(() {
                        for(int i=0;i<16;i++){
                          if(elements.any((element) => element.index == i)){
                            continue;
                          }
                          else{
                            elements.add(
                              Element(2, Colors.green, i,2.toString()),
                            );
                            break;
                          }
                        }
                      }),
                    },
                    color: Colors.red,
                    child: Text('DODAJ'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: MaterialButton(
                    onPressed: () => {
                      setState(() {
                        elements=[];
                      }),
                    },
                    color: Colors.green,
                    child: Text('CZYSC'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class Element {
  Element(this.weight, this.color, this.index, this.text);

  final int index;
  final int weight;
  final Color color;
  final String text;
}
