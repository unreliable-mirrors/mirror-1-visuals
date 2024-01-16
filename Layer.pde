class Layer implements IRunnable{
  PGraphics currentImage;
  
  ArrayList<IRenderer> renderers;
  
  Screen screen;
  
  int panXFactor;
  int panYFactor;
  
  int lastFloor = 0;
  
  ArrayList<PImage> images;
  
  int currentBits = 0;
  int maxBits = 9;
  
  JSONObject settings;
  
  
  Layer(JSONObject settings){
    this.settings = settings;
    renderers = new ArrayList<IRenderer>();
    images = new ArrayList<PImage>();
    //renderers.add(new PassThroughRenderer());
    //renderers.add(new AlphaRenderer());
    //renderers.add(new RectMonteCarloRenderer());
    //renderers.add(new LineMonteCarloRenderer());
    for(int i = 0; i <= maxBits; i++){
       images.add(createImage(1664,936,RGB));
    }
    setupImage();
  }
  
  
  void setupImage(){
    PImage img = images.get(min(currentBits, maxBits));
    
    
    int targetHeight = 100;
    int targetWidth = 100;
    float ratio;
    
    if(img.width < img.height){
      targetWidth = width;
      ratio = targetWidth / (float)img.width;
      targetHeight = floor(img.height * ratio);
      panXFactor = 0;
      panYFactor = 1;
      if(targetHeight < height){
        targetHeight = height;
        ratio = targetHeight / (float)img.height;
        targetWidth = floor(img.width * ratio);
        panXFactor = 1;
        panYFactor = 0;
      }
    }else{
      targetHeight = height;
      ratio = targetHeight / (float)img.height;
      targetWidth = floor(img.width * ratio);
      panXFactor = 1;
      panYFactor = 0;
      
      if(targetWidth < width){
        targetWidth = width;
        ratio = targetWidth / (float)img.width;
        targetHeight = floor(img.height * ratio);
        panXFactor = 0;
        panYFactor = 1;
      }
      
     
    }
    
    currentImage = createGraphics(targetWidth, targetHeight);
    currentImage.beginDraw();
    currentImage.image(img,0,0, targetWidth, targetHeight);
    currentImage.endDraw();
    
    screen = new Screen(currentImage, width, height);
  }
  
  void loadCommands(){
    JSONObject json = loadJSONObject(settings.getString("commandsUrl")).getJSONObject("response");
    JSONArray commands = json.getJSONArray("commands");
    for(int i = 0; i < commands.size(); i++){
      JSONObject command = commands.getJSONObject(i);
      
      String type = command.getString("type");
      
      if("paint".equals(type)){
        int x = command.getInt("x");
        int y = command.getInt("y");
        String colorString = command.getString("color");
        //currentBits = command.getInt("currentBits");
        //currentBits = 2;
        color c = unhex(colorString);
        
        for(int bit = 0; bit < images.size(); bit++){
          PImage img = images.get(bit);
          //24 bit
          float red = red(c);
          float green = green(c);
          float blue = blue(c);
          
          if(bit == 0){
            //1 bit
            int range = 2;
            red = floor(brightness(c)/(256/range))*(255/(range-1));
            green = red;
            blue = green;
          }else if(bit == 1){
            //2 bit
            int range = 4;
            red = floor(brightness(c)/(256/range))*(255/(range-1));
            green = red;
            blue = green;
          }else if(bit == 2){
            //3 bit
            int range = 2;
            red = floor(red(c)/(256/range))*(255/(range-1));
            green = floor(green(c)/(256/range))*(255/(range-1));
            blue = floor(blue(c)/(256/range))*(255/(range-1));
          }else if(bit == 3){
            //6 bit
            int range = 4;
            red = floor(red(c)/(256/range))*(255/(range-1));
            green = floor(green(c)/(256/range))*(255/(range-1));
            blue = floor(blue(c)/(256/range))*(255/(range-1));
          }else if(bit == 4){
            //9 bit
            int range = 8;
            red = floor(red(c)/(256/range))*(255/(range-1));
            green = floor(green(c)/(256/range))*(255/(range-1));
            blue = floor(blue(c)/(256/range))*(255/(range-1));
          }else if(bit == 5){
            //12 bit
            int range = 16;
            red = floor(red(c)/(256/range))*(255/(range-1));
            green = floor(green(c)/(256/range))*(255/(range-1));
            blue = floor(blue(c)/(256/range))*(255/(range-1));
          }else if(bit == 6){
            //15 bit
            int range = 32;
            red = floor(red(c)/(256/range))*(255/(range-1));
            green = floor(green(c)/(256/range))*(255/(range-1));
            blue = floor(blue(c)/(256/range))*(255/(range-1));
          }else if(bit == 7){
            //18 bit
            int range = 64;
            red = floor(red(c)/(256/range))*(255/(range-1));
            green = floor(green(c)/(256/range))*(255/(range-1));
            blue = floor(blue(c)/(256/range))*(255/(range-1));
          }else if(bit == 8){
            //21 bit
            int range = 128;
            red = floor(red(c)/(256/range))*(255/(range-1));
            green = floor(green(c)/(256/range))*(255/(range-1));
            blue = floor(blue(c)/(256/range))*(255/(range-1));
          }
          
          color cc = color(red, green, blue);
          
          img.loadPixels();
          for (int ii = 0; ii <1 ; ii++) {
            img.pixels[((y%height)*width)+(x%width)+ii] = cc;
          }
          img.updatePixels(); 
        }
        
        setupImage();
      }
      
    }
    
  }
  
  void run(int elapsedMillis, int totalMillis){
    if(totalMillis / 1000 > lastFloor){
      //println("TRIGGER", totalMillis / 1000, lastFloor);
      lastFloor = totalMillis / 1000;
      loadCommands();
      currentBits = lastFloor % (maxBits+1);
      setupImage();
    }
    
    Screen filteredImage = screen;
    for(IRenderer renderer : renderers){
        filteredImage = renderer.render(filteredImage);
    }
    //if(filteredImage != screen){
    filteredImage.render();
    //}
    
  }
}
