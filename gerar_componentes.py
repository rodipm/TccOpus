import os
import re
from shutil import copyfile

path_componentes = os.path.join(".", "ComponentesEip")
path_componentes_back = os.path.join(".", "back", "code_generation", "eip_components")
path_componentes_front = os.path.join(".", "front", "lib", "EipWidgets")

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
        [f"import 'package:front/EipWidgets/{file_dart}'", f"'{component}': {component}(100, 100)"])

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

    for imp in imports_file_front:
        import_widgets += imp[0] + ";\n"
        create_widgets += "\t" + imp[1] + ",\n"

    import_file = import_widgets + "\n" + "Map<String, dynamic> eipWidgets = {\n" + create_widgets + "};"
    f.write(import_file)
