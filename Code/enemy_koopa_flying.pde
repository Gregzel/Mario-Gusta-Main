/**
 * Our main enemy
 */
class FlyingKoopa extends MarioEnemy {

  FlyingKoopa(float x, float y) {
    super("Koopa Flying");
    setStates();
    setForces(-0.3, 0);    
    setImpulseCoefficients(DAMPENING, 0);
    setPosition(x,y);
  }
  
  /**
   * Set up our states
   */
  void setStates() {
    
    // they can fly!
    State flying = new State("flying","graphics/enemies/Red-koopa-flying.gif",1,2);
    //flying.sprite.align(CENTER, BOTTOM);
    flying.setAnimationSpeed(0.2);
    
    // in fact, they can do a flying patrolling pattern
    SoundManager.load(flying, "audio/Squish.mp3");
    addState(flying);
    
    // walking state
    State walking = new State("idle", "graphics/enemies/Red-koopa-walking.gif", 1, 2);
    walking.setAnimationSpeed(0.12);
    SoundManager.load(walking, "audio/Squish.mp3");
    addState(walking);
    
    // if we get squished, we first get naked...
    State naked = new State("naked", "graphics/enemies/Naked-koopa-walking.gif", 1, 2);
    naked.setAnimationSpeed(0.12);
    SoundManager.load(naked, "audio/Squish.mp3");
    addState(naked);
    
    setCurrentState("flying");
  }
  
  /**
   * when we hit a vertical wall, we want our
   * koopa to reverse direction
   */
  void gotBlocked(Boundary b, float[] intersection, float[] original) {
    if (b.x==b.xw) {
      ix = -ix;
      fx = -fx;
      setHorizontalFlip(fx > 0);
    }
  }
  
  void hit() {
    SoundManager.play(active);
    if(active.name != "naked" && active.name != "idle") {
      setForces(-0.2,DOWN_FORCE);
      setAcceleration(0,ACCELERATION); 
      setImpulseCoefficients(DAMPENING, DAMPENING);
      SoundManager.play(active);
      // trigger some hitpoints
      layer.addDecal(new HitPoints(x,y,300));
      setCurrentState("idle");
      return;
    }
    // do we have our shell? Then we only get half-squished.
    if (active.name != "naked") {
      setCurrentState("naked");
      return;
    }
    // no shell... this koopa is toast.
    removeActor();
  }
}