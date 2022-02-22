class MAP {
  PVector[] edge;
  boolean visible;
  boolean editing;
  int id;

  public MAP () {
    visible = true;
    edge = new PVector[4];
    if (!load("settings.json")) resetCorners();
    /*edge[0] = new PVector(100, 100);
     edge[1] = new PVector(200, 100);
     edge[2] = new PVector(300, 100);
     edge[3] = new PVector(300, 200);
     edge[4] = new PVector(300, 300);
     edge[5] = new PVector(200, 300);
     edge[6] = new PVector(100, 300);
     edge[7] = new PVector(100, 200);*/
  }
  
  void toggleVisible () {
    visible = !visible;
  }

  boolean load (String fileName) {
    File f = dataFile(fileName);
    if (!f.isFile()) return false;
    JSONArray corners = new JSONArray();
    corners = loadJSONArray(fileName);
    if (corners != null) {
      for (int i=0; i<4; i++) {
        edge[corners.getJSONObject(i).getInt("id")] = new PVector(corners.getJSONObject(i).getInt("x"), corners.getJSONObject(i).getInt("y"));
      }
    }
    return true;
  }
  
  void resetCorners () {
    edge[0] = new PVector(100, 100);
    edge[1] = new PVector(displayWidth-100, 100);
    edge[2] = new PVector(displayWidth-100, displayHeight-100);
    edge[3] = new PVector(100, displayHeight-100);
  }

  void save (String fileName) {
    JSONArray corners = new JSONArray ();
    for (int i=0; i<4; i++) {
      JSONObject corner = new JSONObject ();
      corner.setInt("id", i);
      corner.setInt("x", (int)edge[i].x);
      corner.setInt("y", (int)edge[i].y);
      corners.setJSONObject(i, corner);
    }
    saveJSONArray(corners, "data/"+fileName);
  }

  void handle () {
    if (visible) {
      PVector mouse = new PVector(mouseX, mouseY);
      for (int i=0; i<edge.length; i++) {
        if (edge[i].dist(mouse)<20 && mousePressed && !editing) {
          id = i;
          editing = true;
        }
      }
      if (mousePressed && editing) edge[id] = mouse.copy();
      if (!mousePressed) editing = false;
    }
  }

  void show (PImage content) {
    pushStyle();
    if (visible) {
      noFill();
      stroke(255);
      for (int i=0; i<edge.length; i++) ellipse(edge[i].x, edge[i].y, 40, 40);
    }
    popStyle();

    beginShape();
    texture(content);
    vertex(edge[0].x, edge[0].y, 0, 0);
    vertex(edge[1].x, edge[1].y, content.width, 0);
    vertex(edge[2].x, edge[2].y, content.width, content.height);
    vertex(edge[3].x, edge[3].y, 0, content.height);
    /*vertex(edge[0].x, edge[0].y, 0, 0);
     vertex(edge[1].x, edge[1].y, content.width/2, 0);
     vertex(edge[2].x, edge[2].y, content.width, 0);
     vertex(edge[3].x, edge[3].y, content.width, content.height/2);
     vertex(edge[4].x, edge[4].y, content.width, content.height);
     vertex(edge[5].x, edge[5].y, content.width/2, content.height);
     vertex(edge[6].x, edge[6].y, 0, content.height);
     vertex(edge[7].x, edge[7].y, 0, content.height/2);*/
    endShape();
  }
} 
