--Called once at load time
function init() 
--  Called exactly once per frame. The time step is variable but always between 0.0 and 0.0333333
function tick(dt) 
--    Called at a fixed update rate, but at the most two times per frame. Time step is always 0.0166667 (60 updates per second). Depending on frame rate it might not be called at all for a particular frame.
function update(dt) 
--Called when the 2D overlay is being draw, after the scene but before the standard HUD. Ui functions can only be used from this callback.
function draw() 
--Called exactly once per frame, right before things are actually drawn to the screen.
function render(dt) 
--  Called like update, but after physics. Because update can trigger physics updates, it can be necessary to do some additional calculations afterwards. This is usually used by animators.
function postUpdate() 
