import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:labirynt/labirynt_generator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Labirynt',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      // home: const MyHomePage(title: 'Labirynt'),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget{
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final rowsController = TextEditingController();
  final colsController = TextEditingController();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Menu Główne")),
      body: Container(
        margin: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: (){
                List<int> labirynt = [10, 8, 10, 9,
                                      28, 1, 0, 12,
                                      12, 10, 9, 13,
                                      6, 5, 6, 5];
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyHomePage(
                      title: "Rozgrywka", 
                      labirynt: labirynt,
                      rows: 4,
                      cols: 4
                    )
                  )
                );
              }, 
              child: const Text("Start(domyślny labirynt)"),
            ),
            Material(
              child: TextField(
                controller: rowsController,
                decoration: const InputDecoration(labelText: "Wprowadź liczbe wierszy"),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly], // Only numbers can be entered
              ),
            ),
            Material(
              child: TextField(
                controller: colsController,
                decoration: const InputDecoration(labelText: "Wprowadź liczbe kolumn"),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly], // Only numbers can be entered
              ),
            ),
            ElevatedButton(
              onPressed: (){
                int rowss = int.parse(rowsController.text);
                int colss = int.parse(colsController.text);
                List<int> labirynt = Labirynt(rows: rowss,
                                              cols: colss,
                                              jednstr: false, 
                                              drzwi: false).labirynt;
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyHomePage(
                      title: "Rozgrywka", 
                      labirynt: labirynt,
                      rows: rowss,
                      cols: colss,
                    )
                  )
                );
              }, 
              child: const Text("Start(generuj labirynt)"),
            ),
          ]
        ),
      )
    );
  }

  List<int> generateMaze(int rows, int cols){
    //edges
    // for(var i = 0; i <)
    
    // for(var i = 1; i < cols-1; i++){
    //   for(var j = 1; j < rows-1; j++){

    //   }
    // }
    return List.empty();
  }
}

class WinPage extends StatelessWidget{
  const WinPage({Key? key, required this.numOfMoves}) : super(key: key);

  final int numOfMoves;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
    title: "You win!",
      home: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("You win in $numOfMoves moves!") ,
          ElevatedButton(
            onPressed: (){
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomePage()
                )
              );
            }, 
            child: const Text("Go to main menu"),
          )
        ]
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    Key? key, 
    required this.title, 
    required this.labirynt,
    required this.rows,
    required this.cols}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  final int rows;
  final int cols;
  final List<int> labirynt;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _isUpDisabled = true;
  bool _isLeftDisabled = true;
  bool _isRightDisabled = true;
  bool _isDownDisabled = true;

  int position = 0;
  int numOfMoves = -1;

  @override
  void initState(){
    position = findStart();
    _checkButtons();
  }

  void _checkButtons() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      numOfMoves += 1;
      if(widget.labirynt[position] == 0){
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => WinPage(numOfMoves: numOfMoves)
          )
        );
      }

      _isLeftDisabled = widget.labirynt[position] & (1<<0) == (1<<0) ? false : true;
      _isRightDisabled = widget.labirynt[position] & (1<<1) == (1<<1) ? false : true;
      _isUpDisabled = widget.labirynt[position] & (1<<2) == (1<<2) ? false : true;
      _isDownDisabled = widget.labirynt[position] & (1<<3) == (1<<3) ? false : true;
  }
  

  void _goUp(){
    position -= widget.cols;
    setState(() {_checkButtons();});
  }

  void _goDown(){
    position += widget.cols;
    setState(() {_checkButtons();});
  }

  void _goLeft(){
    position -= 1;
    setState(() {_checkButtons();});
  }

  void _goRight(){
    position += 1;
    setState(() {_checkButtons();});
  }

  int findStart(){
    for(var i = 0; i < widget.rows; i++){
      for(var j = 0; j < widget.cols; j++){
        if(widget.labirynt[i*widget.cols + j] & (1<<4) == (1<<4)){
          return (i*widget.cols+j);
        }
      }
    }
    return -1;
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Container(
        margin: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            ElevatedButton(
              onPressed: _isUpDisabled ? null : _goUp,
              child: const Text('Góra'),
            ),
            Row(
              children: <Widget>[
                ElevatedButton(
                  onPressed: _isLeftDisabled ? null : _goLeft,
                  child: const Text("Lewo"),
                ),
                Expanded(
                    child: drawLabirynt(widget.labirynt, widget.rows, widget.cols,2)
                ),
                  // child: AspectRatio(
                  //   aspectRatio: widget.cols/widget.rows,
                  //   child: Container(
                  //     color: Colors.amber,
                  //   )
                  //   // Image.asset(
                  //   //   'images/block.jpg',
                  //   //   fit: BoxFit.fill  
                  //   // ),
                  // ),
                // Image.asset(
                //   'images/block.jpg'
                //   fit: BoxFit.fill  
                // ),
                ElevatedButton(
                  onPressed: _isRightDisabled ? null : _goRight,
                  child: const Text("Prawo"),
                )
              ],
            ),
            ElevatedButton(
              onPressed: _isDownDisabled ? null : _goDown,
              child: const Text("Dół"),
            )
          ],
        ),
      ),
    );
  }
}

Widget drawLabirynt(List<int> labirynt, int rows, int cols, int endPoint){
  Widget drawInside(int i, int j){
    if(labirynt[i*cols + j] & (1<<5) == (1<<5)){
      return Image.asset(
        'images/doors.png',
        fit: BoxFit.fill
      );
    }
    else if(labirynt[i*cols + j] & (1<<6) == (1<<6)){
      return Image.asset(
        'images/key.png',
        fit: BoxFit.fill
      );
    }
    else if(labirynt[i*cols + j] & (1<<4) == (1<<4)){
      return Image.asset(
        'images/player.png',
        fit: BoxFit.fill
      );
    }
    else if(labirynt[i*cols + j] == 0){
      return Image.asset(
        'images/finish.png',
        fit: BoxFit.fill
      );
    }
    else{
      return Container();
    }
  }

  Widget drawRight(int i, int j){
    if(j < cols-1){
      bool is_left = false;
      bool is_right = false;
      if(labirynt[i*cols + j] & (1<<1) == (1<<1)) { is_right = true; }
      if(labirynt[i*cols + j + 1] & (1<<0) == (1<<0)) { is_left = true; }
      if(is_right && is_left){ 
        return Container();
      }
      else if(!is_right && !is_left){ 
        return Image.asset(
          'images/block.png',
          fit: BoxFit.fill
        );
      }
      else if(is_right){ 
        return Image.asset(
          'images/blockRight.png',
          fit: BoxFit.fill
        );
      }
      else if(is_left){ 
        return Image.asset(
          'images/blockLeft.png',
          fit: BoxFit.fill
        );
      }
    }
    else if(labirynt[i*cols + j] & (1<<1) == (1<<1)){
      return Container();
    }
    return Image.asset(
      'images/block.png',
      fit: BoxFit.fill
    );
  }
  
  Widget drawDown(int i, int j){
    if(i < rows-1){
      bool is_up = false;
      bool is_down = false;
      if(labirynt[i*cols + j] & (1<<3) == (1<<3)) { is_down = true; }
      if(labirynt[(i+1)*cols + j] & (1<<2) == (1<<2)) { is_up = true; }
      if(is_up && is_down){ 
        return Container();
      }
      else if(!is_up && !is_down){ 
        return Image.asset(
          'images/block.png',
          fit: BoxFit.fill
        );
      }
      else if(is_up){ 
        return Image.asset(
          'images/blockUp.png',
          fit: BoxFit.fill
        );
      }
      else if(is_down){ 
        return Image.asset(
          'images/blockDown.png',
          fit: BoxFit.fill
        );
      }
    }
    else if(labirynt[i*cols + j] & (1<<3) == (1<<3)){
      return Container();
    }

    return Image.asset(
      'images/block.png',
      fit: BoxFit.fill
    );
  }
  return Expanded(
    child: AspectRatio(
      aspectRatio: cols/rows,
      child: Column(
        children: [
          Row(
            children: List.generate(cols*2+1, (_) => Expanded(
                child: Image.asset(
                  'images/block.png',
                  fit: BoxFit.fill  
                ),
              ),  
            ),
          ),
          Column(
            children: List.generate(rows, (i) => Column(
              children: [
                Row(
                  children: [
                    Expanded(child:Image.asset(
                        'images/block.png',
                        fit: BoxFit.fill,  
                      ),)] + 
                    List.generate(cols*2, (j) => Expanded(
                        child: j%2==0?
                          Expanded(child: drawInside(i, j~/2)):
                          Expanded(child: drawRight(i, j~/2))
                      )
                    ),
                  ),
                Row(
                  children: [
                    Expanded(child:Image.asset(
                        'images/block.png',
                        fit: BoxFit.fill,  
                      ),)] + 
                    List.generate(cols*2, (j) => Expanded(
                        child: j%2==0?
                          Expanded(child: drawDown(i, j~/2)):
                          Expanded(child: Image.asset(
                        'images/block.png',
                        fit: BoxFit.fill,  
                      ))
                      )
                    ),
                ),
              ]
              )
            )
          ),
        ]
      ),
    ),
  );
  
  // for(var i = 0; i < rows; i++){
  //   stdout.write("██");
  //   for(var j = 0; j < cols; j++){
  //     if(labirynt[i*cols + j] & (1<<5) == (1<<5)){
  //       stdout.write("DD");
  //     }
  //     else if(labirynt[i*cols + j] & (1<<6) == (1<<6)){
  //       stdout.write("KK");
  //     }
  //     else if(labirynt[i*cols + j] & (1<<4) == (1<<4)){
  //       stdout.write("ST");
  //     }
  //     else if(i*cols + j == endPoint){
  //       stdout.write("EN");
  //     }
  //     else{
  //       stdout.write("  ");
  //     }

  //     if(j < cols-1){
  //       bool is_left = false;
  //       bool is_right = false;
  //       if(labirynt[i*cols + j] & (1<<1) == (1<<1)) { is_right = true; }
  //       if(labirynt[i*cols + j + 1] & (1<<0) == (1<<0)) { is_left = true; }
  //       if(is_right && is_left){ stdout.write("  "); }
  //       else if(!is_right && !is_left){ stdout.write("██"); }
  //       else if(is_right){ stdout.write(">>"); }
  //       else if(is_left){ stdout.write("<<"); }
  //     }
  //     else if(labirynt[i*cols + j] & (1<<1) == (1<<1)){
  //       stdout.write("  ");
  //     }
  //     else{
  //       stdout.write("██");
  //     }
  //   }
  //   stdout.write("\n");
  //   stdout.write("██");
  //   for(var j = 0; j < cols; j++){
  //     if(i < rows-1){
  //       bool is_up = false;
  //       bool is_down = false;
  //       if(labirynt[i*cols + j] & (1<<3) == (1<<3)) { is_down = true; }
  //       if(labirynt[(i+1)*cols + j] & (1<<2) == (1<<2)) { is_up = true; }
  //       if(is_up && is_down){ stdout.write("  "); }
  //       else if(!is_up && !is_down){ stdout.write("██"); }
  //       else if(is_up){ stdout.write("^^"); }
  //       else if(is_down){ stdout.write("⬇⬇"); }
  //     }
  //     else if(labirynt[i*cols + j] & (1<<3) == (1<<3)){
  //       stdout.write("  ");
  //     }
  //     else{
  //       stdout.write("██");
  //     }
  //     stdout.write("██");
  //   }
  //   stdout.write("\n");
  // }
}