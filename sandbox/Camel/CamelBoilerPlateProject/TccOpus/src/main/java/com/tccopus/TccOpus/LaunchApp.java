package com.tccopus.TccOpus;

import com.tccopus.TccOpus.routes.SampleRoute;
import org.apache.camel.main.Main;

public class LaunchApp {

	public static void main(String[] args) throws Exception {
		Main main = new Main();
		// main.bind("sampleComponentName", sampleComponentConfigForBinding());
		main.addRoutesBuilder(new SampleRoute());
		main.run();
	}
	
	public static void sampleComponentConfigForBinding() {
		// return ...;
	}
}
