class Particle
{
  PVector location;
  PVector velocity;
  PVector acceleration;
  
  float size;
  float max_force;
  float max_speed;
  color body_color;
  
  Particle(float x, float y, float z)
  {
    location = new PVector(x, y, z);
    velocity = new PVector(0, 0, 0);
    acceleration = new PVector(0, 0, 0);
    
    size = 5;
    max_force = size;
    max_speed = size * 50;
    body_color = color(random(255), 255, 255);
  }
  
  void applyForce(PVector force)
  {
    acceleration.add(force);
  }
  
  PVector seek(PVector target)
  {
    PVector desired = PVector.sub(target, location);
    desired.normalize();
    desired.mult(max_speed);
    PVector steer = PVector.sub(desired, velocity);
    steer.limit(max_force);
    return steer;
  }
    
  PVector separate(ArrayList<Particle> particles)
  {
    float desiredseparation = size;
    PVector sum = new PVector();
    int count = 0;
    for(Particle p : particles)
    {
      float distance = PVector.dist(location, p.location);
      if((distance > 0) && (distance < desiredseparation))
      {
        PVector diff = PVector.sub(location, p.location);
        diff.normalize();
        diff.div(distance);
        sum.add(diff);
        count += 1;
      }
    }
    
    if(count > 0)
    {
      sum.div(count);
      sum.setMag(max_speed);
      PVector steer = PVector.sub(sum, velocity);
      steer.limit(max_force);
      
      return steer;
    }
    
    return new PVector(0, 0, 0);
  }
  
  PVector align(ArrayList<Particle> particles)
  {
    float neighbordist = size * 10;
    PVector sum = new PVector();
    int count = 0;
    for(Particle p : particles)
    {
      float distance = PVector.dist(location, p.location);
      if((distance > 0) && (distance < neighbordist))
      {
        PVector diff = PVector.sub(location, p.location);
        diff.normalize();
        diff.div(distance);
        sum.add(diff);
        count += 1;
      }
    }
    
    if(count > 0)
    {
      sum.div(count);
      sum.setMag(max_speed);
      PVector steer = PVector.sub(sum, velocity);
      steer.limit(max_force);
      
      return steer;
    }
    
    return new PVector(0, 0, 0);
  }
  
  PVector cohesion(ArrayList<Particle> particles)
  {
    float neighbordist = size * 10;
    PVector sum = new PVector();
    int count = 0;
    for(Particle p : particles)
    {
      float distance = PVector.dist(location, p.location);
      if((distance > 0) && (distance < neighbordist))
      {
        sum.add(p.location);
        count += 1;
      }
    }
    
    if(count > 0)
    {
      sum.div(count);
      return seek(sum);
    }
    
    return new PVector(0, 0, 0);
  }
  
  void update()
  {
    velocity.add(acceleration);
    velocity.limit(max_speed);
    location.add(velocity);
    velocity.mult(0.99);
    acceleration.mult(0);
  }
  
  void flok(ArrayList<Particle> particles)
  {
    PVector sep = separate(particles);
    PVector ali = align(particles);
    PVector coh = cohesion(particles);
    
    sep.mult(1);
    coh.mult(1.1);
        
    applyForce(sep);
    applyForce(ali);
    applyForce(coh);
  }
  
  void display()
  {            
    noStroke();
    fill(body_color, 32);
    
    pushMatrix();
    translate(location.x, location.y, location.z);
    for(int i = 1; i < 10; i++)
    {
      sphere(i);
    }
    popMatrix();
  }
  
  void borders()
  {
    PVector distance = PVector.sub(location, new PVector(0, 0, 0));
    if(distance.mag() > 300)
    {
      distance.normalize();
      distance.mult(-max_force);     
      applyForce(distance);
    }
  }
}