package com.finegamedesign.regulate
{
    import flash.display.Stage;
    import flash.events.Event;
    import flash.events.TimerEvent;
    import flash.utils.Timer;

    import asunit.framework.TestCase;

    /**
     * Compare Regular, Watch, and default Timer.
     *
     * Record milliseconds since start of application, 
     * since last delay, and drift of last delay to previous delay. 
     * Compare to frame rate.
     * Record frame rate.
     * @author Ethan Kennerly
     */
    public class TestTimerAccuracy extends TestCase
    {
        public static var frameRate:Number = 30;
        public static var delay:Number = 500;
        public static var repeatCount:int = 60;

        public static var stage:Stage;
        public static var onComplete:Function;

        public static var allVariants:Boolean = false;

        public function testRegular():void
        {
            assertNotNull(stage);
            if (0 < frameRate && stage.frameRate != frameRate) {
                stage.frameRate = frameRate;
            }
            var timer:Timer = new Timer(delay, repeatCount);
            var accuracy:TimerAccuracy = new TimerAccuracy(stage.frameRate, 
                timer.delay, timer.repeatCount, onComplete, timer, "Regular Timer ");
            var regular:Regular = new Regular(timer, accuracy.record, stage.frameRate);
            regular.start();
        }

        public function testWatch():void
        {
            assertNotNull(stage);
            if (0 < frameRate && stage.frameRate != frameRate) {
                stage.frameRate = frameRate;
            }
            var timer:Timer = new Timer(delay, repeatCount);
            var accuracy:TimerAccuracy = new TimerAccuracy(stage.frameRate, 
                timer.delay, timer.repeatCount, onComplete, timer, "Watch Stage ");
            var watch:Watch = new Watch(timer.delay, accuracy.record, stage.frameRate);
            watch.start(stage);
            function stop(event:Event):void
            {
                watch.stop(stage);
            }
            timer.addEventListener(TimerEvent.TIMER_COMPLETE, stop);
            timer.start();
        }

        public function testDefaultTimers():void
        {
            assertNotNull(stage);
            if (0 < frameRate && stage.frameRate != frameRate) {
                stage.frameRate = frameRate;
            }
            new TimerAccuracy(stage.frameRate, delay, repeatCount, onComplete);

            if (allVariants) {
                new TimerAccuracy(stage.frameRate, 1000.0 / 6, 20, onComplete);
                new TimerAccuracy(stage.frameRate, 1000.0 / 60, 60, onComplete);
                new TimerAccuracy(stage.frameRate, 17, 61, onComplete);
                new TimerAccuracy(stage.frameRate, 18, 62, onComplete);
                new TimerAccuracy(stage.frameRate, 20, 21, onComplete);
                new TimerAccuracy(stage.frameRate, 21, 22, onComplete);
                new TimerAccuracy(stage.frameRate, 100, 23, onComplete);
                new TimerAccuracy(stage.frameRate, 500, 13, onComplete);
                new TimerAccuracy(stage.frameRate, 30 * (1000.0 / 60), 14, onComplete);
            }
        }

    }
}
