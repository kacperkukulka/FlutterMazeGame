import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:labirynt/labirynt_generator.dart';
import 'dart:math' show pi;

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
                                              jednstr: true, 
                                              drzwi: true).labirynt;
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
  int numOfMoves = -1;
  int numOfKeys = 0;

  @override
  void initState(){
    _checkButtons();
    super.initState();
  }

  void _checkButtons() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      numOfMoves += 1;
      if(widget.labirynt[position()] & ~(1<<4) == 0){
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => WinPage(numOfMoves: numOfMoves)
          )
        );
      }

      _isLeftDisabled = widget.labirynt[position()] & (1<<0) == (1<<0) ? false : true;
      _isRightDisabled = widget.labirynt[position()] & (1<<1) == (1<<1) ? false : true;
      _isUpDisabled = widget.labirynt[position()] & (1<<2) == (1<<2) ? false : true;
      _isDownDisabled = widget.labirynt[position()] & (1<<3) == (1<<3) ? false : true;

      if(numOfKeys < 1){
        try{ _isLeftDisabled = widget.labirynt[position()-1] & (1<<5) == (1<<5) ? true : _isLeftDisabled; } catch(_){}
        try{ _isRightDisabled = widget.labirynt[position()+1] & (1<<5) == (1<<5) ? true : _isRightDisabled; } catch(_){}
        try{ _isUpDisabled = widget.labirynt[position()-widget.cols] & (1<<5) == (1<<5) ? true : _isUpDisabled; } catch(_){}
        try{ _isDownDisabled = widget.labirynt[position()+widget.cols] & (1<<5) == (1<<5) ? true : _isDownDisabled; } catch(_){}
      }
  }
  
  void move(){
    if(widget.labirynt[position()] & (1<<5) == (1<<5)){
      widget.labirynt[position()] &= ~(1<<5);
      setState((){ numOfKeys--; });
    }
    if(widget.labirynt[position()] & (1<<6) == (1<<6)){
      widget.labirynt[position()] &= ~(1<<6);
      setState(() {
        numOfKeys++;
      });
    }
  }

  void _goUp(){
    var pos = position();
    widget.labirynt[pos] &= ~(1<<4);
    widget.labirynt[pos-widget.cols] |= (1<<4);
    move();
    setState(() {_checkButtons();});
  }

  void _goDown(){
    var pos = position();
    widget.labirynt[pos] &= ~(1<<4);
    widget.labirynt[pos+widget.cols] |= (1<<4);
    move();
    setState(() {_checkButtons();});
  }

  void _goLeft(){
    var pos = position();
    widget.labirynt[pos] &= ~(1<<4);
    widget.labirynt[pos-1] |= (1<<4);
    move();
    setState(() {_checkButtons();});
  }

  void _goRight(){
    var pos = position();
    widget.labirynt[pos] &= ~(1<<4);
    widget.labirynt[pos+1] |= (1<<4);
    move();
    setState(() {_checkButtons();});
  }

  int position(){
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
        child: Stack(
          alignment: Alignment.center,
          children: [
            InteractiveViewer(
              child: SizedBox(
                height: labiryntSize(context, (widget.cols*2+1)/(widget.rows*2+1))[1], // Adjust the height constraint as needed
                width: labiryntSize(context, (widget.cols*2+1)/(widget.rows*2+1))[0],
                child: CustomPaint(
                  painter: LabiryntDraw(widget.rows, widget.cols, widget.labirynt),
                )
              ),
            ),
            Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                children: [
                  ElevatedButton(
                    onPressed: _isUpDisabled ? null : _goUp,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.withOpacity(0.6)
                    ),
                    child: const Text('Góra',),
                  ),
                  Text('Keys: $numOfKeys', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),
                ],
              ),
              Row(
                children: <Widget>[
                  ElevatedButton(
                    onPressed: _isLeftDisabled ? null : _goLeft,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.withOpacity(0.6)
                    ),
                    child: const Text("Lewo"),
                  ),
                  Expanded(
                    child: Container(),
                  ),
                  ElevatedButton(
                    onPressed: _isRightDisabled ? null : _goRight,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.withOpacity(0.6)
                    ),
                    child: const Text("Prawo"),
                  )
                ],
              ),
              Center(
                child: ElevatedButton(
                  onPressed: _isDownDisabled ? null : _goDown,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.withOpacity(0.6)
                    ),
                  child: const Text("Dół"),
                ),
              )
              ],
            ),
          ]
        ),
      ),
    );
  }

  List<double> labiryntSize(BuildContext context, double aspectRatio){
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    if(aspectRatio < 1){
      if(height * aspectRatio > width){
        height = width / aspectRatio;
      }
      else{
        width = height * aspectRatio;
      }
    }
    else{
      if(width / aspectRatio > height){
        width = height * aspectRatio;
      }
      else{
        height = width / aspectRatio;
      }
    }
    return [width, height];
  }
}

class LabiryntDraw extends CustomPainter{

  late List<int> labirynt;
  late int rows;
  late int cols;

  LabiryntDraw(this.rows, this.cols, this.labirynt);

  @override
  void paint(Canvas canvas, Size size){
    double blockWidth = size.width / (cols*2 + 1);
    double blockHeight = size.height / (rows*2 + 1);


    void paintBlock(int i, int j, Color colorStroke, Color colorFill){
      final rect = Rect.fromLTWH(j*blockWidth, i*blockHeight, blockWidth, blockHeight);
      final paintStroke = Paint()
        ..color = colorStroke
        ..style = PaintingStyle.stroke;

      final paintFill = Paint()
        ..color = colorFill
        ..style = PaintingStyle.fill;
      canvas.drawRect(rect, paintFill);
      canvas.drawRect(rect, paintStroke);
    }

    void paintWall(int i, int j){
      paintBlock(i, j, 
        const Color.fromARGB(255, 62, 62, 62), 
        const Color.fromARGB(255, 136, 136, 136));
    }

    void paintWallSide(int i, int j, int direction){
      paintBlock(i, j, 
        const Color.fromARGB(255, 125, 125, 125), 
        const Color.fromARGB(255, 209, 209, 209));
      
      final paint = Paint()
      ..color = const Color.fromARGB(255, 82, 82, 82)
      ..strokeWidth = blockWidth/8
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

      switch (direction) {
        case 0:
          canvas.drawLine(
            Offset(j*blockWidth + blockWidth*0.1, i*blockHeight + blockHeight*0.5), 
            Offset(j*blockWidth + blockWidth*0.9, i*blockHeight + blockHeight*0.5), paint);
            canvas.drawLine(
            Offset(j*blockWidth + blockWidth*0.3, i*blockHeight + blockHeight*0.3), 
            Offset(j*blockWidth + blockWidth*0.1, i*blockHeight + blockHeight*0.5), paint);
          canvas.drawLine(
            Offset(j*blockWidth + blockWidth*0.3, i*blockHeight + blockHeight*0.7), 
            Offset(j*blockWidth + blockWidth*0.1, i*blockHeight + blockHeight*0.5), paint);
          break;
        case 1:
          canvas.drawLine(
            Offset(j*blockWidth + blockWidth*0.1, i*blockHeight + blockHeight*0.5), 
            Offset(j*blockWidth + blockWidth*0.9, i*blockHeight + blockHeight*0.5), paint);
          canvas.drawLine(
            Offset(j*blockWidth + blockWidth*0.7, i*blockHeight + blockHeight*0.3), 
            Offset(j*blockWidth + blockWidth*0.9, i*blockHeight + blockHeight*0.5), paint);
          canvas.drawLine(
            Offset(j*blockWidth + blockWidth*0.7, i*blockHeight + blockHeight*0.7), 
            Offset(j*blockWidth + blockWidth*0.9, i*blockHeight + blockHeight*0.5), paint);
          break;
        case 2:
          canvas.drawLine(
            Offset(j*blockWidth + blockWidth*0.5, i*blockHeight + blockHeight*0.1), 
            Offset(j*blockWidth + blockWidth*0.5, i*blockHeight + blockHeight*0.9), paint);
          canvas.drawLine(
            Offset(j*blockWidth + blockWidth*0.3, i*blockHeight + blockHeight*0.3), 
            Offset(j*blockWidth + blockWidth*0.5, i*blockHeight + blockHeight*0.1), paint);
          canvas.drawLine(
            Offset(j*blockWidth + blockWidth*0.7, i*blockHeight + blockHeight*0.3), 
            Offset(j*blockWidth + blockWidth*0.5, i*blockHeight + blockHeight*0.1), paint);
          break;
        case 3:
          canvas.drawLine(
            Offset(j*blockWidth + blockWidth*0.5, i*blockHeight + blockHeight*0.1), 
            Offset(j*blockWidth + blockWidth*0.5, i*blockHeight + blockHeight*0.9), paint);
          canvas.drawLine(
            Offset(j*blockWidth + blockWidth*0.3, i*blockHeight + blockHeight*0.7), 
            Offset(j*blockWidth + blockWidth*0.5, i*blockHeight + blockHeight*0.9), paint);
          canvas.drawLine(
            Offset(j*blockWidth + blockWidth*0.7, i*blockHeight + blockHeight*0.7), 
            Offset(j*blockWidth + blockWidth*0.5, i*blockHeight + blockHeight*0.9), paint);
          break;
        default:
      }
    }

    void paintDoor(int i, int j){
      paintBlock(i, j, 
        const Color.fromARGB(255, 52, 28, 10), 
        const Color.fromARGB(255, 96, 57, 16));

        final paint = Paint()
        ..color = const Color.fromARGB(255, 170, 170, 170)
        ..strokeWidth = blockWidth/16
        ..style = PaintingStyle.stroke;

        canvas.drawLine(
          Offset(j*blockWidth + blockWidth*0.7, i*blockHeight + blockHeight*0.5), 
          Offset(j*blockWidth + blockWidth*0.9, i*blockHeight + blockHeight*0.5), paint); 

        canvas.drawLine(
          Offset(j*blockWidth + blockWidth*0.9, i*blockHeight + blockHeight*0.5), 
          Offset(j*blockWidth + blockWidth*0.9, i*blockHeight + blockHeight*0.6), paint); 
    }

    void paintKey(int i, int j){
      final rect = Rect.fromLTWH(
        j*blockWidth + blockWidth*0.1, 
        i*blockHeight + blockHeight*0.4, 
        blockWidth*0.2, blockHeight*0.2);

      final paint = Paint()
        ..color = const Color.fromARGB(255, 118, 118, 118)
        ..strokeWidth = blockWidth/16
        ..style = PaintingStyle.stroke;

      canvas.drawArc(rect, 0, 2*pi, false, paint);

      canvas.drawLine(
        Offset(j*blockWidth + blockWidth*0.3, i*blockHeight + blockHeight*0.5), 
        Offset(j*blockWidth + blockWidth*0.9, i*blockHeight + blockHeight*0.5), paint); 
      canvas.drawLine(
        Offset(j*blockWidth + blockWidth*0.8, i*blockHeight + blockHeight*0.5), 
        Offset(j*blockWidth + blockWidth*0.8, i*blockHeight + blockHeight*0.6), paint); 
      canvas.drawLine(
        Offset(j*blockWidth + blockWidth*0.9, i*blockHeight + blockHeight*0.5), 
        Offset(j*blockWidth + blockWidth*0.9, i*blockHeight + blockHeight*0.6), paint); 
    }
    
    void paintPlayer(int i, int j){
      final rect = Rect.fromLTWH(
        j*blockWidth + blockWidth*0.4, 
        i*blockHeight + blockHeight*0.1, 
        blockWidth*0.2, blockHeight*0.2);

      final paint = Paint()
        ..color = const Color.fromARGB(255, 69, 69, 69)
        ..strokeWidth = blockWidth/16
        ..style = PaintingStyle.stroke;

      canvas.drawArc(rect, 0, 2*pi, false, paint);
      canvas.drawLine(
        Offset(j*blockWidth + blockWidth*0.5, i*blockHeight + blockHeight*0.3), 
        Offset(j*blockWidth + blockWidth*0.5, i*blockHeight + blockHeight*0.6), paint); 
      canvas.drawLine(
        Offset(j*blockWidth + blockWidth*0.5, i*blockHeight + blockHeight*0.6), 
        Offset(j*blockWidth + blockWidth*0.3, i*blockHeight + blockHeight*0.9), paint); 
      canvas.drawLine(
        Offset(j*blockWidth + blockWidth*0.5, i*blockHeight + blockHeight*0.6), 
        Offset(j*blockWidth + blockWidth*0.7, i*blockHeight + blockHeight*0.9), paint);
      canvas.drawLine(
        Offset(j*blockWidth + blockWidth*0.5, i*blockHeight + blockHeight*0.4), 
        Offset(j*blockWidth + blockWidth*0.7, i*blockHeight + blockHeight*0.6), paint); 
      canvas.drawLine(
        Offset(j*blockWidth + blockWidth*0.5, i*blockHeight + blockHeight*0.4), 
        Offset(j*blockWidth + blockWidth*0.3, i*blockHeight + blockHeight*0.6), paint);  
    }

    void paintFinish(int i, int j){
      var help = 0;
      for(int k = 0; k < 8; k++){
        for(int l = 0; l < 8; l++){
          final rect = Rect.fromLTWH(
            j*blockWidth + (blockWidth*(l/8)), 
            i*blockHeight + (blockHeight*(k/8)), 
            blockWidth / 8, 
            blockHeight / 8
          );

          final paintFill = Paint()
            ..color = (help++)%2 == 1?Colors.black : Colors.white
            ..style = PaintingStyle.fill;
          canvas.drawRect(rect, paintFill);
        }
        help--;
      }
    }
    //top border
    for(var j = 0; j < (cols*2+1); j++){
      paintWall(0,j);
    }

    //left border
    for(var i = 0; i < rows*2+1; i++){
      paintWall(i, 0);
    }

    for(var i = 0; i < rows; i++){
      for(var j = 0; j < cols; j++){
        paintWall((i*2)+2, (j*2)+2);
        if(labirynt[i*cols + j] & (1<<5) == (1<<5)){
          paintDoor((i*2)+1, (j*2)+1);
        }
        else if(labirynt[i*cols + j] & (1<<6) == (1<<6)){
          paintKey((i*2)+1, (j*2)+1);
        }
        else if(labirynt[i*cols + j] & (1<<4) == (1<<4)){
          paintPlayer((i*2)+1, (j*2)+1);
        }
        else if(labirynt[i*cols + j] == 0){
          paintFinish((i*2)+1, (j*2)+1);
        }

        if(j < cols-1){
          bool isLeft = false;
          bool isRight = false;
          if(labirynt[i*cols + j] & (1<<1) == (1<<1)) { isRight = true; }
          if(labirynt[i*cols + j + 1] & (1<<0) == (1<<0)) { isLeft = true; }
          if(!isRight && !isLeft){ paintWall((i*2)+1, (j*2)+2); }
          else if(isRight && !isLeft){ paintWallSide((i*2)+1, (j*2)+2, 1); }
          else if(isLeft && !isRight){ paintWallSide((i*2)+1, (j*2)+2, 0); }
        }
        else if(labirynt[i*cols + j] & (1<<1) != (1<<1)){
          paintWall((i*2)+1, (j*2)+2);
        }
      }
      for(var j = 0; j < cols; j++){
        if(i < rows-1){
          bool isUp = false;
          bool isDown = false;
          if(labirynt[i*cols + j] & (1<<3) == (1<<3)) { isDown = true; }
          if(labirynt[(i+1)*cols + j] & (1<<2) == (1<<2)) { isUp = true; }
          if(!isUp && !isDown){ paintWall((i*2)+2, (j*2)+1); }
          else if(isUp && !isDown){ paintWallSide((i*2)+2, (j*2)+1, 2); }
          else if(isDown && !isUp){ paintWallSide((i*2)+2, (j*2)+1, 3); }
        }
        else if(labirynt[i*cols + j] & (1<<3) != (1<<3)){
          paintWall((i*2)+2, (j*2)+1);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

List<dynamic> hello(){
  return [[1,2,3],[0,3],["hello","f"]];
}