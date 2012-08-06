package com.finegamedesign.regulate
{
    import asunit.framework.TestSuite;

    public class Tests extends TestSuite
    {
        public function Tests()
        {
            addTest(new TestTimerAccuracy());
        }
    }
}
