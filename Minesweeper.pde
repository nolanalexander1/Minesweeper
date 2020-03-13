import de.bezier.guido.*;
int NUM_ROWS = 25;
int NUM_COLS = 25;
int MAX_MINES = 100;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines = new ArrayList <MSButton>(); //ArrayList of just the minesweeper buttons that are mined

void setup ()
{
    size(400, 400);
    textAlign(CENTER,CENTER);
    
    // make the manager
    Interactive.make( this );
    buttons = new MSButton[NUM_ROWS][NUM_COLS];
    for(int r = 0; r < NUM_ROWS; r++){
        for(int c = 0; c < NUM_COLS; c++){
            buttons[r][c] = new MSButton(r,c);
        }
    } 
    
    setMines();
}
public void setMines()
{
   while(mines.size() < MAX_MINES){
        int r = (int)(Math.random()*NUM_ROWS);
        int c = (int)(Math.random()*NUM_COLS);
        if(!mines.contains(buttons[r][c])){
            mines.add(buttons[r][c]);
        }
    }
}

public void draw ()
{
    background( 0 );
    if(isWon() == true)
        displayWinningMessage();
}
public boolean isWon()
{
    for(int r = 0; r < NUM_ROWS; r++){
        for(int c = 0; c < NUM_COLS; c++){
            if(mines.contains(buttons[r][c]) && !buttons[r][c].flagged == true){
                return false;
            }
        }
    }
    return true;
}
public void displayLosingMessage()
{
    noLoop();
    fill(0);
    buttons[24][9].setLabel("Y");
    buttons[24][10].setLabel("O");
    buttons[24][11].setLabel("U");
    buttons[24][12].setLabel("");
    buttons[24][13].setLabel("L");
    buttons[24][14].setLabel("O");
    buttons[24][15].setLabel("S");
    buttons[24][16].setLabel("E");
}
public void displayWinningMessage()
{
    noLoop();
    fill(0);
    buttons[24][9].setLabel("Y");
    buttons[24][10].setLabel("O");
    buttons[24][11].setLabel("U");
    buttons[24][12].setLabel("");
    buttons[24][13].setLabel("W");
    buttons[24][14].setLabel("I");
    buttons[24][15].setLabel("N");
}
public boolean isValid(int r, int c)
{
    if((0 <= r && r < NUM_ROWS) && (0 <= c && c < NUM_COLS)){
        return true;
    }
    return false;
}
public int countMines(int row, int col)
{
    int count = 0;
    if(isValid(row-1,col-1) && mines.contains(buttons[row-1][col-1])){
    count++;
  }
  if(isValid(row-1,col) == true && mines.contains(buttons[row-1][col])){
    count++;
  }
  if(isValid(row-1,col+1) == true && mines.contains(buttons[row-1][col+1])){
    count++;
  }
  if(isValid(row,col-1) == true && mines.contains(buttons[row][col-1])){
    count++;
  }
  if(isValid(row,col+1) == true && mines.contains(buttons[row][col+1])){
    count++;
  }
  if(isValid(row+1,col-1) == true && mines.contains(buttons[row+1][col-1])){
    count++;
  }
  if(isValid(row+1,col) == true && mines.contains(buttons[row+1][col])){
    count++;
  }
  if(isValid(row+1,col+1) == true && mines.contains(buttons[row+1][col+1])){
    count++;
  }
    return count;
}
public class MSButton
{
    private int myRow, myCol;
    private float x,y, width, height;
    private boolean clicked, flagged;
    private String myLabel;
    
    public MSButton ( int row, int col )
    {
        width = 400/NUM_COLS;
        height = 400/NUM_ROWS;
        myRow = row;
        myCol = col; 
        x = myCol*width;
        y = myRow*height;
        myLabel = "";
        flagged = clicked = false;
        Interactive.add( this ); // register it with the manager
    }

    // called by manager
    public void mousePressed () 
    {
        clicked = true;
        if(mouseButton == RIGHT){
            flagged = !flagged;
            clicked = !clicked;
        }
        if(mouseButton == LEFT){

            if(mines.contains(this)){
                    displayLosingMessage();
                }else if(countMines(myRow, myCol) > 0){
                    myLabel = "" + countMines(myRow, myCol);
            }else{
                    for (int i = -1; i <= 1; i++) {
                        for (int j = -1; j <= 1; j++) {
                            if (!(i == 0 && j == 0)) {
                            if (isValid(myRow+i, myCol+j) && !buttons[myRow+i][myCol+j].clicked) {
                            buttons[myRow+i][myCol+j].mousePressed();
                                }
                            }
                        }
                    }   
            }
        }

    }
    public void draw () 
    {    
        if (flagged)
            fill(0);
        else if( clicked && mines.contains(this) ) 
            fill(255,0,0);
        else if(clicked)
            fill( 200 );
        else 
            fill( 100 );

        rect(x, y, width, height);
        fill(0);
        text(myLabel,x+width/2,y+height/2);
    }
    public void setLabel(String newLabel)
    {
        myLabel = newLabel;
    }
    public void setLabel(int newLabel)
    {
        myLabel = ""+ newLabel;
    }
    public boolean isFlagged()
    {
        return flagged;
    }
}
