import 'dart:math';
import 'dart:io';

class Labirynt{
  late int rows;
  late int cols;
  int jednstrPrzejscia = 10;
  int zageszczenieJedn = 7;
  int zageszczenieDrzwi = 10;
  late List<int> labirynt;
  late List<bool> isVisited;
  late List<int> path;
  late int startX;
  late int startY;
  int endPoint = -1;

  Labirynt({required int rows, required int cols, required bool jednstr, required bool drzwi}){
    this.rows = rows;
    this.cols = cols;
    isVisited = List.filled(rows*cols, false);
    path = List.empty(growable: true);
    startX = Random().nextInt(rows);
    startY = Random().nextInt(cols);
    labirynt = List.filled(rows*cols, 0);

    int endPoint = generujLabirynt(startX, startY);
    
    if(jednstr){ losujJednPrzejscia(); }
    if(drzwi){ losujDrzwi(); }
  }

  void losujDrzwi(){
    int iloscDrzwi = ((path.length-1)/zageszczenieDrzwi).ceil();
    List<bool> czyDrzwi = List.filled(path.length-1, false);
    for(int i = 0; i < iloscDrzwi; i++){ czyDrzwi[i] = true; }
    czyDrzwi.shuffle();

    for(int i = 2; i < path.length-1; i++){
      if(czyDrzwi[i]){
        labirynt[path[i]] |= (1<<5);
        List<bool> isVisitedForDoor = List.filled(rows*cols, false);
        isVisitedForDoor[startX*cols + startY] = true;
        isVisitedForDoor[path[i]] = true;
        int numOfSteps = Random().nextInt(max(rows,cols)*4);
        int pozycja = path[i-1];

        for(int j = 0; j < numOfSteps; j++){
          List<int> directions = [0,1,2,3];
          directions.shuffle();
          bool isContinue = false;
          for(int k = 0; k < 4; k++){
            if(directions[k]==0 && labirynt[pozycja] & (1<<0) == (1<<0)){
              if(!isVisitedForDoor[pozycja-1]){
                pozycja = pozycja-1;
                isContinue = true;
              }
            }
            if(directions[k]==1 && labirynt[pozycja] & (1<<1) == (1<<1)){
              if(!isVisitedForDoor[pozycja+1]){
                pozycja = pozycja+1;
                isContinue = true;
              }
            }
            if(directions[k]==2 && labirynt[pozycja] & (1<<2) == (1<<2)){
              if(!isVisitedForDoor[pozycja-cols]){
                pozycja = pozycja-cols;
                isContinue = true;
              }
            }
            if(directions[k]==3 && labirynt[pozycja] & (1<<3) == (1<<3)){
              if(!isVisitedForDoor[pozycja+cols]){
                pozycja = pozycja+cols;
                isContinue = true;
              }
            }
            if(isContinue){ break; }
          }
          isVisitedForDoor[pozycja] = true;
          if(!isContinue) { break; }
        }
        if((labirynt[pozycja] & (1<<5) == (1<<5)) || (labirynt[pozycja] & (1<<6) == (1<<6))){
          labirynt[path[i]] &= ~(1<<5);
        }
        else{
          labirynt[pozycja] |= (1<<6);
        }
      }
    }
  }

  int generujLabirynt(int x, int y){
    int maxPathLen = -1;
    int maxPathPos = -1;

    List<int> stack = List.empty(growable: true);
    labirynt[x*cols + y] |= (1<<4);

    while(true){
      if(stack.length > maxPathLen){
        maxPathLen = stack.length;
        maxPathPos = x*cols + y;
        path.clear();
        for(var i in stack){
          path.add(i);
        }
      }
      isVisited[x*cols + y] = true;

      List<int> directions = [0,1,2,3];
      directions.shuffle();

      bool isContinue = false;
      for(int i = 0; i < 4; i++){
        if(directions[i] == 0 && y > 0){
          if(!isVisited[x*cols+y-1]){
            stack.add(x*cols+y);
            labirynt[x*cols+y] |= (1<<0);
            labirynt[x*cols+y-1] |= (1<<1);
            y = y-1;
            isContinue = true;
            break;
          }
        }

        if(directions[i] == 1 && y < cols-1){
          if(!isVisited[x*cols+y+1]){
            stack.add(x*cols+y);
            labirynt[x*cols+y] |= (1<<1);
            labirynt[x*cols+y+1] |= (1<<0);
            y = y+1;
            isContinue = true;
            break;
          }
        }

        if(directions[i] == 2 && x > 0){
          if(!isVisited[(x-1)*cols+y]){
            stack.add(x*cols+y);
            labirynt[x*cols+y] |= (1<<2);
            labirynt[(x-1)*cols+y] |= (1<<3);
            x = x-1;
            isContinue = true;
            break;
          }
        }

        if(directions[i] == 3 && x < rows-1){
          if(!isVisited[(x+1)*cols+y]){
            stack.add(x*cols+y);
            labirynt[x*cols+y] |= (1<<3);
            labirynt[(x+1)*cols+y] |= (1<<2);
            x = x+1;
            isContinue = true;
            break;
          }
        }
      }

      if(!isContinue){
        if(stack.isNotEmpty){
          x = stack.last~/cols;
          y = stack.last - (x*cols);
          stack.removeLast();
        }
        else{
          break;
        }
      }
    }
    labirynt[maxPathPos] = 0;
    return maxPathPos;
  }

  void losujJednPrzejscia(){
    int i = 0;
    int iloscPrzejsc = ((path.length-2)/zageszczenieJedn).ceil();

    List<bool> czyJedn = List.filled(path.length-2, false);
    for(int i = 0; i < iloscPrzejsc; i++){ czyJedn[i] = true; }
    czyJedn.shuffle();

    for(int i = 0; i < path.length-2; i++){
      if(czyJedn[i]){
        if (path[i] + 1 == path[i+1]){
          labirynt[path[i+1]] &= ~(1<<0);
        }
        else if(path[i] - 1 == path[i+1]){
          labirynt[path[i+1]] &= ~(1<<1);
        }
        else if(path[i] - cols == path[i+1]){
          labirynt[path[i+1]] &= ~(1<<3);
        }
        else if(path[i] + cols == path[i+1]){
          labirynt[path[i+1]] &= ~(1<<2);
        }
      }
    }
  }
}