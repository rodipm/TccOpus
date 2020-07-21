import sys
import os

def display_help():
    print("Generates a boilerplate project structure for Apache Camel using Maven")
    print(f"Usage: {sys.argv[0]} group_id artifact_id")

if len(sys.argv) != 3:
    display_help()
    exit(0)

artifact_id = sys.argv[2]
group_id = sys.argv[1]
group_id_partial_path = group_id.replace(".", "/")
group_artifact = '.'.join([group_id, artifact_id])

sample_route_file = """
package %s.routes;

import org.apache.camel.builder.RouteBuilder;

public class SampleRoute extends RouteBuilder {

	@Override
	public void configure() throws Exception {
        // Define Route Here
	}
	
}
""" % (group_artifact)

launch_app_file = """
package %s;

import %s.routes.SampleRoute;
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
""" % (group_artifact, group_artifact)

def create_project():

    mvn_command = f"(echo yes | mvn archetype:generate -DarchetypeGroupId=org.apache.camel.archetypes -DarchetypeArtifactId=camel-archetype-java -DgroupId={group_id} -DartifactId={artifact_id} -Dversion=1.0-SNAPSHOT)"
    delete_sample_data_command = f"(rm -rf ./{artifact_id}/src/data & echo Done deleting sample data)"
    delete_sample_code_files_command = f"(rm ./{artifact_id}/src/main/java/{group_id_partial_path}/* & echo Done deleting sample code files)"

    complete_command = mvn_command + "&" + delete_sample_code_files_command + "&" + delete_sample_data_command
    os.system(complete_command)

def update_pom_config():
    with open(f"./{artifact_id}/pom.xml", "r") as f:
        pom_contents = f.read()
        pom_contents = pom_contents.replace("MainApp", f"{artifact_id}.LaunchApp")
    with open(f"./{artifact_id}/pom.xml", "w") as f:
        f.write(pom_contents)
    print("pom.xml updated")

def create_sample_route_file():
    os.makedirs(f"./{artifact_id}/src/main/java/{group_id_partial_path}/{artifact_id}/routes")

    with open(f"./{artifact_id}/src/main/java/{group_id_partial_path}/{artifact_id}/routes/SampleRoute.java", "x") as f:
        f.write(sample_route_file)

    print("SampleRoute.java created")

def create_launch_app_file():
    with open(f"./{artifact_id}/src/main/java/{group_id_partial_path}/{artifact_id}/LaunchApp.java", "x") as f:
        f.write(launch_app_file)
        
    print("LaunchApp.java created")

def main():
    create_project()
    update_pom_config()
    create_sample_route_file()
    create_launch_app_file()

if __name__ == "__main__": main()