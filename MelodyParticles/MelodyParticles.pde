import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;

Minim minim;
AudioPlayer song;
FFT fft;

PImage img;

class Scatter
{
  
public

  float m_x;
  float m_y;
  
  float m_dist;
  float m_radius;
  float m_size;

  float m_velX;
  float m_velY;
  
  float m_acc;
  
public

  Scatter(float initX, float initY, float radius, float size, float initVelX, float initVelY, float acc)
  {
    m_x = initX; m_y = initY; m_size = size; m_radius = radius;
    m_velX = initVelX; m_velY = initVelY; m_acc = acc;
  }

  boolean shouldRemove()
  { 
    return m_dist > m_radius;
  }

  void update()
  {
    color c = img.get(int(m_x), int(m_y));
    stroke(c); fill(c);
    ellipse(m_x, m_y, m_size, m_size);

    float dt = 1.0 / (float)frameRate;
    float theta = atan2(m_velY, m_velX);
    m_x += m_velX * dt; m_y += m_velY * dt;
    
    float vel = sqrt(m_velX * m_velX + m_velY * m_velY);
    m_dist += vel * dt;
    
    m_velX += m_acc * cos(theta) * dt; m_velY += m_acc * sin(theta) * dt;
  }
  
}

class Spot
{

public

  float m_x;
  float m_y;

  ArrayList<Scatter> m_scatters;

public

  Spot(float x, float y)
  {
    m_x = x; m_y = y;
    m_scatters = new ArrayList<Scatter>();
  }

  void trigger(float intensity)
  {
    float size = intensity / 10.0;
    if(size > 20) size = 20;
    else if(size < 3) size = 3;
    
    float raduis = intensity * 3;
    
    int steps = int(intensity / 2.0);
    if(steps < 6) steps = 6;
    else if(steps > 40) steps = 40;
    
    float vel = intensity * 3, acc = (vel / abs(vel)) * intensity / 10.0;
    if(vel > 500) vel = 500;
    
    float stepAngle = (2 * PI) / float(steps);
    for(int i = 0; i < steps; i++){
      float angle = i * stepAngle;
      float velX = vel * cos(angle), velY = -vel * sin(angle);
      
      m_scatters.add(new Scatter(m_x, m_y, raduis, size, velX, velY, acc));
    }
  }

  void update()
  {
    ArrayList<Scatter> newScatters = new ArrayList<Scatter>();
    for(Scatter scatter : m_scatters){
      scatter.update();
      if(!scatter.shouldRemove()){
        newScatters.add(scatter);
      }
    }
    m_scatters = newScatters;
  }

}

int numAudioBands = 5;
Spot[] spots = new Spot[numAudioBands];
float[] lastIntensity = new float[numAudioBands];

void setup()
{
  img = loadImage("data/ducle.jpg");
  img.resize(600 * (img.width / img.height), 600);
  println(img.width);

  size(600,600);
  frameRate(120);

  minim = new Minim(this);
  song = minim.loadFile("data/Demo3.mp3");
  fft = new FFT(song.bufferSize(), song.sampleRate());
  fft.linAverages(numAudioBands);
  song.loop();

  float[] pos = {width * 0.5, height * 0.5, width * 0.2, height * 0.2, width * 0.2, height * 0.8, width * 0.8, height * 0.8, width * 0.8, height * 0.2};
  for(int i = 0; i < numAudioBands; i++){
    spots[i] = new Spot(pos[2 * i], pos[2 * i + 1]);
    lastIntensity[i] = 0.0;
  }
}

void draw()
{
  background(255);
  fft.forward(song.mix);
 
  for(int i = 0; i < numAudioBands; i++){
    
    float intensity = fft.getAvg(i == 0 ? 0 : 1) * 30.0;
    spots[i].trigger(intensity * 0.3 + lastIntensity[i] * 0.7);
    spots[i].update();
    
    lastIntensity[i] = intensity;
  }
}
