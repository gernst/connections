// Image Manipulation

// Copyright
// Gidon Ernst

// Based on:
// Joan Soler-Adillon (https://processing.org/examples/gameoflife.html)

// License: GLP 2

// Variables for timer
int interval = 100;
int lastRecordedTime = 0;

// Array of cells
color[][] cells;

// Pause
boolean pause = false;

int columns, rows;
int scale = 4;
PImage image;
     
int mode = 0; // or 1 or 2 (but that is *very* flashy)

void settings() {
  image = loadImage("marienplatz.png");
  columns = image.width;
  rows = image.height;
  size (columns*scale, rows*scale);
  noSmooth();
}

void setup() {
  init();
  background(0); // Fill in black in case cells don't cover all the windows
}

void init() {
  // Instantiate arrays 
  cells = new int[width][height];
  image.loadPixels();
  
  // Initialization of cells
  for (int x=0; x<columns; x++) {
    for (int y=0; y<rows; y++) {
      int i = x + y * columns;
      color c = image.pixels[i];
      cells[x][y] = c;
    }
  }
}

void draw() {
  //Draw grid
  for (int x=0; x<columns; x++) {
    for (int y=0; y<rows; y++) {
      color c = cells[x][y];
      if(scale == 1) {
        stroke(c);
        point(x, y);
      } else {
        stroke(c);
        fill(c);
        rect(x*scale,y*scale,scale,scale);
      }
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

  // First part: compute hom many r each cell has
  float[][] r = new float[columns][rows];
  float[][] g = new float[columns][rows];
  float[][] b = new float[columns][rows];
  
  for (int x=0; x<columns; x++) {
    for (int y=0; y<rows; y++) {
      r[x][y] = 0;
      g[x][y] = 0;
      b[x][y] = 0;
      
      int k = 0;
      for(int i=-1; i<=1; i++) {
        for(int j=-1; j<=1; j++) {
          if(i != j && 0 <= x+i && x+i < columns && 0 <= y+j && y+j < rows) {
            color c = cells[x+i][y+j];
            r[x][y] += red(c);
            g[x][y] += green(c);
            b[x][y] += blue(c);
            k += 1;
          }
        }
      }
      r[x][y] /= k;
      g[x][y] /= k;
      b[x][y] /= k;
    }
  }
  
  // Second part: determine for each cell the new status depending on its r
  for (int x=0; x<columns; x++) {
    for (int y=0; y<rows; y++) {
      float lower = 2*255/8;
      float upper = 3*255/8;
      
      color c = cells[x][y];
      float _r = red(c);
      float _g = green(c);
      float _b = blue(c);
      
      if(mode == 0) {
        if(r[x][y] < 128) _r -= 1; else _r += 1;
        if(g[x][y] < 128) _g -= 1; else _g += 1;
        if(b[x][y] < 128) _b -= 1; else _b += 1;
      }
      
      if(mode == 1) {
        if(r[x][y] < lower || r[x][y] > upper) _r -= 1; else _r += 1;
        if(g[x][y] < lower || g[x][y] > upper) _g -= 1; else _g += 1;
        if(b[x][y] < lower || b[x][y] > upper) _b -= 1; else _b += 1;
      }
      
      if(mode == 2) {
        if(r[x][y] < lower || r[x][y] > upper) _r = 255 - _r;
        if(g[x][y] < lower || g[x][y] > upper) _g = 255 - _g;
        if(b[x][y] < lower || b[x][y] > upper) _b = 255 - _b;
      }
      
      cells[x][y] = color(_r, _g, _b);
    }
  }
}
