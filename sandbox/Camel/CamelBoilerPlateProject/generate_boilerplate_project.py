import sys
import os

def display_help():
    print("Generates a boilerplate project structure for Apache Camel using Maven")
    print(f"Usage: {sys.argv[0]} group_id artifact_id")

if len(sys.argv) != 3:
    display_help()
    exit(0)

group_id = sys.argv[1]
artifact_id = sys.argv[2]

artifact_id_partial_path = sys.argv[1].replace(".", "/")

mvn_command = f"(echo yes | mvn archetype:generate -DarchetypeGroupId=org.apache.camel.archetypes -DarchetypeArtifactId=camel-archetype-java -DgroupId={group_id} -DartifactId={artifact_id} -Dversion=1.0-SNAPSHOT)"
delete_sample_data_command = f"(rm -rf ./{artifact_id}/src/data & echo Done deleting sample data)"
delete_sample_code_files_command = f"(rm ./{artifact_id}/src/main/java/{artifact_id_partial_path}/* & echo Done deleting sample code files)"

complete_command = mvn_command + "&" + delete_sample_code_files_command + "&" + delete_sample_data_command

os.system(complete_command)