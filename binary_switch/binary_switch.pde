// Binary Switch
// Kuyuri Iroha
//
// 2018.09.21


int setAnswer()
{
  // 1byteまで
  return floor(random(256+1));
}


// 選択肢と正解の取得
//
// データ構造: [0~3: 選択肢, 4: 正解]
IntList getChoices()
{
  IntList choices = new IntList();
  int answer = setAnswer();
  choices.append(answer);
  for(int i=0; i<3; i++)
  {
    int miss = setAnswer();
    while(miss == answer)
    {
      miss = setAnswer();
    }
    
    choices.append(setAnswer());
  }
  choices.shuffle();
  choices.append(answer);
  return choices;
}


//10進数から2進数への基数変換(1byteまで)
boolean[] binaryFromDecimal(int decimal)
{
  if(255 < decimal) {return null;}
  boolean[] binary = new boolean[8];
  for(int i = 0; i<binary.length; i++)
  {
    binary[i] = false;
  }
  
  for(int i=binary.length-1; 0<=i; i--)
  {
    binary[i] = decimal % 2 == 1;
    decimal /= 2;
  }
  
  return binary;
}


class AppData
{
  color background;
  color text;
  color shadow;
  color lightCenter;
  color lightEdge;
  color button;
  int btTexSize;
  int resTexSize;
  String successMs;
  String failedMs;
  
  IntList currQuiz;
  CircleCollider mouseColl;
  RectCollider btColl;
  
  boolean answered;
  boolean succeeded;
  
  int answeredFrame;
  int reChoicedFrame;
  int pressedDelay;
  
  AppData()
  {
    background = color(#222222);
    text = color(#fafafa);
    shadow = color(#cccccc);
    lightCenter = color(#fffff4);
    lightEdge = color(#dbd877);
    button = background;
    btTexSize = 40;
    resTexSize = 70;
    successMs = "Success";
    failedMs = "Failed";
    currQuiz = getChoices();
    mouseColl = new CircleCollider(0, 0, 1);
    btColl = new RectCollider(0, 0, 0, 0);
    answered = false;
    succeeded = false;
    pressedDelay = 30;
  }
  
  
  void update()
  {
    mouseColl.x = mouseX;
    mouseColl.y = mouseY;
  }
  
  void setAnswered(boolean success)
  {
    answered = true;
    succeeded = success;
  }
  
  void updateChoices()
  {
    currQuiz = getChoices();
    answered = false;
    succeeded = false;
  }
}


AppData app;

void setup()
{
  size(500, 500);
  smooth();
  app = new AppData();
}


void draw()
{
  background(app.background);
  app.update();
  
  switches();
  
  if(!app.answered)
  {
    int btX1 = width/7*2;
    int btY1 = height/5*3;
    int btX2 = width/7*5;
    int btY2 = height/5*4;
    button(btX1, btY1, app.currQuiz.get(0));
    button(btX2, btY1, app.currQuiz.get(1));
    button(btX1, btY2, app.currQuiz.get(2));
    button(btX2, btY2, app.currQuiz.get(3));
  }
  else
  {
    result();
  }
}


void mousePressed()
{
  if(app.answered && app.pressedDelay < abs(frameCount - app.answeredFrame))
  {
    app.updateChoices();
    app.reChoicedFrame = frameCount;
  }
}


void switches()
{
  boolean[] binary = binaryFromDecimal(app.currQuiz.get(4));
  
  int lightSize = 40;
  int gradiSize = 30;
  
  int space = width/5*4;
  int y = height/6 * 2;
  for(int i=0; i<binary.length; i++) //<>//
  {
    int x = space / 7 * i + (width-space) / 2;
    if(binary[i])
    {
      noStroke();
      for(int gradi=0; gradi<gradiSize; gradi++)
      {
        fill(lerpColor(app.lightEdge, app.lightCenter, float(gradi) / gradiSize));
        ellipse(x, y, lightSize-gradi, lightSize-gradi);
      }
    }
    else
    {
      stroke(app.shadow);
      noFill();
      ellipse(x, y, lightSize, lightSize);
    }
  }
}

void button(float x, float y, int number)
{
  int shadowOff = 2;
  int rectW = 150;
  int rectH = 80;
  
  app.btColl.x = x;
  app.btColl.y = y;
  app.btColl.w = rectW;
  app.btColl.h = rectH;
  
  int btX = 0;
  int btY = 0;
  int texX = 0;
  int texY = 0;
  
  if(!app.btColl.hit(app.mouseColl))
  {
    //shadow
    rectMode(CORNER);
    noStroke();
    fill(app.shadow);
    rect(x-rectW/2.0+shadowOff, y-rectH/2.0+shadowOff, rectW, rectH);
  
    //button
    btX = int(x);
    btY = int(y);
    //text
    texX = int(x-shadowOff);
    texY = int(y-shadowOff);
  }
  else
  {
    //button
    btX = int(x+shadowOff);
    btY = int(y+shadowOff);
    //text
    texX = int(x);
    texY = int(y);
    
    //answer
    if(mousePressed && app.pressedDelay < abs(frameCount - app.reChoicedFrame))
    {
      app.setAnswered(number == app.currQuiz.get(4));
      app.answeredFrame = frameCount;
    }
  }
  
  //button
  rectMode(CENTER);
  fill(app.button);
  stroke(app.shadow);
  strokeWeight(0.5);
  rect(btX, btY, rectW, rectH);
  
  //text
  textAlign(CENTER, CENTER);
  textSize(app.btTexSize);
  fill(app.text);
  noStroke();
  text(str(number), texX, texY);
}


void result()
{
  if(app.succeeded)
  {
    textAlign(CENTER, CENTER);
    textSize(app.resTexSize);
    fill(app.shadow);
    noStroke();
    text(app.successMs, width/2, height/4*3);
  }
  else
  {
    textAlign(CENTER, CENTER);
    textSize(app.resTexSize);
    fill(app.shadow);
    noStroke();
    text(app.failedMs, width/2, height/4*3);
  }
}
