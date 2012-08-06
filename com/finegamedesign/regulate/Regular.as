package com.finegamedesign.regulate
{
    import flash.display.DisplayObject;
    import flash.events.Event;
    import flash.events.TimerEvent;
    import flash.utils.getTimer;
    import flash.utils.Timer;

    /**
     * Compensate for irregular processing time and frame rate rounding.
     */
    public class Regular
    {
        // The timer that is ticking.  Its delay is copied.
        public var timer:Timer;
        // Callback on each tick near to ideal delay.
        public var onTick:Function;
        // Expected to equal the ideal timer delay.
        public var delay:Number;
        // First tick is unregulated.  read-only
        public var _initialized:Boolean;
        // Milliseconds of tick before now.  read-only
        public var _previous:Number;
        // Time of current tick.  read-only
        public var _now:Number;
        // Cumulative milliseconds away from ideal delay.  read-only
        public var _drift:Number;
        public var _halfFrame:Number;
        public var _frame:Number;

        /**
         * To start, start the timer. 
         * Copies timer delay.
         * Example:  @see TestRegulate.as:testRegulate
         *
         * Frequently, first tick is slow, and timer is limited to 60 bpm,
         * so subtract half frame from first tick.  Use frame rate 30fps or less.
         */
        public function Regular(timer:Timer, onTick:Function, frameRate:Number)
        {
            if (frameRate <= 0) {
                throw new Error("Frame rate must be positive.");
            }
            if (timer.delay <= 1000.0 / frameRate) {
                throw new Error("Flash expects delay ms greater than frame interval.");
            }
            this.delay = timer.delay;
            this._frame = 1000.0 / frameRate;
            this._halfFrame = 500.0 / frameRate;
            this.timer = timer;
            this.onTick = onTick;
            this._drift = 0;
            this._initialized = false;
            this._previous = getTimer();
        }

        /** Start this timer and listen to tick. */
        public function start():void
        {
            timer.delay = Math.max(timer.delay - this._halfFrame, this._frame);
            timer.addEventListener(TimerEvent.TIMER, _tick, false, int.MAX_VALUE);
            timer.start();
        }

        /**
         * First tick is frequently a slow outlier, so do not adjust that.
         * It is probably unwise to call this function directly.
         * Instead, call timer.start()
         * If much more than a frame too soon, do not call onTick yet.
         * If actual interval is too long, onTick is only called once.
         */
        internal function _tick(event:Event)
        {
            _now = getTimer();
            if (_initialized) {
                _drift += _now - _previous;
                if (delay - _frame < _drift) {
                    onTick(event);
                    _drift -= delay;
                }
                if (_drift <= -2.0 || 2.0 <= _drift) {
                    var nextDelay:Number = timer.delay - (0.5 * _drift);
                    if (nextDelay < this._frame) {
                        nextDelay = this._frame;
                    }
                    if (timer.delay != nextDelay) {
                        timer.delay = nextDelay;
                    }
                }
            }
            else {
                onTick(event);
                _initialized = true;
            }
            _previous = _now;
        }
    }
}
