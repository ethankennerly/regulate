package com.finegamedesign.regulate
{
    import flash.display.Stage;
    import flash.events.Event;
    import flash.events.TimerEvent;
    import flash.utils.getTimer;
    import flash.utils.Timer;

    /**
     * @author Ethan Kennerly
     */
    public class TimerAccuracy
    {
        public var frameRate:Number;
        public var delay:Number;
        public var repeatCount:int;
        public var times:Array;
        public var timer:Timer;
        public var message:String;
        public var onComplete:Function;
        public var result:String;

        /**
         * Record milliseconds since start of application, 
         * since last delay, and drift of last delay to previous delay. 
         * Record frame rate.
         * If pass in a timer, it does not start.
         * Example @see TestRegulate.as
         */
        public function TimerAccuracy(frameRate:Number, delay:Number, repeatCount:int, onComplete:Function, yourTimer:Timer=null, message:String = ""):void {
            if (repeatCount <= 9) {
                throw new Error("Need at least 10 samples to measure drift.");
            }
            if (frameRate <= 0) {
                throw new Error("Need frameRate to report.");
            }
            if (delay <= 0) {
                throw new Error("Expect delay milliseconds above 0.");
            }
            if (null == onComplete) {
                throw new Error("Need onComplete callback that takes string argument to deliver result.");
            }
            this.frameRate = frameRate;
            this.delay = delay;
            this.onComplete = onComplete;
            this.repeatCount = repeatCount;
            this.message = message;

            times = new Array();
            if (null == yourTimer) {
                timer = new Timer(delay, repeatCount);
                timer.addEventListener(TimerEvent.TIMER, record);
            }
            else {
                this.timer = yourTimer;
            }
            timer.addEventListener(TimerEvent.TIMER_COMPLETE, report);
            if (null == yourTimer) {
                timer.start();
            }
            var seconds:int = Math.ceil(0.001 * delay * repeatCount);
            onComplete("\nTimerAccuracy: Starting a timer. Please wait " 
                + seconds + " seconds for the report below...");
        }

        public function record(event:Event):void
        {
            times.push(getTimer());
        }

        public function report(event:Event):void
        {
            event.target.stop();
            result = "\n\n" + message;
            result += "reportTime: delay: " + delay + " frameRate: " + frameRate + " repeatCount: " + repeatCount;
            result += "\ntimes: " + times;
            var intervals:Array = new Array();
            for (var t:int=1; t<times.length; t++) {
                intervals.push(times[t] - times[t-1]);
            }
            result += "\nintervals: " + intervals;
            var intervalsSlice:Array = intervals.slice(2);
            var min:int = Math.min.apply(null, intervalsSlice);
            var max:int = Math.max.apply(null, intervalsSlice);
            var sum:int = sumInt.apply(null, intervalsSlice);
            var expectedSum:int = Math.round(intervalsSlice.length * delay);
            var drift:int = Math.round(sum - expectedSum);
            result += "\nafter first 2, min: " + min + " max: " + max 
                + " sum: " + sum + " expected sum: " + expectedSum
                + " drift: " + drift;

            var drifts:Array = new Array();
            var d:int = 0;
            for (var i:int=1; i<intervals.length; i++) {
                d += intervals[i] - delay;
                drifts.push(d);
            }
            result += "\ndrifts: " + drifts;
            var driftsSlice:Array = drifts.slice(4);
            min = Math.min.apply(null, driftsSlice);
            max = Math.max.apply(null, driftsSlice);
            result += "\nafter first 4, min: " + min + " max: " + max;

            onComplete(result);
        }

        public static function sumInt(... args:Array):int
        {
            var total:int;
            for each (var number:int in args) {
                total += number;
            }
            return total;
        }
    }
}

