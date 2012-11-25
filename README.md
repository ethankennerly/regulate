regulate
========

Accurate and efficient timers in ActionScript.
Regulates time up to 10x more accurately than default Timer.

               Max      Sum
    Regulate:    3 ms.   -1 ms.
    Watch:      34 ms.   -3 ms.
    Timer:      35 ms.  200 ms.

Regulate:  Compensates the timer's interval.
Watch:  Watches every frame until the interval would occur.

Pick a delay that is a whole divisor of the target browser's frame rate.
This example is 30 fps with 500 millisecond delay (15 frames).
In low-end browsers, 30 fps is the practical upper limit to frame rate.
In high-end browsers, 60 fps is the practical upper limit to frame rate.
http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/utils/Timer.html

Regulate is more efficient than Harrison or Accurate Timer,
because it has simpler data structures and operations.

Tests depend on AsUnit 3.0.
FLA depends on Flash CS4.  No animation.

Links to other accurate timers:

http://cookbooks.adobe.com/post_Accurate_timer-17332.html
http://www.computus.org/journal/?p=25
http://www.computus.org/journal/?page_id=869

Tinic Uro, Adobe Flash Engineer, explained why timing may be irregular in Flash Player 10.1:

"Timing it right"
http://blog.kaourantin.net/?p=82

Example report:

Regular Timer reportTime: delay: 500 frameRate: 30 repeatCount: 20
times: 1115,1613,2115,2613,3114,3616,4114,4614,5115,5613,6114,6616,7114,7614,8116,8614,9114,9616,10114,10614
intervals: 498,502,498,501,502,498,500,501,498,501,502,498,500,502,498,500,502,498,500
after first 2, min: 498 max: 502 sum: 8499 expected sum: 8500 drift: -1
drifts: 2,0,1,3,1,1,2,0,1,3,1,1,3,1,1,3,1,1
after first 4, min: 0 max: 3

Watch Stage reportTime: delay: 500 frameRate: 30 repeatCount: 20
times: 1081,1549,2083,2581,3082,3582,4080,4582,5083,5581,6082,6582,7080,7582,8082,8580,9082,9582,10080,10580
intervals: 468,534,498,501,500,498,502,501,498,501,500,498,502,500,498,502,500,498,500
after first 2, min: 498 max: 502 sum: 8497 expected sum: 8500 drift: -3
drifts: 34,32,33,33,31,33,34,32,33,33,31,33,33,31,33,33,31,31
after first 4, min: 31 max: 34

reportTime: delay: 500 frameRate: 30 repeatCount: 20
times: 1183,1713,2215,2716,3246,3746,4248,4782,5313,5814,6314,6814,7314,7816,8346,8846,9348,9882,10412,10915
intervals: 530,502,501,530,500,502,534,531,501,500,500,500,502,530,500,502,534,530,503
after first 2, min: 500 max: 534 sum: 8700 expected sum: 8500 drift: 200
drifts: 2,3,33,33,35,69,100,101,101,101,101,103,133,133,135,169,199,202
after first 4, min: 35 max: 202



License MIT
