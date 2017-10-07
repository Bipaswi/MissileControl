final class City {

  public PVector position;
  public int col1;
  public int col2;
  public int col3;
  public int size;
  color c;
  
   City(int x, int y, int col1, int col2, int col3, int size){
    position = new PVector(x, y);
    this.col1 = col1;
    this.col2 = col2;
    this.col3 = col3;
    this.size = size;
   }
   
   public void setCol1(int col1) {
        this.col1 = col1;
   }
   
    public void setCol2(int col2) {
        this.col2 = col2;
    }
    
     public void setCol3(int col3) {
        this.col3 = col3;
    }

   void display(){
     fill(col1, col2, col3);
     noStroke();
     arc(position.x, position.y, size, size, -PI, 0); 
   }
   
}