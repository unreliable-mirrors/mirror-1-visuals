class Screen{
  PGraphics source;
  int targetWidth;
  int targetHeight;
  float panX;
  float panY;
  
  Screen(PGraphics source, int targetWidth, int targetHeight){
    this.source = source;
    this.panX = 0;
    this.panY = 0;
    
    this.targetWidth = targetWidth;
    this.targetHeight = targetHeight;
  }
  
  void pan(float x, float y){
    panX = panX + x;
    panY = panY + y;
  }
  
  color get(int x, int y){
    return source.get(floor(x - panX), floor(y - panY));  
  }
  
  void render(){
    image(source, panX, panY);
  }
  
  void destroy(){
    source = null; 
  }
  
}
