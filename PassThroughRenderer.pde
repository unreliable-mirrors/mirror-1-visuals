class PassThroughRenderer implements IRenderer{
  
  PGraphics cachedResult;
  Screen lastImage;
 
  Screen render(Screen image){
    if(image == lastImage){
      return new Screen(cachedResult, image.targetWidth, image.targetHeight);  
    }
    
    PGraphics result = createGraphics(width, height);
    result.beginDraw();
    result.image(image.source, 0, 0, width, height);
    result.endDraw();
    
    lastImage = image;
    
    cachedResult = result;
    return new Screen(result, image.targetWidth, image.targetHeight);
  }
}
