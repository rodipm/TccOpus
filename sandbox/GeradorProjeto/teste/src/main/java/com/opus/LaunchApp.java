package com.opus;

import org.apache.camel.main.Main;
import com.opus.routes.SampleRoute;

public class LaunchApp {

    public static void main(String[] args) throws Exception {
        Main main = new Main();
        main.configure().addRoutesBuilder(new SampleRoute());
        main.run(args);
    }
}
    