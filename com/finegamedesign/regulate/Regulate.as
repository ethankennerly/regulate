package com.finegamedesign.regulate
{
    import flash.display.DisplayObject;
    import flash.events.Event;
    import flash.utils.getTimer;

    /**
     * Compensate for irregular processing time and frame rate rounding.
     *
     * Accurate and efficient timer in ActionScript.
     * Regulates time up to 10x more accurately than default Timer.
     *
     *                Max      Sum
     *     Regulate:    3 ms.    1 ms.
     *     Timer:      35 ms.  567 ms.
     *
     * To achieve 10 ms accuracy, pick a delay that is a whole divisor 
     * of the target browser's frame rate.
     * This example is 30 fps with 333.3 millisecond delay (10 frames).
     * In low-end browsers, 30 fps is the practical upper limit to frame rate.
     * In high-end browsers, 60 fps is the practical upper limit to frame rate.
     * 
     * In many browsers frame rate is capped at 60 fps,
     * and Flash compiler does not substitute constants,
     * so constants below are optimized for 60 fps and hard-coded.
     */
    public class Regulate
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
         * To start, start the timer. 
         * Copies timer delay.
         * Example:  @see TestRegulate.as:testRegulate
         *
         * Frequently, first tick is slow, and timer is limited to 60 bpm,
         * so subtract half frame from first tick.  Use frame rate 30fps or less.
         * http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/utils/Timer.html
         * Instead of timer, stage listens to tick and regulates interval on each frame. *
         */
        public function Regulate(delay:Number, onTick:Function, frameRate:Number)
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
