// A Processing implementation of Game Life 

// Copyright
// Joan Soler-Adillon
// Gidon Ernst

// https://processing.org/examples/gameoflife.html
// License: GLP 2

// Size of cells
int cellSize = 10;
int columns, rows;

// How likely for a cell to be alive at start (in percentage)
float probabilityOfAliveAtStart = 30;

// Variables for timer
int interval = 100;
int lastRecordedTime = 0;

// Colors for active/inactive cells
color alive = color(0, 200, 0);
color dead = color(0, 0, 0);

// Array of cells
int[][] cells;

// Pause
boolean pause = false;

void setup() {
  size (800, 600);
  columns = width/cellSize;
  rows = height/cellSize;
  
  // Instantiate arrays 
  cells = new int[columns][rows];

  // This stroke will draw the background grid
  stroke(48);

  noSmooth();
  init();

  background(0); // Fill in black in case cells don't cover all the windows
}

void init() {
  // Initialization of cells
  for (int x=0; x<columns; x++) {
    for (int y=0; y<rows; y++) {
      float state = random (100);
      
      if (state < probabilityOfAliveAtStart) { 
        cells[x][y] = 1;
      } else {
        cells[x][y] = 0;
      }
    }
  }
}

void draw() {
  //Draw grid
  for (int x=0; x<columns; x++) {
    for (int y=0; y<rows; y++) {
      if (cells[x][y] == 1) {
        fill(alive); // If alive
      }
      else {
        fill(dead); // If dead
      }
      rect (x*cellSize, y*cellSize, cellSize, cellSize);
    }
  }
  
  // Iterate if timer ticks
  if (millis()-lastRecordedTime>interval) {
    if (!pause) {
      iteration();
      lastRecordedTime = millis();
    }
  }
}


void iteration() { // When the clock ticks

  // First part: compute hom many neighbors each cell has
  int[][] neighbors = new int[columns][rows];
  
  for (int x=0; x<columns; x++) {
    for (int y=0; y<rows; y++) {
      neighbors[x][y] = 0;
      
      // ceck cells above and below
      if(0 <= y-1)
        neighbors[x][y] += cells[x][y-1];
      if(y+1 < rows)
        neighbors[x][y] += cells[x][y+1];
      
      // check cells to left and right
      if(0 <= x-1)
        neighbors[x][y] += cells[x-1][y];
      if(x+1 < columns)
        neighbors[x][y] += cells[x+1][y];
      
      // check diagonal neighbors
      if(0 <= x-1 && 0 <= y-1)
        neighbors[x][y] += cells[x-1][y-1];
      if(x+1 < columns && 0 <= y-1)
        neighbors[x][y] += cells[x+1][y-1];
      if(0 <= x-1 && y+1 < rows)
        neighbors[x][y] += cells[x-1][y+1];
      if(x+1 < columns && y+1 < rows)
        neighbors[x][y] += cells[x+1][y+1];
    }
  }
  
  // Second part: determine for each cell the new status depending on its neighbors
  for (int x=0; x<columns; x++) {
    for (int y=0; y<rows; y++) {
      if(neighbors[x][y] < 2) {
        cells[x][y] = 0;
      }
      
      if(neighbors[x][y] == 3) {
        cells[x][y] = 1;
      }
      
      
      if(neighbors[x][y] > 3) {
        cells[x][y] = 0;
      }
    }
  }
}

void mousePressed() {
  mouseDragged();
}

void mouseDragged() {
  if(pause) {
    int x = int(map(mouseX, 0, width, 0, columns));
    int y = int(map(mouseY, 0, height, 0, rows));
    
    if(0 <= x && x < columns && 0 <= y && y < rows) {
      if(mouseButton == LEFT) {
        cells[x][y] = 1;
      }
      if(mouseButton == RIGHT) {
        cells[x][y] = 0;
      }
    }
  }
}

void keyPressed() {
  if (key=='r' || key == 'R') {
    // Restart: reinitialization of cells
    init();
  }
  if (key==' ') { // On/off of pause
    pause = !pause;
  }
  if (key=='c' || key == 'C') { // Clear all
    for (int x=0; x<columns; x++) {
      for (int y=0; y<rows; y++) {
        cells[x][y] = 0; // Save all to zero
      }
    }
  }
}
