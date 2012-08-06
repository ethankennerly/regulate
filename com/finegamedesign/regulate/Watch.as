package com.finegamedesign.regulate
{
    import flash.display.DisplayObject;
    import flash.events.Event;
    import flash.utils.getTimer;

    /**
     * Watch every frame until the interval would occur.
     */
    public class Watch
    {
        // Callback on each tick near to ideal delay.
        public var onTick:Function;
        // Expected to equal the ideal timer delay.
        public var delay:Number;
        // Milliseconds of tick before now.  read-only
        public var _previous:Number;
        // Time of current tick.  read-only
        public var _now:Number;
        // Cumulative milliseconds away from ideal delay.  read-only
        public var _drift:Number;
        public var _halfFrame:Number;

        /**
         * Instead of timer, stage listens to tick and regulates interval on each frame.
         * Example:  @see TestRegulate.as:testRegulate
         */
        public function Watch(delay:Number, onTick:Function, frameRate:Number)
        {
            if (frameRate <= 0) {
                throw new Error("Frame rate must be positive.");
            }
            if (delay <= 1000.0 / frameRate) {
                throw new Error("Flash expects delay ms greater than frame interval.");
            }
            this.delay = delay;
            this._halfFrame = 500.0 / frameRate;
            this.onTick = onTick;
            this._drift = 0;
        }

        public function start(stage:DisplayObject):void
        {
            this._previous = getTimer();
            stage.addEventListener(Event.ENTER_FRAME, _tickFrame, false, int.MAX_VALUE, true);
        }

        public function stop(stage:DisplayObject):void
        {
            stage.removeEventListener(Event.ENTER_FRAME, _tickFrame);
        }

        public function _tickFrame(event:Event):void
        {
            _now = getTimer();
            _drift += _now - _previous;
            if (delay - _halfFrame < _drift) {
                onTick(event);
                _drift -= delay;
            }
            _previous = _now;
        }
    }
}
