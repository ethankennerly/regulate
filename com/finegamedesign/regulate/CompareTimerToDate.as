package com.finegamedesign.regulate
{
    import flash.utils.getTimer;

    public class CompareTimerToDate
    {
        private var _appCurrentTime:int;
        private var _appTime:int;
        private var _systemTime:int;
        private var _systemCurrentTime:int;

        /**
         * On some OS and brower combination, does timer drift from date time?
         * Copied from HotN Sep 6 '11 at 21:20
         * http://stackoverflow.com/questions/7326315/difference-between-date-gettime-and-gettimer
         */ 
        public function CompareTimerToDate():void
        {
            _appTime = getTimer();
            _systemTime = new Date().getTime();
        }

        /**
         * Text of milliseconds since this instance was constructed.
         */
        public function report():String
        {
            _appCurrentTime = getTimer();
            _systemCurrentTime = new Date().getTime();
            var dateDuration:int = _systemCurrentTime - _systemTime;
            var timerDuration:int = _appCurrentTime - _appTime;
            var timerMinusDate:int = timerDuration - dateDuration;
            return "Timer drift from system date: " + timerMinusDate.toString()
                + ", System Date milliseconds: " + dateDuration.toString()
                + ", Timer milliseconds: " + timerDuration.toString();
        }
    }
}
