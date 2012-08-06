package com.finegamedesign.regulate
{
    import flash.display.Stage;
    import flash.events.Event;

    import asunit.textui.TestRunner;
    
    public class TestRegulateRunner extends TestRunner {
        override protected function addedHandler(event:Event):void
        {
            super.addedHandler(event);
            if (null != stage && null == TestTimerAccuracy.stage) {
                TestTimerAccuracy.stage = this.stage;
                TestTimerAccuracy.onComplete = print;
                start(Tests);
            }
        }

        public function print(... args:Array):void
        {
            fPrinter.print(args);
        }
    }
}
