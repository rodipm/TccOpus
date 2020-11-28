import os
import re
from shutil import copyfile

ORIGIN_DIR = "ComponentesKalei"
BACK_DIR = "kalei_components"
FRONT_DIR = "KaleiWidgets"
path_componentes = os.path.join(".", ORIGIN_DIR)
path_componentes_back = os.path.join(".", "back", "code_generation", BACK_DIR)
path_componentes_front = os.path.join(".", "front", "lib", FRONT_DIR)

components = os.listdir(path_componentes)

pattern = re.compile(r'(?<!^)(?=[A-Z])')

imports_file_back = []
imports_file_front = []

for component in components:
    file_base_name = pattern.sub('_', component).lower()
    file_py = file_base_name + ".py"
    file_dart = file_base_name + ".dart"

    # Copia os arquivos .py para o diretorio no back-end
    copyfile(os.path.join(path_componentes, component, file_py),
             os.path.join(path_componentes_back, file_py))
    imports_file_back.append(f"from .{file_base_name} import {component}")

    # Copia os arquivos .dart para o diretorio no front-end
    copyfile(os.path.join(path_componentes, component, file_dart),
             os.path.join(path_componentes_front, file_dart))
    imports_file_front.append(
        [f"import 'package:front/{FRONT_DIR}/{file_dart}'", f"'{component}': {component.lower()}", "dynamic " + component.lower() + "() {\n\treturn " + component + "(100, 100);\n}"])

    # Imagens para os assets do front
    copyfile(os.path.join(path_componentes, component, component + ".png"),
             os.path.join(".", "front", "assets", component + ".png"))

# Cria o documento de imports de componentes do backend
with open(os.path.join(path_componentes_back, "components_imports.py"), "w") as f:
    f.write("\n".join(imports_file_back))

# Cria o documento de imports de componentes do frontend
with open(os.path.join(path_componentes_front, "import_widgets.dart"), "w") as f:
    import_widgets = ""
    create_widgets = ""
    create_functions = ""

    for imp in imports_file_front:
        import_widgets += imp[0] + ";\n"
        create_widgets += "\t" + imp[1] + ",\n"
        create_functions += imp[2] + "\n"

    var_name = FRONT_DIR[0].lower() + FRONT_DIR[1:]

    import_file = import_widgets + "\n" + "Map<String, dynamic> " + var_name + "= {\n" + create_widgets + "};" + "\n" + create_functions
    f.write(import_file)
