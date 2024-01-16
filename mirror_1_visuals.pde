int lastMillis = 0;
int __framesPerSecond = 90;
int __millisPerFrame = 1000/__framesPerSecond;

ArrayList<Layer> layers = new ArrayList<>();

void setup() {
  size(1664, 936);
  
  layers.add(new Layer(loadJSONObject(".settings.local")));
  
  frameRate(__framesPerSecond);
  background(0);
}

void draw(){
  //layers.get(0).screen.render();
  int totalMillis = millis();
  int elapsedMillis = totalMillis - lastMillis;
 
  for(Layer l : layers){
    l.run(elapsedMillis, totalMillis);
  }
 
  lastMillis = totalMillis;
  //println(elapsedMillis);
}
